#!/usr/bin/env bash
set -euo pipefail

# Deterministically resolve repository root (folder containing .git)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if [[ -d "${SCRIPT_DIR}/.git" ]]; then
  REPO_ROOT="${SCRIPT_DIR}"
else
  REPO_ROOT="${SCRIPT_DIR}"
  while [[ "${REPO_ROOT}" != "/" && ! -d "${REPO_ROOT}/.git" ]]; do
    REPO_ROOT="$(cd -- "${REPO_ROOT}/.." >/dev/null 2>&1 && pwd)"
  done
  if [[ ! -d "${REPO_ROOT}/.git" ]]; then
    echo "ERROR: Could not locate repo root (no .git found) starting from: ${SCRIPT_DIR}" >&2
    exit 1
  fi
fi

cd "${REPO_ROOT}"

ENTRYPOINT="${REPO_ROOT}/run_runtime.py"
if [[ ! -f "${ENTRYPOINT}" ]]; then
  echo "ERROR: Expected runtime entrypoint not found: ${ENTRYPOINT}" >&2
  exit 1
fi

# IMPORTANT:
# Support both possible layouts:
#  - repo root IS the `lillycore` package  => need parent on PYTHONPATH
#  - repo root CONTAINS `lillycore/`       => need repo root on PYTHONPATH
REPO_PARENT="$(cd -- "${REPO_ROOT}/.." >/dev/null 2>&1 && pwd)"
export PYTHONPATH="${REPO_ROOT}:${REPO_PARENT}${PYTHONPATH:+:${PYTHONPATH}}"

exec python3 "${ENTRYPOINT}" "$@"

