# ========================================
# FILE: TECH_SPEC
# ROLE: Technical standards and environment details for LillyCORE
# NOTE: This file defines HOW we build and run things, not WHAT the system is.
# ========================================


# ========================================
# SECTION 1: RUNTIMES AND LANGUAGES
# ========================================
# Primary language:
#   - Python 3.11+ (CPython)
#
# Runtime support (Phases 1–3):
#   - Minimum required version: CPython 3.11
#   - Officially supported/tested range: CPython 3.11–3.14 (inclusive)
#   - Recommended development version: CPython 3.13
#
# Notes (Python version rationale, Phases 1–3):
#   - 3.10 is already in security-only support and will reach EOL during the
#     Phase 1–3 timeline, so we do NOT target it as a minimum.
#   - 3.11–3.14 have long support windows and are fully compatible with modern
#     tooling (formatter, linter, test framework).
#   - We recommend 3.13 for development to benefit from newer performance
#     features while keeping the codebase compatible with 3.11+.
#
# Rules:
#   - Always target python3, NEVER python2.
#   - All runtime code for Phases 1–3 MUST run on CPython 3.11–3.14.
#   - Prefer standard library unless a dependency is explicitly approved.
#
# Other languages (if any):
#   - (e.g. shell scripts, TypeScript for UI, etc. — leave blank or TODO)
#
# TODO:
#   - List any pre-approved third-party libraries once decided.


