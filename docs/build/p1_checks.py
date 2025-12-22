#!/usr/bin/env python3
"""
Canonical local entrypoint for Phase 1 checks.

Runs, in order:
1) Ruff (lint)
2) Black (format check)
3) Pytest (tests)

Resolves tools robustly across PATH / pipx / venv installs.
"""

from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path


def _repo_root_from_this_file() -> Path:
    # <repo_root>/docs/build/p1_checks.py
    return Path(__file__).resolve().parents[2]


def _resolve_tool(tool: str) -> list[str]:
    """
    Resolve a tool invocation.

    Priority:
    1) PATH binary (pipx, system install)
    2) python -m <tool> (venv / module install)
    """
    binary = shutil.which(tool)
    if binary:
        return [binary]

    # Fallback to python -m
    return [sys.executable, "-m", tool]


def _run(cmd: list[str], cwd: Path) -> int:
    print(f"\n$ {' '.join(cmd)}", flush=True)
    try:
        completed = subprocess.run(cmd, cwd=str(cwd))
        return int(completed.returncode)
    except FileNotFoundError:
        print(f"ERROR: tool not found: {cmd[0]}", file=sys.stderr, flush=True)
        return 127



def main() -> int:
    repo_root = _repo_root_from_this_file()

    ruff = _resolve_tool("ruff") + ["check", "."]
    black = _resolve_tool("black") + ["--check", "."]
    pytest = _resolve_tool("pytest")

    steps = [ruff, black, pytest]

    for cmd in steps:
        rc = _run(cmd, cwd=repo_root)
        if rc != 0:
            return rc
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
