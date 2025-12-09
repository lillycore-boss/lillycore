# ========================================
# FILE: FEATURES
# ROLE: Feature card structure + optional mirror of key work items
# NOTE: GitHub Issues / Project Board is the primary tracker.
# ========================================

# ========================================
# SECTION: OVERVIEW
# ========================================
Procedural and workflow rules for feature card creation, QA processing,
correction tasks, and phase bundles now live in DOCUMENTATION_PROTOCOL.
See docs/build/documentation_protocol.md and docs/build/documentation_governance.md.

This file defines:
- The standard shape of a LillyCORE feature card.
- How GPTs should think about feature cards.
- (Optionally) a curated set of mirrored features from GitHub.

The GitHub Project Board remains the authoritative source of truth
for actual work items.

This file does NOT need to contain every feature. It can contain:
- Just the template, OR
- Template + a curated subset of important cards.

# ========================================
# SECTION: SOURCE OF TRUTH
# ========================================
Canonical feature list:
- GitHub Project Board and GitHub Issues.

For GPTs:
- Architect GPT:
    - Designs feature cards and may propose their contents.
    - MUST NOT assume GitHub state; Andrew decides what actually exists.
- Implementer GPT:
    - Only works from card bodies explicitly pasted into chat.

When a GPT needs a feature card, it MUST ask Andrew to:
- Paste the GitHub issue text, OR
- Paste the FEATURES entry if mirrored here.

Example GPT request:
"Please paste the GitHub card body or FEATURES entry for F-XXX."

# ========================================
# SECTION: FEATURE CARD TEMPLATE
# ========================================
All LillyCORE features SHOULD use this structure.

ID:
- A short identifier like F-001 or F-002.
- May match a GitHub Issue or use a separate scheme.

Template:

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

GPT RULE:
- Architect MUST use this template.
- Implementer MUST NOT alter template semantics.

# ========================================
# SECTION: GPT INTERACTION RULES
# ========================================
Architect GPT:
- May propose new features.
- MUST label them with an ID and Phase.
- MUST ask Andrew whether to:
    - Add them to GitHub,
    - Add them to this file,
    - Or treat them as exploratory only.

Implementer GPT:
- MUST request the full card text before implementing.
- MUST NOT infer missing fields or invent “Done When” criteria.

QA GPT:
- Validates work after implementation.
- MUST NOT modify feature cards.
- Creates corrective tasks if needed, following DOCUMENTATION_PROTOCOL.

When in doubt:
ASK Andrew:
"Is this card tracked in GitHub, FEATURES, or both?"

# ========================================
# SECTION: EXAMPLE FEATURE CARD (PLACEHOLDER)
# ========================================
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
    - Architect + Implementer GPTs consistently follow this structure.

Notes / Future:
    - Replace with real examples as system matures.

# ========================================
# SECTION: OPTIONAL MIRRORED FEATURES
# ========================================
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

# ========================================
# SECTION: PHASE BUNDLES INDEX
# ========================================
This index lists phase card bundles generated by Architect GPT.

Procedural rules for phase bundles, retry counters, QA flows, and escalation
now live entirely in DOCUMENTATION_PROTOCOL.

Architect GPT MUST update this index when a new phase bundle is created.

Example Format:

- Phase 01 — Attempt 0  
    Bundle: <reference or filename>  
    Notes: Initial design  

- Phase 01 — Attempt 1  
    Bundle: <reference or filename>  
    Notes: Redesign after QA  

- Phase 02 — Attempt 0  
    Bundle: <reference or filename>

# ========================================
# END OF FEATURES
# ========================================
