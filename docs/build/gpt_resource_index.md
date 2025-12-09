# ========================================
# FILE: GPT_RESOURCE_INDEX
# ROLE: Master index of project resources for LillyCORE
# NOTE: All other docs are referenced here by NAME only.
# ========================================

# ----------------------------------------
# SECTION: OVERVIEW
# ----------------------------------------
This file is the single source of truth for:
- What project documents exist
- What each document is for
- Where they live in the repository

Procedural rules for how GPTs load, use, and update these documents
are defined in DOCUMENTATION_PROTOCOL and DOCUMENTATION_GOVERNANCE.
See docs/build/documentation_protocol.md and
docs/documentation_governance.md.

Architect, Implementer, and QA GPTs should treat this file as the
directory of canonical docs. If a new canonical doc is created or an
existing one changes meaning, this index must be updated.

Mandatory-load set:
- For any architectural reasoning, planning, implementation, or QA work
  on LillyCORE, GPT roles MUST load and read, at minimum:
    - GPT_RESOURCE_INDEX (this file)
    - DOCUMENTATION_GOVERNANCE
    - DOCUMENTATION_PROTOCOL
- DOCUMENTATION_PROTOCOL is the procedural authority for how GPTs
  behave when reading/updating docs.
- DOCUMENTATION_GOVERNANCE is the conceptual authority for doc layers,
  categories, and which docs are allowed or forbidden.

Physical location (Phase 0):
- All named documents listed in this index are stored under:
    docs/build/
- Filenames follow snake_case with a .md extension, for example:
    PROJECT_CANON          → docs/build/project_canon.md
    LILLYCORE_ROADMAP      → docs/build/lillycore_roadmap.md
    FEATURES               → docs/build/features.md
    TECH_SPEC              → docs/build/tech_spec.md
    MODULES                → docs/build/modules.md
    GPT_RESOURCE_INDEX     → docs/build/gpt_resource_index.md
    DOCUMENTATION_PROTOCOL → docs/build/documentation_protocol.md
    DOCUMENTATION_GOVERNANCE → docs/documentation_governance.md

In prompts and AI instructions, documents should be referred to by
their conceptual names (PROJECT_CANON, TECH_SPEC, etc.), not by path.


# ----------------------------------------
# SECTION: DOCUMENT: PROJECT_CANON
# ----------------------------------------
name: PROJECT_CANON
type: system_rules
status: exists
path: docs/build/project_canon.md
description:
  Core philosophy, global AI behaviour principles, ontology of
  components, and high-level planning discipline.

usage:
  - Used to ensure new work aligns with LillyCORE’s meaning and
    ontological categories.

access:
  - When needed, Andrew can paste the relevant Canon section into chat.

# ----------------------------------------
# SECTION: DOCUMENT: LILLYCORE_ROADMAP
# ----------------------------------------
name: LILLYCORE_ROADMAP
type: roadmap
status: exists
path: docs/build/lillycore_roadmap.md
description:
  High-level phases (0..N) for LillyCORE evolution, defining when
  subsystems appear and their intent.

usage:
  - Used to understand phase context and when subsystems are expected
    to exist.

access:
  - When needed, Andrew can paste the relevant roadmap phases.

# ----------------------------------------
# SECTION: DOCUMENT: FEATURES
# ----------------------------------------
name: FEATURES
type: feature_cards
status: exists
path: docs/build/features.md
description:
  Defines the standard feature card structure for LillyCORE and
  optionally mirrors a small subset of important features.

truth_source:
  - Canonical feature list lives in GitHub Issues / Project Board.
  - FEATURES is a template and optional mirror.

usage:
  - Used to design, read, and reference feature cards.

access:
  - When needed, Andrew can paste the relevant feature card(s) from
    GitHub or FEATURES.

