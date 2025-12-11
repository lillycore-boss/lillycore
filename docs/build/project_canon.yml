# docs/registry/project_canon.yml

version: "1.0"

blocks:
  # --------------------------------
  # Overview / file meta
  # --------------------------------
  - id: project_canon.overview
    kind: overview
    name: PROJECT_CANON
    applies_to: [architect, implementer, qa]
    tags: [canon, philosophy, ontology]
    md: |
      # PROJECT_CANON

      **FILE:** PROJECT_CANON  
      **ROLE:** Core philosophy, rules, ontology, and planning discipline  
      **VERSION:** v1.0 (Engines/Plugins terminology update)

      > NOTE:
      >   Detailed GPT behavioural rules and documentation-governance procedures
      >   now live in GPT_BEHAVIOUR_SPEC, DOCUMENTATION_PROTOCOL, and
      >   DOCUMENTATION_GOVERNANCE. PROJECT_CANON focuses on LillyCORE’s
      >   philosophy, ontology, and planning discipline.

  # --------------------------------
  # Section 1 – Philosophy & Authority
  # --------------------------------
  - id: project_canon.philosophy_and_authority
    kind: philosophy
    applies_to: [architect, implementer, qa]
    tags: [philosophy, authority, prime_directive]
    md: |
      # ========================================
      # SECTION 1 — PHILOSOPHY & AUTHORITY
      # ========================================
      LillyCORE is a modular, evolving AI system.
      Its rules, definitions, and meaning come from Andrew only.

      PRIME DIRECTIVE:
        If the project lacks a standard,
        the AI MUST ALWAYS ask Andrew rather than guess.

      This rule overrides all others — including convenience.

      Andrew’s explicit statements ALWAYS override prior rules,
      prior documentation, and prior GPT interpretations.
      No subsystem, GPT, module, or engine may reinterpret or soften this.

  # --------------------------------
  # Section 2 – Global AI Behaviour Rules
  # --------------------------------
  - id: project_canon.global_ai_behaviour_rules
    kind: behaviour_rules
    applies_to: [architect, implementer, qa]
    tags: [behaviour, no_assumptions, user_intent]
    md: |
      # ========================================
      # SECTION 2 — GLOBAL AI BEHAVIOUR RULES
      # ========================================
      2.1 — NO ASSUMPTIONS
        - Do NOT invent rules, dependencies, behaviours, limitations,
          or missing pieces of architecture.
        - Do NOT simplify or reinterpret system meaning.
        - When unsure → ASK ANDREW.

      2.2 — ASK BEFORE ACTING
        Any ambiguity → ask Andrew.
        Any missing information → ask Andrew.
        Any unclear dependency → ask Andrew.

      2.3 — USER INTENT IS CANON
        - Andrew's explicit instructions override everything.
        - AI cannot decide something is unnecessary, irrelevant,
          or should be deprioritized unless Andrew says so.

  # --------------------------------
  # Section 3 – Naming, Standards & Conventions
  # --------------------------------
  - id: project_canon.naming_standards_and_conventions
    kind: standards
    applies_to: [architect, implementer]
    tags: [naming, standards, taxonomy]
    md: |
      # ========================================
      # SECTION 3 — NAMING, STANDARDS & CONVENTIONS
      # ========================================
      - LillyCORE standard for project-owned files and folders is snake_case
        (lowercase_with_underscores).
      - Technical naming details and explicit exceptions (e.g. tool-standard
        filenames and vendored third-party files) are defined in TECH_SPEC
        Section 2, which is the authoritative source for naming rules.
      - Hyphens ("-") in names are only allowed where external tools,
        ecosystems, or third-party artefacts REQUIRE them (e.g.
        .pre-commit-config.yaml, pyproject.toml) or in non-filename titles.
      - Files, folders, modules, and engines MUST follow the folder taxonomy
        defined in the Tools & Environment Spec (TECH_SPEC).

      - Docs MUST mirror code structure:
            clear comment blocks
            no fragile formatting
            easy to overwrite entire sections

      - Documentation version numbers are optional and symbolic.
        Git is the real version history.
        AI MUST NOT depend on doc version numbers for logic.

      Repository taxonomy ownership and change process:
        - The authoritative definition of the repository folder taxonomy and
          module-to-path mapping lives in:
              - TECH_SPEC Section 3 (Repository Layout), and
              - MODULES (engine/plugin responsibilities and their mapping to
                engines/ and plugins/ folders).
        - Files, folders, modules, and engines MUST continue to follow the
          taxonomy defined in TECH_SPEC and MODULES; Implementer GPTs MUST
          NOT silently change the folder structure in ways that conflict with
          those docs.
        - Any change to:
              - the set of top-level folders under the repository root, or
              - the meaning or responsibilities of those top-level folders, or
              - the mapping between conceptual modules/engines/plugins and
                their physical paths,
          MUST go through an Architect-designed feature/phase card that
          updates TECH_SPEC Section 3 (and MODULES where appropriate).
        - PROJECT_CANON is ONLY updated when the underlying ontology or
          planning discipline changes (for example, redefining what "core",
          "engine", or "plugin" means). Ordinary folder layout changes are
          captured in TECH_SPEC and MODULES, not by silently editing Canon.

  # --------------------------------
  # Section 4 – Documentation Standards (pointer)
  # --------------------------------
  - id: project_canon.documentation_standards
    kind: docs_pointer
    applies_to: [architect, implementer, qa]
    tags: [docs, governance, pointer]
    md: |
      # ========================================
      # SECTION 4 — DOCUMENTATION STANDARDS
      # ========================================
      NOTE:
        Detailed rules for documentation maintenance, update responsibilities,
        and governance now live in DOCUMENTATION_PROTOCOL and
        DOCUMENTATION_GOVERNANCE. PROJECT_CANON no longer defines per-role
        documentation procedures.

  # --------------------------------
  # Section 5 – System Ontology
  # --------------------------------
  - id: project_canon.system_ontology
    kind: ontology
    applies_to: [architect, implementer, qa]
    tags: [ontology, core, engines, plugins, doc_layers]
    md: |
      # ========================================
      # SECTION 5 — SYSTEM ONTOLOGY (THE MEANING OF COMPONENTS)
      # ========================================
      LillyCORE uses a precise vocabulary to prevent GPT drift.

      CORE:
        - Runtime loop, logging, preferences
        - AI pools
        - System DOC (durable storage)
        - Engines (core subsystems)

      ENGINES (Core Subsystems):
        - DRIFT_ENGINE     → Context/emotion/perception processor (formerly 2a)
        - HELPER_ENGINE    → Work engine / backend orchestrator (formerly 2b)
        - PLUGIN_ENGINE    → Loads and routes external plugins
        - HELP_DESK_ENGINE → Failure detection and self-repair
        - DREAM_ENGINE     → Optimization, degradation, drift management
        - SCRIPT_ENGINE    → Internal script optimizer & validator

      PLUGINS:
        - Optional add-ons that extend behaviour without modifying the core.
        - Examples:
            UX Plugin
            Notes Plugin
            Project Management Plugin
            Personal Assistant Plugin
            Multi-User Plugin
            Demo Plugins

      PIPELINES:
        - Named multi-step processes involving engines, plugins, or pools.

      AGENTS:
        - LLM-driven reasoning entities used by engines or plugins.

      DOC LAYERS:
        - System DOC → durable system-level storage
        - Plugin DOC → per-plugin storage boundary
        - User DOC   → user-generated content

      AI MAY NOT:
        - Invent new ontological categories.
        - Reclassify existing engines/plugins without explicit approval.

  # --------------------------
