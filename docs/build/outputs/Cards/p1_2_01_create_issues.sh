#!/usr/bin/env bash
set -euo pipefail

# ===============================
# CONFIG YOU MUST SET (EDIT THIS)
# ===============================

OWNER_LOGIN="lillycore-boss"                 # e.g. "lillycore-boss" or "YourOrg"
OWNER_TYPE="user"                           # "user" or "org"
PROJECT_TITLE="LillyCORE Main"              # must match UI title
WORKDIR="/tmp/lillycore_cards/p1"           # local temp workspace
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
# Typical output contains a URL like https://github.com/<owner>/<repo>/issues/<N>
extract_issue_number_from_create_output() {
  local out="$1"
  echo "$out" \
  | grep -Eo 'https?://[^ ]+/issues/[0-9]+' \
  | tail -n 1 \
  | sed -E 's#.*/issues/([0-9]+)$#\1#'
}

# Best-effort REUSE lookup by exact title (for cards you already created).
resolve_issue_number_by_title() {
  local full_title="$1"
  gh issue list --author "$author_filter" --limit 200 \
  --json number,title,createdAt \
  --jq "[.[] | select(.title == \"${full_title}\")] | sort_by(.createdAt) | last | .number" \
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
  create_out=$(gh issue create \
    --title "$full_title" \
    --body-file "$body_file" \
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

# --- CARD: P1.2.1 ---
write_body_file "$WORKDIR/P1.2.1.md" <<'EOF'
---
Card ID: P1.2.1
Card Title: P1.2.1 — Error Envelope v1 Contract (Schema + Severity Semantics)
Executor Role: Architect

Phase Context:
  Phase: P1
  Slice: P1.2.1
  Parent Card: P1.2

Deliverables Served:
  - P1.D3 — Implemented error envelope schema integrated into runtime and logging

Description:
  This card defines the Phase 1 **Error Envelope v1** contract for LillyCORE: the structural schema, required vs optional fields,
  and the intended severity semantics used by the runtime loop and unified logging.

  This card defines what exists, how it is shaped, and how it must propagate. It does NOT implement envelope logic,
  does NOT bind envelopes to any destination/persistence, and does NOT introduce Phase 2+ concerns.

---
Reminder (non-authoritative): Due to model variance under partial authority, default to the most cautious interpretation of scope/permission; when in doubt, STOP and request the governing block(s).

---
Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:
- all blocks listed below are loaded, OR
- Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else:
Bootstrap (minimum operating context for any task):
  Run:
  ```bash
  python3 docs/build/get_md.py --block \
    block_loading.overview \
    block_loading.script_interface \
    block_loading.canvas_usage \
    block_loading.operating_principles \
    gpt_resource_index.index \
    gpt_resource_index.load_paths \
    documentation_protocol.required_stop_on_missing_context \
    system_resource_index.index
````

Required Blocks (task-specific; list exact IDs):

* build_canon.feature_card_template
* documentation_protocol.no_placeholder_deferral
* roadmap.p1
* modules.core_runtime
* system_canon.system_ontology
* system_canon.runtime_settings_contract

Notes:

* Missing context is expected; inventing context is forbidden.

---

Inputs / Preconditions:

* P1.2 slice exists and is the architectural owner for logging + error envelope contract.
* Runtime loop has defined envelope seams and treats envelope objects as opaque outside the authority module.

Constraints:

* MUST NOT implement code.
* MUST keep the envelope transport-agnostic and sink-agnostic.
* MUST NOT assume persistence (file/DB/remote sinks) in Phase 1.
* MUST preserve the Phase 1 runtime rule: Stop request control signal is NOT an envelope.
* MUST support future higher-level wrapping (e.g., later self-healing systems) without breaking the v1 contract.

Steps:

1. Define Error Envelope v1 as a structured object with required fields and allowed optional fields.
2. Define severity semantics for Phase 1 usage (runtime behaviour expectations + logging expectations).
3. Define propagation rules: where envelopes are created (runtime catch boundaries) and where they are consumed (logging emission).
4. Define the minimum guarantees an envelope provides to downstream components.
5. Identify explicit extension points permitted in v1.

Done When:

* Error Envelope v1 schema is explicitly documented with required vs optional fields.
* Severity semantics are explicit for Phase 1:

  * WARN = degraded/maybe-bug (runtime continues)
  * ERROR = failure event (runtime continues unless escalated by policy)
  * FATAL = runtime stops after emitting/logging + shutdown attempt
* Stack trace policy is explicit: included by default for WARN/ERROR/FATAL.
* Propagation semantics are explicit: runtime creates/wraps at catch boundaries; logging emits envelope-shaped events.
* No implementation work is performed in this card.

Proof / Execution Evidence (when required):

* Not required (Architect-level contract).

Documentation Updates (implicit requirement):

* (A) The GitHub issue body for this card is the authoritative Phase 1 contract for Error Envelope v1.

Notes / Future:

* Later phases may introduce a higher-level “system envelope” that wraps Error Envelope v1; v1 must remain embeddable.
* Persistence/DB storage of envelopes is out of scope for Phase 1.

QA Hooks:

* PASS/FAIL criteria:

  * Schema is explicit and non-contradictory
  * Severity semantics are explicit and match Phase 1 intent
  * No sink/persistence assumptions
  * No implementation leakage

---

## Error Envelope v1 (Phase 1 Contract)

### Required Fields

* `envelope_version` (number): Must be `1`.
* `id` (string): Unique identifier for correlation.
* `timestamp` (string): ISO-8601 timestamp when envelope is created.
* `severity` (string): `WARN` | `ERROR` | `FATAL`.
* `message` (string): Human-readable summary.
* `origin` (object):

  * `component` (string): e.g., `runtime`
  * `boundary` (string): `start|tick|ingress|stop|shutdown`

### Optional Fields

* `kind` (string): coarse classification.
* `cause` (object):

  * `type` (string)
  * `message` (string)
  * `stack` (string): stack trace text (included by default for WARN/ERROR/FATAL).
* `context` (object): structured metadata (tick number, command, settings source).
* `tags` (array[string])
* `is_retryable` (boolean)

### Propagation Rules (Design)

* Created at runtime catch boundaries via injected `envelope_factory`.
* Forwarded to logging via injected `envelope_sink`.
* `RuntimeStopRequested` is NOT wrapped.

### Extension Rule

* Readers ignore unknown fields.
* `context` is the primary extension surface in Phase 1.
EOF

# --- CARD: P1.2.2 ---

write_body_file "$WORKDIR/P1.2.2.md" <<'EOF'

Card ID: P1.2.2
Card Title: P1.2.2 — Unified LogRecord v1 Contract (JSONL + Required Fields + Event Taxonomy)
Executor Role: Architect

Phase Context:
Phase: P1
Slice: P1.2.2
Parent Card: P1.2

Deliverables Served:

* P1.D2 — Unified logging system with documented entry points and formatting rules
* P1.D3 — Implemented error envelope schema integrated into runtime and logging

Description:
This card defines the Phase 1 **Unified LogRecord v1** contract: record schema, default formatting (JSON Lines),
and a minimum event taxonomy for backbone runtime logging (lifecycle/tick/ingress/envelope/settings).

This card defines the contract only. It does NOT implement logging and does NOT assume destinations or persistence.

---

Reminder (non-authoritative): Due to model variance under partial authority, default to the most cautious interpretation of scope/permission; when in doubt, STOP and request the governing block(s).

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else:
Bootstrap (minimum operating context for any task):
Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context \
  system_resource_index.index
```

Required Blocks (task-specific; list exact IDs):

* build_canon.feature_card_template
* documentation_protocol.no_placeholder_deferral
* roadmap.p1
* modules.core_runtime
* system_canon.runtime_settings_contract

---

Inputs / Preconditions:

* Runtime provides logging seams/hook points.
* Heartbeat emission is bounded by settings (avoid spam by default).

Constraints:

* MUST NOT implement code.
* MUST remain sink-agnostic and destination-agnostic.
* MUST NOT assume persistence (file/DB) in Phase 1.
* MUST support structured envelope events without inventing envelope schema beyond P1.2.1.
* MUST define formatting rules: JSONL.

Steps:

1. Define LogRecord v1 schema (required vs optional).
2. Define log levels and intended meaning for Phase 1.
3. Define minimum Phase 1 event taxonomy.
4. Define envelope representation within LogRecord.
5. Define settings-controlled heartbeat rules (bounded).

Done When:

* LogRecord v1 schema is explicit (required + optional fields).
* JSONL is explicit as default formatting.
* Minimum taxonomy covers lifecycle/tick/ingress/envelope/settings.
* Envelope representation rule is explicit.
* No sink/persistence assumptions.
* No implementation leakage.

Proof / Execution Evidence (when required):

* Not required (Architect-level contract).

Documentation Updates (implicit requirement):

* (A) The GitHub issue body for this card is the authoritative Phase 1 contract for LogRecord v1.

Notes / Future:

* Future sinks/routing/tracing are Phase 2+.
* Work-trace/handoff stream may reuse this shape later; not required in Phase 1.

QA Hooks:

* PASS/FAIL criteria:

  * Schema explicit
  * JSONL explicit
  * Taxonomy explicit
  * No sink assumptions
  * No implementation leakage

---

## Unified LogRecord v1 (Phase 1 Contract)

### Default Format

* JSON Lines (JSONL): one LogRecord JSON object per line.

### Required Fields

* `log_version` (number): `1`
* `timestamp` (string): ISO-8601
* `level` (string): `DEBUG|INFO|WARN|ERROR|FATAL`
* `event` (string): stable event name (taxonomy-defined)
* `component` (string)
* `message` (string)

### Optional Fields

* `tick` (number)
* `data` (object)
* `envelope` (object|null)
* `correlation_id` (string)

### Level Semantics (Phase 1)

* `DEBUG`: development detail; may be suppressed by settings.
* `INFO`: normal lifecycle/heartbeat events.
* `WARN`: degraded/maybe-bug; MUST be emitted and tracked; stack traces supported via envelope cause when applicable.
* `ERROR`: error event; MUST be emitted; commonly paired with an envelope.
* `FATAL`: terminal event; MUST be emitted; paired with an envelope; runtime stops after emission + shutdown attempt.

### Minimum Event Taxonomy (Phase 1 Backbone)

* `runtime.start`
* `runtime.tick`
* `runtime.stop_requested`
* `runtime.shutdown.start`
* `runtime.shutdown.complete`
* `ingress.command.received`
* `config.missing_file`
* `runtime.envelope`

### Heartbeat Controls (Settings)

* Heartbeat/tick logging must be bounded by settings (enabled + every_n_ticks) and avoid spam by default.
EOF

# --- CARD: P1.2.3 ---

write_body_file "$WORKDIR/P1.2.3.md" <<'EOF'

Card ID: P1.2.3
Card Title: P1.2.3 — Runtime ↔ Logging ↔ Envelope Wiring Rules (Boundary Map + Non-Envelope Stop Signal)
Executor Role: Architect

Phase Context:
Phase: P1
Slice: P1.2.3
Parent Card: P1.2

Deliverables Served:

* P1.D2 — Unified logging system with documented entry points and formatting rules
* P1.D3 — Implemented error envelope schema integrated into runtime and logging

Description:
This card defines Phase 1 wiring rules between the runtime loop, unified logging, and error envelopes.
It specifies where envelopes are created, how they propagate, and how stop is handled as a non-envelope control signal.

This card is design-only and does NOT implement runtime, logging, or envelope code.

---

Reminder (non-authoritative): Due to model variance under partial authority, default to the most cautious interpretation of scope/permission; when in doubt, STOP and request the governing block(s).

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else:
Bootstrap (minimum operating context for any task):
Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context \
  system_resource_index.index
```

Required Blocks (task-specific; list exact IDs):

* build_canon.feature_card_template
* documentation_protocol.no_placeholder_deferral
* roadmap.p1
* modules.core_runtime
* system_canon.runtime_settings_contract
* P1.1 (provided by Andrew)
* P1.1.4 (provided by Andrew)
* P1.1.5 (provided by Andrew)

Notes:

* Missing context is expected; inventing context is forbidden.

---

Inputs / Preconditions:

* Runtime provides seams for command ingress, settings load boundary, envelope factory/sink, and logging hooks.

Constraints:

* MUST NOT implement code.
* MUST NOT invent schema beyond P1.2.1 and P1.2.2.
* Stop requested MUST NOT be enveloped.
* MUST keep Phase 1 scope (no Phase 2+ observability pipelines).

Steps:

1. Enumerate runtime catch boundaries where envelopes are created.
2. Define envelope propagation path runtime → logging.
3. Define required logging entry points for backbone events.
4. Define shutdown logging including negative-path shutdown.
5. Define guarantees downstream can rely on.

Done When:

* Boundary map is explicit.
* Propagation path is explicit.
* Stop-not-enveloped rule is explicit.
* Required entry points are explicit.
* No implementation leakage.

Proof / Execution Evidence (when required):

* Not required (Architect-level wiring spec).

Documentation Updates (implicit requirement):

* (A) The GitHub issue body for this card is the authoritative wiring spec.

QA Hooks:

* PASS/FAIL criteria:

  * Wiring rules align with Phase 1 runtime seams
  * Stop requested is not enveloped
  * No schema invention

---

## Wiring Rules (Phase 1)

### Wrap Boundaries (Envelope Creation)

Envelopes MUST be created at:

* `start` boundary
* `tick/step` boundary
* `ingress handling` boundary
* `shutdown finalization` boundary

### Non-Envelope Stop Signal

* Stop requested creates `RuntimeStopRequested`.
* Must be logged as `runtime.stop_requested`.
* Must NOT be wrapped as an envelope.

### Propagation

* Runtime catch boundary → `envelope_factory` → Error Envelope v1.
* Runtime forwards envelope to `envelope_sink`.
* Logging emits a LogRecord v1:

  * `event = runtime.envelope`
  * `level` mapped from envelope severity
  * `envelope` populated
EOF

# --- CARD: P1.2.4 ---

write_body_file "$WORKDIR/P1.2.4.md" <<'EOF'

Card ID: P1.2.4
Card Title: P1.2.4 — Work-Trace Compatibility Notes (Shared Record Shape; No DB Commitment in Phase 1)
Executor Role: Architect

Phase Context:
Phase: P1
Slice: P1.2.4
Parent Card: P1.2

Deliverables Served:

* P1.D2 — Unified logging system with documented entry points and formatting rules

Description:
Documents how Phase 1 unified logging remains compatible with a future high-volume work-trace/handoff stream
without committing Phase 1 to DB persistence or durable storage assumptions.

This card is documentation and constraint-setting only.

---

Reminder (non-authoritative): Due to model variance under partial authority, default to the most cautious interpretation of scope/permission; when in doubt, STOP and request the governing block(s).

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else:
Bootstrap (minimum operating context for any task):
Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context \
  system_resource_index.index
```

Required Blocks (task-specific; list exact IDs):

* build_canon.feature_card_template
* documentation_protocol.no_placeholder_deferral
* roadmap.p1
* modules.core_runtime

Notes:

* Missing context is expected; inventing context is forbidden.

---

Inputs / Preconditions:

* Phase 1 unified logging (backbone) exists as a sink-agnostic contract.

Constraints:

* MUST NOT introduce or assume DB persistence in Phase 1.
* MUST keep record formats stable and compatible with later sinks.
* MUST ensure event records can support correlation when a work-trace exists.

Steps:

1. Define how LogRecord v1 supports future correlation without changing its core shape.
2. Define naming guidance for future handoff events without requiring Phase 1 to emit them.
3. Document separation of concerns: Phase 1 backbone logs vs later durable work-trace.

Done When:

* Compatibility guidance is explicit and does not impose Phase 2+ requirements.
* Record-shape stability expectations are documented.

Proof / Execution Evidence (when required):

* Not required.

Documentation Updates (implicit requirement):

* (A) The GitHub issue body for this card is the authoritative compatibility note.

QA Hooks:

* PASS/FAIL criteria:

  * No DB assumption
  * Correlation guidance does not force new required fields

---

## Compatibility Guidance

* Prefer LogRecord v1 as shared event shape across backbone logs and future work-trace.
* `correlation_id` remains optional in v1.
* Future systems may add rich correlation inside `data` without changing v1.
EOF

# --- CARD: P1.2.QA ---

write_body_file "$WORKDIR/P1.2.QA.md" <<'EOF'

Card ID: P1.2.QA
Card Title: P1.2.QA — Slice QA: P1.D2 + P1.D3 Coverage (Proof-First Enforcement: Request Evidence Before FAIL)
Executor Role: QA

Phase Context:
Phase: P1
Slice: P1.2.QA
Parent Card: P1.2

Deliverables Served:

* P1.D2 — Unified logging system with documented entry points and formatting rules
* P1.D3 — Implemented error envelope schema integrated into runtime and logging

Description:
Validates P1.D2 and P1.D3 coverage for P1.2, enforcing Proof-First: QA must request missing evidence before FAIL.

---

Reminder (non-authoritative): Due to model variance under partial authority, default to the most cautious interpretation of scope/permission; when in doubt, STOP and request the governing block(s).

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else:
Bootstrap (minimum operating context for any task):
Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context \
  system_resource_index.index
```

Required Blocks (task-specific; list exact IDs):

* build_canon.feature_card_template
* documentation_protocol.no_placeholder_deferral
* roadmap.p1
* modules.core_runtime
* system_canon.runtime_settings_contract
* P1.2.1
* P1.2.2
* P1.2.3
* P1.2.4
* P1.1.4
* P1.1.5

Notes:

* Missing context is expected; inventing context is forbidden.

---

Inputs / Preconditions:

* Implementer work for runtime logging hooks and envelope integration has been completed (or is presented for review).
* Executors can provide proof artefacts (raw logs, stdout captures, settings used) for verification.

Constraints:

* MUST request missing proof before FAIL (Proof-First enforcement).
* MUST NOT invent missing outputs.
* MUST NOT accept Phase 2+ features as satisfying Phase 1 deliverables.

Steps:

1. Validate schema conformance:

   * Error Envelope v1 fields and semantics (P1.2.1)
   * LogRecord v1 fields, JSONL format, event taxonomy (P1.2.2)
2. Validate wiring conformance:

   * envelopes created at runtime boundaries and forwarded to logging (P1.2.3)
   * stop requested not enveloped; logged as normal event (P1.2.3)
   * heartbeat bounded by settings (P1.2.2 / runtime settings contract)
3. Validate evidence:

   * ensure raw logs/proof show required events and at least one envelope propagation.
4. Apply Proof-First rule:

   * if any required proof is missing, request it explicitly and pause PASS/FAIL.
   * only after the executor declines or fails to produce the requested proof may QA mark FAIL.

Done When:

* PASS is issued only if all PASS criteria are satisfied.
* If evidence is incomplete:

  * QA requests the missing proof explicitly (with exact filenames/paths expected), and
  * records status as BLOCKED / NEEDS EVIDENCE (not FAIL).
* FAIL is issued only after Proof-First request cycle is completed and requirements remain unmet.

Proof / Execution Evidence (when required):

* Evidence must include, at minimum:

  * JSONL log output demonstrating lifecycle + tick logging
  * a WARN/ERROR/FATAL envelope event emitted as structured log record
  * settings used to demonstrate bounded heartbeat emission

Documentation Updates (implicit requirement):

* (A) QA results must be appended to the end of the GitHub issue body for deterministic parsing.

QA Hooks:

* PASS/FAIL criteria:

  * P1.D2 covered: entry points + JSONL formatting + event taxonomy demonstrated
  * P1.D3 covered: envelope propagation into logging demonstrated
  * No schema invention by implementers
  * No sink/persistence assumptions beyond Phase 1
  * Proof-First enforcement followed
EOF

# ===============================

# CARDS TO CREATE (EDIT THESE)

# ===============================

create_or_reuse_issue "P1.2.1" "Error Envelope v1 Contract (Schema + Severity Semantics)" "$WORKDIR/P1.2.1.md"
create_or_reuse_issue "P1.2.2" "Unified LogRecord v1 Contract (JSONL + Required Fields + Event Taxonomy)" "$WORKDIR/P1.2.2.md"
create_or_reuse_issue "P1.2.3" "Runtime ↔ Logging ↔ Envelope Wiring Rules (Boundary Map + Non-Envelope Stop Signal)" "$WORKDIR/P1.2.3.md"
create_or_reuse_issue "P1.2.4" "Work-Trace Compatibility Notes (Shared Record Shape; No DB Commitment in Phase 1)" "$WORKDIR/P1.2.4.md"
create_or_reuse_issue "P1.2.QA" "Slice QA: P1.D2 + P1.D3 Coverage (Proof-First Enforcement: Request Evidence Before FAIL)" "$WORKDIR/P1.2.QA.md"

echo
echo "Manifest written: $MANIFEST"
cat "$MANIFEST"
EOF

# ===============================

# CARDS TO CREATE (EDIT THESE)

# ===============================

create_or_reuse_issue "P1.2.1" "Error Envelope v1 Contract (Schema + Severity Semantics)" "$WORKDIR/P1.2.1.md"
create_or_reuse_issue "P1.2.2" "Unified LogRecord v1 Contract (JSONL + Required Fields + Event Taxonomy)" "$WORKDIR/P1.2.2.md"
create_or_reuse_issue "P1.2.3" "Runtime ↔ Logging ↔ Envelope Wiring Rules (Boundary Map + Non-Envelope Stop Signal)" "$WORKDIR/P1.2.3.md"
create_or_reuse_issue "P1.2.4" "Work-Trace Compatibility Notes (Shared Record Shape; No DB Commitment in Phase 1)" "$WORKDIR/P1.2.4.md"
create_or_reuse_issue "P1.2.QA" "Slice QA: P1.D2 + P1.D3 Coverage (Proof-First Enforcement: Request Evidence Before FAIL)" "$WORKDIR/P1.2.QA.md"

echo
echo "Manifest written: $MANIFEST"
cat "$MANIFEST"
