#!/usr/bin/env python3
"""
registry_sync_from_github_smoketest.py

Purpose:
- Read GitHub ProjectV2 items via gh + GraphQL
- Extract card metadata fields
- Emit a registry snapshot suitable for building per-phase registry files

This is a SMOKE TEST:
- It must run end-to-end without crashing.
- It skips items missing required fields, logging why.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from dataclasses import dataclass, asdict
from datetime import datetime
from typing import Any, Dict, List, Optional, Tuple

# ----- Config: expected custom field names on your ProjectV2 -----
DEFAULT_FIELD_NAMES = {
    "card_id": "Card ID",
    "phase_id": "Phase ID",
    "parent_id": "Parent ID",
    "executor_role": "Executor Role",
    "deliverables": "Deleverables",  # NOTE: you spelled it "Deleverables" earlier; change to "Deliverables" if that's the real field name.
    "attempt": "Attempt #",
}

# If your field is actually named "Deliverables" (correct spelling), set it at runtime:
#   --field deliverables="Deliverables"


@dataclass
class ProjectItem:
    github_item_id: str
    title: str
    url: str
    number: Optional[int]  # issue/PR number if available
    card_id: Optional[str]
    phase_id: Optional[str]
    parent_id: Optional[str]
    executor_role: Optional[str]
    deliverables: Optional[str]
    attempt: Optional[int]


def run_gh_graphql(query: str, variables: Dict[str, Any]) -> Dict[str, Any]:
    """Run a GitHub GraphQL query using `gh api graphql`."""
    cmd = ["gh", "api", "graphql", "-f", f"query={query}"]
    for k, v in variables.items():
        # Use -F for ints, -f for strings; gh doesn't mind strings with -f but we keep it clean.
        if isinstance(v, int):
            cmd += ["-F", f"{k}={v}"]
        else:
            cmd += ["-f", f"{k}={v}"]

    proc = subprocess.run(cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        print(proc.stdout)
        print(proc.stderr, file=sys.stderr)
        raise RuntimeError(f"gh api graphql failed (exit {proc.returncode})")

    data = json.loads(proc.stdout)
    if "errors" in data:
        raise RuntimeError(f"GraphQL errors: {json.dumps(data['errors'], indent=2)}")
    return data


def get_project_id(owner: str, project_number: int) -> str:
    query = """
    query($login:String!, $n:Int!) {
      user(login: $login) {
        projectV2(number: $n) {
          id
          title
        }
      }
    }
    """
    data = run_gh_graphql(query, {"login": owner, "n": project_number})
    proj = data["data"]["user"]["projectV2"]
    if not proj or not proj.get("id"):
        raise RuntimeError("Could not resolve projectV2 id.")
    return proj["id"]


def get_project_fields(project_id: str) -> Dict[str, str]:
    """
    Return mapping: fieldName -> fieldId
    """
    query = """
    query($pid:ID!) {
      node(id:$pid) {
        ... on ProjectV2 {
          fields(first: 100) {
            nodes {
              ... on ProjectV2FieldCommon {
                id
                name
              }
            }
          }
        }
      }
    }
    """
    data = run_gh_graphql(query, {"pid": project_id})
    nodes = data["data"]["node"]["fields"]["nodes"]
    out: Dict[str, str] = {}
    for f in nodes:
        if f and f.get("name") and f.get("id"):
            out[f["name"]] = f["id"]
    return out


def parse_field_value(field_node: Dict[str, Any]) -> Optional[str]:
    """
    Pull a human value out of ProjectV2ItemFieldValue union.
    We only need text/number/single-select for the smoke test.
    """
    if not field_node:
        return None

    # text
    if "text" in field_node and field_node["text"] is not None:
        return str(field_node["text"])

    # number
    if "number" in field_node and field_node["number"] is not None:
        # store as string; we can cast later
        return str(field_node["number"])

    # single select
    if "name" in field_node and field_node["name"] is not None:
        return str(field_node["name"])

    return None


def fetch_all_items(project_id: str) -> List[Dict[str, Any]]:
    """
    Fetch all items via pagination.
    Each item includes content (issue/pr/draft), plus fieldValues.
    """
    query = """
    query($pid:ID!, $cursor:String) {
      node(id:$pid) {
        ... on ProjectV2 {
          items(first: 50, after: $cursor) {
            pageInfo { hasNextPage endCursor }
            nodes {
              id
              content {
                ... on Issue { number title url }
                ... on PullRequest { number title url }
              }
              fieldValues(first: 50) {
                nodes {
                  ... on ProjectV2ItemFieldTextValue {
                    text
                    field { ... on ProjectV2FieldCommon { name } }
                  }
                  ... on ProjectV2ItemFieldNumberValue {
                    number
                    field { ... on ProjectV2FieldCommon { name } }
                  }
                  ... on ProjectV2ItemFieldSingleSelectValue {
                    name
                    field { ... on ProjectV2FieldCommon { name } }
                  }
                }
              }
            }
          }
        }
      }
    }
    """

    items: List[Dict[str, Any]] = []
    cursor: Optional[str] = None

    while True:
        vars_: Dict[str, Any] = {"pid": project_id}
        if cursor:
            vars_["cursor"] = cursor

        data = run_gh_graphql(query, vars_)
        block = data["data"]["node"]["items"]
        nodes = block["nodes"] or []
        items.extend(nodes)

        pi = block["pageInfo"]
        if not pi["hasNextPage"]:
            break
        cursor = pi["endCursor"]

    return items


def build_project_items(raw_items: List[Dict[str, Any]], field_names: Dict[str, str]) -> Tuple[List[ProjectItem], List[str]]:
    """
    Convert raw GraphQL items into typed ProjectItem list.
    Return (items, warnings)
    """
    warnings: List[str] = []
    out: List[ProjectItem] = []

    for node in raw_items:
        content = node.get("content") or {}
        title = content.get("title") or "(no title)"
        url = content.get("url") or ""
        number = content.get("number")

        # map fieldValues by field name -> parsed value
        fv_map: Dict[str, str] = {}
        for fv in (node.get("fieldValues") or {}).get("nodes") or []:
            field = (fv.get("field") or {})
            fname = field.get("name")
            if not fname:
                continue
            val = parse_field_value(fv)
            if val is not None:
                fv_map[fname] = val

        def get(name_key: str) -> Optional[str]:
            fname = field_names.get(name_key)
            if not fname:
                return None
            return fv_map.get(fname)

        attempt_raw = get("attempt")
        attempt_int: Optional[int] = None
        if attempt_raw is not None:
            try:
                attempt_int = int(float(attempt_raw))
            except ValueError:
                warnings.append(f"Item '{title}' has non-numeric Attempt #: {attempt_raw!r}")

        out.append(
            ProjectItem(
                github_item_id=node["id"],
                title=title,
                url=url,
                number=number,
                card_id=get("card_id"),
                phase_id=get("phase_id"),
                parent_id=get("parent_id"),
                executor_role=get("executor_role"),
                deliverables=get("deliverables"),
                attempt=attempt_int,
            )
        )

    return out, warnings


def group_by_phase(items: List[ProjectItem]) -> Dict[str, List[ProjectItem]]:
    phases: Dict[str, List[ProjectItem]] = {}
    for it in items:
        if not it.phase_id:
            continue
        pid = it.phase_id.strip()
        phases.setdefault(pid, []).append(it)
    return phases


def ensure_dir(path: str) -> None:
    os.makedirs(path, exist_ok=True)


def write_snapshot(out_dir: str, items: List[ProjectItem], warnings: List[str], field_names: Dict[str, str]) -> str:
    ensure_dir(out_dir)
    payload = {
        "generated_at": datetime.utcnow().isoformat() + "Z",
        "field_names_used": field_names,
        "warnings": warnings,
        "items": [asdict(i) for i in items],
    }
    fp = os.path.join(out_dir, "registry_snapshot.json")
    with open(fp, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2)
    return fp


def write_minimal_phase_yamls(out_dir: str, phases: Dict[str, List[ProjectItem]]) -> List[str]:
    """
    Minimal YAML output: just enough to prove grouping works.
    You can replace this later with your real schema.
    """
    ensure_dir(out_dir)
    written: List[str] = []

    for phase_id, items in sorted(phases.items(), key=lambda kv: kv[0]):
        # normalize p0/p1/p2 style filenames
        phase_file = phase_id.lower().replace(".", "_")
        fp = os.path.join(out_dir, f"{phase_file}.yml")

        lines: List[str] = []
        lines.append(f"phase:")
        lines.append(f"  id: {phase_id}")
        lines.append(f"  slices:")
        # only include items that have Card ID; skip otherwise
        for it in sorted(items, key=lambda x: (x.card_id or "", x.title)):
            if not it.card_id:
                continue
            lines.append(f"    - card_id: {it.card_id}")
            lines.append(f"      title: {it.title!r}")
            if it.parent_id:
                lines.append(f"      parent_id: {it.parent_id}")
            if it.executor_role:
                lines.append(f"      executor_role: {it.executor_role!r}")
            if it.deliverables:
                lines.append(f"      deliverables: {it.deliverables!r}")
            if it.attempt is not None:
                lines.append(f"      attempt: {it.attempt}")
            if it.number is not None:
                lines.append(f"      github_issue_number: {it.number}")
            if it.url:
                lines.append(f"      url: {it.url!r}")

        with open(fp, "w", encoding="utf-8") as f:
            f.write("\n".join(lines) + "\n")

        written.append(fp)

    return written


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--owner", required=True, help="GitHub username/org owning the project (e.g. lillycore-boss)")
    ap.add_argument("--project-number", required=True, type=int, help="ProjectV2 number (e.g. 6)")
    ap.add_argument("--out-dir", default="builds/outputs/registry_smoketest", help="Output directory for snapshot files")
    ap.add_argument("--emit-phase-yamls", action="store_true", help="Write minimal per-phase YAML files to out-dir")

    # allow overriding field names
    ap.add_argument("--field", action="append", default=[], help='Override field mapping: key=name (e.g. --field deliverables="Deliverables")')

    args = ap.parse_args()

    field_names = dict(DEFAULT_FIELD_NAMES)
    for ov in args.field:
        if "=" not in ov:
            raise SystemExit(f"Invalid --field {ov!r}; expected key=value")
        k, v = ov.split("=", 1)
        k = k.strip()
        v = v.strip()
        if k not in field_names:
            raise SystemExit(f"Unknown field key {k!r}. Allowed: {', '.join(field_names.keys())}")
        field_names[k] = v

    project_id = get_project_id(args.owner, args.project_number)

    # Not strictly needed for smoke test, but nice sanity: warn if expected fields don't exist.
    fields = get_project_fields(project_id)
    missing = [field_names[k] for k in field_names if field_names[k] not in fields]
    if missing:
        print("WARN: The following expected Project fields were not found (script will still run, values may be blank):")
        for m in missing:
            print(f"  - {m}")

    raw_items = fetch_all_items(project_id)
    items, warnings = build_project_items(raw_items, field_names)

    # Hard requirement for "usable in registry": Card ID + Phase ID
    usable = [i for i in items if i.card_id and i.phase_id]
    skipped = [i for i in items if not (i.card_id and i.phase_id)]
    if skipped:
        warnings.append(f"Skipped {len(skipped)} items missing Card ID and/or Phase ID (see snapshot for details).")

    phases = group_by_phase(usable)
    snapshot_fp = write_snapshot(args.out_dir, items, warnings, field_names)

    print(f"Wrote snapshot: {snapshot_fp}")
    print(f"Total items: {len(items)} | usable (has Card ID + Phase ID): {len(usable)} | phases: {len(phases)}")
    if warnings:
        print("Warnings:")
        for w in warnings:
            print(f"  - {w}")

    if args.emit_phase_yamls:
        written = write_minimal_phase_yamls(args.out_dir, phases)
        print(f"Wrote {len(written)} phase YAML files under: {args.out_dir}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
