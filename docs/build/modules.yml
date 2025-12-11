# docs/registry/modules.yml

version: 1

blocks:
  # --------------------------------
  # Overview
  # --------------------------------
  - id: modules.overview
    kind: overview
    name: MODULES
    applies_to: [architect, implementer, qa]
    tags: [modules, engines, plugins, overview]
    md: |
      # MODULES

      **FILE:** MODULES  
      **ROLE:** Overview of major engines and plugins in LillyCORE  

      > NOTE: This file tracks BIG PIECES of the system, not individual features.

      ## SECTION: OVERVIEW

      In LillyCORE, we distinguish between:

        CORE ENGINES (core modules):
          - DRIFT_ENGINE       (2a) front/context/emotion
          - HELPER_ENGINE      (2b) work engine / helper
          - MODULE_ENGINE      module / plugin management
          - HELP_DESK_ENGINE   stability / auto-fix
          - DREAM_ENGINE       offline reasoning/maintenance
          - SCRIPT_ENGINE      script optimisation + self-maintenance

        PLUGINS (add-on modules):
          - UX_INTERFACE
          - PROJECT_MANAGEMENT
          - PERSONAL_ASSISTANT
          - NOTES_PLUGIN       (demo/testbed)
          - MULTI_USER
          - DEMOS_AND_CORP
          - Any future “extra capability” systems

      **Engines:**

      - Core of how Lilly thinks, works, and maintains itself.

      **Plugins:**

      - Built on top of engines.
      - NOT part of the core runtime.

      **Implementation layout (folder mapping):**

      - All engines are implemented under:

        `engines/<engine_name>/`

        e.g.:

        - `engines/drift_engine/`
        - `engines/helper_engine/`
        - `engines/plugin_engine/`
        - `engines/helpdesk_engine/`
        - `engines/dream_engine/`
        - `engines/script_engine/`

      - All plugins are implemented under:

        `plugins/<plugin_name>/`

        e.g.:

        - `plugins/notes_plugin/`
        - `plugins/ux_interface/`
        - `plugins/project_management/`
        - `plugins/personal_assistant/`
        - `plugins/multi_user/`
        - `plugins/demos_and_corp/`

      - The folder taxonomy for these modules is defined in TECH_SPEC Section 3
        and MUST be kept in sync with this overview.

      **Dependency and boundary rules:**

      - Engines may depend on:
          `core/` (runtime loop, logging, AI pools, System DOC),
          other engines where explicitly listed under "dependencies"
          in this MODULES file.
      - Engines MUST NOT import plugins directly; they see plugins only through
        PLUGIN_ENGINE / MODULE_ENGINE registries and capability interfaces.

      - Plugins may depend on:
          `core/` and engines/, as clients of those APIs.
      - Plugins MUST NOT:
          be imported directly by `core/` or engines/ (except via plugin
          registration and routing interfaces),
          own or redefine System DOC schemas (plugins operate within the
          DOC layer boundaries defined by core/System DOC).

      This file answers:

      - What engines and plugins exist?
      - When do they appear (which phase)?
      - What are they responsible for?
      - What do they depend on?

      Architect GPT can use this to:

      - Keep subsystems distinct.
      - Place new features in the right engine or plugin.

      QA GPT can use this to verify that implemented work respects module boundaries
      and responsibilities.

      Implementer GPT can use this for:

      - Context when touching specific engines/plugins.

  # --------------------------------
  # Entry template
  # --------------------------------
  - id: modules.entry_template
    kind: entry_template
    applies_to: [architect]
    tags: [template, module_entry]
    md: |
      ## SECTION: ENTRY TEMPLATE

      Use this pattern for each entry:

      ```text
      # ----------------------------------------
      # MODULE: <NAME>
      # ----------------------------------------
        type: core | engine | plugin | ui | infra
        phase: <roadmap phase number>
        status: planned | in-progress | implemented

        summary:
          Short description of what this owns.

        responsibilities:
          - bullet
          - bullet

        dependencies:
          - list engines/plugins/layers it needs

        notes:
          - any important constraints or decisions
      ```

  # --------------------------------
  # MODULE: CORE_RUNTIME
  # --------------------------------
  - id: modules.core_runtime
    kind: module
    module_name: CORE_RUNTIME
    type: core
    phase: 1
    status: planned
    tags: [core, runtime]
    md: |
      # ----------------------------------------
      # MODULE: CORE_RUNTIME
      # ----------------------------------------
      type: core
      phase: 1
      status: planned

      summary:
        Core runtime loop, logging, and user preference handling.

      responsibilities:
        - Provide the main event loop for LillyCORE.
        - Initialize logging and error envelopes.
        - Load and apply user preferences.
        - Coordinate low-level use of AI pools.

      dependencies:
        - None (foundational).

      notes:
        - In future, DRIFT_ENGINE and HELPER_ENGINE may run in separate processes
          or on separate machines.
        - Do NOT bake in assumptions that all engines are forever fused.

  # --------------------------------
  # MODULE: AI_POOLS
  # --------------------------------
  - id: modules.ai_pools
    kind: module
    module_name: AI_POOLS
    type: core
    phase: 2
    status: planned
    tags: [core, ai_pools]
    md: |
      # ----------------------------------------
      # MODULE: AI_POOLS
      # ----------------------------------------
      type: core
      phase: 2
      status: planned

      summary:
        Encapsulates different LLM "brains" and execution wrappers.

      responsibilities:
        - Provide conversational, deterministic, and worker pools.
        - Wrap LLM calls with retries, timeouts, and envelopes.

      dependencies:
        - CORE_RUNTIME

      notes:
        - Backend choices (OpenAI, local models, etc.) are defined elsewhere.

  # --------------------------------
  # MODULE: SYSTEM_DOC
  # --------------------------------
  - id: modules.system_doc
    kind: module
    module_name: SYSTEM_DOC
    type: core
    phase: 3
    status: planned
    tags: [core, system_doc]
    md: |
      # ----------------------------------------
      # MODULE: SYSTEM_DOC
      # ----------------------------------------
      type: core
      phase: 3
      status: planned

      summary:
        Durable storage layer for system state and work logs.

      responsibilities:
        - Store work events.
        - Keep permanent logs.
        - Manage snapshots and final outputs (pdf/txt/img routing).

      dependencies:
        - CORE_RUNTIME

      notes:
        - Actual DB/storage engine is defined in TECH_SPEC / future design.
        - Engines and plugins build on this.

  # --------------------------------
  # MODULE: DRIFT_ENGINE
  # --------------------------------
  - id: modules.drift_engine
    kind: module
    module_name: DRIFT_ENGINE
    type: engine
    phase: 5
    status: planned
    tags: [engine, drift]
    md: |
      # ----------------------------------------
      # MODULE: DRIFT_ENGINE
      # ----------------------------------------
      type: engine
      phase: 5
      status: planned

      summary:
        2a – "Lilly the Person".
        Front/context/emotion engine that shapes how input is perceived.

      responsibilities:
        - Classify content as work / personal / ephemeral.
        - Apply emotional weights to experiences and memories.
        - Maintain personal memory entries.
        - Track ephemeral context (recent messages, tone).
        - Produce thread/context summaries as input to HELPER_ENGINE.

      dependencies:
        - SYSTEM_DOC
        - NOTES_PLUGIN (for testing / early flows)

      notes:
        - Name "DRIFT_ENGINE" reflects its role in managing emotional/contextual drift.
        - May eventually run in a separate process/machine from HELPER_ENGINE.

  # --------------------------------
  # MODULE: HELPER_ENGINE
  # --------------------------------
  - id: modules.helper_engine
    kind: module
    module_name: HELPER_ENGINE
    type: engine
    phase: 6
    status: planned
    tags: [engine, helper]
    md: |
      # ----------------------------------------
      # MODULE: HELPER_ENGINE
      # ----------------------------------------
      type: engine
      phase: 6
      status: planned

      summary:
        2b – "Lilly the Worker".
        Executes work given structured context from DRIFT_ENGINE.

      responsibilities:
        - Accept WorkPackage + ContextBundle.
        - Select appropriate work mode/type.
        - Call backend AIs or stubs.
        - Return structured results.
        - Log work events.

      dependencies:
        - AI_POOLS
        - DRIFT_ENGINE
        - SYSTEM_DOC

      notes:
        - Does not decide who Lilly is; it just does work in context.
        - May have its own runtime separate from DRIFT_ENGINE for stability.

  # --------------------------------
  # MODULE: PLUGIN_ENGINE
  # --------------------------------
  - id: modules.plugin_engine
    kind: module
    module_name: PLUGIN_ENGINE
    type: engine
    phase: 7
    status: planned
    tags: [engine, plugin_engine]
    md: |
      # ----------------------------------------
      # MODULE: PLUGIN_ENGINE
      # ----------------------------------------
      type: engine
      phase: 7
      status: planned

      summary:
        Manages dynamic loading/unloading and registry of plugins.

      responsibilities:
        - Register, load, and unload plugins at runtime.
        - Maintain a capability registry for all plugins.
        - Route calls to plugin sandboxes.
        - Keep per-plugin DOC boundaries sane and isolated.

      dependencies:
        - CORE_RUNTIME
        - SYSTEM_DOC (for plugin-level DOCs)

      notes:
        - Previously called "Module Handler" → "Module Engine".
        - Now definitively called PLUGIN_ENGINE to align with plugin terminology.

  # --------------------------------
  # MODULE: HELP_DESK_ENGINE
  # --------------------------------
  - id: modules.help_desk_engine
    kind: module
    module_name: HELP_DESK_ENGINE
    type: engine
    phase: 8
    status: planned
    tags: [engine, stability]
    md: |
      # ----------------------------------------
      # MODULE: HELP_DESK_ENGINE
      # ----------------------------------------
      type: engine
      phase: 8
      status: planned

      summary:
        Detects and responds to repeated failures in the system.

      responsibilities:
        - Detect recurring errors or failing operations.
        - Attempt auto-repair or mitigation.
        - Escalate issues to Andrew when needed.
        - Distinguish fatal vs recoverable failures.

      dependencies:
        - CORE_RUNTIME
        - SYSTEM_DOC
        - MODULE_ENGINE (for plugin-level fixes, later).

      notes:
        - Part of the "stability spine" along with DREAM_ENGINE and SCRIPT_ENGINE.

  # --------------------------------
  # MODULE: DREAM_ENGINE
  # --------------------------------
  - id: modules.dream_engine
    kind: module
    module_name: DREAM_ENGINE
    type: engine
    phase: 8
    status: planned
    tags: [engine, dream]
    md: |
      # ----------------------------------------
      # MODULE: DREAM_ENGINE
      # ----------------------------------------
      type: engine
      phase: 8
      status: planned

      summary:
        Performs offline reasoning, compression, and drift correction.

      responsibilities:
        - Degrade or compress memories over time.
        - Compress System DOC data where appropriate.
        - Perform lateral reasoning about past events.
        - Evaluate drift and propose optimizations.

      dependencies:
        - SYSTEM_DOC
        - DRIFT_ENGINE

      notes:
        - Intended to run during downtime or scheduled windows.

  # --------------------------------
  # MODULE: SCRIPT_ENGINE
  # --------------------------------
  - id: modules.script_engine
    kind: module
    module_name: SCRIPT_ENGINE
    type: engine
    phase: 8
    status: planned
    tags: [engine, scripts]
    md: |
      # ----------------------------------------
      # MODULE: SCRIPT_ENGINE
      # ----------------------------------------
      type: engine
      phase: 8
      status: planned

      summary:
        Manages and improves automation scripts used by LillyCORE.

      responsibilities:
        - Analyze and optimize internal scripts.
        - Merge/split script units for clarity and reuse.
        - Validate changes in a sandbox.
        - Optionally auto-approve safe improvements.

      dependencies:
        - CORE_RUNTIME
        - TECH_SPEC (for script standards).

      notes:
        - Works with HELP_DESK_ENGINE and DREAM_ENGINE for self-maintenance.

  # --------------------------------
  # MODULE: NOTES_PLUGIN
  # --------------------------------
  - id: modules.notes_plugin
    kind: module
    module_name: NOTES_PLUGIN
    type: plugin
    phase: 4
    status: planned
    tags: [plugin, notes]
    md: |
      # ----------------------------------------
      # MODULE: NOTES_PLUGIN
      # ----------------------------------------
      type: plugin
      phase: 4
      status: planned

      summary:
        Simple notes subsystem; primarily a demo / testbed.

      responsibilities:
        - Summarize transcripts.
        - Accumulate notes.
        - Support basic queries over notes.

      dependencies:
        - SYSTEM_DOC

      notes:
        - Used heavily by DRIFT_ENGINE as an early, cheap test surface.
        - This is NOT a core engine; it is a plugin/demo.

  # --------------------------------
  # MODULE: UX_INTERFACE
  # --------------------------------
  - id: modules.ux_interface
    kind: module
    module_name: UX_INTERFACE
    type: ui
    phase: 9
    status: planned
    tags: [ui, plugin]
    md: |
      # ----------------------------------------
      # MODULE: UX_INTERFACE
      # ----------------------------------------
      type: ui
      phase: 9
      status: planned

      summary:
        Chat, output, and debug panels for interacting with LillyCORE.

      responsibilities:
        - Provide a chat interface.
        - Display outputs and errors.
        - Surface identity and personality cues.

      dependencies:
        - HELPER_ENGINE
        - CORE_RUNTIME

      notes:
        - UX is a plugin-level concern, not a core engine.

  # --------------------------------
  # MODULE: PROJECT_MANAGEMENT
  # --------------------------------
  - id: modules.project_management
    kind: module
    module_name: PROJECT_MANAGEMENT
    type: plugin
    phase: 10
    status: planned
    tags: [plugin, project_management]
    md: |
      # ----------------------------------------
      # MODULE: PROJECT_MANAGEMENT
      # ----------------------------------------
      type: plugin
      phase: 10
      status: planned

      summary:
        Internal project management tooling inside LillyCORE.

      responsibilities:
        - Task breakdown.
        - Work tracking.
        - Self-roadmapping.

      dependencies:
        - SYSTEM_DOC
        - HELPER_ENGINE

  # --------------------------------
  # MODULE: PERSONAL_ASSISTANT
  # --------------------------------
  - id: modules.personal_assistant
    kind: module
    module_name: PERSONAL_ASSISTANT
    type: plugin
    phase: 11
    status: planned
    tags: [plugin, assistant]
    md: |
      # ----------------------------------------
      # MODULE: PERSONAL_ASSISTANT
      # ----------------------------------------
      type: plugin
      phase: 11
      status: planned

      summary:
        User-facing assistant behaviour.

      responsibilities:
        - Daily briefings.
        - Summaries.
        - Routine tracking.
        - Calendar-like memory.

      dependencies:
        - DRIFT_ENGINE
        - HELPER_ENGINE
        - NOTES_PLUGIN

  # --------------------------------
  # MODULE: MULTI_USER
  # --------------------------------
  - id: modules.multi_user
    kind: module
    module_name: MULTI_USER
    type: plugin
    phase: 13
    status: planned
    tags: [plugin, multi_user]
    md: |
      # ----------------------------------------
      # MODULE: MULTI_USER
      # ----------------------------------------
      type: plugin
      phase: 13
      status: planned

      summary:
        Multi-user identity and isolation.

      responsibilities:
        - Per-user memory.
        - Per-user plugin data.
        - Route threads to correct user identity.

      dependencies:
        - SYSTEM_DOC
        - DRIFT_ENGINE
        - HELPER_ENGINE

  # --------------------------------
  # MODULE: IO_NETWORK_LAYER
  # --------------------------------
  - id: modules.io_network_layer
    kind: module
    module_name: IO_NETWORK_LAYER
    type: infra
    phase: 14
    status: planned
    tags: [infra, network]
    md: |
      # ----------------------------------------
      # MODULE: IO_NETWORK_LAYER
      # ----------------------------------------
      type: infra
      phase: 14
      status: planned

      summary:
        Communication across devices.

      responsibilities:
        - Unified packet format.
        - LAN endpoints.
        - Voice/wake commands.
        - Device sandbox coordination.

      dependencies:
        - CORE_RUNTIME
        - UX_INTERFACE

      notes:
        - Appliance / hardware specifics defined later.

  # --------------------------------
  # MODULE: DEMOS_AND_CORP
  # --------------------------------
  - id: modules.demos_and_corp
    kind: module
    module_name: DEMOS_AND_CORP
    type: plugin
    phase: "12+"
    status: future
    tags: [plugin, demos, corp]
    md: |
      # ----------------------------------------
      # MODULE: DEMOS_AND_CORP
      # ----------------------------------------
      type: plugin
      phase: 12+
      status: future

      summary:
        Demo plugins (calculator, story helper, etc.) and any corp/enterprise-specific plugins.

      responsibilities:
        - Showcase capabilities.
        - Provide focused functionality built on core engines.

      dependencies:
        - HELPER_ENGINE (usually)
        - DRIFT_ENGINE (where context/personality matters)

  # --------------------------------
  # Future engines / plugins placeholder
  # --------------------------------
  - id: modules.future_placeholder
    kind: future_placeholder
    applies_to: [architect]
    tags: [future, placeholder]
    md: |
      ## SECTION: FUTURE ENGINES / PLUGINS PLACEHOLDER

      Placeholder for:
        - Appliance Layer specifics
        - Enterprise demo orchestration
        - Any future engines/plugins not yet described.

      NOTE:
        Procedural rules for introducing new engines and plugins, including
        when they become canonical and how they are indexed, are defined in
        DOCUMENTATION_GOVERNANCE and DOCUMENTATION_PROTOCOL.

      ---

      _End of MODULES_
