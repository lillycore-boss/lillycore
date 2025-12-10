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

CARD_ID: P2
CARD_TITLE: AI Execution Layer – Pools and Safe Execution Envelopes

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P2
  - Slice: P2
  - Parent Card: none

DELIVERABLES_SERVED:
  - P2.D1 – Conversational AI Pool designed and implemented with backend adapter
  - P2.D2 – Deterministic/Lightweight AI Pool designed and implemented with backend adapter
  - P2.D3 – Worker/Back-end AI Pool designed and implemented with backend adapter
  - P2.D4 – Unified execution envelopes (request/response, retries, timeouts, error wrapping)
  - P2.D5 – Stable backend-agnostic AI API exposed to the rest of LillyCORE
  - P2.D6 – System preference/configuration entries governing pool selection and execution limits
  - P2.D7 – Documentation updates covering pool roles, contracts, execution behavior, and backend configuration

---
DESCRIPTION:
  Define and implement the first fully-functional, model-agnostic AI execution layer.
  Phase 2 introduces a strict abstraction boundary between LillyCORE and any LLM backend by
  defining AI pools (conversational, deterministic, worker) and the safe execution envelopes
  that wrap all LLM calls. This enables consistent AI behavior, backend swap capability,
  and foundational safety mechanisms for all future system features.

INPUTS / PRECONDITIONS:
  - Phase 1 runtime loop, logging system, and error envelope semantics.
  - Canon rules relating to execution safety, runtime integrity, and system identity.
  - TECH_SPEC sections on:
      - Repository layout
      - Tooling and environment constraints
      - Logging and error-handling rules
  - Knowledge of available local LLM backends (CLI, API, SDK, HTTP endpoints).
  - System preferences or global configuration patterns that influence:
      - Execution limits
      - Backend selection
      - Timeouts and retry strategies
  - Future-phase understanding of:
      - DRIFT engine (conversational behavior)
      - HELPER engine (worker/task semantics)
      - Execution topology planned for plugins and UX

STEPS:
  - Step 1: Analyze Phase 1 runtime loop and identify integration points where AI pools will attach.
  - Step 2: Define contracts/interfaces for three AI pools:
      - Conversational Pool
      - Deterministic/Lightweight Pool
      - Worker/Back-end Pool
    Specify required fields, methods, call patterns, and invariant guarantees.
  - Step 3: Design backend adapters capable of routing pool requests to an actual LLM backend, with:
      - Backend-agnostic abstraction layer
      - Ability to swap model/provider without modifying callers
  - Step 4: Design execution envelopes including:
      - Request/response schemas
      - Timeout and retry behavior
      - Structured error wrapping (Phase 1 envelope rules)
      - Logging of inputs/outputs/errors
      - Resource guardrails
  - Step 5: Establish the unified API surface that:
      - Receives system-level AI requests
      - Routes to the correct pool
      - Never exposes raw model/provider details to higher layers
  - Step 6: Determine system preferences/config entries controlling:
      - Which backend each pool uses
      - Default max tokens / timeout values
      - Safety thresholds
  - Step 7: Produce a complete set of Architect-decomposed P2.x cards for Implementer and QA, ensuring:
      - Each deliverable (P2.D1–P2.D7) is traceably implemented
      - No higher-level semantics (DRIFT/HELPER) leak into Phase 2
      - Safety constraints from Canon are preserved
      - Backend details remain encapsulated and swappable
  - Step 8: Identify unresolved architectural questions (if any) such as:
      - Multi-backend selection rules
      - Long-term concurrency strategy
      - Pool specialization evolution
    Encode these into additional P2.x cards rather than assumptions.

DONE_WHEN:
  - Full decomposition into P2.x cards is complete and covers all deliverables (P2.D1–P2.D7).
  - All three AI pools have clear documented interfaces and backend adapters.
  - Execution envelopes are fully defined (timeouts, retries, error wrapping, logging).
  - Unified AI API contract is documented and ready for implementation.
  - All design work respects:
      - Canon execution/safety rules
      - TECH_SPEC constraints
      - Phase 1 runtime conventions
  - No Phase 3+ responsibilities appear in the design (e.g., no persistence engine work).
  - At least one QA card exists to validate Phase 2 completion.
  - Documentation references and update points (Canon/TECH_SPEC) are catalogued.

DOCUMENTATION_UPDATES:
  - Canon:
      - May require additions for global AI execution invariants or safety guarantees.
      - Architect must propose updates via separate cards if modifications are required.
  - TECH_SPEC:
      - Must gain sections for:
          - AI pool architecture
          - Backend adapter structure
          - Execution envelopes
          - System AI configuration rules
      - Population of these sections is handled by Implementer P2.x cards.
  - FEATURES:
      - Must record P2.x implementation slices and their deliverables.
  - MODULES:
      - Add or refine notes regarding where AI pool code, adapters, and envelopes belong in the repo taxonomy.


CARD_ID: P3
CARD_TITLE: Durable Data & Document Layer – Unified Persistence Backbone

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P3
  - Slice: P3
  - Parent Card: none

DELIVERABLES_SERVED:
  - P3.D1 – Canonical data model skeleton covering all major future domains
  - P3.D2 – Selection and standardization of persistence technologies and schema conventions
  - P3.D3 – Initial working data layer implemented for:
        • Preferences/config
        • System/runtime state and tracking
        • Document storage foundations
  - P3.D4 – Document handler wired to the data layer
  - P3.D5 – Security/validation step for all data-layer writes
  - P3.D6 – Storage mappings (directories/tables) established for all in-scope data
  - P3.D7 – Documentation defining the data layer, boundaries, exceptions, and write rules

---
DESCRIPTION:
  Phase 3 creates LillyCORE’s unified, local-only persistence spine. This phase defines
  the canonical data model skeleton, chooses the core storage technologies, implements
  the initial data layer with full read/write control, and introduces the document handler
  that ensures structured documents pass through the persistence layer rather than bypassing it.
  The result is a consistent, secure, extensible system for recording state, preferences,
  documents, and future subsystem data.

INPUTS / PRECONDITIONS:
  - Phase 1 runtime:
      • Core loop
      • Logging
      • Error envelopes
      • Preference system
  - Phase 2 execution framework:
      • AI pool structures and backend configuration needs
  - Roadmap expectations regarding:
      • Notes plugin
      • Drift and Helper engines
      • Multi-user evolution
      • Plugin data models
  - Canon rules:
      • Privacy, safety, local-operation requirements
      • Structured behavior for persistent system identity
  - Existing data sources:
      • Preferences
      • Basic runtime markers
      • Initial logs and configuration outputs
  - Decisions needed:
      • Primary storage technology (structured files vs database)
      • Schema/directory/table conventions
      • Approved direct-write exceptions (logs, sandbox, future Drift tables)

STEPS:
  - Step 1: Define the canonical data model skeleton, covering:
      • Preferences/config
      • System/runtime state and tracking
      • Documents/notes
      • AI artifact indexing
      • Plugin and engine data domains (future placeholders included)
  - Step 2: Select and standardize persistence technologies that are:
      • Local-only
      • Offline-first
      • Long-term stable
      • Abstracted behind interfaces for future backend swaps
  - Step 3: Design the data layer module with:
      • Centralized read/write API
      • Internal mapping from conceptual entities → tables/directories/schemas
      • Uniform conventions for structured storage
  - Step 4: Implement initial persistence for:
      • Preferences and config state
      • Runtime/session tracking
      • Basic document storage
  - Step 5: Design and implement the document handler:
      • Reads/writes documents via data layer
      • Uses consistent formats, schemas, and directory/layout rules
  - Step 6: Define the security/validation step for all writes:
      • Structural validation
      • Type/schema checks
      • Suspicious-payload rejection behavior
      • Error surfacing rules
  - Step 7: Produce Architect-level decomposition into P3.x cards:
      • Data model skeleton card(s)
      • Persistence technology selection
      • Data layer API architecture
      • Document handler specification
      • Validation/security rules
      • Storage mapping specifications
      • Documentation update tasks
  - Step 8: Identify any unresolved architectural questions for escalation (e.g.,
      directory taxonomy refinements, schema evolution strategy, future multi-user structures).

