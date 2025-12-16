#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="docs/build/outputs/p0.qa"
mkdir -p "${OUT_DIR}"

# --------------------------------------------------------------------
# REQUIRED: Fill these with the *actual* issue numbers for p0.1–p0.5.
# (Do not guess. Pull from the board or issue list.)
# --------------------------------------------------------------------
P0_1_ISSUE="46"
P0_2_ISSUE="47"
P0_3_ISSUE="48"
P0_4_ISSUE="50"
P0_5_ISSUE="21"

# Capture issue bodies (source of truth for card bodies)
gh issue view "${P0_1_ISSUE}" --json number,title,body --jq '.body' > "${OUT_DIR}/p0.1.issue_body.md"
gh issue view "${P0_2_ISSUE}" --json number,title,body --jq '.body' > "${OUT_DIR}/p0.2.issue_body.md"
gh issue view "${P0_3_ISSUE}" --json number,title,body --jq '.body' > "${OUT_DIR}/p0.3.issue_body.md"
gh issue view "${P0_4_ISSUE}" --json number,title,body --jq '.body' > "${OUT_DIR}/p0.4.issue_body.md"
gh issue view "${P0_5_ISSUE}" --json number,title,body --jq '.body' > "${OUT_DIR}/p0.5.issue_body.md"

# Capture the docs under test (from working tree)
# NOTE: These paths must exist in-repo; if any differ, adjust *explicitly*.
cp -f "docs/modules.yml"              "${OUT_DIR}/docs.modules.yml"
cp -f "docs/system_canon.yml"         "${OUT_DIR}/docs.system_canon.yml"
cp -f "docs/system_resource_index.yml" "${OUT_DIR}/docs.system_resource_index.yml"

# Minimal manifest (recommended by tech_spec.proof_outputs_convention)
cat > "${OUT_DIR}/manifest.txt" <<EOF
p0.qa input capture
Timestamp: $(date -Iseconds)

Issue bodies:
- p0.1 -> ${P0_1_ISSUE} -> p0.1.issue_body.md
- p0.2 -> ${P0_2_ISSUE} -> p0.2.issue_body.md
- p0.3 -> ${P0_3_ISSUE} -> p0.3.issue_body.md
- p0.4 -> ${P0_4_ISSUE} -> p0.4.issue_body.md
- p0.5 -> ${P0_5_ISSUE} -> p0.5.issue_body.md

Docs captured:
- docs/modules.yml              -> docs.modules.yml
- docs/system_canon.yml         -> docs.system_canon.yml
- docs/system_resource_index.yml -> docs.system_resource_index.yml
EOF

echo "Captured inputs to: ${OUT_DIR}"
