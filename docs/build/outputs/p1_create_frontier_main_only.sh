#!/usr/bin/env bash
set -euo pipefail

# --- CONFIG (fill these in) ---
MAIN_PROJECT_NUMBER="<MAIN_PROJECT_NUMBER>"   # LillyCORE Main
ATTEMPT_NUMBER="1"
PHASE_ID="p1"

# --- sanity checks ---
if [[ "$MAIN_PROJECT_NUMBER" == "6" ]] || [[ -z "$MAIN_PROJECT_NUMBER" ]]; then
  echo "ERROR: Set MAIN_PROJECT_NUMBER" >&2
  exit 1
fi

WORKDIR="/tmp/lillycore_cards/p1"
mkdir -p "$WORKDIR"

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
  This card does NOT implement the runtime loop. It produces bounded, concrete leaf Implementer cards and P1.1.QA only when required operational authorities (repo layout/tooling constraints, logging baseline expectations) are available to avoid guessing.

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
  - MUST NOT define Phase 2+ behaviors (scheduling/chaining/AI pool execution).
  - MUST NOT generate downstream Implementer cards that rely on unknown file paths, unknown module layout, or unknown script/tooling conventions.

Steps:
  1. Establish runtime loop boundaries (continuous operation definition, lifecycle states).
  2. Define integration points (conceptual): logging invocation, envelope wrapping, preference load.
  3. Identify missing governing constraints required to safely write leaves; STOP and request authority if missing.
  4. Spawn leaf Implementer cards (only once constraints are known):
     - P1.1.1 (Implementer): implement core runtime loop per P1.1 plan
     - P1.1.2 (Implementer): implement error envelope hooks per approved schema source
  5. Spawn slice QA:
     - P1.1.QA (QA): validate P1.D1 + P1.D3 for this slice before parent proceeds

Done When:
  - Runtime-loop plan exists traceable to P1.D1.
  - Envelope integration expectations specified without inventing schema details (P1.D3).
  - P1.1.* leaves and P1.1.QA are created only with concrete, non-guessed targets OR card is explicitly BLOCKED.

Documentation Updates (implicit requirement):
  - (B) No documentation updates required. Reason: planning/decomposition only.

Notes / Future:
  - If envelope schema authority is missing, route to P1.2 owner slice rather than inventing fields here.
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
  This card owns the unified logging system definition (entry points + formatting rules) and the error envelope contract required to wire into logging and runtime.
  This card does NOT implement logging or envelopes. It produces concrete Implementer leaves and a slice QA once required constraints are known, without guessing.

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec

Inputs / Preconditions:
  - P1 deliverables list is authoritative.

Constraints:
  - MUST NOT implement.
  - MUST provide documented entry points + formatting rules (P1.D2).
  - MUST NOT invent envelope fields/severity taxonomy without authority; request Andrew decision if needed.
  - MUST avoid Phase 2+ observability scope.

Steps:
  1. Define logging contract: channels (conceptual), levels, message structure rules, required metadata, entry points.
  2. Define error envelope contract: required top-level properties, propagation rules, rendering into logs. STOP/request decision if missing.
  3. Identify missing operational constraints (TECH_SPEC/repo conventions). STOP if required.
  4. Spawn Implementer leaves when targets are concrete:
     - P1.2.1 (Implementer): implement unified logger per contract
     - P1.2.2 (Implementer): implement envelope schema + logging integration per contract
     - P1.2.3 (Implementer): wire entry points into runtime hooks (coord with P1.1)
  5. Spawn P1.2.QA validating P1.D2 + P1.D3 for this slice.

Done When:
  - Logging spec exists with checkable formatting rules + entry points.
  - Envelope contract is wiring-ready without invented authority.
  - Leaves + P1.2.QA exist without guessed targets.

Documentation Updates (implicit requirement):
  - (B) No documentation updates required. Reason: planning only.
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
  This card owns the Phase 1 system preference loader contract: defaults, precedence, overrides, and persistence.
  This card does NOT implement storage or loaders. It spawns Implementer leaves + P1.3.QA only when required constraints are known.

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec

Inputs / Preconditions:
  - P1 roadmap intent includes persistent user identity.

Constraints:
  - MUST NOT implement.
  - MUST support persistence + override capability (P1.D4).
  - MUST NOT guess storage mechanism or paths; STOP/request authority/Andrew decision if needed.
  - No Phase 2+ profile management.

Steps:
  1. Define precedence rules (defaults vs persisted vs overrides).
  2. Define persistence contract (what, when, validity rules).
  3. Identify missing constraints; STOP if required.
  4. Spawn Implementer leaves when targets are concrete:
     - P1.3.1 (Implementer): implement preference loader + persistence + overrides
     - P1.3.2 (Implementer): integrate load into runtime startup (coord with P1.1)
  5. Spawn P1.3.QA validating P1.D4.

Done When:
  - Preference contract is explicit and bounded (P1.D4).
  - Leaves + P1.3.QA exist without guessed targets.

Documentation Updates (implicit requirement):
  - (B) No documentation updates required. Reason: planning only.
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
  Defines and documents the AI pool structural model for Phase 1: types, fields, relationships only.
  Does NOT implement execution/scheduling/chaining.

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec

Constraints:
  - MUST NOT add pool execution semantics.
  - MUST NOT guess where definitions live (docs vs code types) without authority.

Steps:
  1. Define minimal structural entities and relationships.
  2. Identify storage target constraints; STOP if unknown.
  3. Spawn Implementer leaf once targets are concrete:
     - P1.4.1 (Implementer): write definitions into approved repo locations
  4. Validation can be handled by P1.QA unless slice QA is required by workflow.

