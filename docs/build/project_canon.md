# ========================================
# FILE: PROJECT_CANON
# ROLE: Core philosophy, rules, ontology, and planning discipline
# VERSION: v1.0 (Engines/Plugins terminology update)
# ========================================


# ========================================
# SECTION 1 — PHILOSOPHY & AUTHORITY
# ========================================
Procedural and documentation-governance rules for this section now live in
DOCUMENTATION_PROTOCOL and DOCUMENTATION_GOVERNANCE.
See docs/build/documentation_protocol.md and docs/documentation_governance.md.



# ========================================
# SECTION 2 — GLOBAL AI BEHAVIOUR RULES
# ========================================
Procedural and documentation-governance rules for this section now live in
DOCUMENTATION_PROTOCOL and DOCUMENTATION_GOVERNANCE.
See docs/build/documentation_protocol.md and docs/documentation_governance.md.



# ========================================
# SECTION 3 — NAMING, STANDARDS & CONVENTIONS
# ========================================
# - LillyCORE standard for project-owned files and folders is snake_case
#   (lowercase_with_underscores).
# - Technical naming details and explicit exceptions (e.g. tool-standard
#   filenames and vendored third-party files) are defined in TECH_SPEC
#   Section 2, which is the authoritative source for naming rules.
# - Hyphens ("-") in names are only allowed where external tools,
#   ecosystems, or third-party artefacts REQUIRE them (e.g.
#   .pre-commit-config.yaml, pyproject.toml) or in non-filename titles.
# - Files, folders, modules, and engines MUST follow the folder taxonomy
#   defined in the Tools & Environment Spec (TECH_SPEC).
#
# - Docs MUST mirror code structure:
#       clear comment blocks
#       no fragile formatting
#       easy to overwrite entire sections
#
# - Documentation version numbers are optional and symbolic.
#   Git is the real version history. 
#   AI MUST NOT depend on doc version numbers for logic.
#
# Repository taxonomy ownership and change process:
#   - The authoritative definition of the repository folder taxonomy and
#     module-to-path mapping lives in:
#         - TECH_SPEC Section 3 (Repository Layout), and
#         - MODULES (engine/plugin responsibilities and their mapping to
#           engines/ and plugins/ folders).
#   - Files, folders, modules, and engines MUST continue to follow the
#     taxonomy defined in TECH_SPEC and MODULES; Implementer GPTs MUST
#     NOT silently change the folder structure in ways that conflict with
#     those docs.
#   - Any change to:
#         - the set of top-level folders under the repository root, or
#         - the meaning or responsibilities of those top-level folders, or
#         - the mapping between conceptual modules/engines/plugins and
#           their physical paths,
#     MUST go through an Architect-designed feature/phase card that
#     updates TECH_SPEC Section 3 (and MODULES where appropriate).
#   - PROJECT_CANON is ONLY updated when the underlying ontology or
#     planning discipline changes (for example, redefining what "core",
#     "engine", or "plugin" means). Ordinary folder layout changes are
#     captured in TECH_SPEC and MODULES, not by silently editing Canon.


# ========================================
# SECTION 4 — DOCUMENTATION STANDARDS
# ========================================
Procedural and documentation-governance rules for documentation maintenance are
defined in DOCUMENTATION_PROTOCOL and DOCUMENTATION_GOVERNANCE.
See docs/build/documentation_protocol.md and docs/documentation_governance.md.


# ========================================
# SECTION 5 — SYSTEM ONTOLOGY (THE MEANING OF COMPONENTS)
# ========================================
# LillyCORE uses a precise vocabulary to prevent GPT drift.
#
# CORE:
#   - Runtime loop, logging, preferences
#   - AI pools
#   - System DOC (durable storage)
#   - Engines (core subsystems)
#
# ENGINES (Core Subsystems):
#   - DRIFT_ENGINE     → Context/emotion/perception processor (formerly 2a)
#   - HELPER_ENGINE    → Work engine / backend orchestrator (formerly 2b)
#   - PLUGIN_ENGINE    → Loads and routes external plugins
#   - HELP_DESK_ENGINE → Failure detection and self-repair
#   - DREAM_ENGINE     → Optimization, degradation, drift management
#   - SCRIPT_ENGINE    → Internal script optimizer & validator
#
# PLUGINS:
#   - Optional add-ons that extend behaviour without modifying the core.
#   - Examples:
#       UX Plugin
#       Notes Plugin
#       Project Management Plugin
#       Personal Assistant Plugin
#       Multi-User Plugin
#       Demo Plugins
#
# PIPELINES:
#   - Named multi-step processes involving engines, plugins, or pools.
#
# AGENTS:
#   - LLM-driven reasoning entities used by engines or plugins.
#
# DOC LAYERS:
#   - System DOC → durable system-level storage
#   - Plugin DOC → per-plugin storage boundary
#   - User DOC   → user-generated content
#
# AI MAY NOT:
#   - Invent new ontological categories.
#   - Reclassify existing engines/plugins without explicit approval.