DONE_WHEN:
  - Full decomposition into P3.x cards fully covers deliverables P3.D1–P3.D7.
  - Canonical data model skeleton is documented and complete.
  - Persistence technology decisions are specified and justified.
  - Data layer architecture is fully defined and ready for Implementer execution.
  - Document handler behaviors, formats, and directory/table mappings are documented.
  - Security/validation rules for writes are complete and consistent with Canon safety.
  - No out-of-scope features (multi-user logic, Drift personal tables, plugin logic) are implemented.
  - QA card for validating Phase 3 exists and references all required outcomes.

DOCUMENTATION_UPDATES:
  - Canon:
      • May require updates for persistence security, privacy, and invariants.
      • All updates must be proposed through dedicated cards.
  - TECH_SPEC:
      • Must gain sections for:
          - Storage technology selection
          - Schema/directory conventions
          - Data layer API specification
          - Document handler rules
          - Validation/security details
  - FEATURES:
      • Must record P3.x implementer and QA tasks, ensuring traceability.
  - MODULES:
      • Must reflect correct placement of data layer, document handler, schemas, and mapping files.

CARD_ID: P4
CARD_TITLE: Notes Plugin V0 – Minimal Plugin & Memory-Flow Testbed

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P4
  - Slice: P4
  - Parent Card: none

DELIVERABLES_SERVED:
  - P4.D1 – Definition of minimal Notes Plugin V0 interface and responsibilities
  - P4.D2 – Processing path capable of generating dummy/basic summaries
  - P4.D3 – Accumulation and persistence rules for plugin outputs
  - P4.D4 – User output folder definition + naming/organization conventions
  - P4.D5 – Integration rules between Notes Plugin and:
        • Data/document layer (system-owned content)
        • User-output write path (user-owned artifacts)
        • Runtime/logging visibility
  - P4.D6 – Minimal invocation harness for running the plugin
  - P4.D7 – Documentation describing plugin role, limits, and how future phases will use it

---
DESCRIPTION:
  Phase 4 introduces LillyCORE’s first plugin-like subsystem: Notes Plugin V0.
  It is intentionally minimal and serves as a safe “lab bench” for exercising the
  memory flow established in earlier phases. The plugin accepts transcript-like content,
  produces basic or dummy summaries, stores system-visible artifacts through the data layer,
  and emits user-facing output files in a designated user-output folder.
  
  This milestone creates a complete, low-risk end-to-end test of:
    • Data/document layer integration
    • Plugin boundaries and storage rules
    • Runtime/logging visibility
    • Simple processing workflows that will later evolve

INPUTS / PRECONDITIONS:
  - Phase 1:
      • Runtime loop
      • Logging and error envelopes
      • Preference system
  - Phase 2:
      • AI pools and execution framework (used minimally or stably stubbed)
  - Phase 3:
      • Durable data/document layer
      • Any System DOC structures already defined
  - Canon rules for:
      • Plugin boundaries and system-vs-user data separation
      • User output vs internal persistent storage
      • Disk-write constraints and allowed bypasses
  - Information required:
      • Location of user-visible output directory
      • Metadata structure for traceability (timestamps, source IDs, run IDs)
      • Expectations for minimal transcript/notes behavior at this stage

STEPS:
  - Step 1: Define minimal Notes Plugin V0 interface:
      • Input format (transcript-like content)
      • Output structure (summary or dummy summary)
      • Plugin metadata requirements (timestamps, IDs)
  - Step 2: Specify the processing path:
      • Accept input
      • Generate summary/dummy output
      • Store a persistent “note” version through the data/document layer
  - Step 3: Define rules for accumulating plugin outputs:
      • Naming conventions
      • Storage paths and organization
      • Linking outputs to sessions/inputs
  - Step 4: Create user output folder conventions:
      • Directory name
      • File formats (text/markdown)
      • Naming rules for user-visible artifacts
  - Step 5: Specify integration rules:
      • All system-owned data must go through the data/document layer
      • Only user-output files may bypass it
      • Runtime/logging must record plugin operations
  - Step 6: Define a minimal invocation harness:
      • Simple developer-oriented or runtime hook
      • Does not require Plugin Engine (future phase)
  - Step 7: Architect-level decomposition into P4.x cards:
      • V0 interface and processing pipeline specification
      • User-output folder definition
      • Integration with data layer
      • Logging/runtime wiring
      • Testing harness specification
      • Documentation updates
  - Step 8: Identify unresolved questions to escalate:
      • How transcripts should be represented in future phases
      • Whether early heuristic summarization should exist now or remain dummy
      • Metadata expansion rules for future plugin versions

