#!/usr/bin/env python3
import argparse
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML missing. Install: python3 -m pip install pyyaml")


def prefix_for(block_id: str) -> str:
    return block_id.split(".", 1)[0]


def load_blocks(path: Path):
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(data, list):
        raise ValueError(f"{path} must be a top-level YAML list of blocks")
    return data


def search_bases(root: Path, override: Path | None) -> list[Path]:
    if override is not None:
        return [override]
    # Default: root, parent, grandparent
    bases = [root, root.parent, root.parent.parent]
    # Deduplicate while preserving order (in case root is '.' or similar)
    seen = set()
    out = []
    for b in bases:
        b = b.resolve()
        if b not in seen:
            seen.add(b)
            out.append(b)
    return out


def find_block_file(prefix: str, root: Path, override_search_root: Path | None, cache: dict[str, Path | None]) -> Path | None:
    """
    Resolve <prefix>.yml.

    Non-breaking behaviour:
      1) First, check root/<prefix>.yml exactly (old behaviour).
      2) If missing, search recursively in:
         - root
         - root.parent
         - root.parent.parent
         (or override_search_root if provided)

    If multiple matches are found, raise a clear error.
    """
    if prefix in cache:
        return cache[prefix]

    # 1) old exact-path behaviour
    direct = (root / f"{prefix}.yml")
    if direct.exists():
        cache[prefix] = direct
        return direct

    # 2) recursive search
    candidates: list[Path] = []
    for base in search_bases(root, override_search_root):
        if not base.exists():
            continue
        # rglob can raise on permission issues in some environments; keep it robust.
        try:
            candidates.extend([p for p in base.rglob(f"{prefix}.yml") if p.is_file()])
        except (PermissionError, OSError):
            continue

    # Deduplicate (same file via different bases)
    uniq = []
    seen = set()
    for p in candidates:
        rp = p.resolve()
        if rp not in seen:
            seen.add(rp)
            uniq.append(rp)

    if not uniq:
        cache[prefix] = None
        return None

    if len(uniq) > 1:
        # Prefer not to “guess” — fail loudly.
        msg = ["### ERROR: ambiguous block file match:",
               f"prefix: {prefix}",
               "matches:"]
        msg.extend([f"- {p}" for p in uniq])
        raise RuntimeError("\n".join(msg))

    cache[prefix] = uniq[0]
    return uniq[0]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default="docs/build", help="docs/build root (primary location)")
    ap.add_argument("--search-root", default=None,
                    help="optional: override search base (searched recursively); if omitted, searches --root, its parent, and grandparent")
    ap.add_argument("--block", nargs="+", required=True, help="one or more block IDs")
    ap.add_argument("--mode", choices=["md", "block"], default="md",
                    help="md=print md only, block=print full YAML block")
    args = ap.parse_args()

    root = Path(args.root)
    search_root = Path(args.search_root) if args.search_root else None

    # Resolve which file each block belongs to, then group
    resolve_cache: dict[str, Path | None] = {}
    by_file: dict[Path, list[str]] = {}
    missing_prefixes: list[str] = []

    for bid in args.block:
        prefix = prefix_for(bid)
        try:
            path = find_block_file(prefix, root, search_root, resolve_cache)
        except RuntimeError as e:
            # Ambiguous matches: report and abort (safer than partial wrong output)
            sys.exit(str(e))

        if path is None:
            missing_prefixes.append(prefix)
            continue

        by_file.setdefault(path, []).append(bid)

    out: list[str] = []

    # Report missing files (if any)
    for pref in sorted(set(missing_prefixes)):
        out.append(f"### ERROR: missing file for prefix '{pref}' (looked for '{pref}.yml')")

    for path, bids in by_file.items():
        if not path.exists():
            out.append(f"### ERROR: missing file: {path}")
            continue

        blocks = load_blocks(path)
        idx = {b.get("id"): b for b in blocks}

        for bid in bids:
            b = idx.get(bid)
            if not b:
                out.append(f"### ERROR: missing block: {bid} (in {path})")
                continue

            if args.mode == "md":
                out.append(f"## {bid}\n")
                out.append(str(b.get("md", "")).rstrip() + "\n")
            else:
                out.append(yaml.safe_dump([b], sort_keys=False, allow_unicode=True).rstrip() + "\n")

    sys.stdout.write("\n".join(out).rstrip() + "\n")


if __name__ == "__main__":
    main()