# ========================================
# SECTION 2: CODE STYLE & COMMENTS
# ========================================
# General style:
#   - Follow Pythonic conventions (PEP8-ish, but Andrew is the final authority).
#
# Formatter:
#   - LillyCORE USES an auto-formatter for all Python code.
#   - Chosen formatter: Black.
#   - All Python code committed to the repo MUST be formatted with Black.
#   - We use Black's defaults; no custom style overrides beyond its standard behaviour.
#   - Effective line length is Black's default (currently 88 characters).
#
# Comments:
#   - Use "#" for line comments.
#   - For larger logical blocks in config/docs, use this pattern:
#     # ========================================
#     # SECTION: NAME
#     # ========================================
#
# Naming conventions:
#   - Functions and variables:
#       - Use snake_case for all Python functions, methods, variables, and module-level names.
#
#   - Folders and Python modules:
#       - All project-owned folders and Python modules MUST use snake_case
#         (lowercase_with_underscores).
#       - Hyphens ("-") MUST NOT be used in any importable Python package
#         or module name.
#
#   - Python files:
#       - Python source files MUST use snake_case filenames, e.g.:
#           - core_runtime.py
#           - run_tests.py
#           - rebuild_notes_index.py
#
#   - Non-Python files (project-owned):
#       - Where LillyCORE controls the filename, prefer
#         lowercase_with_underscores, e.g.:
#           - project_canon.md
#           - tech_spec.md
#           - notes_plugin_overview.md
#
#   - Allowed exceptions:
#       - Tool- or ecosystem-standard filenames that are defined externally,
#         for example (non-exhaustive):
#           - pyproject.toml
#           - .pre-commit-config.yaml
#           - .editorconfig
#           - .gitignore
#           - .vscode/settings.json
#       - Third-party generated or vendored files that arrive with fixed
#         names MUST keep their upstream naming (even if they use hyphens
#         or other styles).
#
#   - Display-only names:
#       - Conceptual document names like PROJECT_CANON, TECH_SPEC, or
#         LILLYCORE_ROADMAP are titles, not filenames; they do not override
#         the snake_case rules for actual files in the repo.
#
# Per-folder naming expectations (Phase 0 layout):
#   - core/:
#       - Subfolders and Python modules use snake_case, e.g.:
#           - core/runtime/
#           - core/logging/
#           - core/ai_pools/
#           - core/system_doc/
#       - Python files under core/ use snake_case, e.g.:
#           - core/runtime/core_runtime.py
#
#   - engines/:
#       - Each engine lives in a snake_case folder:
#           - engines/drift_engine/
#           - engines/helper_engine/
#           - engines/plugin_engine/
#           - engines/helpdesk_engine/
#           - engines/dream_engine/
#           - engines/script_engine/
#       - Python modules inside these folders use snake_case filenames.
#
#   - plugins/:
#       - Each plugin lives in a snake_case folder:
#           - plugins/notes_plugin/
#           - plugins/ux_interface/
#           - plugins/project_management/
#           - plugins/personal_assistant/
#           - plugins/multi_user/
#           - plugins/demos_and_corp/
#       - Python modules inside these folders use snake_case filenames.
#
#   - config/:
#       - Project-owned config files prefer lowercase_with_underscores,
#         unless an external standard dictates otherwise (e.g. pyproject.toml).
#
#   - scripts/:
#       - All scripts MUST use snake_case filenames, e.g.:
#           - scripts/format_code.py
#           - scripts/run_tests.py
#           - scripts/check_types.py
#
#   - tests/:
#       - Tests mirror the runtime layout and use snake_case, e.g.:
#           - tests/core/test_core_runtime.py
#           - tests/engines/test_drift_engine.py
#           - tests/plugins/test_notes_plugin.py
#           - tests/scripts/test_format_code.py
#
# Workflow expectations:
#   - Developers SHOULD configure their editor to format-on-save with Black for .py files.
#   - If format-on-save is not used, developers MUST run Black manually before committing.
#   - When git hooks/CI are introduced:
#       - A pre-commit hook SHOULD run Black on staged Python files.
#       - CI SHOULD include a check that fails if running Black would change the codebase.
#   - Exact hook framework (e.g., shell scripts vs additional tooling) and script paths
#     will be defined in a future task; this section only defines the formatter and policy.
#
# GPT RULE:
#   - If any style or naming detail is unclear, ASK Andrew instead of guessing.
#   - GPTs MUST assume that all Python examples and new files are Black-formatted.
#
# Linting:
#   - LillyCORE USES a Python linter for all runtime Python code.
#   - Chosen linter: Ruff.
#   - Ruff is the single source of truth for lint checks; we do NOT run flake8 or pylint
#     in addition to Ruff for early phases (0–3).
#
#   Scope:
#   - All non-generated Python code in the repository is expected to be Ruff-clean
#     under the agreed rule set.
#   - Any exceptions (e.g., generated code or external vendored code) MUST be explicitly
#     excluded via Ruff configuration in the repo.
#
#   Strictness philosophy (Phases 0–3):
#   - Goal: catch real bugs and keep the codebase clean, without over-policing style.
#   - We adopt a “standard” strictness in early phases:
#       - ENABLE high-signal rule families:
#           - Core correctness and hygiene (undefined names, unused imports/variables, etc.).
#           - Style rules that are compatible with Black's formatting.
#           - Import hygiene and ordering.
#       - DO NOT enforce in early phases:
#           - Docstring coverage / style (no pydocstyle-style requirements).
#           - Project-wide mandatory type annotations.
#           - Complexity / design metrics (e.g., cyclomatic complexity limits).
#           - Hyper-pedantic style rules that create noise without clear benefit.
#
#   Enforcement model:
#   - All active Ruff rules are treated as errors in CI once CI exists:
#       - If Ruff reports an error on the current codebase, the lint job fails.
#   - Developers SHOULD run Ruff locally (manually, via editor integration, or via scripts)
#     before pushing changes.
#   - When git hooks are introduced:
#       - A pre-commit hook SHOULD run Ruff on staged Python files, alongside Black.
#
#   Rule configuration:
#   - Ruff configuration (which rule families are enabled/disabled) MUST live in a
#     central, version-controlled config file (e.g., pyproject.toml or equivalent),
#     to be defined when the repository structure is finalized.
#   - Any per-file or per-rule ignores:
#       - MUST be justified with a short comment in-code or in the config.
#       - SHOULD be as narrow as possible (e.g., specific rule on a specific line/file).
#
#   Future tightening:
#   - As LillyCORE matures, additional rule families (e.g., docstring and type-annotation
#     enforcement, complexity metrics) MAY be enabled in later phases, subject to
#     explicit decisions and TECH_SPEC updates.
#
# ---------------------------------------------
# TYPING & TYPE CHECKING
# ---------------------------------------------
# Typing Philosophy (Phases 0–3):
#   - LillyCORE uses Python type hints (PEP 484+).
#   - Type hints are ENCOURAGED for all new code.
#   - Type hints are ENFORCED for core runtime and engine modules.
#
# Strict Typing Set:
#   - The following modules MUST remain type-clean and fully annotated:
#       - core/:
#           - CORE_RUNTIME
#           - AI_POOLS
#           - SYSTEM_DOC
#       - Engines:
#           - DRIFT_ENGINE
#           - HELPER_ENGINE
#           - PLUGIN_ENGINE
#           - HELP_DESK_ENGINE
#           - DREAM_ENGINE
#           - SCRIPT_ENGINE
#
# Non-strict Modules:
#   - Plugins and experimental modules:
#       - Type hints strongly encouraged.
#       - Public APIs SHOULD be typed.
#       - mypy may run in non-strict mode.
#
# Static Type Checker:
#   - LillyCORE uses mypy for static type checking.
#   - mypy configuration MUST live at repo root.
#   - mypy MUST be configured for Python 3.11+.
#
# Enforcement Model:
#   - Strict modules must:
#       - Use type hints consistently.
#       - Pass mypy with zero errors before merge.
#   - Non-strict modules:
#       - Allowed to have non-blocking mypy warnings during early phases.
#
# CI Expectations:
#   - CI MUST fail if:
#       - mypy reports errors in strict modules.
#   - mypy MAY run in informational mode for the rest of the codebase.
#
# GPT RULE (Typing):
#   - GPTs MUST add type hints to all public functions.
#   - GPTs SHOULD add hints to internal helpers.
#   - For strict-set files, GPTs MUST maintain mypy cleanliness.
#   - If an ignore is required:
#       - It MUST be justified and as narrow as possible.
# ---------------------------------------------
# BASELINE TOOLING (PHASE 0)
# ---------------------------------------------
# This subsection defines the minimal development tooling that all
# contributors are expected to use for LillyCORE in Phase 0.
#
# These tools sit alongside the style and typing rules defined above
# and the scripts / CI expectations defined elsewhere in this spec.
#
# Phase 0 REQUIRED tools
# ----------------------
# The following tools are REQUIRED for Phase 0 development:
#
#   - Black
#       - Single source of truth for Python formatting.
#       - All committed Python code MUST be Black-formatted.
#
#   - Ruff
#       - Single source of truth for Python linting.
#       - All non-generated Python code MUST be kept clean under the
#         agreed Ruff configuration (see Section 2).
#
#   - mypy
#       - Static type checker for Python.
#       - STRICT for the core runtime and engine modules as defined in
#         Section 2 (CORE_RUNTIME, AI_POOLS, SYSTEM_DOC, engines, etc.).
#
#   - pytest
#       - Python test runner for all automated tests under tests/.
#       - Standard invocation: `pytest` or `python -m pytest` from the
#         repository root.
#
#   - pre-commit
#       - Git hook manager used to run Black, Ruff, and mypy (and
#         optionally pytest) on staged files.
#       - All contributors SHOULD install pre-commit locally and enable
#         hooks via:
#             pre-commit install
#       - Hooks MUST NOT introduce interactive prompts; they MUST be
#         suitable for both local use and CI.
#
# Root-level configuration files
# ------------------------------
# For this section, "repository root" means the top-level LillyCORE Git
# repository directory (the folder containing .git), not the filesystem root.
#
# The repository root is expected to contain:
#
#   - pyproject.toml
#       - Defines Python package metadata and shared tool configuration
#         for LillyCORE.
#       - MUST live at the repository root to satisfy Python packaging
#         and tooling expectations.
#
#   - .pre-commit-config.yaml
#       - Defines the pre-commit hooks that run Black, Ruff, and mypy
#         (and optionally pytest) on staged files.
#       - Exact hook set and ordering are defined by future scripting /
#         CI tasks, but Black/Ruff/mypy MUST be present.
#
#   - .editorconfig
#       - Captures basic formatting conventions (indentation, charset,
#         line endings) for non-VS Code editors.
#       - SAFE to add/extend at any time; CI and hooks do not depend on
#         it in Phase 0.
#
#   - .vscode/settings.json (and optionally .vscode/extensions.json)
#       - Provides recommended settings and extension suggestions for
#         contributors using VS Code (e.g., format-on-save with Black,
#         Ruff integration, mypy/pytest support).
#       - These files are advisory only; they MUST NOT be treated as a
#         hard requirement for non–VS Code editors.
#
# Repo-level task runner
# ----------------------
# Phase 0 explicitly does NOT adopt a dedicated repo-level task runner
# such as a Makefile or justfile.
#
#   - Standard automation MUST use Python scripts under scripts/
#     (see Section 5: SCRIPTS & CLI TOOLS) for tasks such as:
#         - formatting (Black),
#         - linting (Ruff),
#         - type checking (mypy),
#         - running tests (pytest).
#
#   - A future feature card MAY introduce a task runner once common
#     workflows are stable and Andrew approves a specific choice.
#
# Relationship to CI and scripts
# ------------------------------
#   - CI is expected to run Black, Ruff, mypy, and pytest as described
#     in Section 8 (Testing and CI). pre-commit hooks are a local
#     enforcement/convenience mechanism and DO NOT replace CI.
#
#   - Developer scripts under scripts/ (e.g. format_code, run_tests,
#     check_types) MAY wrap these tools, but the tools themselves are
#     the canonical behaviour. Any such scripts MUST follow the rules
#     in Section 5 (location, naming, CLI conventions).
#
# GPT RULE (Baseline tooling):
#   - GPTs MUST assume that Black, Ruff, mypy, pytest, and pre-commit
#     are available and SHOULD generate code that is compatible with
#     these tools.
#   - GPTs MUST NOT introduce new baseline tools without:
#       - an explicit feature card, AND
#       - a corresponding TECH_SPEC update approved by Andrew.


