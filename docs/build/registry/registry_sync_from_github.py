#!/usr/bin/env python3
"""
registry_sync_from_github.py

Sync LillyCORE Main GitHub project cards into registry phase files.

Source of truth: GitHub issues / project items.
Registry: minimal topology + metadata (no card bodies).

Writes:
- docs/build/registry/<phase_id>.yml (e.g., p1.yml)
- docs/build/registry/phase_registry_index.yml (manifest)

Requirements:
- gh CLI installed and authenticated
- PyYAML installed: pip install pyyaml

Configuration (either flags or env vars):
- GITHUB_OWNER
- GITHUB_REPO
- GITHUB_PROJECT_NUMBER   (GitHub Project v2 number)
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

try:
    import yaml  # type: ignore
except Exception as e:
    raise SystemExit(
        "Missing dependency: PyYAML. Install with: pip install pyyaml\n"
        f"Import error: {e}"
    )

REGISTRY_DIR_DEFAULT = Path("docs/build/registry")
INDEX_FILE_NAME = "phase_registry_index.yml"

PHASE_ID_RE = re.compile(r"^p\d+([a-z_]\w*)?$")  # p1, p8a_help_desk_engine, p18, etc.


@dataclass(frozen=True)
class Card:
    card_id: str
    phase_id: str
    parent_id: Optional[str]
    executor_role: Optional[str]
    deliverables: List[str]
    attempt: Optional[int]
    title: str
    url: Optional[str]


def run(cmd: List[str]) -> str:
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if p.returncode != 0:
        raise RuntimeError(f"Command failed:\n  {' '.join(cmd)}\n\nSTDERR:\n{p.stderr}")
    return p.stdout


def gh_graphql(owner: str, project_number: int, after: Optional[str] = None) -> Dict[str, Any]:
    """
    Fetch one page of project items + their field values using GitHub GraphQL through `gh api graphql`.
    This environment's gh build rejects Int GraphQL variables, so project_number is inlined.
    """
    # IMPORTANT: project_number is inlined as an int literal to avoid gh Int-variable bugs.
    query = f"""