DONE_WHEN:
  - Full decomposition into P4.x cards covers deliverables P4.D1–P4.D7.
  - Minimal but functional plugin definition is complete.
  - User output folder rules are documented and unambiguous.
  - Rules for accumulating and storing notes are finalized.
  - All write-path rules follow Phase 3 data/document conventions.
  - Runtime/logging integration requirements are defined.
  - No advanced DRIFT/HELPER or semantic querying logic appears.
  - QA card for Phase 4 exists and correctly references all required outcomes.

DOCUMENTATION_UPDATES:
  - Canon:
      • Plugin-boundary rules may require additions
      • User-output vs system-owned data distinctions documented
  - TECH_SPEC:
      • File/output conventions
      • Plugin storage mappings
      • Notes Plugin integration with runtime/logging
  - FEATURES:
      • P4.x implementer and QA cards recorded
  - MODULES:
      • Placement of Notes Plugin directory and integration mapping defined

CARD_ID: P5
CARD_TITLE: DRIFT Engine MVP – Context, Emotion, Perception Layer

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P5
  - Slice: P5
  - Parent Card: none

DELIVERABLES_SERVED:
  - P5.D1 – Structured perceptual parsing model (emotional metadata, context classification, memory extraction)
  - P5.D2 – Ephemeral-context engine specification and update rules
  - P5.D3 – Long-term personal-memory structures and schemas
  - P5.D4 – DRIFT-specific storage region (“personal tables”) and multi-user layout
  - P5.D5 – Real-time update pipeline integrating DRIFT into the runtime loop
  - P5.D6 – DRIFT → HELPER (Phase 6) structured handoff schema
  - P5.D7 – Documentation of emotional scales, classification rules, schema definitions, boundaries, lifecycle expectations

---
DESCRIPTION:
  Phase 5 introduces LillyCORE’s first perceptual engine: DRIFT MVP.  
  DRIFT transforms raw user input into structured emotional metadata, short-term context,
  and long-term personal memory. It establishes the perceptual backbone that the HELPER
  Engine (Phase 6) will rely on for reasoning, workflow extraction, and personalized behavior.

  DRIFT performs:
    • Emotional interpretation
    • Work/personal/ephemeral classification
    • Extraction of personal-memory candidates
    • Maintenance of an ephemeral “rolling context window”
    • Maintenance of long-term personal memory entries
    • Real-time updates per incoming message
    • Delivery of a structured perceptual payload to downstream systems

  DRIFT’s storage must remain isolated from system-level data and plugin layers.  
  DRIFT owns all personal/emotional/perceptual memory.

INPUTS / PRECONDITIONS:
  - From Phase 1:
      • Runtime loop
      • Logging/error envelopes
  - From Phase 2:
      • AI pools and extraction wrappers (optional but available)
  - From Phase 3:
      • Durable data/document layer
      • Schemas and write-path rules needed for DRIFT tables/folders
  - From Phase 4:
      • Notes Plugin V0 (for validating memory-flow interactions)
  - From Canon/architecture:
      • Emotional-weight semantics
      • Personal memory entry structure
      • Rules for personal vs ephemeral vs system-level data boundaries
      • Classification meaning and downstream expectations
  - Required decisions:
      • Emotional scale definitions (valence, intensity, tone range)
      • Criteria for personal-memory entry acceptance
      • Folder/table layout for multi-user future support