# ========================================
# SECTION 3: REPOSITORY LAYOUT
# ========================================
# This section defines the authoritative top-level repository structure
# for LillyCORE in Phase 0. All contributors and GPTs MUST use this
# structure when creating or referencing files.
#
# ----------------------------------------
# TOP-LEVEL FOLDERS (PHASE 0 STANDARD)
# ----------------------------------------
#
#   core/
#       - Runtime loop
#       - Logging
#       - Core services
#       - AI pools
#       - System DOC interfaces
#       (Engines are conceptually part of the core system but live in a
#        separate folder for clarity.)
#
#   engines/
#       - All core subsystem engines:
#           DRIFT_ENGINE
#           HELPER_ENGINE
#           PLUGIN_ENGINE
#           HELP_DESK_ENGINE
#           DREAM_ENGINE
#           SCRIPT_ENGINE
#
#   plugins/
#       - All optional add-on subsystems:
#           NOTES_PLUGIN
#           UX_INTERFACE
#           PROJECT_MANAGEMENT
#           PERSONAL_ASSISTANT
#           MULTI_USER
#           DEMOS_AND_CORP
#           (And any future plugins approved by Andrew)
#
#   config/
#       - Central configuration files.
#       - Content refined in later feature cards.
#
#   docs/
#       - Required human-facing documentation.
#       - docs/ is a REQUIRED top-level folder in LillyCORE.
#       - Must contain:
#           docs/build/
#               - Engineering/build-docs home.
#               - Physical storage location for system/build docs such as:
#                   - PROJECT_CANON
#                   - LILLYCORE_ROADMAP
#                   - FEATURES
#                   - TECH_SPEC
#                   - MODULES
#                   - GPT_RESOURCE_INDEX
#               - Auto-generated technical documentation MAY also live here.
#
#       - Reserved for future user-facing layers (to be defined in later phases), e.g.:
#           docs/user/
#               - "Official" user-facing guides, onboarding docs, and narratives.
#           docs/api/
#               - Published API/SDK documentation.
#
#       - GPT RULE:
#           - All build/system documentation lives under docs/build/ by default.
#           - User-facing docs MUST NOT be mixed into docs/build/; they belong in
#             dedicated user-facing subtrees (e.g. docs/user/, docs/api/) once created.
#
#
#   scripts/
#       - All dev and runtime scripts (see Section 5).
#
#   tests/
#       - pytest-based automated tests.
#       - MUST mirror the runtime layout:
#           tests/core/
#           tests/plugins/
#           tests/scripts/
#           (Additional mirrors may be added as new top-level folders appear.)
#
# ----------------------------------------
# FOLDER RESPONSIBILITIES & BOUNDARIES
# ----------------------------------------
# Purpose:
#   Tie the top-level folders (core/, engines/, plugins/, config/, scripts/, tests/)
#   to the system ontology from PROJECT_CANON (CORE, ENGINES, PLUGINS, DOC layers)
#   and MODULES, and define clear "must never" rules so future work does not drift.
#
# General dependency rule:
#   - core/ and engines/ together form the core runtime and engines.
#   - plugins/ builds on top of core/ and engines/, never the other way around.
#   - config/ and scripts/ may depend on core/, engines/, and plugins/ as described
#     below, but runtime code MUST NEVER depend on scripts/.
#   - tests/ may import from anywhere in the runtime tree, but runtime and scripts
#     MUST NEVER import from tests/.
#
# These rules apply to all current and future engines/plugins unless explicitly
# overridden by Andrew via updated docs.
#
# core/
#     Responsibility:
#       - Host the core runtime loop, logging, error envelopes, user preferences,
#         AI pool definitions, and System DOC integration.
#       - Provide shared infrastructure services used by engines and plugins.
#       - Construct and orchestrate engines without owning their internal business logic.
#
#     Allowed:
#       - Define reusable core services, utilities, and abstractions.
#       - Create and wire engine instances and AI pools.
#       - Read configuration from config/.
#
#     Must NEVER:
#       - Import directly from plugins/ or depend on any concrete plugin module.
#       - Contain plugin-specific behaviour, UX logic, or plugin schemas.
#       - Implement engine-specific business logic.
#
# engines/
#     Responsibility:
#       - Implement all core subsystem engines defined in PROJECT_CANON & MODULES.
#       - Each engine resides under engines/<engine_name>/ in snake_case folders.
#       - Encapsulate cognitive/work/stability behaviour (DRIFT, HELPER, PLUGIN,
#         HELP_DESK, DREAM, SCRIPT engines).
#
#     Allowed:
#       - Import from core/ (runtime loop, logging, AI pools, System DOC).
#       - Import other engines only where MODULES explicitly lists dependencies.
#       - Interact with plugins *indirectly* through PLUGIN_ENGINE registries.
#
#     Must NEVER:
#       - Import plugins/ directly or depend on concrete plugin code.
#       - Own UX surfaces or UI behaviour.
#       - Define or own System DOC schemas; engines *use* System DOC only.
#
# plugins/
#     Responsibility:
#       - Implement optional add-on modules (NOTES_PLUGIN, UX_INTERFACE, etc.).
#       - Extend system behaviour without modifying core runtime.
#       - Own plugin-specific behaviour, Plugin DOC, and per-plugin data.
#
#     Allowed:
#       - Import from core/ and engines/ as consumers of those APIs.
#       - Own their Plugin DOC schemas within DOC-layer boundaries.
#       - Provide UX surfaces as needed.
#
#     Must NEVER:
#       - Be imported directly by core/ or engines/ (only via PLUGIN_ENGINE routing).
#       - Define or modify System DOC schemas.
#       - Reconfigure global logging, AI pools, or the runtime loop.
#
# config/
#     Responsibility:
#       - Central configuration: environment definitions, templates, settings.
#       - Provide structured configuration values for core/, engines/, plugins/, scripts/.
#
#     Allowed:
#       - Define configuration objects and helpers.
#       - Be imported broadly across the runtime and scripts/.
#
#     Must NEVER:
#       - Contain business logic belonging to core/, engines/, plugins/, or scripts/.
#       - Import plugins/ when determining configuration.
#       - Define persistent storage schemas.
#
# scripts/
#     Responsibility:
#       - Dev/runtime scripts per TECH_SPEC Section 5.
#       - Wrap automation tasks such as formatting, linting, type checking,
#         running tests, seeding/migrating data.
#
#     Allowed:
#       - Import from core/, engines/, plugins/, and config/ to orchestrate tasks.
#       - Contain CLI logic and glue code.
#
#     Must NEVER:
#       - Be imported by core/, engines/, or plugins/.
#       - Implement long-lived APIs or business logic.
#       - Own persistent storage.
#
# tests/
#     Responsibility:
#       - pytest-based automated tests mirroring runtime structure.
#       - Validate behaviour across core/, engines/, plugins/, config/, scripts/.
#
#     Allowed:
#       - Import any runtime code to test it.
#       - Contain test-only helpers and fixtures.
#
#     Must NEVER:
#       - Be imported by runtime or scripts/.
#       - Host production logic (anything reused MUST be moved into runtime code).
#
#     Default Phase 0 layout:
#       - tests/core/
#           - Tests for core/ runtime modules.
#           - Tests for all engines/ modules (engines are treated as part of "core" for testing).
#       - tests/plugins/
#           - Tests for plugin modules under plugins/.
#       - tests/scripts/
#           - Tests for scripts/ wrappers and CLIs.
#
#     Substructure & density heuristics:
#       - Additional subdirectories under tests/core/, tests/plugins/, or tests/scripts/ MAY be created
#         as the codebase grows, provided they:
#           - follow the same "mirror the runtime layout" intent, and
#           - group clearly related tests.
#       - As a rule of thumb:
#           - Consider introducing a subfolder when a single tests/* folder approaches
#             roughly 20–30 test modules or navigation becomes painful.
#           - Avoid creating subfolders that are likely to remain at a single test file
#             for a long time; aim for at least ~3 closely related tests per new subfolder,
#             or a near-term plan to reach that density.
#           - Treat any tests/* folder with ~50+ unrelated files as a signal to re-group
#             tests or introduce structure.
#       - These numbers are guidelines, not hard limits; Architect/Andrew may override
#         them at any time.
#
# ----------------------------------------
# MIRRORING RULE
# ----------------------------------------
# All runtime Python code must have a corresponding test root under tests/.
#
# Examples:
#   core/runtime/core_runtime.py        → tests/core/test_core_runtime.py
#   engines/drift_engine/xyz.py         → tests/core/test_drift_engine_xyz.py
#   plugins/notes_plugin/abc.py         → tests/plugins/test_notes_plugin_abc.py
#   scripts/run_tests.py                → tests/scripts/test_run_tests.py
#
# ----------------------------------------
# GPT RULES
# ----------------------------------------
# - Do NOT invent new top-level folders without Andrew’s approval.
# - When unsure where something belongs, ASK:
#       "Should this live in core/, engines/, plugins/, or elsewhere?"
# - Engines are conceptually part of the core system but MUST remain in
#   the engines/ folder for structural clarity.
#
# ----------------------------------------
# DOCS LAYOUT RULES (PHASE 0)
# ----------------------------------------
# Purpose:
#   - Ensure that "build/system" documentation and "user-facing" documentation
#     stay structurally separate, even when they refer to the same concepts.
#
# Build/System docs (docs/build/):
#   - docs/build/ is the canonical home for internal engineering and system docs.
#   - The following conceptual documents are stored physically under docs/build/:
#       - PROJECT_CANON          → docs/build/project_canon.md
#       - LILLYCORE_ROADMAP      → docs/build/lillycore_roadmap.md
#       - FEATURES               → docs/build/features.md
#       - TECH_SPEC              → docs/build/tech_spec.md
#       - MODULES                → docs/build/modules.md
#       - GPT_RESOURCE_INDEX     → docs/build/gpt_resource_index.md
#
#   - Filenames follow the standard non-Python naming rule:
#       - lowercase_with_underscores, .md extension.
#   - Conceptual names (PROJECT_CANON, etc.) remain the titles used in prompts
#     and internal references; they do NOT override filename rules.
#
# User-facing docs (future):
#   - Future "official" user docs (e.g., onboarding guides, how-tos) will live
#     under dedicated subtrees such as docs/user/ and docs/api/.
#   - These user-facing folders MUST NOT contain build/system docs:
#       - PROJECT_CANON, TECH_SPEC, etc. remain in docs/build/ even if user
#         docs reference their content.
#   - User docs MAY quote or summarise build/system docs but should present
#     them in a user-friendly form.
#
# GPT RULE (docs layout):
#   - When referring to these core documents in prompts, always use their
#     conceptual names (PROJECT_CANON, TECH_SPEC, etc.).
#   - When suggesting or creating physical files, always place build/system
#     docs under docs/build/ with snake_case .md filenames.
#   - Do NOT invent additional top-level docs subtrees (beyond docs/build/
#     and reserved docs/user/, docs/api/) without Andrew’s explicit approval.