# ----------------------------------------
# SECTION: DOCUMENT: TECH_SPEC
# ----------------------------------------
name: TECH_SPEC
type: tools_environment
status: exists
path: docs/build/tech_spec.md
description:
  Technical standards and environment details, such as:
  - Python versions
  - naming conventions
  - repository layout
  - script conventions
  - tooling and CI expectations

usage:
  - Used to understand and obey technical constraints and environment
    rules.

access:
  - When needed, Andrew can paste the relevant TECH_SPEC section
    (e.g. Python, DB, scripts).

# ----------------------------------------
# SECTION: DOCUMENT: MODULES
# ----------------------------------------
name: MODULES
type: module_overview
status: exists
path: docs/build/modules.md
description:
  Overview of major modules, engines, and handlers:
  - responsibilities
  - boundaries
  - dependencies

usage:
  - Used to understand where module responsibilities live and how they
    relate.

access:
  - When needed, Andrew can paste the MODULES entry for a given
    module or engine.

# ----------------------------------------
# SECTION: DOCUMENT: DOCUMENTATION_GOVERNANCE
# ----------------------------------------
name: DOCUMENTATION_GOVERNANCE
type: system_rules
status: exists
path: docs/documentation_governance.md
description:
  System-level conceptual documentation governance for LillyCORE:
  defines documentation layers and categories, which docs are
  canonical vs exploratory, and which doc types are allowed or
  forbidden.

usage:
  - Used to reason about where new docs belong and which kinds of docs
    may be introduced or promoted.
  - MUST be loaded as part of the mandatory-load set before any
    reasoning, planning, or documentation updates involving canonical
    docs.

access:
  - When needed, Andrew can paste the full content of
    DOCUMENTATION_GOVERNANCE.


# ----------------------------------------
# SECTION: DOCUMENT: DOCUMENTATION_PROTOCOL
# ----------------------------------------
name: DOCUMENTATION_PROTOCOL
type: system_rules
status: exists
path: docs/build/documentation_protocol.md
description:
  Build/system documentation protocol defining roles, triggers, and
  procedures for updating canonical docs (PROJECT_CANON, ROADMAP,
  TECH_SPEC, MODULES, FEATURES, GPT_RESOURCE_INDEX, and related
  conceptual docs).

usage:
  - Used as the operational reference for when and how to update
    docs, which roles are responsible, and how QA verifies doc
    completeness.
  - MUST be loaded and read as part of the mandatory-load set before
    any reasoning, architectural planning, implementation, or QA that
    reads or writes canonical docs.

access:
  - When needed, Andrew can paste the DOCUMENTATION_PROTOCOL build
    doc.

# ----------------------------------------
# SECTION: DOCUMENT: GPT_BEHAVIOUR_SPEC
# ----------------------------------------
name: GPT_BEHAVIOUR_SPEC
type: process_rules
status: exists
path: docs/build/gpt_behaviour_spec.md
description:
  Unified behaviour and ingestion standard for GPT roles used to build
  LillyCORE (Architect, Implementer, QA, and future helper GPTs). Defines
  role boundaries, ingestion rules, feature-card lifecycle, and how GPTs
  interact with canonical docs and with Andrew.

usage:
  - MUST be loaded by any GPT participating in the LillyCORE build process.
  - Used to determine how GPTs ingest docs, ask Andrew for clarification,
    and coordinate between Architect, Implementer, and QA roles.

access:
  - When needed, Andrew can paste the full content of GPT_BEHAVIOUR_SPEC
    or relevant sections.


# ----------------------------------------
# SECTION: DOCUMENT: OTHER
# ----------------------------------------
name: (future docs to be listed here)
type: extension
status: future
description:
  Placeholder for additional docs that may be added later, such as:
  - NOTES_PLUGIN_SPEC
  - DREAM_ENGINE_SPEC
  - or other subsystem-specific documents.

When new docs are added, they should follow this pattern:
- SECTION header
- name:
- type:
- status:
- path: (if applicable)
- description:
- usage:
- access:
