#!/usr/bin/env python3
"""
registry_validate.py

Validate registry YAML files under docs/build/registry/.

Checks:
- YAML parses
- expected keys exist (phase.id, structure.slices)
- slice ids are unique per phase
- parent links resolve (either phase_id or existing slice id)
- basic field types

Requires:
- PyYAML: pip install pyyaml
"""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Any, Dict, List, Set

try:
    import yaml  # type: ignore
except Exception as e:
    raise SystemExit(
        "Missing dependency: PyYAML. Install with: pip install pyyaml\n"
        f"Import error: {e}"
    )

REGISTRY_DIR_DEFAULT = Path("docs/build/registry")


def load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def walk_slices(slices: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    out: List[Dict[str, Any]] = []
    for s in slices:
        out.append(s)
        subs = s.get("subslices") or []
        if subs:
            if not isinstance(subs, list):
                raise ValueError(f"subslices must be a list (slice {s.get('id')})")
            out.extend(walk_slices(subs))
    return out


def validate_phase_file(path: Path) -> List[str]:
    errors: List[str] = []
    try:
        doc = load_yaml(path)
    except Exception as e:
        return [f"{path}: YAML parse failed: {e}"]

    if not isinstance(doc, dict):
        return [f"{path}: top-level must be a mapping/dict"]

    phase = doc.get("phase")
    structure = doc.get("structure")

    if not isinstance(phase, dict):
        errors.append(f"{path}: missing/invalid 'phase' mapping")
        return errors
    if not isinstance(structure, dict):
        errors.append(f"{path}: missing/invalid 'structure' mapping")
        return errors

    phase_id = phase.get("id")
    if not isinstance(phase_id, str) or not phase_id:
        errors.append(f"{path}: phase.id missing/invalid")
        return errors

    slices = (structure.get("slices") or [])
    if not isinstance(slices, list):
        errors.append(f"{path}: structure.slices must be a list")
        return errors

    all_nodes = walk_slices(slices)

    # Unique IDs
    ids: Set[str] = set()
    for n in all_nodes:
        sid = n.get("id")
        if not isinstance(sid, str) or not sid:
            errors.append(f"{path}: slice missing/invalid id: {n}")
            continue
        if sid in ids:
            errors.append(f"{path}: duplicate slice id '{sid}'")
        ids.add(sid)

    # Parent links
    for n in all_nodes:
        sid = n.get("id")
        parent = n.get("parent")
        if not isinstance(parent, str) or not parent:
            errors.append(f"{path}: slice '{sid}' missing/invalid parent")
            continue
        if parent != phase_id and parent not in ids:
            errors.append(f"{path}: slice '{sid}' parent '{parent}' not found (phase '{phase_id}')")

    # Basic required fields
    for n in all_nodes:
        sid = n.get("id", "<unknown>")
        for key in ("title", "executor_role", "qa_status"):
            if key not in n:
                errors.append(f"{path}: slice '{sid}' missing '{key}'")
        delivers = n.get("delivers", [])
        if delivers is None:
            delivers = []
        if not isinstance(delivers, list):
            errors.append(f"{path}: slice '{sid}' delivers must be list")
        subs = n.get("subslices", [])
        if subs is None:
            subs = []
        if not isinstance(subs, list):
            errors.append(f"{path}: slice '{sid}' subslices must be list")

    return errors


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--registry-dir", default=str(REGISTRY_DIR_DEFAULT))
    args = ap.parse_args()

    reg_dir = Path(args.registry_dir)
    phase_files = sorted([p for p in reg_dir.glob("p*.yml") if p.name != "phase_registry_index.yml"])

    if not phase_files:
        print(f"No phase registry files found in {reg_dir}")
        return 0

    all_errors: List[str] = []
    for pf in phase_files:
        all_errors.extend(validate_phase_file(pf))

    if all_errors:
        print("REGISTRY VALIDATION: FAIL")
        for e in all_errors:
            print(f"- {e}")
        return 1

    print("REGISTRY VALIDATION: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