lillycore/
├── core/
│   ├── runtime/
│   ├── logging/
│   ├── ai_pools/
│   └── system_doc/
│
├── engines/
│   ├── drift_engine/
│   ├── helper_engine/
│   ├── plugin_engine/
│   ├── helpdesk_engine/
│   ├── dream_engine/
│   └── script_engine/
│
├── plugins/
│   ├── notes_plugin/
│   ├── ux_interface/
│   ├── project_management/
│   ├── personal_assistant/
│   ├── multi_user/
│   └── demos_and_corp/
│
├── config/
│
├── docs/
│   └── build/
│
├── scripts/
│
└── tests/
    ├── core/
    ├── plugins/
    └── scripts/


# ========================================
# SECTION 4: LOGGING & ERROR HANDLING
# ========================================
# Logging:
#   - There will be a unified logging system (defined in Phase 1).
#   - All new code that does meaningful work SHOULD log via that system once it exists.
#
# Errors:
#   - Prefer explicit exceptions over silent failure.
#   - Wrap external/IO calls where appropriate with clear error envelopes (as per design).
#
# GPT RULE:
#   - If logging or error envelope APIs are not defined yet, do NOT invent them.
#   - Instead, note in PLAN/DOC:
#       "Logging/error handling integration TBD once core logging is defined."
#
# TODO:
#   - Define the actual logging interface once Phase 1 is built.


