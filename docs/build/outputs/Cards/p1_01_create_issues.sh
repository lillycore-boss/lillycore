#!/usr/bin/env bash
set -euo pipefail

OWNER="lillycore-boss"
MAIN_PROJECT_TITLE="LillyCORE Main"
WORKDIR="/tmp/lillycore_cards/p1"
MANIFEST="${WORKDIR}/p1_manifest.tsv"

mkdir -p "$WORKDIR"

echo "Writing bodies under: $WORKDIR"

touch "$MANIFEST"

fail(){ echo "ERROR: $*" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || fail "gh CLI not found"
command -v jq >/dev/null 2>&1 || fail "jq not found"

# ------------------------------
# Card bodies (same as before)
# ------------------------------
cat > "$WORKDIR/P1.1.md" <<'EOF'
Card ID: P1.1
Card Title: P1.1 — Runtime Core Loop Owner (Heartbeat + Envelope Integration Plan)
Executor Role: Architect

Phase Context:
  Phase: P1
  Slice: P1.1
  Parent Card: P1

Deliverables Served:
  - P1.D1
  - P1.D3

Description:
  This card owns the Phase 1 runtime “heartbeat” and establishes the plan/contract for a core loop capable of continuous operation, including how structured errors (error envelopes) are created/propagated and how the loop interacts with unified logging and preferences.
  This card does NOT implement the runtime loop. It produces bounded, concrete leaf Implementer cards and P1.1.QA only when required operational authorities are available to avoid guessing.
EOF

cat > "$WORKDIR/P1.2.md" <<'EOF'
Card ID: P1.2
Card Title: P1.2 — Logging + Error Envelope Owner (Spec + Wiring Plan)
Executor Role: Architect

Phase Context:
  Phase: P1
  Slice: P1.2
  Parent Card: P1

Deliverables Served:
  - P1.D2
  - P1.D3

Description:
  Owns unified logging definition (entry points + formatting rules) and the error envelope contract needed for wiring into logging/runtime.
  Does NOT implement; spawns leaves + slice QA when constraints are known.
EOF

cat > "$WORKDIR/P1.3.md" <<'EOF'
Card ID: P1.3
Card Title: P1.3 — Preferences Owner (Loader + Persistence + Overrides Contract)
Executor Role: Architect

Phase Context:
  Phase: P1
  Slice: P1.3
  Parent Card: P1

Deliverables Served:
  - P1.D4

Description:
  Owns Phase 1 preference loader contract (defaults, precedence, overrides, persistence). Does NOT implement; spawns leaves + P1.3.QA when constraints are known.
EOF

cat > "$WORKDIR/P1.4.md" <<'EOF'
Card ID: P1.4
Card Title: P1.4 — AI Pool Structural Definitions Owner (Types/Fields/Relationships Only)
Executor Role: Architect

Phase Context:
  Phase: P1
  Slice: P1.4
  Parent Card: P1

Deliverables Served:
  - P1.D5

Description:
  Defines AI pool structural model only (types/fields/relationships). No execution/scheduling.
EOF

cat > "$WORKDIR/P1.5.md" <<'EOF'
Card ID: P1.5
Card Title: P1.5 — Infrastructure Baseline Owner (Detect/Validate Before Change)
Executor Role: Architect

Phase Context:
  Phase: P1
  Slice: P1.5
  Parent Card: P1

Deliverables Served:
  - P1.D6

Description:
  Owns Phase 1 infra baseline as controlled change: detect/validate existing repo/CI/tooling before any changes; then spawn leaves.
EOF

cat > "$WORKDIR/P1.QA.md" <<'EOF'
Card ID: P1.QA
Card Title: P1.QA — Phase 1 Deliverables Sign-off (D1–D6)
Executor Role: QA

Phase Context:
  Phase: P1
  Slice: P1.QA
  Parent Card: P1

Deliverables Served:
  - P1.D1
  - P1.D2
  - P1.D3
  - P1.D4
  - P1.D5
  - P1.D6

Description:
  Phase-level deliverables sign-off. Validates P1.D1–P1.D6 before phase completion.
EOF

# ------------------------------
# Helpers
# ------------------------------

# Best-effort REUSE lookup by exact title (for cards you already created).
resolve_issue_number_by_title() {
  local full_title="$1"
  gh issue list --author "@me" --limit 200 \
    --json number,title,createdAt \
    --jq "[.[] | select(.title == \"$full_title\")] | sort_by(.createdAt) | last | .number" \
    | tr -d '\n'
}

# Deterministic: parse issue number from gh issue create stdout URL.
# Typical output contains a URL like https://github.com/<owner>/<repo>/issues/<N>
extract_issue_number_from_create_output() {
  local out="$1"
  echo "$out" \
    | grep -Eo 'https?://[^ ]+/issues/[0-9]+' \
    | tail -n 1 \
    | sed -E 's#.*/issues/([0-9]+)$#\1#'
}

create_or_resolve() {
  local card_id="$1"; shift
  local title_tail="$1"; shift
  local body_file="$1"; shift
  local full_title="${card_id} — ${title_tail}"

  # Idempotent: if already in manifest, keep it
  if grep -qE "^${card_id}\t" "$MANIFEST"; then
    echo "SKIP (manifest): $card_id"
    return 0
  fi

  # Reuse if it already exists (exact title)
  local existing
  existing="$(resolve_issue_number_by_title "$full_title" || true)"
  if [[ -n "$existing" && "$existing" != "null" ]]; then
    printf "%s\t%s\t%s\n" "$card_id" "$existing" "$full_title" >> "$MANIFEST"
    echo "REUSE: $card_id -> #$existing"
    return 0
  fi

  # Create (capture stdout; older gh can't return JSON)
  local create_out
  create_out=$(gh issue create \
    --title "$full_title" \
    --body-file "$body_file" \
    --project "$MAIN_PROJECT_TITLE")

  local issue_number
  issue_number="$(extract_issue_number_from_create_output "$create_out" || true)"
  if [[ -z "$issue_number" || "$issue_number" == "null" ]]; then
    # fallback (rare)
    issue_number="$(resolve_issue_number_by_title "$full_title" || true)"
  fi

  [[ -n "$issue_number" && "$issue_number" != "null" ]] || fail "Could not resolve issue number for $card_id ($full_title)"

  printf "%s\t%s\t%s\n" "$card_id" "$issue_number" "$full_title" >> "$MANIFEST"
  echo "CREATED: $card_id -> #$issue_number"
}

# ------------------------------
# Run
# ------------------------------
: > "$MANIFEST"
create_or_resolve "P1.1" "Runtime Core Loop Owner (Heartbeat + Envelope Integration Plan)" "$WORKDIR/P1.1.md"
create_or_resolve "P1.2" "Logging + Error Envelope Owner (Spec + Wiring Plan)" "$WORKDIR/P1.2.md"
create_or_resolve "P1.3" "Preferences Owner (Loader + Persistence + Overrides Contract)" "$WORKDIR/P1.3.md"
create_or_resolve "P1.4" "AI Pool Structural Definitions Owner (Types/Fields/Relationships Only)" "$WORKDIR/P1.4.md"
create_or_resolve "P1.5" "Infrastructure Baseline Owner (Detect/Validate Before Change)" "$WORKDIR/P1.5.md"
create_or_resolve "P1.QA" "Phase 1 Deliverables Sign-off (D1–D6)" "$WORKDIR/P1.QA.md"

echo
echo "Manifest written: $MANIFEST"
cat "$MANIFEST"

