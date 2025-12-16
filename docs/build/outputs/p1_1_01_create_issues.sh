# ===============================
# SCRIPT 01 — template_01_create_issues.sh (P1.1 child cards)
# ===============================

#!/usr/bin/env bash
set -euo pipefail

# ===============================
# CONFIG YOU MUST SET (EDIT THIS)
# ===============================

OWNER_LOGIN="lillycore-boss"                 # e.g. "lillycore-boss" or "YourOrg"
OWNER_TYPE="user"                           # "user" or "org"
PROJECT_TITLE="LillyCORE Main"              # e.g. "LillyCORE Main" (must match UI title)
WORKDIR="/tmp/lillycore_cards/p1.1"         # local temp workspace (safe default for this batch)
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

extract_issue_number_from_create_output() {
local out="$1"
echo "$out" \
| grep -Eo 'https?://[^ ]+/issues/[0-9]+' \
| tail -n 1 \
| sed -E 's#.*/issues/([0-9]+)$#\1#'
}

resolve_issue_number_by_title() {
local full_title="$1"
gh issue list --author "$author_filter" --limit 200 \
--json number,title,createdAt \
--jq "[.[] | select(.title == \"$full_title\")] | sort_by(.createdAt) | last | .number" \
| tr -d '\n'
}

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
  issue_number="$(resolve_issue_number_by_title "$full_title" || true)"
fi

[[ -n "$issue_number" && "$issue_number" != "null" ]] || fail "Could not resolve issue number for $card_id ($full_title)"

printf "%s\t%s\t%s\n" "$card_id" "$issue_number" "$full_title" >> "$MANIFEST"
echo "CREATED: $card_id -> #$issue_number"
}

# ===============================
# CARD BODIES (EDIT THESE)
# ===============================

write_body_file "$WORKDIR/P1.1.1.md" <<'EOF'
Card ID: P1.1.1 Card Title: P1.1.1 — Runtime Heartbeat Loop Skeleton (Phase 1 Interactive Runner) Executor Role: Implementer

Phase Context: Phase: P1 Slice: P1.1.1 Parent Card: P1.1

Deliverables Served:

* P1.D1

Description: Implement the Phase 1 core runtime “heartbeat” loop skeleton capable of continuous operation in an interactive (foreground) posture. This card implements the loop structure and lifecycle boundaries only (start → tick/step → stop), with explicit seams for:

* command ingress (manual feed)
* logging hooks
* system settings (config) load
* structured error envelope propagation

This card MUST NOT define error-envelope schema details (that is governed elsewhere) and MUST NOT introduce Phase 2+ behaviours (daemonization, web server integration, multi-loop orchestration).

---