Done When:
  - Structural definitions exist as documented model serving P1.D5.
  - No execution/scheduling scope leakage.
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
  Owns Phase 1 infrastructure setup as a controlled change: define detect/validate-first checklist, then spawn concrete Implementer leaves.
  Does NOT modify repo files/CI directly.

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - build_canon.feature_card_template
  - documentation_protocol.no_placeholder_deferral
  - roadmap.p1
  - gpt_resource_index.tech_spec
  - build_github_reference.github_automation_scripts
  - registry_system.script_contracts

Constraints:
  - MUST include detection/validation of existing setup before proposing changes.
  - MUST NOT guess CI provider, scripts, or repo layout targets.

Steps:
  1. Define infra audit checklist (repo structure, config files, CI workflows, tooling, dev automation).
  2. Identify missing authority; STOP if required.
  3. Spawn Implementer leaves only when targets are concrete:
     - P1.5.1 (Implementer): perform infra audit + record evidence
     - P1.5.2 (Implementer): implement approved infra baseline changes
  4. Spawn P1.5.QA if infra changes are material.

Done When:
  - Detect/validate-first plan exists.
  - Leaves are concrete, non-guessed.
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
  Validates that Phase 1 deliverables P1.D1–P1.D6 are met before signing off the phase.
  Focus: deliverables reality. No implementation changes; FAIL results must point to responsible slice.

---
Block Load Requirements (Hard Gate)

Required Blocks (task-specific; list exact IDs):
  - qa_reference.qa_report_template
  - build_github_reference.github_automation_scripts
  - registry_system.gpt_usage_guidelines

Constraints:
  - MUST produce PASS/FAIL per deliverable P1.D1–P1.D6.
  - MUST append QA report deterministically to end of issue body.

Steps:
  1. For each deliverable P1.D1–P1.D6, identify responsible slices and expected evidence.
  2. Verify and record PASS/FAIL.
  3. Append QA report using canonical template.
  4. If FAIL, create corrective cards in Main board owned by the appropriate slice owner.

Done When:
  - PASS/FAIL recorded for each deliverable.
  - QA report appended to the phase QA issue.
EOF

# --- CREATE MAIN BOARD ISSUES (body-file avoids quoting hell) ---

gh issue create \
  --title "P1.1 — Runtime Core Loop Owner (Heartbeat + Envelope Integration Plan)" \
  --body-file "$WORKDIR/P1.1.md" \
  --project "$MAIN_PROJECT_NUMBER" \
  --field "Card ID=P1.1" \
  --field "Phase ID=$PHASE_ID" \
  --field "Parent ID=P1" \
  --field "Executor Role=architect" \
  --field "Deliverables=P1.D1,P1.D3" \
  --field "Attempt #=$ATTEMPT_NUMBER"

gh issue create \
  --title "P1.2 — Logging + Error Envelope Owner (Spec + Wiring Plan)" \
  --body-file "$WORKDIR/P1.2.md" \
  --project "$MAIN_PROJECT_NUMBER" \
  --field "Card ID=P1.2" \
  --field "Phase ID=$PHASE_ID" \
  --field "Parent ID=P1" \
  --field "Executor Role=architect" \
  --field "Deliverables=P1.D2,P1.D3" \
  --field "Attempt #=$ATTEMPT_NUMBER"

gh issue create \
  --title "P1.3 — Preferences Owner (Loader + Persistence + Overrides Contract)" \
  --body-file "$WORKDIR/P1.3.md" \
  --project "$MAIN_PROJECT_NUMBER" \
  --field "Card ID=P1.3" \
  --field "Phase ID=$PHASE_ID" \
  --field "Parent ID=P1" \
  --field "Executor Role=architect" \
  --field "Deliverables=P1.D4" \
  --field "Attempt #=$ATTEMPT_NUMBER"

gh issue create \
  --title "P1.4 — AI Pool Structural Definitions Owner (Types/Fields/Relationships Only)" \
  --body-file "$WORKDIR/P1.4.md" \
  --project "$MAIN_PROJECT_NUMBER" \
  --field "Card ID=P1.4" \
  --field "Phase ID=$PHASE_ID" \
  --field "Parent ID=P1" \
  --field "Executor Role=architect" \
  --field "Deliverables=P1.D5" \
  --field "Attempt #=$ATTEMPT_NUMBER"

gh issue create \
  --title "P1.5 — Infrastructure Baseline Owner (Detect/Validate Before Change)" \
  --body-file "$WORKDIR/P1.5.md" \
  --project "$MAIN_PROJECT_NUMBER" \
  --field "Card ID=P1.5" \
  --field "Phase ID=$PHASE_ID" \
  --field "Parent ID=P1" \
  --field "Executor Role=architect" \
  --field "Deliverables=P1.D6" \
  --field "Attempt #=$ATTEMPT_NUMBER"

gh issue create \
  --title "P1.QA — Phase 1 Deliverables Sign-off (D1–D6)" \
  --body-file "$WORKDIR/P1.QA.md" \
  --project "$MAIN_PROJECT_NUMBER" \
  --field "Card ID=P1.QA" \
  --field "Phase ID=$PHASE_ID" \
  --field "Parent ID=P1" \
  --field "Executor Role=qa" \
  --field "Deliverables=P1.D1,P1.D2,P1.D3,P1.D4,P1.D5,P1.D6" \
  --field "Attempt #=$ATTEMPT_NUMBER"

# --- REGISTRY: sync then validate ---
# NOTE: paths here come from registry_system.locations + script_contracts.
python3 docs/build/registry/registry_sync_from_github.py
python3 docs/build/registry/registry_validate.py