query($owner: String!, $after: String) {{
  user(login: $owner) {{
    projectV2(number: {int(project_number)}) {{
      items(first: 100, after: $after) {{
        pageInfo {{ hasNextPage endCursor }}
        nodes {{
          id
          content {{
            __typename
            ... on Issue {{
              title
              url
            }}
            ... on PullRequest {{
              title
              url
            }}
          }}
          fieldValues(first: 50) {{
            nodes {{
              __typename
              ... on ProjectV2ItemFieldTextValue {{
                text
                field {{ ... on ProjectV2FieldCommon {{ name }} }}
              }}
              ... on ProjectV2ItemFieldNumberValue {{
                number
                field {{ ... on ProjectV2FieldCommon {{ name }} }}
              }}
              ... on ProjectV2ItemFieldSingleSelectValue {{
                name
                field {{ ... on ProjectV2FieldCommon {{ name }} }}
              }}
            }}
          }}
        }}
      }}
    }}
  }}
}}
"""

    cmd = [
        "gh",
        "api",
        "graphql",
        "-f",
        f"query={query}",
        "-F",
        f"owner={owner}",
    ]

    # Only pass `after` when present; avoid null/None.
    if after is not None:
        cmd += ["-F", f"after={after}"]

    out = run(cmd)
    return json.loads(out)

def extract_fields(field_nodes: List[Dict[str, Any]]) -> Dict[str, Any]:
    fields: Dict[str, Any] = {}
    for n in field_nodes:
        typename = n.get("__typename")
        field = n.get("field") or {}
        name = field.get("name")
        if not name:
            continue

        if typename == "ProjectV2ItemFieldTextValue":
            fields[name] = n.get("text")
        elif typename == "ProjectV2ItemFieldNumberValue":
            fields[name] = n.get("number")
        elif typename == "ProjectV2ItemFieldSingleSelectValue":
            fields[name] = n.get("name")
    return fields


def normalize_list_field(v: Optional[str]) -> List[str]:
    if not v:
        return []
    # split on commas; trim; drop empties
    parts = [p.strip() for p in v.split(",")]
    return [p for p in parts if p]


def validate_phase_id(phase_id: str) -> None:
    if not PHASE_ID_RE.match(phase_id):
        raise ValueError(f"Invalid Phase ID '{phase_id}'. Expected snake_case like p1, p8a_help_desk_engine, p18.")


def fetch_all_cards(owner: str, project_number: int) -> List[Card]:
    cards: List[Card] = []
    after: Optional[str] = None

    while True:
        data = gh_graphql(owner=owner, project_number=project_number, after=after)
        proj = data["data"]["user"]["projectV2"]
        items = proj["items"]["nodes"]
        page = proj["items"]["pageInfo"]

        for it in items:
            content = it.get("content") or {}
            title = content.get("title") or ""
            url = content.get("url")

            fields = extract_fields(it.get("fieldValues", {}).get("nodes", []))

            # Required custom fields (per your board)
            card_id = (fields.get("Card ID") or "").strip()
            phase_id = (fields.get("Phase ID") or "").strip()

            # Ignore items that aren't real cards yet
            if not card_id or not phase_id:
                continue

            validate_phase_id(phase_id)

            parent_id = (fields.get("Parent ID") or None)
            if isinstance(parent_id, str):
                parent_id = parent_id.strip() or None

            executor_role = (fields.get("Executor Role") or None)
            if isinstance(executor_role, str):
                executor_role = executor_role.strip() or None

            deliverables_raw = fields.get("Deliverables")
            deliverables = normalize_list_field(deliverables_raw if isinstance(deliverables_raw, str) else None)

            attempt = fields.get("Attempt #")
            attempt_int: Optional[int] = None
            if isinstance(attempt, (int, float)):
                attempt_int = int(attempt)

            cards.append(
                Card(
                    card_id=card_id,
                    phase_id=phase_id,
                    parent_id=parent_id,
                    executor_role=executor_role,
                    deliverables=deliverables,
                    attempt=attempt_int,
                    title=title.strip(),
                    url=url,
                )
            )

        if not page["hasNextPage"]:
            break
        after = page["endCursor"]

    return cards


def build_phase_tree(cards: List[Card]) -> Dict[str, Any]:
    """
    Output structure per phase:
      {
        "p1": {
          "phase": {...},
          "slices": { card_id -> node }
        }
      }
    Nodes are stitched using Parent ID, but we do not assume missing parents.
    """
    by_phase: Dict[str, List[Card]] = {}
    for c in cards:
        by_phase.setdefault(c.phase_id, []).append(c)

    phases: Dict[str, Any] = {}

    for phase_id, phase_cards in by_phase.items():
        # Create nodes for each card
        nodes: Dict[str, Dict[str, Any]] = {}
        for c in phase_cards:
            nodes[c.card_id] = {
                "id": c.card_id,
                "title": c.title or c.card_id,
                "executor_role": c.executor_role or "unknown",
                "parent": c.parent_id or phase_id,
                "delivers": c.deliverables,
                "attempt": c.attempt,
                "url": c.url,
                "qa_status": "pending",
                "subslices": [],
            }

        # Attach children
        roots: List[Dict[str, Any]] = []
        for c in phase_cards:
            node = nodes[c.card_id]
            parent = c.parent_id or phase_id

            if parent == phase_id:
                roots.append(node)
            else:
                parent_node = nodes.get(parent)
                if not parent_node:
                    # Parent not in this phase export => fail loudly
                    raise RuntimeError(
                        f"Card '{c.card_id}' claims Parent ID '{parent}', but that parent card was not found "
                        f"in Phase ID '{phase_id}'. Fix the Parent ID or create/sync the parent card first."
                    )
                parent_node["subslices"].append(node)

        # Stable ordering: sort roots and subslices by id
        def sort_tree(n: Dict[str, Any]) -> None:
            n["subslices"] = sorted(n["subslices"], key=lambda x: x["id"])
            for ch in n["subslices"]:
                sort_tree(ch)

        roots = sorted(roots, key=lambda x: x["id"])
        for r in roots:
            sort_tree(r)

        phases[phase_id] = {
            "phase": {
                "id": phase_id,
                "name": "",  # intentionally blank; roadmap is authoritative for names
                "description": "",
                "generated_at": datetime.now(timezone.utc).isoformat(),
            },
            "structure": {"slices": roots},
        }

    return phases


def write_yaml(path: Path, obj: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        yaml.safe_dump(obj, f, sort_keys=False, width=120, allow_unicode=True)


def write_phase_files(registry_dir: Path, phases: Dict[str, Any]) -> List[Tuple[str, Path]]:
    outputs: List[Tuple[str, Path]] = []
    for phase_id, doc in phases.items():
        out_path = registry_dir / f"{phase_id}.yml"
        write_yaml(out_path, doc)
        outputs.append((phase_id, out_path))
    return outputs


def write_registry_index(registry_dir: Path, phases: Dict[str, Any]) -> Path:
    index = {
        "registry_index": {
            "version": 1,
            "root_dir": str(registry_dir.as_posix()),
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "phases": [
                {
                    "id": phase_id,
                    "file": f"{phase_id}.yml",
                    "state": "active",
                }
                for phase_id in sorted(phases.keys())
            ],
            "scripts": [
                {"name": "registry_sync_from_github", "path": str((registry_dir / "registry_sync_from_github.py").as_posix())},
                {"name": "registry_validate", "path": str((registry_dir / "registry_validate.py").as_posix())},
            ],
        }
    }
    out_path = registry_dir / INDEX_FILE_NAME
    write_yaml(out_path, index)
    return out_path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--owner", default=os.getenv("GITHUB_OWNER"), help="GitHub owner/user login (env: GITHUB_OWNER)")
    ap.add_argument("--repo", default=os.getenv("GITHUB_REPO"), help="Repo name (env: GITHUB_REPO) - unused but kept for future")
    ap.add_argument(
        "--project-number",
        type=int,
        default=int(os.getenv("GITHUB_PROJECT_NUMBER", "0") or "0"),
        help="GitHub Project v2 number (env: GITHUB_PROJECT_NUMBER)",
    )
    ap.add_argument("--registry-dir", default=str(REGISTRY_DIR_DEFAULT), help="Registry directory path")
    args = ap.parse_args()

    if not args.owner or args.project_number <= 0:
        raise SystemExit(
            "Missing required config.\n"
            "Provide --owner and --project-number, or set env vars:\n"
            "  GITHUB_OWNER=<you>\n"
            "  GITHUB_PROJECT_NUMBER=<number>\n"
        )

    registry_dir = Path(args.registry_dir)

    cards = fetch_all_cards(owner=args.owner, project_number=args.project_number)
    if not cards:
        print("No cards found with both Card ID and Phase ID set. Nothing to sync.")
        return 0

    phases = build_phase_tree(cards)
    phase_outputs = write_phase_files(registry_dir, phases)
    index_path = write_registry_index(registry_dir, phases)

    print("Synced registry:")
    for phase_id, path in phase_outputs:
        print(f"  - {phase_id}: {path}")
    print(f"  - index: {index_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
