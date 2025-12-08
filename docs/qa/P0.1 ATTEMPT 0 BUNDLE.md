# ========================================
# BUNDLE: P0.1 — Select Technical Baseline Standards
# Parent Card: P0.1
# Role: Architect decomposition → Implementer leaf tasks + QA end-cap
# ========================================
# Scope:
#   - ONLY covers the feature "Select Technical Baseline Standards"
#   - This is a slice under Phase 0, not the whole phase
#
# Children in this bundle:
#   - P0.1.1 through P0.1.7  → Implementer leaf cards
#   - P0.1.8                 → QA card for this bundle
#
# All child cards follow the Architect/Implementer/QA structures defined in Canon.


# ========================================
# CARD P0.1.1 — Decide Minimum Python Version & Supported Range
# ========================================
ID: P0.1.1
Title: Decide Minimum Python Version & Supported Range
Type: Implementer

Description:
    Choose the official minimum Python version LillyCORE supports for Phases 1–3 and the general version range we target for development/runtime.

Steps:
    - List Python versions you consider viable (e.g., 3.10, 3.11, 3.12), including any OS or hosting constraints that matter to you.
    - Check which versions are best supported by the tools you’re likely to pick (formatter, linter, test framework, type checker).
    - Choose:
        - Minimum supported Python version.
        - Recommended development version (if different).
    - Write 1–3 sentences explaining why this version range was chosen (for future you).
    - Coordinate with Implementer GPT (in a later execution pass) to update TECH_SPEC:
        - Minimum version.
        - Supported range.
        - Any explicitly unsupported versions (e.g., “3.9 and earlier not supported”).

Done When:
    - TECH_SPEC clearly states “LillyCORE requires Python X.Y or newer,” plus the supported range.
    - There is no ambiguity about which Python version new code should target.

Deliverable:
    - Decisions recorded in TECH_SPEC and any other relevant docs; if no doc needs updating, explicitly state why.


# ========================================
# CARD P0.1.2 — Choose Code Formatter & Formatting Policy
# ========================================
ID: P0.1.2
Title: Choose Code Formatter & Formatting Policy
Type: Implementer

Description:
    Decide whether LillyCORE uses an automatic code formatter and, if so, which one and how it is used in the workflow.

Steps:
    - Decide whether to use an auto-formatter at all (yes/no).
    - If yes, shortlist 1–2 realistic formatter candidates you are comfortable with.
    - Choose a single formatter, and decide:
        - Whether you accept its defaults, or
        - Whether you override a small list of specific settings (list them).
    - Decide how formatting fits into the workflow:
        - Format-on-save in editor?
        - Pre-commit hook?
        - Manual command before committing/PR?
    - Coordinate with Implementer GPT to update TECH_SPEC:
        - Formatter name.
        - Configuration stance (defaults vs key overrides).
        - Expectations for contributors (“PRs must be formatted with X”).

Done When:
    - There is exactly one canonical formatting story for LillyCORE, written in TECH_SPEC.
    - No one has to guess which formatter to use.

Deliverable:
    - Documentation updated to reflect chosen formatter, configuration stance, and workflow expectations.


# ========================================
# CARD P0.1.3 — Choose Linter & Lint Strictness Policy
# ========================================
ID: P0.1.3
Title: Choose Linter & Lint Strictness Policy
Type: Implementer

Description:
    Select the linter tooling (or decide explicitly not to use one yet) and define how strict linting is for early phases.

Steps:
    - Decide whether you want:
        - A single tool (e.g., ruff),
        - A combination (e.g., flake8 + something else),
        - Or no linter for now (explicit choice).
    - Choose a default strictness level:
        - Minimal (“catch obvious issues”),
        - Standard (“keep things reasonably clean”),
        - Strict (“treat lint issues almost like errors”).
    - Decide how lint failures behave:
        - Block PRs?
        - Only warn in CI?
        - Only run locally when you choose?
    - Identify any classes of lint rules you already know you don’t care about (e.g., line length, docstring quirks).
    - Coordinate with Implementer GPT to update TECH_SPEC:
        - Linter(s) selected.
        - Enforced strictness / policy.
        - Any intentionally disabled rules or categories.

Done When:
    - TECH_SPEC documents the lint tool(s), strictness level, and enforcement strategy.
    - You can explain “how seriously we take linting” in one sentence.

Deliverable:
    - Documentation updated wherever linting behavior, tools, or enforcement are referenced.


# ========================================
# CARD P0.1.4 — Decide Typing & Type Checking Policy
# ========================================
ID: P0.1.4
Title: Decide Typing & Type Checking Policy
Type: Implementer

Description:
    Define LillyCORE’s stance on type hints and whether/how to enforce them with a type checker.

Steps:
    - Choose your typing stance:
        - Hints optional and informal,
        - Hints encouraged but not enforced,
        - Strict typing for core modules.
    - Decide whether to use a type checker now:
        - None,
        - mypy, pyright, or other.
    - If using a checker:
        - Decide which parts of the codebase must be type-clean.
        - Decide whether type errors block CI or PRs.
    - Sketch 2–3 example function signatures and doc patterns that “look right” to you.
    - Coordinate with Implementer GPT to update TECH_SPEC:
        - Typing philosophy.
        - Tools (if any).
        - Enforcement rules and scope.