# ========================================
# SECTION 5: SCRIPTS & CLI TOOLS
# ========================================
# This section defines where scripts live, how they are invoked,
# and the CLI norms that all LillyCORE scripts MUST follow.
#
# It complements the repository layout rules in SECTION 3
# (top-level scripts/ folder).  All GPTs and contributors MUST
# treat this as the single source of truth for script/CLI behaviour.
#
# Repository Path Assumptions:
#   - Scripts may import from:
#       core/
#       engines/
#       plugins/
#       config/
#   - All examples in this section assume these top-level folders exist
#     as defined in Section 3.
#
# ----------------------------------------
# 5.1 LOCATION & NAMING
# ----------------------------------------
# Where scripts live:
#   - All Python scripts for LillyCORE live under the top-level:
#       - scripts/
#   - No additional top-level folders (e.g. tools/, bin/, etc.) are
#     used for scripts unless explicitly approved and documented.
#
# File naming:
#   - Script files MUST use snake_case:
#       - examples: format_code.py, run_tests.py, seed_system_doc.py
#   - Names MUST be descriptive of behaviour, not environment:
#       - GOOD: rebuild_notes_index.py
#       - BAD: script1.py, helper.py
#
# Python only (Phases 0–3):
#   - All official scripts are Python 3.11+ scripts, consistent with
#     the runtime rules in SECTION 1.  :contentReference[oaicite:3]{index=3}
#   - Shell or other-language helpers MAY exist in the future but are
#     NOT considered standard scripts until explicitly added here.
#
# ----------------------------------------
# 5.2 INVOCATION MODEL
# ----------------------------------------
# Working directory:
#   - All examples and automation MUST assume the repository root as
#     the working directory.
#
# Standard invocation:
#   - The standard way to run a script is:
#       - python scripts/<script_name>.py [ARGS...]
#
# Examples:
#   - Run code formatter:
#       - python scripts/format_code.py
#   - Run tests:
#       - python scripts/run_tests.py -v
#
# Python module imports:
#   - Scripts SHOULD be written so they can be imported as modules:
#       - import scripts.format_code as format_code
#   - Each script SHOULD expose a main(argv: Sequence[str] | None) -> int
#     function, and use:
#       - if __name__ == "__main__":
#             raise SystemExit(main())
#     so tests and other scripts can reuse logic without executing the
#     CLI side effects.
#
# Entry points:
#   - No global console entrypoints (e.g. "lillycore" CLI installed
#     via setup tools) are defined in Phase 0–3.
#   - If/when a branded CLI is introduced, this section MUST be
#     updated with its invocation rules.
#
# ----------------------------------------
# 5.3 CLI INTERFACE NORMS (FLAGS & HELP)
# ----------------------------------------
# Argument parsing:
#   - Scripts MUST use the Python standard library for argument parsing
#     (argparse or equivalent), not third-party CLI frameworks, unless
#     explicitly approved.
#
# Help text:
#   - Every script MUST support:
#       - -h / --help
#     which prints:
#       - A one-line summary of what the script does.
#       - A description of each argument/flag.
#       - Defaults for key options (where applicable).
#
# Flag conventions:
#   - Common flags SHOULD follow these patterns when applicable:
#       - --dry-run
#           - Perform all checks and logging but do NOT write changes.
#       - -v / --verbose
#           - Increase verbosity; multiple -v flags MAY increase level.
#       - -q / --quiet
#           - Reduce non-essential output.
#       - --config PATH
#           - Path to a config file, when the script supports configs.
#
# Input/Output norms:
#   - Normal informational output SHOULD go to stdout.
#   - Errors and warnings SHOULD go to stderr.
#   - Scripts MUST avoid interactive prompts by default; they should be
#     fully controllable via arguments so they work in automation.
#
# ----------------------------------------
# 5.4 EXIT CODES
# ----------------------------------------
# All scripts MUST exit with a meaningful status code:
#
#   - 0  → Success (script completed as intended).
#   - 1  → Generic failure (unexpected error, unhandled exception).
#   - 2  → CLI usage error (invalid arguments, missing required flags).
#
# Additional non-zero codes MAY be defined per script for specific
# conditions, but they MUST be documented in that script’s module-level
# docstring and/or help text.
#
# On failure:
#   - Scripts MUST:
#       - Print a clear, human-readable error message.
#       - Exit with a non-zero status code.
#
# Logging:
#   - Once a unified logging system exists (see SECTION 4), scripts
#     SHOULD prefer that logging system instead of ad-hoc prints, but
#     this is NOT required in Phase 0. :contentReference[oaicite:4]{index=4}
#
# ----------------------------------------
# 5.5 DEVELOPER SCRIPTS VS RUNTIME SCRIPTS
# ----------------------------------------
# Definitions:
#
#   Developer scripts ("dev"):
#     - Scripts intended for contributors working on LillyCORE itself.
#     - Examples:
#         - format_code.py   (Black/Ruff helpers)
#         - run_tests.py     (pytest runner)
#         - check_types.py   (mypy wrapper)
#     - MAY depend on dev-only tools (Black, Ruff, mypy, pytest, etc.).
#
#   Runtime scripts ("runtime"):
#     - Scripts that interact directly with LillyCORE’s runtime,
#       engines, or persistent data.
#     - Examples (conceptual):
#         - start_core_runtime.py
#         - rebuild_system_doc_index.py
#     - MUST restrict dependencies to the approved runtime environment
#       and libraries documented elsewhere in TECH_SPEC.
#
# Location:
#   - Both developer and runtime scripts live under scripts/.
#   - Optional subdirectories (e.g. scripts/dev/, scripts/runtime/)
#     MAY be introduced later, but are NOT required in Phase 0–3.
#
# Identification:
#   - Each script MUST declare its type in the module-level docstring:
#
#       \"\"\"LillyCORE script (type: dev) — short description.\"\"\"
#       or
#       \"\"\"LillyCORE script (type: runtime) — short description.\"\"\"
#
#   - This distinction helps future automation (e.g., SCRIPT_ENGINE,
#     CI helpers) understand how to treat each script. 
#
# Behavioural expectations:
#   - Developer scripts:
#       - MAY be more experimental, but SHOULD remain stable where used
#         in automated workflows (e.g., pre-commit, CI).
#   - Runtime scripts:
#       - SHOULD be treated as part of the core runtime surface:
#           - typed where practical,
#           - tested where practical,
#           - conservative about side effects.
#
# NOTE:
#   - SCRIPT_ENGINE (Phase 8) will eventually reason about scripts,
#     but its behaviour will be defined separately; this section only
#     defines the human/GPT-facing conventions for now. :contentReference[oaicite:6]{index=6}
#
# ----------------------------------------
# 5.6 TESTING SCRIPTS
# ----------------------------------------
# Tests for scripts:
#   - Tests live under:
#       - tests/scripts/
#   - Tests SHOULD mirror script names where practical:
#       - scripts/format_code.py     → tests/scripts/test_format_code.py
#
# Invocation in tests:
#   - Where possible, tests SHOULD import the script module and call its
#     main() or underlying functions directly, rather than shelling out
#     to subprocesses.  This keeps tests fast and type-checkable.
#
#   - Subprocess-based tests MAY be used for end-to-end behaviour if
#     needed, but SHOULD be limited to key flows.
#
# This is consistent with the general testing rules in SECTION 8. :contentReference[oaicite:7]{index=7}
#
# ----------------------------------------
# 5.7 GPT RULES (SCRIPTS & CLI)
# ----------------------------------------
# For Architect, Implementer, and QA GPTs:
#
#   - When a feature requires a new script:
#       - The script MUST live under scripts/ and follow the naming and
#         invocation rules above.
#       - Architect/Implementer MUST NOT introduce new top-level script
#         folders without explicit approval.
#
#   - Implementer GPT:
#       - MUST define:
#           - script file name,
#           - expected invocation (python scripts/<name>.py ...),
#           - whether it is a "dev" or "runtime" script,
#           - its exit code semantics.
#       - MUST ensure at least a docstring and help text stub exist.
#
#   - QA GPT:
#       - MUST verify that any script added or modified:
#           - Lives under scripts/.
#           - Conforms to the invocation and CLI norms above.
#           - Uses non-zero exit codes on failure.
#
#   - If any script convention appears missing or ambiguous:
#       - GPTs MUST flag this and propose a TECH_SPEC update, rather
#         than silently inventing new behaviour.
#
# This section is the authoritative reference for script and CLI
# behaviour until updated by Andrew.
#
# ----------------------------------------
# 5.8 SUBSTRUCTURE & DENSITY (scripts/)
# ----------------------------------------
# Default Phase 0 layout:
#   - scripts/ has no mandatory subfolders.
#   - New scripts SHOULD, by default, live directly under scripts/ as single-module entrypoints.
#
# When to introduce subfolders:
#   - Optional subdirectories under scripts/ (e.g. scripts/dev/, scripts/runtime/) MAY be introduced when:
#       - there is a clear conceptual grouping (such as "developer tooling" vs "runtime orchestration"), AND
#       - either scripts/ is approaching roughly 20–30 mixed-purpose scripts, OR
#       - the new subgroup is expected to contain at least ~3–5 closely related scripts in the near term.
#
# Heuristics and cautions:
#   - Avoid subfolders that are likely to stay at a single script for a long time.
#   - Prefer shallow structure in Phase 0:
#       - At most one level of subfolders under scripts/ (e.g. scripts/dev/, scripts/runtime/).
#   - Treat any single scripts/ folder with ~50+ unrelated scripts as a signal to re-group and introduce structure.
#   - These density numbers are guidelines, not hard numeric limits; Architect/Andrew can override them as needed.
#
# Relationship to tests/:
#   - Tests for scripts/ continue to live under tests/scripts/ regardless of whether scripts are in subfolders.
#   - Where subfolders exist (e.g. scripts/dev/format_code.py), tests SHOULD either:
#       - stay flat under tests/scripts/ with clear names (e.g. test_dev_format_code.py), OR
#       - use matching light substructure (e.g. tests/scripts/dev/test_format_code.py) when that improves navigation.
#   - The choice of test substructure MUST still follow the tests/ density heuristics in SECTION 3 and SECTION 8.


