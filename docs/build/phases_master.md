CARD_ID: P0
CARD_TITLE: Phase 0 — Foundations & Tooling

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P0
  - Slice: P0
  - Parent Card: None

DELIVERABLES_SERVED:
  - Roadmap.Phase0 – Foundations & Tooling milestone
  - Establish foundational environment, standards, and documentation structures for all later phases

---
DESCRIPTION:
  Phase 0 establishes the foundational environment, standards, and documentation structures
  required for all subsequent phases of LillyCORE. Before any functional architecture or
  implementation begins, the project must have a coherent, stable, and uniform base that
  both GPTs and humans can operate within reliably.

  This phase defines:
  - Documentation structures, formats, and ingestion rules GPTs must follow.
  - Technical standards required to begin programming (tooling, Python version, linters/formatters,
    testing baseline, etc.).
  - The core repository organization at a conceptual level (folder taxonomy, naming conventions,
    doc layout).
  - The minimal PROJECT_CANON foundations required to begin Phase 1 cleanly.
  - How standards, docs, and canon will be maintained and updated as the system evolves.
  - The workspace preparation required for consistent execution, even if some folders or tooling
    are only defined conceptually here and created later.

  Purpose:
  - Establish the foundational environment, standards, and documentation structures required for
    all subsequent phases of LillyCORE.

  Scope:
  - Define documentation structures, formats, and ingestion rules GPTs must follow.
  - Establish technical standards necessary to begin programming.
  - Create or finalize core repository organization at the conceptual level.
  - Define minimal PROJECT_CANON foundations required for a clean Phase 1 start.
  - Establish maintenance and update rules for standards and docs.
  - Ensure the workspace is prepared for consistent execution.

  System Impact:
  - Introduces the rules that govern all future architecture, implementation, and documentation behaviour.
  - Establishes the initial documentation and canon anchors that future phases depend upon.
  - Creates the baseline technical environment which all future code and modules will assume.
  - Bootstraps the system so it can support structured feature cards, milestones, modules, and
    implementation patterns in later phases.

  Constraints:
  - Phase 0 introduces no system functionality beyond documentation, standards, and foundational constructs.
  - All definitions must remain high-level, avoiding premature architecture or implementation decisions.
  - No module, engine, or functional code may be designed or implemented beyond establishing the environment
    in which they will later exist.
  - All documentation and standards must be maintainable by GPTs and align with PROJECT_CANON and
    GPT_RESOURCE_INDEX.
  - Phase 0 outputs must not conflict with later roadmap phases; they act as prerequisites, not prescriptive architecture.

  Notes:
  - Phase 0 is intentionally minimal in system “behavior” but maximal in importance.
  - All later phases assume its rules and structures exist.
  - This phase acts as the initiator for the entire system lifecycle — every new phase begins from
    the standards and canon established here.
  - Some items may be defined conceptually in Phase 0 but only materially created during early
    implementation phases; the job here is to define them clearly enough for consistent execution.

INPUTS / PRECONDITIONS:
  - Roadmap definitions indicating the role and boundaries of Phase 0.
  - PROJECT_CANON where it relates to system-wide rules and philosophy (minimal subset required to start).
  - Existing repository or workspace conditions to be normalized.
  - Decisions on tooling requirements (Python version, formatter, linter, testing framework,
    documentation format rules, etc.).
  - Documentation format structures needed for GPT comprehension and update consistency.

STEPS:
  - Step 1: Capture the conceptual definition of Phase 0 from Roadmap + milestone descriptions.
  - Step 2: Normalize the Phase 0 definition into this canonical card format.
  - Step 3: Ensure Phase 0 scope and constraints are aligned with PROJECT_CANON.
  - Step 4: Confirm that Phase 0 provides enough structure for Phase 1 to begin without ambiguity.

DONE_WHEN:
  - A clear, normalized Phase 0 definition exists in this card format.
  - The foundational environment, documentation structures, and constraints are fully described.
  - The definition is sufficient for GPTs and humans to begin Phase 1 work without ambiguity.
  - Phase 0 does not conflict with any later roadmap phases.

DOCUMENTATION_UPDATES:
  - Canon: Reference Phase 0 as the origin of foundational standards (optional summary).
  - TECH_SPEC: Capture any Phase-0-specific technical environment standards (tooling, language version, etc.).
  - FEATURES: None (Phase 0 is infrastructural, not feature-based).
  - MODULES: None (no functional modules in Phase 0).