Reminder (non-authoritative): Due to model variance under partial authority, default to the most cautious interpretation of scope/permission; when in doubt, STOP and request the governing block(s).

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else: Bootstrap (minimum operating context for any task): Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context
```

Required Blocks (task-specific; list exact IDs):

* roadmap.p1
* tech_spec.repo_taxonomy_authority
* tech_spec.proof_outputs_convention
* documentation_protocol.no_placeholder_deferral
* documentation_protocol.update_triggers
* documentation_protocol.qa_expectations

Inputs / Preconditions:

* Parent plan/contract exists in P1.1 (runtime boundaries + integration expectations).
* Repo layout changes (new folders) are allowed only under tech_spec taxonomy rules.

Constraints:

* MUST implement under the Phase-1 runtime surface:

  * `lillycore/runtime/` (new folder if absent)
* MUST NOT hardcode envelope schema fields; treat “envelope” as an opaque structured object produced elsewhere.
* MUST keep ingress/logging/settings integration as callable seams (interfaces/functions/modules), not inline ad-hoc logic.
* MUST NOT define or implement “second runtime loop” orchestration in Phase 1.

Steps:

1. Create/confirm runtime package layout under `lillycore/runtime/` (exact subpaths documented in this card’s proof).
2. Implement a Phase-1 interactive runner entrypoint that:

   * initializes runtime context
   * enters a continuous loop
   * advances the loop via a deterministic “tick/step”
3. Establish explicit lifecycle hooks:

   * on_start, on_tick, on_stop (names need not be these exact strings; the concept is required)
4. Add seams (non-functional placeholders allowed only as *interfaces*, not stubs claiming behaviour):

   * command ingress adapter (fed by P1.1.2)
   * logging adapter/hook calls (wired by P1.1.5)
   * settings load call boundary (wired by P1.1.3)
   * structured error propagation surface (wired by P1.1.4)
5. Implement graceful loop termination mechanism for Phase 1 (details aligned with P1.1.6).
6. Produce a minimal runnable invocation command (Phase 1 interactive run).

Done When:

* A continuous loop can be started interactively and stays running until explicitly stopped.
* Loop structure has explicit, testable seams for ingress/logging/settings/envelopes.
* No envelope schema is invented or referenced beyond “opaque structured envelope object”.
* No Phase 2+ behaviours appear in code or docs.

Proof / Execution Evidence (when required):

* Evidence MUST be stored under: `docs/build/outputs/p1.1.1/`
* Include:

  * command(s) executed to start the interactive loop
  * stdout/stderr capture (raw)
  * any logs produced (raw)
  * a short note demonstrating continuous operation (e.g., N ticks observed)
  * a stop/exit capture

Documentation Updates (implicit requirement):

* Feature cards / phase bundle entries (tracked externally): update status/notes for P1.D1 progress if applicable.
* No canonical doc updates required unless repo taxonomy changes were made; if new top-level folders are introduced (should not be), STOP and escalate per tech_spec.repo_taxonomy_authority.

Notes / Future:

* Andrew’s planning heuristic (recorded for implementers): prefer wide trees (1 Architect + ~5–7 Implementers + 1 QA); avoid tall, low-branch decompositions.
* Phase 2+ runtime posture (background process, multi-loop orchestration) is explicitly out of scope.

QA Hooks (if Executor Role is QA or card requires QA):

* PASS/FAIL criteria:

  * loop runs continuously and stops cleanly (interactive posture)
  * seams exist for P1.1.2/.3/.4/.5/.6 integration
  * proof exists under `docs/build/outputs/p1.1.1/`
  * no envelope schema invention
  * no Phase 2+ behaviour
EOF

write_body_file "$WORKDIR/P1.1.2.md" <<'EOF'
Card ID: P1.1.2 Card Title: P1.1.2 — Manual Command Ingress (Terminal Feed) + Replaceable Boundary Executor Role: Implementer

Phase Context: Phase: P1 Slice: P1.1.2 Parent Card: P1.1

Deliverables Served:

* P1.D1

Description: Implement Phase 1 “manual feed” command ingress for the runtime loop, using interactive terminal input as the initial transport. The critical requirement is that ingress is behind a small boundary (adapter/interface) so it can be replaced later without rewriting the core loop.

This card MUST NOT define future transports (web server, background services) beyond keeping the interface replaceable.

---

Block Load Requirements (Hard Gate) Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else: Bootstrap (minimum operating context for any task): Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context
```

Required Blocks (task-specific; list exact IDs):

* roadmap.p1
* tech_spec.proof_outputs_convention
* documentation_protocol.no_placeholder_deferral
* documentation_protocol.qa_expectations

Inputs / Preconditions:

* P1.1.1 provides loop seam(s) for ingress.
* Runtime surface lives under `lillycore/runtime/`.

Constraints:

* MUST use terminal input for Phase 1 (interactive).
* MUST implement ingress as a boundary (adapter/interface/module) that can be swapped later.
* MUST NOT require envelope schema knowledge.

Steps:

1. Define a minimal command representation suitable for Phase 1 (string or simple structured object).
2. Implement a terminal ingress adapter that:

   * reads input
   * produces commands in the runtime’s expected form
   * can block/wait without breaking loop semantics (as defined by P1.1.1)
3. Wire adapter into the loop via the seam established by P1.1.1.
4. Ensure the ingress boundary is isolated (so a future transport can implement the same interface).

Done When:

* Runtime can receive commands from terminal input during continuous operation.
* Ingress is encapsulated behind a replaceable boundary (document where/how).
* Proof shows at least one command successfully delivered to the loop.

Proof / Execution Evidence (when required):

