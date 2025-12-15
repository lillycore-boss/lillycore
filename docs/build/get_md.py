#!/usr/bin/env python3
import argparse, sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML missing. Install: python3 -m pip install pyyaml")

def file_for(block_id: str, root: Path) -> Path:
    prefix = block_id.split(".", 1)[0]
    return root / f"{prefix}.yml"

def load_blocks(path: Path):
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(data, list):
        raise ValueError(f"{path} must be a top-level YAML list of blocks")
    return data

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default="docs/build", help="docs/build root")
    ap.add_argument("--block", nargs="+", required=True, help="one or more block IDs")
    ap.add_argument("--mode", choices=["md", "block"], default="md",
                    help="md=print md only, block=print full YAML block")
    args = ap.parse_args()

    root = Path(args.root)
    # group requested blocks by file
    by_file = {}
    for bid in args.block:
        by_file.setdefault(file_for(bid, root), []).append(bid)

    out = []
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
