# docs/build/features.yml

version: "1.0"

blocks:
  # --------------------------------
  # Overview
  # --------------------------------
  - id: features.overview
    kind: overview
    name: FEATURES
    applies_to: [architect, implementer, qa]
    tags: [features, cards, template, canonical]
    md: |
      # FEATURES

      **ROLE:** Feature card structure + optional mirror of key work items  
      **NOTE:** GitHub Issues / Project Board is the primary tracker.

      Procedural and workflow rules for feature card creation, QA processing,
      correction tasks, and phase bundles live in DOCUMENTATION_PROTOCOL.
      See:
      - `docs/build/documentation_protocol.yml`
      - `docs/build/documentation_governance.yml`

      This file defines:
      - The standard shape of a LillyCORE feature card.
      - How GPTs should think about feature cards.
      - (Optionally) a curated set of mirrored features from GitHub.

      The GitHub Project Board remains the authoritative source of truth
      for actual work items.

      This file does NOT need to contain every feature. It can contain:
      - Just the template, OR
      - Template + a curated subset of important cards.

  # --------------------------------
  # Source of Truth
  # --------------------------------
  - id: features.source_of_truth
    kind: rules
    applies_to: [architect, implementer, qa]
    tags: [source_of_truth, github]
    md: |
      ## Source of Truth

      Canonical feature list:
      - GitHub Project Board and GitHub Issues.

      For GPTs:
      - Architect:
          - Designs feature cards and may propose their contents.
          - MUST NOT assume GitHub state; Andrew decides what actually exists.
      - Implementer:
          - Only works from card bodies explicitly pasted into chat.

      When a GPT needs a feature card, it MUST ask Andrew to:
      - Paste the GitHub issue text, OR
      - Paste the FEATURES entry if mirrored here.

      Example GPT request:
      "Please paste the GitHub card body or FEATURES entry for F-XXX."

  # --------------------------------
  # Feature Card Template
  # --------------------------------
  - id: features.card_template
    kind: template
    applies_to: [architect, implementer, qa]
    tags: [template, card_format]
    md: |
      ## Feature Card Template

      All LillyCORE features SHOULD use this structure.

      **ID**
      - A short identifier like F-001 or F-002.
      - May match a GitHub Issue or use a separate scheme.

      **Template**

      ID: F-XXX  
      Title: <short feature name>  
      Phase: <roadmap phase numbers>  
      Engine/Plugin: <DRIFT_ENGINE, HELPER_ENGINE, NOTES_PLUGIN, etc.>  
      GitHub: <optional issue link or number>  
      Status: planned | in-progress | implemented | blocked  

      Purpose:
          - Why this feature exists.

      Context:
          - Where it fits in the roadmap or module layout.
          - Relevant background information.

      Deliverables:
          - Concrete outputs (code, behavior, docs).

      Done When:
          - Clear, checkable completion criteria.

      Notes / Future:
          - Follow-ups.
          - Risks or possible extensions.

      **GPT RULE**
      - Architect MUST use this template.
      - Implementer MUST NOT alter template semantics.

  # --------------------------------
  # GPT Interaction Rules
  # --------------------------------
  - id: features.gpt_interaction_rules
    kind: rules
    applies_to: [architect, implementer, qa]
    tags: [gpt_rules, workflow]
    md: |
      ## GPT Interaction Rules

      **Architect**
      - May propose new features.
      - MUST label them with an ID and Phase.
      - MUST ask Andrew whether to:
          - Add them to GitHub,
          - Add them to this file,
          - Or treat them as exploratory only.

      **Implementer**
      - MUST request the full card text before implementing.
      - MUST NOT infer missing fields or invent “Done When” criteria.

      **QA**
      - Validates work after implementation.
      - MUST NOT modify feature cards.
      - Creates corrective tasks if needed, following DOCUMENTATION_PROTOCOL.

      When in doubt:
      ASK Andrew:
      "Is this card tracked in GitHub, FEATURES, or both?"

  # --------------------------------
  # Example Feature Card Placeholder
  # --------------------------------
  - id: features.example_card_placeholder
    kind: example
    applies_to: [architect, implementer, qa]
    tags: [example, placeholder]
    md: |
      ## Example Feature Card (Placeholder)

      This is an example only. It does NOT represent real work unless Andrew adopts it.

      ID: F-000  
      Title: Example Feature Card Template  
      Phase: 0  
      Engine/Plugin: (none)  
      Status: planned  

      Purpose:
          - Demonstrate the feature card structure.

      Context:
          - Reference used by GPTs and Andrew when authoring real cards.

      Deliverables:
          - Template stored in FEATURES.
          - Shared understanding of card fields.

      Done When:
          - Architect + Implementer consistently follow this structure.

      Notes / Future:
          - Replace with real examples as system matures.

  # --------------------------------
  # Optional Mirrored Features
  # --------------------------------
  - id: features.mirrored_features
    kind: registry
    applies_to: [architect, implementer, qa]
    tags: [mirror, github]
    md: |
      ## Optional Mirrored Features

      Andrew may mirror selected GitHub features here for convenience.

      Mirrored cards MUST be direct normalizations of the GitHub source.

      Example mirrored card:

      ID: P0.2.6  
      Title: Decide Tooling Config Placement (pyproject, Editorconfig, Pre-Commit)  
      Phase: 0  
      Engine/Plugin: (none)  
      Status: implemented  

      Purpose:
          - Freeze location of baseline tooling configs so GPTs do not guess.

      Deliverables:
          - Decision on config placement.
          - TECH_SPEC updates describing:
              - "repository root" definition,
              - root-level config files.

      Done When:
          - Andrew confirms Option A (configs live at repository root).
          - TECH_SPEC reflects this decision.

      Notes / Future:
          - Any future exceptions MUST be documented in TECH_SPEC.

  # --------------------------------
  # Phase Bundles Index
  # --------------------------------
  - id: features.phase_bundles_index
    kind: index
    applies_to: [architect, implementer, qa]
    tags: [phase_bundles, index]
    md: |
      ## Phase Bundles Index

      This index lists phase card bundles generated by Architect.

      Procedural rules for phase bundles, retry counters, QA flows, and escalation
      live in DOCUMENTATION_PROTOCOL.

      Architect MUST update this index when a new phase bundle is created.

      Example Format:

      - Phase 01 — Attempt 0  
          Bundle: <reference or filename>  
          Notes: Initial design  

      - Phase 01 — Attempt 1  
          Bundle: <reference or filename>  
          Notes: Redesign after QA  

      - Phase 02 — Attempt 0  
          Bundle: <reference or filename>