* Evidence MUST be stored under: `docs/build/outputs/p1.1.2/`
* Include:

  * command(s) executed
  * raw terminal session capture (or equivalent raw logs)
  * demonstration of at least one command being ingested while loop continues

Documentation Updates (implicit requirement):

* Feature cards / phase bundle entries (tracked externally): update P1.D1 progress notes if applicable.
* No canonical doc updates required unless new tooling or repo layout rules were changed (should not happen here).

Notes / Future:

* Future transports (API/web/service) are out of scope; only the interface seam is required now.
EOF

write_body_file "$WORKDIR/P1.1.3.md" <<'EOF'
Card ID: P1.1.3 Card Title: P1.1.3 — Runtime System Settings Contract (Defaults < File < Temp Override) Executor Role: Implementer

Phase Context: Phase: P1 Slice: P1.1.3 Parent Card: P1.1

Deliverables Served:

* P1.D1

Description: Implement Phase 1 runtime *system settings* support with a clear precedence model: **defaults < system settings file < temporary override (session/runtime)**.

Settings are operational/runtime-focused (e.g., async on/off, tick interval, logging verbosity) and explicitly not “persona” or “AI behaviour” settings. The system settings file format for non-documentation files is **JSON**, and the Phase 1 canonical path is: `lillycore/runtime/config/runtime.system.json`.

This card MUST keep the contract simple and must not introduce multiple-module settings resolution beyond what Phase 1 needs.

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else: Bootstrap (minimum operating context for any task): Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context
```

Required Blocks (task-specific; list exact IDs):

* roadmap.p1
* tech_spec.repo_taxonomy_authority
* tech_spec.proof_outputs_convention
* documentation_protocol.qa_expectations

Inputs / Preconditions:

* P1.1.1 has a seam/hook for “settings load” at runtime start (or equivalent).
* Runtime surface exists under `lillycore/runtime/`.

Constraints:

* MUST use JSON for non-doc configuration.
* MUST use canonical Phase 1 path: `lillycore/runtime/config/runtime.system.json`
* MUST implement precedence exactly: defaults < file < temp override.
* MUST NOT introduce persona/AI behaviour settings under this system settings mechanism.

Steps:

1. Define a minimal settings structure (keys only; keep it small and operational).
2. Implement defaults in code (internal).
3. Implement file load from the canonical JSON path.
4. Implement a temporary override mechanism suitable for Phase 1 interactive runs (e.g., runtime arguments, in-memory override map, or command-driven override).
5. Wire settings resolution into runtime initialization (via P1.1.1 seam).
6. Log (via runtime logging hooks) what settings source(s) were applied, without leaking sensitive content.

Done When:

* Runtime loads settings with correct precedence.
* Missing settings file behaviour is defined and safe (e.g., fall back to defaults; log a warning).
* No YAML is used for runtime config.
* Proof includes examples showing precedence behaviour.

Proof / Execution Evidence (when required):

* Evidence MUST be stored under: `docs/build/outputs/p1.1.3/`
* Include:

  * sample `runtime.system.json` used for test (stored as evidence)
  * commands executed
  * raw output showing default vs file vs override precedence

Documentation Updates (implicit requirement):

* Feature cards / phase bundle entries (tracked externally): update P1.D1 progress if applicable.
* No canonical doc updates required unless repo taxonomy changes occurred (should not).

Notes / Future:

* Andrew expects multiple settings files eventually; Phase 1 only establishes the system settings contract and canonical location pattern.
EOF

write_body_file "$WORKDIR/P1.1.4.md" <<'EOF'
Card ID: P1.1.4 Card Title: P1.1.4 — Error Envelope Integration Boundary (Runtime Creates/Propagates; Logging Emits) Executor Role: Implementer

Phase Context: Phase: P1 Slice: P1.1.4 Parent Card: P1.1

Deliverables Served:

* P1.D3

Description: Implement the integration boundary between the runtime loop and structured error envelopes, ensuring envelopes are:

* created/wrapped at runtime boundaries where errors surface, and
* propagated to unified logging for emission/recording.

This card MUST NOT invent or define the envelope schema. It must treat the envelope as an opaque structured object governed by the envelope authority for Phase 1 (P1.D3). This card focuses on “where wrapping happens” and “how envelopes flow” between runtime and logging.

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else: Bootstrap (minimum operating context for any task): Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context
```

Required Blocks (task-specific; list exact IDs):

* roadmap.p1
* tech_spec.proof_outputs_convention
* documentation_protocol.qa_expectations

Inputs / Preconditions:

* A Phase 1 envelope schema exists or is being implemented under the proper card(s) responsible for P1.D3.
* P1.1.1 loop skeleton exists with error-handling seams/boundaries.

Constraints:

* MUST NOT define envelope schema fields.
* MUST ensure runtime wraps/produces envelopes at the boundary where errors are caught.
* MUST ensure logging accepts/enforces envelope-shaped error inputs for emission.
* MUST keep Phase 1 scope (no distributed tracing, no remote sinks assumptions).

Steps:

1. Identify the runtime boundary points for error capture (start, tick/step, shutdown, ingress handling).
2. At each boundary, ensure errors are converted into the envelope object using the Phase 1 envelope constructor/wrapper (referenced from the owning envelope module).
3. Ensure envelopes are propagated through the runtime-to-logging seam (P1.1.5).
4. Ensure negative paths are exercised (at least one forced error) and show envelope propagation to logging.

Done When:

* Runtime produces envelopes at defined boundaries and hands them to logging.
* No schema is invented; only calls into the envelope authority are used.
* Proof shows at least one negative-path error wrapped and logged.

Proof / Execution Evidence (when required):

* Evidence MUST be stored under: `docs/build/outputs/p1.1.4/`
* Include:

  * raw output demonstrating an error occurring
  * evidence that the error became an envelope (as represented by the envelope system)
  * evidence that logging emitted/recorded it

Documentation Updates (implicit requirement):

* Feature cards / phase bundle entries (tracked externally): update P1.D3 integration notes if applicable.
* No canonical doc updates unless envelope authority or logging conventions require changes and those changes are explicitly within scope.

Notes / Future:

* Envelope schema evolution is handled by its owning cards; this card only wires integration points.
EOF

write_body_file "$WORKDIR/P1.1.5.md" <<'EOF'
Card ID: P1.1.5 Card Title: P1.1.5 — Runtime Logging Hooks (Lifecycle + Heartbeat + Envelope Events) Executor Role: Implementer

Phase Context: Phase: P1 Slice: P1.1.5 Parent Card: P1.1

Deliverables Served:

* P1.D1
* P1.D3

Description: Implement unified logging integration points for the Phase 1 runtime loop. This includes:

* lifecycle logging (start/stop)
* heartbeat/tick logging (bounded; avoid spam by default)
* structured logging of error envelopes received from the runtime boundary (P1.1.4)

This card MUST NOT introduce a complex logging backend; Phase 1 can emit to console/stdout as the default sink unless a separate logging card defines otherwise.

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else: Bootstrap (minimum operating context for any task): Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context
```

Required Blocks (task-specific; list exact IDs):

* roadmap.p1
* tech_spec.proof_outputs_convention
* documentation_protocol.qa_expectations

Inputs / Preconditions:

* Runtime loop skeleton exists (P1.1.1).
* Envelope integration boundary exists or is in progress (P1.1.4).

Constraints:

* MUST support logging of envelope objects without inventing schema.
* MUST keep heartbeat logging bounded by settings (see P1.1.3).
* MUST avoid Phase 2+ assumptions (web server sinks, external log aggregation, etc.) unless separately authorized.

Steps:

1. Define logging hook points in runtime lifecycle (start/tick/stop) via the loop seams.
2. Implement a minimal unified logger interface/adapter used by runtime.
3. Ensure logger can emit structured envelope objects (opaque payload) as a first-class event.
4. Wire logging verbosity/heartbeat emission to system settings (P1.1.3).
5. Demonstrate logs on:

   * startup
   * at least one tick
   * shutdown
   * a forced envelope event (from P1.1.4)

Done When:

* Runtime emits consistent logs for lifecycle events.
* Heartbeat logging is controllable by settings (not hardcoded spam).
* Envelope events are logged as structured events (schema opaque).
* Proof captures show logging output.

Proof / Execution Evidence (when required):

* Evidence MUST be stored under: `docs/build/outputs/p1.1.5/`
* Include:

  * raw log output
  * settings used to configure logging verbosity
  * evidence of envelope event emission

Documentation Updates (implicit requirement):

* Feature cards / phase bundle entries (tracked externally): update P1.D1 and/or P1.D3 progress notes if applicable.
* No canonical doc updates required unless a new logging convention/tool is introduced (should not in Phase 1).

Notes / Future:

* Future sinks and structured log routing are out of scope; keep adapters replaceable.
EOF

write_body_file "$WORKDIR/P1.1.6.md" <<'EOF'
Card ID: P1.1.6 Card Title: P1.1.6 — Stop/Shutdown Semantics (Phase 1 Graceful Exit) Executor Role: Implementer

Phase Context: Phase: P1 Slice: P1.1.6 Parent Card: P1.1

Deliverables Served:

* P1.D1
* P1.D3

Description: Implement Phase 1 stop/shutdown semantics for the interactive runtime loop, ensuring:

* graceful termination on explicit user command (and/or standard signals if applicable)
* logging flush/finish behaviours are respected
* error envelopes during shutdown are still propagated to logging

This card defines and implements shutdown mechanics for Phase 1 only.

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else: Bootstrap (minimum operating context for any task): Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context
```

Required Blocks (task-specific; list exact IDs):

* roadmap.p1
* tech_spec.proof_outputs_convention
* documentation_protocol.qa_expectations

Inputs / Preconditions:

* Loop skeleton exists (P1.1.1).
* Logging hooks exist (P1.1.5).
* Envelope boundary exists (P1.1.4).

Constraints:

* MUST provide an explicit shutdown path for Phase 1 interactive operation.
* MUST NOT add daemon/service lifecycle behaviours (Phase 2+).
* MUST preserve envelope propagation on shutdown errors.

Steps:

1. Define the Phase 1 “stop” trigger(s):

   * a terminal command (preferred)
   * optionally standard signals if they are already part of the baseline platform behaviour
2. Implement shutdown flow:

   * request stop
   * exit loop cleanly
   * perform final logging
3. Ensure shutdown errors are wrapped into envelopes and logged.
4. Demonstrate clean stop and a negative-path stop (forced error during shutdown).

Done When:

* Interactive loop exits gracefully on command.
* Logs clearly show shutdown sequence.
* Shutdown-time errors become envelopes and are logged.
* Proof captures include both normal and negative-path shutdown.

Proof / Execution Evidence (when required):

* Evidence MUST be stored under: `docs/build/outputs/p1.1.6/`
* Include:

  * raw output of normal shutdown
  * raw output of negative-path shutdown
  * commands executed

Documentation Updates (implicit requirement):

* Feature cards / phase bundle entries (tracked externally): update P1.D1/P1.D3 notes if applicable.
* No canonical doc updates required unless shutdown semantics introduce new repo-wide conventions (should not).

Notes / Future:

* Phase 2+ “keep one loop alive while another ends” orchestration is out of scope here; this card only ensures Phase 1 loop can stop safely.
EOF

write_body_file "$WORKDIR/P1.1.QA.md" <<'EOF'
Card ID: P1.1.QA Card Title: P1.1.QA — Slice QA: Runtime Loop Contract + Integration (P1.1.x) Executor Role: QA

Phase Context: Phase: P1 Slice: P1.1.QA Parent Card: P1.1

Deliverables Served:

* P1.D1
* P1.D3

Description: QA for the P1.1 slice. Verifies that the Phase 1 runtime loop can operate continuously (interactive posture), and that integration seams and wiring for logging, system settings, and error envelopes are implemented without inventing schema or Phase 2+ behaviours.

This QA MUST enforce proof requirements and must FAIL any runtime/execution claims without proof artefacts under the authoritative proof convention location.

---

Block Load Requirements (Hard Gate)

Executor MUST NOT proceed until:

* all blocks listed below are loaded, OR
* Andrew explicitly waives the requirement for this card.

Have Andrew run the following before requesting anything else: Bootstrap (minimum operating context for any task): Run:

```bash
python3 docs/build/get_md.py --block \
  block_loading.overview \
  block_loading.script_interface \
  block_loading.canvas_usage \
  block_loading.operating_principles \
  gpt_resource_index.index \
  gpt_resource_index.load_paths \
  documentation_protocol.required_stop_on_missing_context
```

Required Blocks (task-specific; list exact IDs):

* documentation_protocol.qa_expectations
* tech_spec.proof_outputs_convention
* roadmap.p1
* qa_reference.qa_report_template

Inputs / Preconditions:

* Implementer cards P1.1.1–P1.1.6 completed (or subset if explicitly waived by Andrew).
* Proof folders exist per card under `docs/build/outputs/`.

Constraints:

* Proof location authority is `tech_spec.proof_outputs_convention`:

  * `docs/build/outputs/<phase_id>/`
* QA MUST FAIL any claimed runtime behaviour without raw proof artefacts.
* QA MUST FAIL any envelope schema invention or Phase 2+ behaviour leakage.

Steps:

1. Documentation correctness checks (per documentation_protocol.qa_expectations):

   * external phase bundle/feature tracking entries updated (where applicable)
   * no unindexed “shadow specs” introduced
2. Proof verification (per tech_spec.proof_outputs_convention):

   * confirm proof folders exist:

     * `docs/build/outputs/p1.1.1/` … `p1.1.6/`
   * confirm commands executed are provided
   * confirm raw outputs/logs exist
3. Runtime behaviour checks (based on evidence, not assertions):

   * loop runs continuously (interactive posture)
   * manual command ingress works
   * settings precedence behaviour demonstrated
   * envelope propagation to logging demonstrated (negative path)
   * graceful shutdown demonstrated (normal + negative path)
4. Validate “no forbidden claims”:

   * no Phase 2+ daemon/service orchestration
   * no invented envelope schema fields

Done When:

* QA report appended using the canonical template, marked PASS/FAIL/FAIL_ESCALATE.
* If FAIL: corrective Implementer cards are created and linked, and dependencies noted.

Proof / Execution Evidence (when required):

* QA MUST reference the proof folders under: `docs/build/outputs/`
* QA report must name key artefacts and commands used as evidence.

Documentation Updates (implicit requirement):

* Append QA report to the relevant card/issue body using qa_reference template mechanics.
* No other doc updates required unless QA detects drift requiring corrective action.

Notes / Future:

* If any mismatch exists between older QA template wording and authoritative proof path, treat tech_spec.proof_outputs_convention as the controlling authority and record the mismatch as documentation drift (do not remediate unless authorized).

QA Hooks (if Executor Role is QA or card requires QA):

* PASS/FAIL criteria:

  * P1.D1 demonstrated with proof (continuous interactive loop)
  * P1.D3 demonstrated with proof (envelope propagation integrated into runtime+logging)
  * proof artefacts exist under `docs/build/outputs/p1.1.x/`
  * no schema invention, no Phase 2+ leakage
  * documentation alignment confirmed per documentation_protocol.qa_expectations
EOF

# ===============================
# CARDS TO CREATE (EDIT THESE)
# ===============================

create_or_reuse_issue "P1.1.1" "Runtime Heartbeat Loop Skeleton (Phase 1 Interactive Runner)" "$WORKDIR/P1.1.1.md"
create_or_reuse_issue "P1.1.2" "Manual Command Ingress (Terminal Feed) + Replaceable Boundary" "$WORKDIR/P1.1.2.md"
create_or_reuse_issue "P1.1.3" "Runtime System Settings Contract (Defaults < File < Temp Override)" "$WORKDIR/P1.1.3.md"
create_or_reuse_issue "P1.1.4" "Error Envelope Integration Boundary (Runtime Creates/Propagates; Logging Emits)" "$WORKDIR/P1.1.4.md"
create_or_reuse_issue "P1.1.5" "Runtime Logging Hooks (Lifecycle + Heartbeat + Envelope Events)" "$WORKDIR/P1.1.5.md"
create_or_reuse_issue "P1.1.6" "Stop/Shutdown Semantics (Phase 1 Graceful Exit)" "$WORKDIR/P1.1.6.md"
create_or_reuse_issue "P1.1.QA" "Slice QA: Runtime Loop Contract + Integration (P1.1.x)" "$WORKDIR/P1.1.QA.md"

echo
echo "Manifest written: $MANIFEST"
cat "$MANIFEST"