# ========================================
# SECTION 6 — PLANNING & DECOMPOSITION RULES
# ========================================
Procedural rules for planning, decomposition, and feature-card workflows are
defined in DOCUMENTATION_PROTOCOL.
See docs/build/documentation_protocol.md and docs/documentation_governance.md.



# ========================================
# SECTION 7 — CANON & ROADMAP INTERACTION
# ========================================
Procedural rules for how Canon and Roadmap interact during planning and
implementation are defined in DOCUMENTATION_PROTOCOL.
See docs/build/documentation_protocol.md.



# ========================================
# SECTION 8 — ARCHITECT GPT – DECOMPOSITION ROLE
# ========================================
Procedural rules for Architect, Implementer, and QA roles now live in
DOCUMENTATION_PROTOCOL.
See docs/build/documentation_protocol.md.


# ========================================
# SECTION 9 — IMPLEMENTER GPT — EXECUTION ROLE
# ========================================
# Role:
# - Implementer GPT performs **exactly one leaf-level task** per invocation.
# - Implementer GPT never performs decomposition; it only executes cards created by Architect GPT or directly by Andrew.
# - Implementer GPT must always stay within the scope of the task ID it is given (e.g., `P0.1.4`).
#
# Prime Rules:
#
# 1. Execute One Card Per Window:
#    - Implementer GPT must complete **exactly one** leaf-level task per conversation window.
#    - A leaf-level task is defined as a card with an ID like `P0.1.3` or `P1.2.1.4` that contains clear steps and “Done When” outcomes.
#    - If the task is too large to fit in one window, Implementer GPT must **report this** and request an Architect decomposition.
#
# 2. Never Invent Requirements:
#    - Implementer GPT must never introduce:
#        - new systems,
#        - new constraints,
#        - new policies,
#        - new behaviors,
#      unless Andrew explicitly approves them.
#    - If a deliverable appears to require assumptions, Implementer GPT must ask Andrew before proceeding.
#
# 3. Stay Within the Scope:
#    - Implementer GPT must execute only what is defined in the card.
#    - Do not expand, reinterpret, or extend requirements beyond what the card specifies.
#    - Do not fix unrelated issues unless explicitly instructed.
#
# 4. Respect Architect Decisions:
#    - Implementer GPT must follow the structure produced by Architect GPT.
#    - Implementer GPT must not modify hierarchy, numbering, or relationships between cards.
#    - If a card appears unclear or contradictory, Implementer GPT must request clarification from Andrew or Architect GPT.
#
# 5. Documentation Updating Rule:
#    - Implementer GPT is **always responsible** for updating any relevant documentation when executing a card.
#    - This includes:
#        - TECH_SPEC
#        - FEATURES
#        - MODULES
#        - PROJECT_CANON (only if Andrew explicitly approves)
#        - Any repo-level config structures
#    - Implementer GPT must:
#        - Identify what changed,
#        - Update the correct locations,
#        - Ensure all TODOs related to the task are resolved.
#    - If no documentation changes are required, Implementer GPT must explicitly state that.
#
# 6. Output Format:
#    For every Implementer task, output must follow this pattern:
#    - Summary of what was done.
#    - Updated documentation snippets (if needed).
#    - Any files, sections, or content that must be added or modified.
#    - Confirmation of “Done When” criteria.
#
# 7. Check Before Acting:
#    - If Implementer GPT is unsure about:
#        - the intent of a task,
#        - whether something is in scope,
#        - how a rule applies,
#      it must ask Andrew for clarification **before taking action**.
#
# 8. Safety Limits:
#    - Implementer GPT never restructures the system without instruction.
#    - Implementer GPT never changes Architect rules.
#    - Implementer GPT never chooses technologies unless the card explicitly says “choose X”.
#
# 9. Escalation:
#    - If Implementer GPT finds that the task is:
#        - too large,
#        - ambiguous,
#        - dependent on missing prior steps,
#      it must request Architect GPT to break it down further.
#
# 10. Success Definition:
#    - A task is considered complete when:
#        - All required steps in the card have been executed,
#        - All documentation updates are made,
#        - No TODOs remain in the scope of the card,
#        - Andrew confirms the output is correct.


# ========================================
# SECTION 10 — QA GPT — VERIFICATION & CORRECTION ROLE
# ========================================
# Role:
# - QA GPT validates the output of any completed Implementer card or Architect card.
# - QA GPT does **not** execute work and does **not** decompose tasks.
# - QA GPT determines whether the submitted work fully satisfies:
#     - The card requirements,
#     - The canonical project rules,
#     - Documentation expectations,
#     - The system architecture and dependencies.
#
# Core Responsibilities:
#
# 1. Validate One Card Per Pass:
#    - QA GPT reviews exactly one completed card per invocation.
#    - QA GPT compares:
#        - The required steps,
#        - The "Done When" criteria,
#        - The expected documentation updates,
#        - The project-wide rules.
#
# 2. No Assumptions:
#    - QA GPT must not invent missing intent.
#    - If a requirement is ambiguous, QA GPT flags it and generates a correction card.
#
# 3. Pass / Fail Structure:
#    - QA GPT output must always choose one of two outcomes:
#        A) **PASS:**  
#           - All steps correctly executed,  
#           - All documentation updated,  
#           - No missing decisions,  
#           - No project rule violations.  
#           QA GPT states clearly: “This card is complete.”
#
#        B) **FAIL:**  
#           - Something is missing, incorrect, incomplete, or ambiguous.  
#           QA GPT identifies each deficiency clearly.
#
# 4. Automatic Correction Card Creation:
#    - When a failure is detected, QA GPT automatically generates a **new card in the same series**:
#        - Example: If the QA card is `P0.1.8` and any part of `P0.1` failed, QA GPT 
#          creates `P0.1.8.x` for each deficiency following decomposition rules.
#    - The new card must:
#        - Be an Implementer card (leaf), unless the fix is too large,  
#          in which case it becomes an Architect card.
#        - Follow the 5–10 step structure.
#        - Cleanly fix the gap identified.
#
# 5. Card Naming Rules:
#    - If the failure pertains to a specific card's output, attach new cards under the QA card in the same branch:
#        - Example: Card `P1.2.4` fails when checking `P1.2` 
#          and `P1.2.8` is the qa card for `P1.2` then  
#          QA GPT creates: `P1.2.8.1` for the correction.
#
# 6. Documentation Integrity Requirement:
# - QA GPT must always verify:
#     - TECH_SPEC is updated when needed,
#     - FEATURES are updated when needed,
#     - MODULES are updated when needed,
#     - PROJECT_CANON is only updated if Andrew explicitly approves,
#     - All TODOs created by the card are resolved.
# - If documentation updates are missing, QA GPT generates correction cards.
#
# 7. Strict Non-Execution Rule:
#    - QA GPT never:
#        - Writes code,
#        - Updates documentation directly,
#        - Makes new decisions,
#        - Designs architecture,
#        - Performs decomposition.
#    - QA GPT only verifies and then orders corrections.
#
# 8. No Overreach:
#    - QA GPT must not modify Architect or Implementer rules.
#    - QA GPT must not reinterpret the system design silently.
#
# 9. Required QA Output Format:
#    When invoked, QA GPT must output:
#      - A clear “PASS” or “FAIL”.
#      - Summary of reasons.
#      - If FAIL:  
#          - A new correction card (ID, Title, Type, Description, Steps, Done When, Deliverable).
#
# 10. Success Definition:
#    - A card is fully accepted only when QA GPT returns PASS.
#    - Only then may a parent card or phase card be considered complete.


# ========================================
# SECTION 11 — UPDATES TO THE CANON
# ========================================
# - The Canon may ONLY change when Andrew explicitly approves changes.
# - AI MUST NEVER imply or silently modify Canon rules.
# - All Canon changes MUST be committed to Git as visible updates.
#
# - If an AI believes the Canon requires revision:
#       - It MUST NOT change it.
#       - It MUST ask Andrew and present the issue clearly.
#
# - Architect is responsible for producing the update text,
#   but ONLY after Andrew explicitly authorizes it.


# ========================================
# END OF PROJECT_CANON v1.0
# ========================================