STEPS:
  - Step 1: Define structured perceptual parsing:
      • Emotional metadata model
      • Input classification (work/personal/ephemeral)
      • Entity + personal-memory extraction specification
  - Step 2: Design ephemeral context engine:
      • Rolling-window update rules
      • Mini-summaries and short-term tone tracking
      • Message-by-message update workflow
  - Step 3: Design long-term personal-memory subsystem:
      • Stable identity traits
      • Persistent facts (relationships, preferences)
      • Social/interaction metadata
      • Storage schemas and indexing rules
  - Step 4: Specify DRIFT storage region:
      • Personal-memory tables/folders
      • Ephemeral-context tables/folders
      • Multi-user structure (user/UID namespacing)
  - Step 5: Integrate DRIFT into runtime:
      • User message → DRIFT parsing
      • DRIFT output → downstream consumption
      • Logging/error handling through Phase 1 infrastructure
  - Step 6: Define DRIFT→HELPER handoff schema:
      • Emotional metadata structure
      • Extracted entities
      • Memory candidates
      • Thread-level ephemeral summaries
  - Step 7: Architect decomposition into P5.x cards:
      • Perceptual model definition
      • Ephemeral engine specification
      • Long-term memory model + schemas
      • Storage folder/table implementation spec
      • Runtime integration mapping
      • Handoff schema spec
      • Documentation updates
  - Step 8: Identify unresolved architectural questions:
      • Whether personal-memory degradation should begin here or later
      • Handling conflicting emotional signals
      • Granularity of ephemeral summaries

DONE_WHEN:
  - DRIFT MVP design fully decomposed into P5.x cards covering P5.D1–P5.D7.
  - Emotional metadata, classification rules, memory extraction, and update behaviors are defined.
  - Ephemeral-context model and long-term personal-memory schemas are stable.
  - DRIFT-specific storage region is documented, isolated, and aligned with Phase 3 conventions.
  - DRIFT→HELPER handoff structure is finalized.
  - Runtime integration requirements are clear, complete, and testable.
  - No HELPER or advanced DRIFT-lifecycle features included prematurely.
  - QA card for Phase 5 exists and references all required outcomes.

DOCUMENTATION_UPDATES:
  - Canon:
      • Emotional semantics
      • Personal vs ephemeral vs system-state distinctions
      • DRIFT storage boundaries and guarantees
  - TECH_SPEC:
      • DRIFT storage mappings and schema layout
      • Perceptual pipeline integration in runtime stack
  - FEATURES:
      • P5.x implementer and QA cards added
  - MODULES:
      • DRIFT Engine module location and data-region placement established

CARD_ID: P6
CARD_TITLE: HELPER Engine MVP – Work Orchestration Layer

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P6
  - Slice: P6
  - Parent Card: none

DELIVERABLES_SERVED:
  - P6.D1 – HELPER_ENGINE MVP architecture and orchestration model
  - P6.D2 – Internal work packet specification (request → result)
  - P6.D3 – Task-reasoning and decomposition framework for MVP
  - P6.D4 – AI_POOL routing rules and backend selection logic
  - P6.D5 – HELPER → SYSTEM_DOC storage mapping for events + results
  - P6.D6 – End-to-end integration path (DRIFT → HELPER → output)
  - P6.D7 – Documentation for HELPER boundaries, responsibilities, and packet APIs

---
DESCRIPTION:
  Phase 6 introduces LillyCORE’s first fully functional work engine: HELPER_ENGINE MVP.
  HELPER converts DRIFT’s structured perception into actionable tasks, executes them through
  AI_POOLS, and returns structured result packets for downstream consumption.

  HELPER does NOT generate user-facing messages.  
  Its outputs are backend-only and become inputs for future conversational layers.

  HELPER performs:
    • Work-package interpretation (intent → task modes)
    • Task reasoning and decomposition into primitives
    • AI backend selection through AI_POOLS
    • Managed execution with timeouts, retries, envelopes
    • Logging + structured work-event persistence
    • Return of a unified work-result packet

  Phase 6 also establishes the canonical internal packet format that all future engines and plugins will rely on.

INPUTS / PRECONDITIONS:
  - From roadmap:
      • HELPER defined as LillyCORE’s “worker brain”
  - From PROJECT_CANON:
      • Engine/plugin boundaries and ontological rules
      • Pipeline structure expectations
  - From MODULES:
      • HELPER_ENGINE responsibilities, dependencies
      • DRIFT_ENGINE output semantics
      • NOTES_PLUGIN testbed usage
  - From earlier phases:
      • Phase 1 runtime loop, logging, prefs
      • Phase 2 AI_POOLS + execution envelopes
      • Phase 3 SYSTEM_DOC integrations for persistent logs/results
      • Phase 4 Notes Plugin V0 as test surface
      • Phase 5 DRIFT structured perception (WorkPackage + ContextBundle)
  - Required decisions:
      • MVP task modes (analysis, transformation, generation, lookup, etc.)
      • Inline vs file-backed result patterns
      • Work-event logging and retention granularity

