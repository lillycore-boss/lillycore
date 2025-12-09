
# ========================================
# FILE: GPT_RESOURCE_INDEX
# ROLE: Master index of project resources for LillyCORE
# NOTE: All other docs are referenced here by NAME only.
# ========================================

# ----------------------------------------
# SECTION: OVERVIEW
# ----------------------------------------
# This file is the single source of truth for:
# - What project documents exist
# - What each document is for
# - How AIs should think about those documents
#
# Architect and Implementer GPTs MUST:
# - Treat this file as the "directory" of knowledge
# - NEVER assume a document exists if it's not listed here
# - ALWAYS ask Andrew to paste the relevant section from:
#   - this file, or
#   - the documents named here
#
# QA GPT:
#     - Uses this index to locate referenced documents when verifying work.
#     - MUST request any missing document sections before evaluation.
#
# Rule:
# If a new doc is created, it should be added here.
# If a doc changes meaning, this index should be updated.
#
# Physical location (Phase 0):
#   - All named documents listed in this index are stored physically under:
#       docs/build/
#   - Filenames follow snake_case with a .md extension, e.g.:
#       PROJECT_CANON          → docs/build/project_canon.md
#       LILLYCORE_ROADMAP      → docs/build/lillycore_roadmap.md
#       FEATURES               → docs/build/features.md
#       TECH_SPEC              → docs/build/tech_spec.md
#       MODULES                → docs/build/modules.md
#       GPT_RESOURCE_INDEX     → docs/build/gpt_resource_index.md
#       docs/build/documentation_protocol.md
#       docs/build/documentation_governance.md
#
# Prompt usage:
#   - In prompts and AI instructions, continue to refer to documents by their
#     conceptual names (PROJECT_CANON, TECH_SPEC, etc.), not by filename.
#   - GPTs MUST NOT assume any document exists outside docs/build/ unless it
#     is explicitly added to this index.

# ----------------------------------------
# SECTION: DOCUMENT: PROJECT_CANON
# ----------------------------------------
# name: PROJECT_CANON
# type: system_rules
# status: exists
# path: docs/build/project_canon.md
# description:
#   Global philosophy, AI behaviour rules,
#   ontology of components, and high-level planning rules.
#
# usage:
#   - Architect uses this to ensure new features fit the system's meaning.
#   - Implementer uses this to avoid violating global rules.
#
# access:
#   - When needed, GPT should ask:
#     "Please paste the relevant section of PROJECT_CANON."

# ----------------------------------------
# SECTION: DOCUMENT: LILLYCORE_ROADMAP
# ----------------------------------------
# name: LILLYCORE_ROADMAP
# type: roadmap
# status: exists
# path: docs/build/lillycore_roadmap.md
# description:
#   High-level phases (0..N) for LillyCORE evolution,
#   defining when subsystems appear and their intent.
#
# usage:
#   - Architect uses this to decide which phase/subsystem work belongs to.
#   - Implementer uses this for context only (does NOT change it).
#
# access:
#   - GPT should ask:
#     "Please paste the roadmap phases relevant to <topic>."

# ----------------------------------------
# SECTION: DOCUMENT: FEATURES
# ----------------------------------------
# name: FEATURES
# type: feature_cards
# status: exists
# path: docs/build/features.md
# description:
#   Defines the standard feature card structure for LillyCORE
#   and (optionally) mirrors a small subset of important features.
#
# truth_source:
#   - Canonical feature list lives in GitHub Issues / Project Board.
#   - FEATURES is a structural/template reference and optional mirror.
#
# usage:
#   - Architect:
#       - Uses this to design feature cards and propose new features.
#   - Implementer:
#       - Uses cards pasted from GitHub or this file to implement work.
#
# access:
#   - GPT should ask:
#       "Please paste the relevant feature card(s) from GitHub or FEATURES
#        for the work we are doing."


# ----------------------------------------
# SECTION: DOCUMENT: TECH_SPEC
# ----------------------------------------
# name: TECH_SPEC
# type: tools_environment
# status: exists
# path: docs/build/tech_spec.md
# description:
#   Technical standards and environment details, e.g.:
#   - python3 usage
#   - comment style
#   - DB selection and connection model
#   - folder structure
#   - script conventions
#
# usage:
#   - Architect uses this to avoid planning things that violate technical constraints.
#   - Implementer uses this to obey the agreed standards.
#
# access:
#   - GPT should ask:
#     "Please paste the relevant TECH_SPEC section (e.g. Python, DB, scripts)."

# ----------------------------------------
# SECTION: DOCUMENT: MODULES
# ----------------------------------------
# name: MODULES
# type: module_overview
# status: exists
# path: docs/build/modules.md
# description:
#   Overview of major modules / engines / handlers:
#   - Responsibilities
#   - Boundaries
#   - Dependencies
#
# usage:
#   - Architect updates this as new modules become real.
#   - Implementer uses this for context when working on module internals.
#
# access:
#   - GPT should ask:
#     "Please paste the MODULES section for <module_name>."

# ----------------------------------------
# SECTION: DOCUMENT: DOCUMENTATION_GOVERNANCE
# ----------------------------------------
# name: DOCUMENTATION_GOVERNANCE
# type: system_rules
# status: exists
# path: docs/documentation_governance.md
# description:
#   System-level conceptual documentation governance for LillyCORE:
#   defines documentation layers and categories, which docs are
#   canonical vs exploratory, and which doc types are allowed or
#   forbidden.
#
# usage:
#   - Architect:
#       - Uses this to reason about where new docs belong and which
#         kinds of docs may be introduced.
#   - Implementer:
#       - Uses this to understand which docs are canonical, which are
#         scratch/exploratory, and when a new doc must be promoted and
#         indexed.
#   - QA:
#       - Uses this to verify that no forbidden doc categories are
#         relied on and that canonical docs are kept in sync.
#
# access:
#   - When needed, GPT should ask:
#     "Please paste the full content of DOCUMENTATION_GOVERNANCE
#      (docs/documentation_governance.md)."


# ----------------------------------------
# SECTION: DOCUMENT: DOCUMENTATION_PROTOCOL
# ----------------------------------------
# name: DOCUMENTATION_PROTOCOL
# type: system_rules
# status: exists
# path: docs/build/documentation_protocol.md
# description:
#   Build/system documentation protocol defining roles, triggers, and
#   procedures for updating canonical docs (PROJECT_CANON, ROADMAP,
#   TECH_SPEC, MODULES, FEATURES, GPT_RESOURCE_INDEX, and related
#   conceptual docs).
#
# usage:
#   - Architect:
#       - Uses this to ensure phase and feature bundles include proper
#         documentation deliverables and flows.
#   - Implementer:
#       - Uses this as the operational checklist for which docs to
#         update after implementing a card, and when to stop and ask
#         Andrew.
#   - QA:
#       - Uses this alongside the QA System in FEATURES to decide
#         whether documentation updates are complete for a card or
#         phase.
#
# access:
#   - When needed, GPT should ask:
#     "Please paste the DOCUMENTATION_PROTOCOL build doc
#      (docs/build/documentation_protocol.md)."


# ----------------------------------------
# SECTION: DOCUMENT: OTHER
# ----------------------------------------
# name: (future docs to be listed here)
# type: extension
# status: future
# description:
#   Placeholder for any additional docs you may add later:
#   - e.g., NOTES_PLUGIN_SPEC, DREAM_ENGINE_SPEC, etc.
#
# When new docs are added, they should follow the same pattern:
# - SECTION header
# - name:
# - type:
# - status:
# - description:
# - usage:
# - access:




