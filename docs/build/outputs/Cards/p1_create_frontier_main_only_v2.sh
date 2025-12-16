#!/usr/bin/env bash
set -euo pipefail

# One script, two calls per card:
#  1) gh issue create (adds to project)
#  2) gh project item edit (sets custom fields)
# Uses GraphQL to resolve the Project Item ID for the created issue.

# --- CONFIG (fill these in) ---
OWNER="lillycore-boss"               # e.g. "andrew" or "YourOrg"
MAIN_PROJECT_TITLE="LillyCORE Main"     # must match the Projects UI title
MAIN_PROJECT_NUMBER="6"  # the numeric project number in the URL  # the numeric project number in the URL
ATTEMPT_NUMBER="1"
PHASE_ID="p1"

# --- sanity checks ---
fail() { echo "ERROR: $*" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || fail "gh CLI not found"
command -v jq >/dev/null 2>&1 || fail "jq not found (required)"

[[ "$OWNER" != "<ORG_OR_USERNAME>" && -n "$OWNER" ]] || fail "Set OWNER"
[[ "$MAIN_PROJECT_NUMBER" != "<MAIN_PROJECT_NUMBER>" && -n "$MAIN_PROJECT_NUMBER" ]] || fail "Set MAIN_PROJECT_NUMBER"
[[ -n "$MAIN_PROJECT_TITLE" ]] || fail "Set MAIN_PROJECT_TITLE"

WORKDIR="/tmp/lillycore_cards/p1"
mkdir -p "$WORKDIR"

# --- Helpers ---

# Resolve the ProjectV2 node ID from owner + project number
get_project_v2_id() {
  gh api graphql -f query="query { user(login: \"${OWNER}\") { projectV2(number: ${MAIN_PROJECT_NUMBER}) { id } } }" \
    --jq '.data.user.projectV2.id'
}


PROJECT_V2_ID="$(get_project_v2_id)"
[[ -n "$PROJECT_V2_ID" && "$PROJECT_V2_ID" != "null" ]] || fail "Could not resolve ProjectV2 ID. Check OWNER + MAIN_PROJECT_NUMBER."

# Find the project item ID for a given issue number by scanning items.
# This is fine for small boards; if your project has thousands of items, we can page.
get_item_id_for_issue_number() {
  local issue_number="$1"
  gh api graphql -F projectId="$PROJECT_V2_ID" -F n="$issue_number" -f query='
    query($projectId:ID!, $n:Int!) {
      node(id:$projectId) {
        ... on ProjectV2 {
          items(first:200) {
            nodes {
              id
              content {
                ... on Issue { number }
              }
            }
          }
        }
      }
    }' | jq -r ".data.node.items.nodes[] | select(.content.number == ${issue_number}) | .id" | head -n 1
}

get_issue_number_by_title() {
  local expected_title="$1"
  gh issue list \
    --author "@me" \
    --limit 20 \
    --json number,title \
    --jq ".[] | select(.title == \"$expected_title\") | .number" \
  | head -n 1
}

create_issue_and_set_fields() {
  local card_id="$1"
  local title="$2"
  local parent_id="$3"
  local role="$4"
  local deliverables_csv="$5"
  local body_file="$6"
  local full_title="${card_id} — ${title}"

  # 1) Create issue (and add to main project by title)
  gh issue create \
    --title "$full_title" \
    --body-file "$body_file" \
    --project "$MAIN_PROJECT_TITLE" >/dev/null

  # 2) Resolve issue number afterwards (gh version-safe)
  local issue_number
  issue_number="$(get_issue_number_by_title "$full_title")"
  [[ -n "$issue_number" && "$issue_number" != "null" ]] || fail "Could not resolve issue number for $card_id"

  # 3) Resolve Project Item ID (may lag due to eventual consistency)
  local item_id=""
  local tries=12
  local sleep_s=1

  for ((i=1; i<=tries; i++)); do
    item_id="$(get_item_id_for_issue_number "$issue_number" || true)"
    if [[ -n "$item_id" && "$item_id" != "null" ]]; then
      break
    fi
    sleep "$sleep_s"
  done


  gh project item edit "$item_id" \
    --project "$MAIN_PROJECT_NUMBER" \
    --field "Card ID=$card_id" \
    --field "Phase ID=$PHASE_ID" \
    --field "Parent ID=$parent_id" \
    --field "Executor Role=$role" \
    --field "Deliverables=$deliverables_csv" \
    --field "Attempt #=$ATTEMPT_NUMBER"

  echo "Created $card_id as issue #$issue_number; set fields on item $item_id"
}

# --- Card bodies ---

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

---
Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:
- all blocks listed below are loaded, OR
- Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else:
Bootstrap (minimum operating context for any task):
  Run:
  python3 docs/build/get_md.py --block \
    block_loading.overview \
    block_loading.script_interface \
    block_loading.canvas_usage \
    block_loading.operating_principles \
    gpt_resource_index.index \
    gpt_resource_index.load_paths \
    documentation_protocol.required_stop_on_missing_context

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec

Inputs / Preconditions:
  - Phase 0 documentation governance + repo taxonomy standards are complete.
  - Roadmap intent for P1 is accepted.

Constraints:
  - MUST NOT implement runtime loop or write code in this card.
  - MUST NOT define Phase 2+ behaviors.
  - MUST NOT generate downstream Implementer cards that rely on unknown file paths.

Steps:
  1. Establish runtime loop boundaries.
  2. Define integration points (conceptual): logging, envelope wrapping, preference load.
  3. Identify missing governing constraints; STOP and request authority if missing.
  4. Spawn leaf Implementer cards once constraints are known.
  5. Spawn slice QA: P1.1.QA.

Done When:
  - Runtime-loop plan exists traceable to P1.D1.
  - Envelope integration expectations specified without inventing schema details.
  - Leaves and slice QA are created only with concrete targets OR card is explicitly BLOCKED.
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

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec

Constraints:
  - MUST NOT implement.
  - MUST NOT invent envelope fields/taxonomy without authority.

Steps:
  1. Define logging contract and entry points.
  2. Define envelope contract; request decision if missing.
  3. STOP if TECH_SPEC constraints are required but unavailable.
  4. Spawn leaves + P1.2.QA when concrete.

Done When:
  - P1.D2 logging spec exists.
  - P1.D3 envelope contract exists.
  - Leaves and slice QA created without guessing.
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

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec

Constraints:
  - MUST NOT implement.
  - MUST NOT guess persistence mechanism or paths.

Steps:
  1. Define precedence rules.
  2. Define persistence contract.
  3. STOP if missing constraints.
  4. Spawn leaves + P1.3.QA when concrete.

Done When:
  - Contract exists serving P1.D4.
  - Leaves and slice QA created without guessing.
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

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec

Constraints:
  - MUST NOT add pool execution semantics.
  - MUST NOT guess where definitions live.

Steps:
  1. Define minimal structures.
  2. STOP if storage target unknown.
  3. Spawn P1.4.1 leaf if/when concrete.

Done When:
  - Structural definitions exist (P1.D5).
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

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec
  - registry_system.script_contracts

Constraints:
  - MUST detect/validate first.
  - MUST NOT guess CI/provider/paths.

Steps:
  1. Define infra audit checklist.
  2. STOP if missing constraints.
  3. Spawn leaves + optional slice QA when concrete.

Done When:
  - Plan exists + leaves concrete (P1.D6).
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

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - qa_reference.qa_report_template
  - build_github_reference.github_automation_scripts
  - registry_system.gpt_usage_guidelines

Constraints:
  - MUST produce PASS/FAIL per deliverable.

Steps:
  1. Verify each deliverable with evidence.
  2. Append QA report deterministically.
  3. If FAIL, create corrective cards on Main board.

Done When:
  - PASS/FAIL recorded for each deliverable.
EOF

# --- Create issues + set fields ---

create_issue_and_set_fields "P1.1" "Runtime Core Loop Owner (Heartbeat + Envelope Integration Plan)" "P1" "architect" "P1.D1,P1.D3" "$WORKDIR/P1.1.md"
create_issue_and_set_fields "P1.2" "Logging + Error Envelope Owner (Spec + Wiring Plan)" "P1" "architect" "P1.D2,P1.D3" "$WORKDIR/P1.2.md"
create_issue_and_set_fields "P1.3" "Preferences Owner (Loader + Persistence + Overrides Contract)" "P1" "architect" "P1.D4" "$WORKDIR/P1.3.md"
create_issue_and_set_fields "P1.4" "AI Pool Structural Definitions Owner (Types/Fields/Relationships Only)" "P1" "architect" "P1.D5" "$WORKDIR/P1.4.md"
create_issue_and_set_fields "P1.5" "Infrastructure Baseline Owner (Detect/Validate Before Change)" "P1" "architect" "P1.D6" "$WORKDIR/P1.5.md"
create_issue_and_set_fields "P1.QA" "Phase 1 Deliverables Sign-off (D1–D6)" "P1" "qa" "P1.D1,P1.D2,P1.D3,P1.D4,P1.D5,P1.D6" "$WORKDIR/P1.QA.md"

# --- Registry: sync then validate ---
python3 docs/build/registry/registry_sync_from_github.py
python3 docs/build/registry/registry_validate.py