STEPS:
  - Step 1: Define HELPER_ENGINE architecture:
      • Entry points
      • Routing logic
      • MVP task-mode catalog
      • Internal data structures
  - Step 2: Define the internal work packet format:
      • Required/optional fields
      • Origin + context + metadata
      • Result payload fields
      • Error and completion structures
      • Versioning rules
  - Step 3: Design task reasoning + decomposition:
      • Interpret DRIFT WorkPackage
      • Identify primitive tasks
      • Build execution sequences
      • Pool-selection logic
  - Step 4: Define execution pipeline:
      • AI_POOL invocation path
      • Timeout/retry rules
      • Envelope wrapping
      • Logging hooks
  - Step 5: Define SYSTEM_DOC integration:
      • Work-event persistence model
      • Result-storage mapping
      • Inspection/debugging needs
  - Step 6: Define end-to-end test path:
      • DRIFT → HELPER invocation
      • Notes Plugin V0 as consumer
      • CLI-based workflows
  - Step 7: Architect P6.x implementer cards for:
      • Work packet spec
      • Reasoning/decomposition logic
      • Routing and execution engine
      • SYSTEM_DOC write-paths
      • Test harness integration
      • Documentation deliverables
  - Step 8: Identify open architectural questions:
      • Priority/queue semantics for future phases
      • Multi-task parallelism expectations
      • How much of HELPER’s future inference logic belongs in MVP

DONE_WHEN:
  - HELPER MVP architecture fully decomposed into P6.x cards.
  - Work-packet spec is complete, stable, and documented.
  - Reasoning/decomposition model for MVP finalized.
  - AI_POOL routing rules and execution flow fully defined.
  - SYSTEM_DOC storage mappings complete and aligned with Phase 3.
  - End-to-end integration path (DRIFT → HELPER → output) validated.
  - Documentation on HELPER boundaries, responsibilities, and APIs prepared.
  - QA card for Phase 6 created and references P6.D1–P6.D7.

DOCUMENTATION_UPDATES:
  - Canon:
      • Engine roles and boundaries
      • Work packet ontology
  - TECH_SPEC:
      • HELPER module location + routing rules
      • AI_POOL invocation constraints and safety
  - FEATURES:
      • P6.x implementer + QA cards
  - MODULES:
      • HELPER module entry + responsibilities finalized


CARD_ID: P7
CARD_TITLE: Plugin Engine MVP – Safe Modular Expansion Layer

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P7
  - Slice: P7
  - Parent Card: none

DELIVERABLES_SERVED:
  - P7.D1 – Plugin Engine architecture + boundaries
  - P7.D2 – Plugin manifest schema + plugin folder specification
  - P7.D3 – Plugin discovery, registration, validation model
  - P7.D4 – Plugin sandbox execution model
  - P7.D5 – Plugin packet-routing rules (user-initiated + system-initiated)
  - P7.D6 – Plugin result validation + SYSTEM_DOC logging
  - P7.D7 – End-to-end Plugin Engine integration path
  - P7.D8 – Documentation set covering manifests, packets, sandboxing

---
DESCRIPTION:
  Phase 7 introduces the Plugin Engine—a high-boundary, controlled expansion mechanism
  allowing LillyCORE to grow safely through modular, folder-based plugins.

  Plugins are treated as black boxes.  
  All communication occurs through validated packets.  
  No plugin can bypass engine boundaries or touch internal subsystems directly.

  Plugin Engine MVP provides:
    • Plugin discovery (folder-as-plugin)
    • Manifest validation + safety review
    • Capability registration
    • Structured packet-based execution
    • Full sandboxing with restricted I/O
    • Strict output validation
    • Logging + metadata persistence via SYSTEM_DOC

  Two packet types are supported:
    • User-initiated (DRIFT → HELPER → Plugin Engine)
    • System-initiated (backend tasks delegated by HELPER or engines)

  This becomes the foundation for all future extensibility—UX plugins, reasoning plugins,
  data plugins, and system automation scripts.

