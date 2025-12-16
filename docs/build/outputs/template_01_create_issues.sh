#!/usr/bin/env bash
set -euo pipefail

# ===============================

# CONFIG YOU MUST SET (EDIT THIS)

# ===============================

OWNER_LOGIN="<lillycore-boss>"                 # e.g. "lillycore-boss" or "YourOrg"
OWNER_TYPE="user"                           # "user" or "org"
PROJECT_TITLE="LillyCORE Main"             # e.g. "LillyCORE Main" (must match UI title)
WORKDIR="/tmp/lillycore_cards/<phase_id>"   # local temp workspace
MANIFEST_NAME="manifest.tsv"                # output mapping: card_id -> issue_number -> title

# Optional: if you want to avoid REUSE behavior, set to 0

ALLOW_REUSE_BY_TITLE="1"                    # 1 = reuse newest matching exact title, 0 = always create

# ===============================

# CORE (DO NOT EDIT)

# ===============================

fail(){ echo "ERROR: $*" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || fail "gh CLI not found"
command -v jq >/dev/null 2>&1 || fail "jq not found"

mkdir -p "$WORKDIR"
MANIFEST="${WORKDIR}/${MANIFEST_NAME}"
: > "$MANIFEST"

echo "Writing card bodies under: $WORKDIR"

author_filter='@me'

# Deterministic: parse issue number from gh issue create stdout URL.

# Typical output contains a URL like [https://github.com/](https://github.com/)<owner>/<repo>/issues/<N>

extract_issue_number_from_create_output() {
local out="$1"
echo "$out" 
| grep -Eo 'https?://[^ ]+/issues/[0-9]+' 
| tail -n 1 
| sed -E 's#.*/issues/([0-9]+)$#\1#'
}

# Best-effort REUSE lookup by exact title (for cards you already created).

resolve_issue_number_by_title() {
local full_title="$1"
gh issue list --author "$author_filter" --limit 200 
--json number,title,createdAt 
--jq "[.[] | select(.title == "$full_title")] | sort_by(.createdAt) | last | .number" 
| tr -d '\n'
}

# Write a body file from stdin (so you can keep card bodies clean and local)

write_body_file() {
local path="$1"
cat > "$path"
}

create_or_reuse_issue() {
local card_id="$1"; shift
local title_tail="$1"; shift
local body_file="$1"; shift

local full_title="${card_id} — ${title_tail}"

if [[ "$ALLOW_REUSE_BY_TITLE" == "1" ]]; then
local existing
existing="$(resolve_issue_number_by_title "$full_title" || true)"
if [[ -n "$existing" && "$existing" != "null" ]]; then
printf "%s\t%s\t%s\n" "$card_id" "$existing" "$full_title" >> "$MANIFEST"
echo "REUSE: $card_id -> #$existing"
return 0
fi
fi

local create_out
create_out=$(gh issue create 
--title "$full_title" 
--body-file "$body_file" 
--project "$PROJECT_TITLE")

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

# ===============================

# CARD BODIES (EDIT THESE)

# ===============================

# You can paste full card bodies here. Each card writes to $WORKDIR/<CARD_ID>.md.

# Keep titles aligned with what script 02 will field-set.

# --- CARD: P1 (phase parent anchor; required for registry parent links) ---

write_body_file "$WORKDIR/P1.md" <<'EOF'
Card ID: P1
Card Title: Phase 1 — Core Loop, Logging, User Preferences
Executor Role: Architect

Phase Context:
Phase: P1
Slice: P1
Parent Card: none

Deliverables Served:

P1.D1 – Functional core runtime loop capable of continuous operation

P1.D2 – Unified logging system with documented entry points and formatting rules

P1.D3 – Implemented error envelope schema integrated into runtime and logging

P1.D4 – Operational system preference loader with persistence and override capability

P1.D5 – AI pool structural definitions (types, fields, relationships) defined and documented

P1.D6 – Initial project infrastructure implemented (repo, config files, CI, tooling, developer automation)

Description:
Establish LillyCORE’s first functional runtime layer by introducing a stable execution loop, unified logging behavior, structured error handling, and a minimal but extensible preference system. This milestone defines the overall goals and boundaries for Phase 1 and requires decomposition into P1.x cards that cover runtime, logging, error envelopes, preferences, AI pool structural definitions, and initial infrastructure setup.
This milestone does NOT implement Phase 1 features directly; it produces a QA-ready P1.x card bundle with explicit constraints, bounded scope, and traceability to P1.D1–P1.D6.

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

all blocks listed below are loaded, OR

Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else:
Bootstrap (minimum operating context for any task):
Run:

python3 docs/build/get_md.py --block
block_loading.overview
block_loading.script_interface
block_loading.canvas_usage
block_loading.operating_principles
gpt_resource_index.index
gpt_resource_index.load_paths
documentation_protocol.required_stop_on_missing_context

Required Blocks (task-specific; list exact IDs):

build_canon.feature_card_template

documentation_protocol.no_placeholder_deferral

roadmap.p1

Notes:

If unsure which blocks exist, request *.index blocks first, then request specifics by ID.

Missing context is expected; inventing context is forbidden.

Inputs / Preconditions:

Completed Phase 0 foundations, including:

Documentation structures and governance (P0.2, P0.3, P0.7)

GPT behaviour and ingestion rules (P0.4)

Minimum stable Canon subset for Phase 1 (P0.5)

Repository taxonomy and naming standards (P0.2)

Root-level file rules (P0.6)

Roadmap definition for Phase 1 (Core Loop, Logging, User Preferences)

Relevant Canon rules governing runtime behaviour, identity persistence, and system integrity / invariants

TECH_SPEC sections covering repository layout/folder taxonomy, logging + error-handling baseline expectations, and tooling/infrastructure decisions from P0.1

Decisions required or partially defined (to be resolved via bounded P1.x cards):

Preference persistence mechanism (file, object, or other)

Logging channels (console, file, structured output)

Error envelope schema details (fields, severity levels, propagation rules)

Constraints:

MUST NOT perform implementation work in this milestone description.

MUST NOT embed Phase 2+ responsibilities into Phase 1 scope.

MUST keep AI pools structural only in Phase 1 (no execution, scheduling, or chaining).

MUST preserve Phase 0 standards for documentation governance, repo taxonomy, and naming conventions.

Steps:

Review Phase 0 outputs (Canon, TECH_SPEC, documentation governance, repo taxonomy, GPT behaviour rules) and Phase 1 roadmap text to confirm constraints, dependencies, and expectations.

Confirm and treat P1.D1–P1.D6 as authoritative Phase 1 “done when” targets.

Decompose Phase 1 into a bounded set of P1.x Architect / Implementer / QA cards, separating:

runtime loop design vs implementation

logging schema vs integration points

error envelope design vs wiring into the loop

preference loader design vs persistence/storage decisions

AI pool structural definitions (no execution)

infrastructure setup (repo, config files, CI, tooling, developer automation)

Encode Phase 1 constraints into P1.x cards (no scope leakage into later phases; alignment with Phase 0 standards).

Ensure the infrastructure setup slice explicitly includes detection/validation of existing repo/CI/tooling before changes.

Produce a QA-ready P1.x bundle that fully covers P1.D1–P1.D6 and ends with at least one Phase 1 QA card.

Capture open questions/risks and route them into targeted P1.x decision cards (no implicit assumptions).

Done When:

A complete P1.x card bundle exists in the universal format covering P1.D1–P1.D6.

Each P1.x card has explicit inputs/preconditions, constraints, bounded steps, and checkable done criteria.

At least one QA card validates Phase 1 deliverables.

No Phase 2+ responsibilities are embedded in Phase 1 cards.

Proof / Execution Evidence (when required):

Not required for this milestone description; this is an Architect-level decomposition milestone only.

Documentation Updates (implicit requirement):

(B) No documentation updates required. Reason: GitHub milestone descriptions only.

Notes / Future:

Phase 1 implementer cards may identify Canon/TECH_SPEC updates; those must be proposed via dedicated cards rather than being silently introduced here.

Any unresolved decisions (preferences/logging/envelope details) must be converted into explicit P1.x decision work, not left implicit.

QA Hooks (if Executor Role is QA or card requires QA):

PASS/FAIL criteria:

P1.x bundle covers all deliverables P1.D1–P1.D6

Each card is properly scoped (no implementation in Architect cards)

No scope leakage into Phase 2+

Final QA card exists and is traceable to deliverables
EOF

# --- CARD: P1.1 example ---

write_body_file "$WORKDIR/P1.1.md" <<'EOF' <PASTE CARD BODY HERE>
EOF

# --- CARD: P1.2 example ---

write_body_file "$WORKDIR/P1.2.md" <<'EOF' <PASTE CARD BODY HERE>
EOF

# ===============================

# CARDS TO CREATE (EDIT THESE)

# ===============================

# Format: create_or_reuse_issue "<CARD_ID>" "<TITLE_TAIL>" "$WORKDIR/<CARD_ID>.md"

# IMPORTANT: create parents before children.

create_or_reuse_issue "P1" "Phase 1 — Core Loop, Logging, User Preferences" "$WORKDIR/P1.md"
create_or_reuse_issue "P1.1" "Runtime Core Loop Owner (Heartbeat + Envelope Integration Plan)" "$WORKDIR/P1.1.md" "Runtime Core Loop Owner (Heartbeat + Envelope Integration Plan)" "$WORKDIR/P1.1.md"
create_or_reuse_issue "P1.2" "Logging + Error Envelope Owner (Spec + Wiring Plan)" "$WORKDIR/P1.2.md"

# Add more...

echo
echo "Manifest written: $MANIFEST"
cat "$MANIFEST"