# ========================================
# SECTION 6: STORAGE & DATABASE
# ========================================
# Current state:
#   - System DOC is conceptually defined in the Roadmap.
#   - No specific DB engine is frozen yet (e.g. SQLite vs Postgres).
#
# Interim rules:
#   - For early prototypes, prefer file-based or in-memory options UNLESS Andrew says otherwise.
#   - The Architect must NOT commit the system to a specific database without Andrew’s explicit decision.
#
# GPT RULE:
#   - If a feature needs persistence, ASK:
#       "For this feature, should we use a simple file approach, in-memory, or design for a future DB?"
#
# TODO:
#   - Decide on default DB (if any) for early phases.
#   - Document connection patterns once chosen.


# ========================================
# SECTION 7: ENVIRONMENTS & HARDWARE
# ========================================
# Development environment:
#   - Assume Andrew is developing on local hardware (exact OS/hardware to be clarified if needed).
#
# Hardware constraints:
#   - Do NOT assume GPU availability.
#   - Do NOT assume multi-machine cluster.
#
# GPT RULE:
#   - If hardware affects a design (e.g. heavy parallelism, GPU ops), ASK Andrew first.
#
# TODO:
#   - Specify OS assumptions if they become important (e.g. Linux vs Windows paths).
#   - Document any future dedicated appliance constraints (for Appliance Layer / Phase 15).