INPUTS / PRECONDITIONS:
  - From prior phases:
      • P1: Runtime, logging, preferences
      • P2: AI_POOLS for manifest checking and validation
      • P3: SYSTEM_DOC for plugin metadata and logs
      • P4: Notes Plugin as minimal testbed
      • P5: DRIFT structured input (context + emotional metadata)
      • P6: HELPER work engine + packet format
  - From Canon + MODULES:
      • Engine boundaries
      • Plugin ontology
      • Safety/permission rules
  - Required decisions:
      • Manifest schema (version, capabilities, permissions)
      • Allowed plugin operations
      • Plugin output directory rules
      • Required return fields for packets

STEPS:
  - Step 1: Architect Plugin Engine core:
      • Entry points and routing model
      • Folder-discovery rules and scanning intervals
      • Plugin lifecycle (load → validate → register → execute)
  - Step 2: Define plugin manifest standard:
      • Required fields (name, version, capabilities, permissions)
      • Safety declarations
      • Entrypoint definitions
      • Optional metadata patterns
  - Step 3: Architect plugin sandbox:
      • Execution boundaries
      • Allowed vs forbidden operations
      • Output directory isolation
      • Output validation protocol
  - Step 4: Architect packet routing:
      • User-initiated → DRIFT → HELPER → Plugin Engine
      • System-initiated → HELPER → Plugin Engine
      • Packet-to-plugin capability matching
      • Error packet generation
  - Step 5: Architect plugin registry:
      • Capability index
      • Plugin availability signals
      • Version and compatibility management
  - Step 6: Architect SYSTEM_DOC integration:
      • Plugin activity logs
      • Manifest storage
      • Execution results + metadata persistence
  - Step 7: Architect end-to-end test path:
      • Use Notes Plugin V0 or dummy plugin
      • Verify routing + sandboxing + output validation
      • Validate logs and registry state
  - Step 8: Identify open questions for P7.x implementation cards:
      • Hot-reload behavior
      • Plugin upgrade rules
      • UI plugin permissions (future phase)
      • Rich capability negotiation

DONE_WHEN:
  - Plugin Engine architecture fully decomposed into P7.x implementer cards.
  - Manifest + folder specification finalized and documented.
  - Sandbox boundaries defined and vetted.
  - Packet routing rules fully aligned with HELPER packet spec.
  - Plugin registry architecture stable.
  - SYSTEM_DOC integration requirements complete.
  - End-to-end test plan and pipeline defined.
  - Complete documentation set prepared for implementers + QA.

DOCUMENTATION_UPDATES:
  - Canon:
      • Engine/plugin boundary definitions
      • Plugin ontology rules
  - TECH_SPEC:
      • Plugin Engine runtime integration
      • Manifest schema + sandbox constraints
      • Plugin directory structure
  - FEATURES:
      • P7.x implementer + QA cards
  - MODULES:
      • Plugin Engine entry, responsibilities, and contract definitions


CARD_ID: P8
CARD_TITLE: Stability Spine — HELP_DESK, DREAM, SCRIPT (Maintenance & Self-Repair Layer)

EXECUTOR_ROLE: Architect

PHASE_CONTEXT:
  - Phase: P8
  - Slice: P8
  - Parent Card: none

DELIVERABLES_SERVED:
  - P8.D1 – Architecture for HELP_DESK_ENGINE (auto-repair + escalation)
  - P8.D2 – Architecture for DREAM_ENGINE (memory degradation + DOC compression)
  - P8.D3 – Architecture for SCRIPT_ENGINE (procedural optimization + regeneration)
  - P8.D4 – Unified Stability Spine framework (packet formats, diagnostics, recovery)
  - P8.D5 – Snapshot + integrity verification + restoration protocols
  - P8.D6 – Maintenance cycle schedule (idle, shutdown, crash, timed)
  - P8.D7 – System boundaries between stability engines and operational engines
  - P8.D8 – Documentation covering full stability lifecycle and responsibilities

