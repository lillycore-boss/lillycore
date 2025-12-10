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


CARD_ID: P1
CARD_TITLE: Core Loop, Logging, and User Preferences – Phase 1 Milestone

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P1
  - Slice: P1
  - Parent Card: none

DELIVERABLES_SERVED:
  - P1.D1 – Functional core runtime loop capable of continuous operation
  - P1.D2 – Unified logging system with documented entry points and formatting rules
  - P1.D3 – Implemented error envelope schema integrated into runtime and logging
  - P1.D4 – Operational system preference loader with persistence and override capability
  - P1.D5 – AI pool structural definitions (types, fields, relationships) defined and documented
  - P1.D6 – Initial project infrastructure implemented (repo, config files, CI, tooling, developer automation)

---
DESCRIPTION:
  Establish LillyCORE’s first functional runtime layer by introducing a stable execution loop, unified logging behaviour, structured error handling, and a minimal but extensible preference system. This card defines the overall goals and boundaries for Phase 1 and instructs the Architect to design a full set of P1.x cards that implement the runtime, logging, error envelopes, preference loader, AI pool structures, and the initial infrastructure setup defined in Phase 0.

INPUTS / PRECONDITIONS:
  - Completed Phase 0 foundations, including:
    - Documentation structures and governance (P0.2, P0.3, P0.7)
    - GPT behaviour and ingestion rules (P0.4)
    - Minimum stable Canon subset for Phase 1 (P0.5)
    - Repository taxonomy and naming standards (P0.2)
    - Root-level file rules (P0.6)
  - Roadmap definition for Phase 1 (Core Loop, Logging, User Preferences)
  - Relevant Canon rules governing:
    - Runtime behaviour
    - Identity persistence
    - System integrity / invariants
  - TECH_SPEC sections covering:
    - Repository layout and folder taxonomy
    - Logging and error-handling baseline expectations
    - Tooling and infrastructure decisions from P0.1
  - Decisions required or partially defined:
    - Preference persistence mechanism (file, object, or other)
    - Logging channels (console, file, structured output)
    - Error envelope schema details (fields, severity levels, propagation rules)

STEPS:
  - Step 1: Review all relevant Phase 0 outputs (Canon, TECH_SPEC, documentation governance, repo taxonomy, GPT behaviour rules) and the Phase 1 roadmap text to confirm constraints, dependencies, and expectations for the first runtime layer.
  - Step 2: Define or refine the Phase 1 deliverables list (P1.D1–P1.D6) as the authoritative “done when” targets for the core loop, logging, error envelopes, preferences, AI pool structures, and infrastructure setup.
  - Step 3: Design a decomposition plan for Phase 1 into P1.x Architect and Implementer cards:
      - Separate runtime loop design vs implementation work.
      - Separate logging schema and integration points.
      - Separate error envelope format design vs wiring into the loop.
      - Separate preference loader design vs storage/persistence details.
      - Separate AI pool structural definitions (no execution yet).
      - Separate infrastructure setup (repo, config files, CI, pre-commit, dev automation).
  - Step 4: Encode all required constraints into the P1.x cards, including:
      - No AI execution, scheduling, or chaining (AI pools are structural only).
      - No module-level functionality beyond what runtime, logging, and prefs require.
      - No Phase 2/3/4 architectural decisions leaked into Phase 1.
      - Alignment with Phase 0 standards and documentation conventions.
  - Step 5: Explicitly design the “infrastructure setup” slice so that Implementer cards:
      - Detect if repo/CI/tooling already exist.
      - Validate configuration against TECH_SPEC and Canon.
      - Fix or create missing pieces as needed.
  - Step 6: Produce a QA-ready P1.x card bundle that:
      - Covers all P1.D1–P1.D6 deliverables.
      - Includes at least one final QA card for Phase 1.
      - Keeps each card non-trivial but bounded in scope.
      - Respects card-count and decomposition rules from Architect behaviour spec.
  - Step 7: Identify and document any open questions or risks (e.g., preference storage tradeoffs, logging backend options) that require Andrew’s decision, and encode them into targeted Architect/Implementer cards rather than leaving them implicit.

DONE_WHEN:
  - A complete set of P1.x cards exist in the new universal format, covering:
    - Core runtime loop behaviour and implementation.
    - Unified logging design and wiring.
    - Error envelope schema and integration.
    - System preference loader design and implementation.
    - AI pool structural definitions (no execution yet).
    - Initial infrastructure setup (repo, CI, pre-commit/tooling, developer automation).
  - Each P1.x card is clearly assigned to Architect, Implementer, or QA, with:
    - Explicit inputs and preconditions.
    - Clear steps and DONE_WHEN criteria.
    - Correct linkage to P1.D1–P1.D6 deliverables.
  - Constraints from Phase 0 (Canon, TECH_SPEC, documentation governance, repo taxonomy, GPT behaviour) are explicitly reflected in the P1.x cards.
  - There is at least one QA card at the end of the P1 bundle to validate Phase 1’s deliverables.
  - No Phase 2+ responsibilities are silently embedded into Phase 1 cards.

DOCUMENTATION_UPDATES:
  - Canon:
      - None directly from this milestone card.
      - Architect must flag any Canon updates discovered during decomposition as separate Architect cards (e.g., runtime invariants, error-handling philosophy, identity persistence rules).
  - TECH_SPEC:
      - Identify required sections for later Implementer updates:
        - Runtime loop architecture and contracts.
        - Logging schema, channels, and usage patterns.
        - Error envelope structure and semantics.
        - Preference storage format and loading behaviour.
        - Infrastructure and CI expectations (repo, tools, hooks).
      - These updates will be executed by Implementer P1.x cards, not by this card directly.
  - FEATURES:
      - Ensure that P1.x cards and their relationship to P1.D1–P1.D6 are documented or mirrored as needed.
  - MODULES:
      - Add or refine high-level notes indicating how runtime, logging, preferences, and AI pools relate to core/ and engines/ layout if required by P1.x decomposition.