# ========================================
# SECTION 8: TESTING
# ========================================
# General approach:
#   - LillyCORE uses automated tests to validate behaviour where practical.
#   - Small, focused tests or usage examples are preferred over large,
#     monolithic suites.
#
# Chosen test framework:
#   - Python test framework: pytest.
#   - Rationale:
#       - Widely used, stable, and integrates well with Black, Ruff, and mypy.
#       - Current pytest releases support all actively maintained Python
#         versions in the LillyCORE target range (CPython 3.11–3.14).
#   - Developers are expected to install a pytest version compatible with the
#     supported Python versions defined in Section 1.
#
# Test folder layout (tests/):
#   - The default Phase 0 test roots are:
#       - tests/core/     → tests for core/ and all engines/ modules
#                          (engines are treated as part of "core" for testing).
#       - tests/plugins/  → tests for plugins/.
#       - tests/scripts/  → tests for scripts/.
#   - This layout MUST remain the default unless Architect/Andrew explicitly revises it.
#
# Density heuristics (tests/):
#   - Additional subdirectories under tests/core/, tests/plugins/, or tests/scripts/ MAY be added when:
#       - a single folder is approaching roughly 20–30 test modules; OR
#       - there is a clear conceptual grouping (e.g. tests/plugins/notes_plugin/) that
#         makes navigation and targeted test runs meaningfully easier.
#   - Avoid:
#       - subfolders that are likely to remain at a single test file for a long time.
#       - very large, flat folders with around 50+ unrelated tests.
#   - These heuristics are guidelines only; Architect/Andrew can override them for specific cases.
#
# Running tests:
#   - From the repository root, the standard way to run the test suite is:
#       - pytest
#     or equivalently:
#       - python -m pytest
#   - All test-running examples and scripts SHOULD assume the repo root as
#     the working directory unless otherwise specified.
#
# GPT RULE:
#   - When implementing non-trivial behaviour, propose at least:
#       - A pytest unit-test skeleton, OR
#       - A simple manual test procedure, if writing a test is clearly out
#         of scope for the current card.
#
# CI and static checks:
#   - Once CI is configured for LillyCORE, the minimum expected checks are:
#       - Black formatting check (no changes when Black is run).
#       - Ruff lint check under the configured rule set.
#       - mypy type-checker for the configured strict set of modules
#         (see Section 2: Typing & type checking).
#       - The pytest test suite (run via pytest from the repo root).
#   - CI SHOULD fail if:
#       - Black would reformat any committed Python file, OR
#       - Ruff reports lint errors for the current codebase, OR
#       - mypy reports type errors in the strict set of modules, OR
#       - pytest tests fail.
#   - Additional static analysis tools beyond Black/Ruff/mypy/pytest MAY be
#     added in future tasks and will be documented here when chosen.


