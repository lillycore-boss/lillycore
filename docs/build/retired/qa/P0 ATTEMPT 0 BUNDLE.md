# ========================================
# PHASE 0 ATTEMPT 0 BUNDLE
# ========================================
# Broad Phase-0 Feature Cards
# Architect GPT Submission
# ========================================

# ----------------------------------------
# P0.1 — Select Technical Baseline Standards
# ----------------------------------------
ID: P0.1
Title: Select Technical Baseline Standards (Python Version, Formatter, Linter, Tooling)
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Choose the essential technical baselines (Python version, formatter, linter,
    test framework, etc.) required for Phase 1 to begin.

Context:
    TECH_SPEC contains unresolved TODOs. Phase 1 depends on well-defined
    technical standards. Architect does not guide these decisions; Implementer
    works with Andrew to finalize them during Phase 0.

Deliverables:
    - Final Python version
    - Chosen formatter
    - Chosen linter
    - Minimum tooling requirements
    - Updated TECH_SPEC reflecting all decisions
    - A Phase-0 summary of baseline decisions

Done When:
    - All technical choices are made and documented
    - No unresolved TODOs remain in TECH_SPEC technical-baseline sections
    - Implementer has supplied ready-to-paste TECH_SPEC updates

Notes / Future:
    Baseline remains stable unless revised by Andrew via future cards.


# ----------------------------------------
# P0.2 — Define Repository Taxonomy & Naming Standards
# ----------------------------------------
ID: P0.2
Title: Define Repository Taxonomy & Naming Standards
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Create a stable conceptual structure for the repository, including folder
    taxonomy, naming rules, and placement boundaries.

Context:
    TECH_SPEC defines draft folders; Canon requires mirrored doc/code structure;
    Andrew selected lowercase_with_underscores for naming.

Deliverables:
    - Final conceptual folder map
    - Naming convention rules
    - Placement boundaries
    - Rules for future structural changes

Done When:
    - Repo taxonomy is fully defined
    - Naming rules are finalized
    - TECH_SPEC updated accordingly

Notes / Future:
    No physical folders created until Phase 1.


# ----------------------------------------
# P0.3 — Documentation Structure & Update Rules
# ----------------------------------------
ID: P0.3
Title: Establish Documentation Structure & Update Rules
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Define how documentation is organized, updated, governed, and mirrored across
    GPT roles.

Context:
    Canon and TECH_SPEC require consistent, rule-driven documentation behaviour.

Deliverables:
    - Full doc hierarchy
    - Update protocol
    - Formatting rules
    - Role-based responsibilities
    - Rules for adding new docs

Done When:
    - Doc structure is finalized
    - Update rules are unambiguous
    - All GPT roles have clear behavioural boundaries

Notes / Future:
    Prevents drift and maintains project consistency.


# ----------------------------------------
# P0.4 — GPT Behaviour & Ingestion Rules Finalization
# ----------------------------------------
ID: P0.4
Title: Finalize GPT Behaviour Standards & Ingestion Rules
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Consolidate and finalize how Architect, Implementer, and QA GPTs behave,
    load documents, request clarification, and interact with Andrew.

Context:
    Canonical rules exist across multiple documents; Phase 0 consolidates them.

Deliverables:
    - Unified GPT behaviour spec
    - Final ingestion rule
    - Document access/update rules
    - Feature card lifecycle rules

Done When:
    - Behaviour is fully defined in one authoritative form
    - Canon and TECH_SPEC reflect the unified rules

Notes / Future:
    Forms the backbone of all future GPT interactions.


# ----------------------------------------
# P0.5 — Canon Bootstrapping (Minimum Canon for Phase 1)
# ----------------------------------------
ID: P0.5
Title: Define Minimum Stable Canon for Entering Phase 1
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Freeze the Canon subset required for Phase 1 and classify all remaining
    sections as mutable or deferred.

Context:
    Canon is global and must remain stable for Phase 1 functionality.

Deliverables:
    - Frozen Canon subset
    - Mutable Canon list
    - Updated Canon sections

Done When:
    - Canon required for Phase 1 is finalized and stable
    - BUILD_CANON updated to mark frozen/mutable sections

Notes / Future:
    Future Canon expansions require explicit approval.


# ----------------------------------------
# P0.6 — Repository Root File Standards
# ----------------------------------------
ID: P0.6
Title: Define Repository Root File Standards
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Decide which files must exist at the repo root, which are optional, and
    which are forbidden.

Context:
    Canon and TECH_SPEC require structural consistency.

Deliverables:
    - Required root files list
    - Optional file rules
    - Forbidden file rules
    - Naming & placement standards

Done When:
    - Root-level file standards are finalized
    - TECH_SPEC updated accordingly

Notes / Future:
    Physical file creation occurs in Phase 1.


# ----------------------------------------
# P0.7 — Establish TECH_SPEC Foundations
# ----------------------------------------
ID: P0.7
Title: Establish TECH_SPEC Foundations (Structure & Update Flow)
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Define TECH_SPEC structure and governance before inserting technical
    decisions.

Context:
    TECH_SPEC is partially drafted and requires foundational structure.

Deliverables:
    - Full TECH_SPEC structure
    - Update rules
    - Cross-doc alignment rules
    - Conventions for section creation

Done When:
    - TECH_SPEC skeleton is finalized and ready for P0.1 decisions

Notes / Future:
    Prepares TECH_SPEC for Phase-0 technical baseline selections.


# ----------------------------------------
# P0.8 — Phase-0 Meta Issue Log System
# ----------------------------------------
ID: P0.8
Title: Establish Phase-0 Meta Issue Log System (P0.x tracking mechanism)
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Create the official mechanism for tracking P0.x meta items that emerge
    during Phase 0.

Context:
    Andrew wants numbered tracking entries like P0.10, P0.11, etc.

Deliverables:
    - Meta issue creation rules
    - Naming conventions
    - Workflow for converting meta issues into features
    - Resolution/deferral rules

Done When:
    - Meta system is fully documented and usable during Phase 0

Notes / Future:
    Prevents drift and centralizes Phase-0 questions.


# ----------------------------------------
# P0.9 — Phase-Transition Rules (Phase 0 → Phase 1)
# ----------------------------------------
ID: P0.9
Title: Define Phase-Transition Rules (Phase 0 → Phase 1)
Phase: 0
Engine/Plugin: none
Status: planned

Purpose:
    Establish explicit rules determining when Phase 0 is considered complete and
    how LillyCORE transitions into Phase 1.

Context:
    The Roadmap does not define transition mechanics; Canon requires clarity.

Deliverables:
    - Phase-0 completion checklist
    - Allowed deferrals
    - Transition procedure
    - Documentation of authority roles

Done When:
    - Transition checklist approved
    - All P0.x cards resolved, deferred, or closed
    - Architect signals readiness and Andrew confirms

Notes / Future:
    Sets the template for transitions in all future phases.