Done When:
    - TECH_SPEC contains a clear typing philosophy and, if applicable, type checking rules.
    - You can answer “how seriously do we take type hints?” in one sentence.

Deliverable:
    - Documentation updated to reflect typing policy and any type checker tools in use.


# ========================================
# CARD P0.1.5 — Choose Test Framework & Test Layout
# ========================================
ID: P0.1.5
Title: Choose Test Framework & Test Layout
Type: Implementer

Description:
    Select a default test framework (or explicitly defer) and decide where tests live and how they are named.

Steps:
    - Decide whether to commit to a test framework now (e.g., pytest) or explicitly defer testing for the moment.
    - If choosing a framework:
        - Confirm compatibility with the chosen Python version and tooling.
    - Decide the test folder structure:
        - A top-level tests/ directory?
        - Per-module tests folders?
    - Define naming conventions:
        - File names (e.g., test_*.py).
        - Test function naming style.
    - Coordinate with Implementer GPT to update TECH_SPEC:
        - Framework choice or explicit deferral.
        - Directory and naming conventions.

Done When:
    - TECH_SPEC clearly states where tests go, what they are called, and what framework (if any) is used.

Deliverable:
    - Documentation updated for test framework and layout rules.


# ========================================
# CARD P0.1.6 — Define Script & CLI Conventions
# ========================================
ID: P0.1.6
Title: Define Script & CLI Conventions
Type: Implementer

Description:
    Establish where scripts live, how they’re invoked, and what basic CLI behavior is expected across LillyCORE.

Steps:
    - Decide where scripts belong in the repo (e.g., scripts/, tools/, core/scripts/).
    - Decide preferred invocation:
        - python -m package.module,
        - dedicated CLI entrypoint,
        - direct script execution.
    - Define CLI expectations:
        - Arg/flag style,
        - Presence and style of --help output,
        - Exit code conventions (0 success, non-zero failure).
    - Decide whether you differentiate between “developer-only scripts” and “runtime scripts,” and how.
    - Coordinate with Implementer GPT to document this in TECH_SPEC’s scripting/CLI section.

Done When:
    - TECH_SPEC contains a clear, single story for script locations and CLI invocation patterns.

Deliverable:
    - Documentation updated to reflect script paths, invocation rules, and CLI behavior expectations.


# ========================================
# CARD P0.1.7 — Choose Baseline Tooling (pre-commit, editorconfig, IDE)
# ========================================
ID: P0.1.7
Title: Choose Baseline Tooling (pre-commit, editorconfig, IDE)
Type: Implementer

Description:
    Define the minimal baseline tooling expected for contributors and for your own workflow.

Steps:
    - Decide whether to use:
        - pre-commit,
        - .editorconfig,
        - recommended VS Code (or other IDE) settings.
    - Decide whether to introduce a simple task runner:
        - Makefile, justfile, or none for now.
    - Identify the 3–5 tools you actually care about for Phase 0 (vs “someday nice to have”).
    - Categorize each tool as “Phase 0 required” vs “later optional.”
    - Coordinate with Implementer GPT to:
        - Add a “Baseline Tooling” section to TECH_SPEC.
        - Note which tools are mandatory in early phases.

Done When:
    - Tooling expectations are written in TECH_SPEC and it’s clear which tools are required now.

Deliverable:
    - Documentation updated for baseline tools, including what’s required vs optional.


# ========================================
# CARD P0.1.8 — QA for P0.1 Technical Baseline Decisions
# ========================================
ID: P0.1.8
Title: QA Validation for P0.1 Technical Baseline Standards
Type: QA

Description:
    Validate that all child cards of P0.1 (P0.1.1 through P0.1.7) were correctly executed, that all technical baseline decisions exist, and that all required documentation updates have been applied.

Steps:
    - Review outputs for cards P0.1.1–P0.1.7.
    - Verify that each card’s Done When criteria are fully met.
    - Confirm TECH_SPEC includes:
        - Python version and range,
        - Formatter choice,
        - Linter + strictness,
        - Typing policy,
        - Test framework + layout (or explicit deferral),
        - Script/CLI conventions,
        - Baseline tooling.
    - Check that decisions across all cards are internally consistent (no contradictions).
    - Confirm that all necessary documentation (TECH_SPEC, any related docs) has been updated and contains no lingering TODOs tied to P0.1.
    - If any deficiencies are found, generate corrective cards as P0.1.8.x (e.g., P0.1.8.1, P0.1.8.2) that precisely fix the gaps.

Done When:
    - QA GPT returns PASS for P0.1.
    - All corrective cards (if any) have been created and later executed/verified.

Deliverable:
    - PASS/FAIL report for P0.1.
    - If FAIL: corrective cards in the P0.1.8.x series, ready for Architect/Implementer passes.