---
DESCRIPTION:
  Phase 8 establishes the Stability Spine: the internal maintenance, self-repair, and 
  long-term refinement layer that ensures LillyCORE remains reliable, healthy, and 
  recoverable indefinitely.

  This phase architects three major subsystems:
    • HELP_DESK_ENGINE – first responder, automatic repair, escalation logic
    • DREAM_ENGINE – long-term optimization, memory degradation, DOC compression
    • SCRIPT_ENGINE – maintenance and regeneration of procedural scripts

  The Spine introduces:
    • Daily snapshots
    • Integrity checks and correction
    • Recovery protocols for pipeline crashes
    • Shared diagnostic data and packet formats
    • Scheduled maintenance cycles

  After Phase 8, LillyCORE becomes a self-governing system capable of correcting drift, 
  healing failures, optimizing itself, and sustaining long-term growth with minimal 
  developer intervention.

INPUTS / PRECONDITIONS:
  - From prior phases:
      • DRIFT_ENGINE MVP (perception data; emotional escalation signals)
      • HELPER_ENGINE MVP (work decomposition + error contexts)
      • SYSTEM_DOC (canonical schemas, durable storage foundations)
      • Plugin Engine MVP (routing, capability registration)
      • Packet standardization from P1–P7
      • Snapshot + filesystem infrastructure from P3
  - Required knowledge:
      • Error classification rules (recoverable vs fatal)
      • Memory degradation policies
      • Script regeneration boundaries
  - Required decisions:
      • Snapshot schedule + retention rules
      • Integrity-check conditions and thresholds
      • Escalation rules for HELP_DESK
      • Validation steps for destructive operations

STEPS:
  - Step 1: Architect HELP_DESK_ENGINE:
      • Auto-repair pathways (worker → decomposition → root recovery)
      • Failure pattern detection + root-cause analysis
      • Escalation rules requiring user confirmation
      • Error-envelope integration
  - Step 2: Architect DREAM_ENGINE:
      • Memory degradation (safe delete, compress, reorganize)
      • DOC consolidation + historical log compaction
      • Structural reasoning passes for topology improvement
      • Tiered optimization governance (auto / batch / user-confirmed)
  - Step 3: Architect SCRIPT_ENGINE:
      • Script extraction, analysis, rewriting, and regeneration
      • Sandbox validation before activation
      • Versioning + diff metadata
      • Strict boundaries (cannot modify runtime engines)
  - Step 4: Architect unified Stability Spine:
      • Shared packet structures
      • Shared diagnostic tables + recovery metadata
      • Cross-engine signaling pathways
      • Reporting interfaces for CORE + SYSTEM_DOC
  - Step 5: Architect snapshot + recovery model:
      • Daily snapshots
      • Crash-triggered snapshots
      • Shutdown-cycle maintenance checks
      • Full restoration algorithm
  - Step 6: Architect maintenance cycle schedule:
      • Idle maintenance cycles
      • 24-hour forced maintenance cycles
      • Recovery cycles after HELP_DESK intervention
  - Step 7: Architect stability boundaries:
      • DRIFT personal data isolation
      • HELPER operational data isolation
      • Plugin boundary restrictions
      • Stability engines may not modify plugin code
  - Step 8: Identify P8.x implementer cards needed:
      • One per engine (HELP_DESK, DREAM, SCRIPT)
      • One for unified packet spec
      • One for snapshot system
      • One for recovery procedures
      • One for maintenance scheduler
      • One for stability/operational boundaries

DONE_WHEN:
  - Architecture for all three stability engines is complete and internally consistent.
  - Unified stability packet formats and diagnostic schemes are defined.
  - Snapshot, integrity verification, and restoration protocols are finalized.
  - Maintenance cycle schedule documented and approved.
  - Boundaries between stability engines, operational engines, and plugins are fully specified.
  - P8.x implementer cards generated and validated against Canon + TECH_SPEC.
  - Documentation updated across Canon, TECH_SPEC, MODULES, and FEATURES.

DOCUMENTATION_UPDATES:
  - Canon:
      • Stability engine ontology
      • Rules for self-repair, degradation, and script regeneration
      • Escalation + destructive-op validation rules
  - TECH_SPEC:
      • Snapshot system spec
      • Integrity checks
      • Stability packet formats
      • Engine boundaries (stability vs operational)
  - FEATURES:
      • P8.x implementer + QA cards
  - MODULES:
      • HELP_DESK, DREAM, SCRIPT engine definitions + contracts


