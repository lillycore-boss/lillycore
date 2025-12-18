#!/usr/bin/env bash
set -euo pipefail

# Always run Phase 1 harness from the repo root (no matter where you call it from)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"
PYTHONPATH="." python3 lillycore/run_runtime.py