# ========================================
# SECTION 9: GPT-SPECIFIC NOTES
# ========================================
# For Architect, Implementer, and QA GPTs:
# - NEVER:
#     - invent libraries
#     - invent folder structures
#     - invent tools or CLIs
#   without Andrew’s explicit approval.
#
# - ALWAYS:
#     - Ask for clarification when technical constraints matter.
#     - Treat this TECH_SPEC as evolving; if something feels missing:
#         Ask:
#         "Should we add this rule or choice to TECH_SPEC?"
#
# - QA GPT uses TECH_SPEC to verify that implemented work follows the correct technical standards.
#
# This file is living documentation and will grow as LillyCORE matures.


# ========================================
# SECTION 10: EXAMPLES
# ========================================
#
# Example Type Signatures (Python 3.11+)
#
#   from pathlib import Path
#   from collections.abc import Sequence
#   from typing import Any
#
#   def load_user_preferences(path: Path) -> dict[str, Any]:
#       """Load user preferences from disk."""
#       ...
#
#   def run_core_loop(config: CoreConfig, *, dry_run: bool = False) -> int:
#       """Run the CORE_RUNTIME loop and return an exit code."""
#       ...
#
#   def summarize_transcript(
#       lines: Sequence[str],
#       max_tokens: int | None = None,
#   ) -> str:
#       """Summarize transcript text for NOTES_PLUGIN."""
#       ...
#
# Notes:
#   - Examples here illustrate expected annotation style, not behavior.
#   - All examples assume Python 3.11+ type syntax.


# ========================================
# END OF TECH_SPEC
# ========================================
