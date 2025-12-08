# ========================================
# FILE: FEATURES
# ROLE: Feature card structure + optional mirror of key work items
# NOTE: GitHub Issues / Project Board is the primary tracker.
# ========================================


# ========================================
# SECTION: OVERVIEW
# ========================================
# This file defines:
#   - The standard shape of a LillyCORE feature card.
#   - How GPTs should THINK about features.
#   - (Optionally) a small set of important feature cards mirrored
#     from GitHub for quick reference.
#
# Primary source of truth for actual work items:
#   - GitHub Issues / Project Board (owned by Andrew).
#
# This file does NOT need to contain every feature.
# It can be:
#   - Just the template, OR
#   - Template + a curated subset of important cards.


# ========================================
# SECTION: SOURCE OF TRUTH
# ========================================
# Canonical feature list:
#   - GitHub Project Board and Issues.
#
# For GPTs:
#   - Architect GPT:
#       - Designs feature cards logically and may propose card content.
#       - MUST NOT assume GitHub state; Andrew decides what actually gets created.
#   - Implementer GPT:
#       - Only works from feature cards explicitly pasted into chat.
#
# When a GPT needs a feature card, it MUST ask Andrew to:
#   - Paste the GitHub issue body, OR
#   - Paste the corresponding section from this FEATURES file if you keep mirrors.
#
# Example GPT request:
#   "Please paste the GitHub card body or FEATURES entry for F-XXX so I can implement it."


# ========================================
# SECTION: FEATURE CARD TEMPLATE
# ========================================
# All features for LillyCORE SHOULD use this structure.
#
# ID:
#   - A short identifier like F-001, F-002, etc.
#   - Optionally match the GitHub issue number or have a separate scheme.
#
# Template:
#
#   ID: F-XXX
#   Title: <short feature name>
#   Phase: <roadmap phase number(s)>
#   Engine/Plugin: <e.g. DRIFT_ENGINE, HELPER_ENGINE, NOTES_PLUGIN, etc.>
#   GitHub: <optional link or issue number>
#   Status: planned | in-progress | implemented | blocked
#
#   Purpose:
#       - Why this feature exists.
#
#   Context:
#       - Where it fits in the roadmap and module/engine layout.
#       - Any relevant background information.
#
#   Deliverables:
#       - Bullet list of concrete outputs (code, behaviour, docs).
#
#   Done When:
#       - Clear, checkable conditions for "this is complete".
#
#   Notes / Future:
#       - Follow-ups.
#       - Risks.
#       - Ideas for later expansion.
#
# GPT RULE:
#   - Architect MUST use this shape when proposing or refining features.
#   - Implementer MUST NOT silently change these semantics.


# ========================================
# SECTION: GPT INTERACTION RULES
# ========================================
# Architect GPT:
#   - May propose new feature cards in this format.
#   - MUST label them clearly with an ID and Phase.
#   - MUST ask Andrew whether to:
#       - Add them to GitHub,
#       - Add them to this file,
#       - Or treat them as exploratory only.
#
# Implementer GPT:
#   - MUST ask Andrew for the card text before implementing.
#   - MUST NOT:
#       - Infer missing fields.
#       - Invent "Done When" criteria.
#       - Change the Purpose/Context without approval.
#
# QA GPT:
#   - Validates completed feature cards after implementation.
#   - Ensures "Done When" and documentation updates are correctly satisfied.
#   - MUST NOT modify features, only verify and request corrections.
#   - If a completed card fails checks, QA GPT creates corrective cards
#     in the same branch for Architect or Implementer to address.
#
# When in doubt:
#   - ASK Andrew:
#       "Is this card tracked in GitHub, FEATURES, or both?"


# ========================================
# SECTION: EXAMPLE FEATURE CARD (PLACEHOLDER)
# ========================================
# This is an example only. It does NOT represent current real work
# unless Andrew chooses to adopt it.
#
#   ID: F-000
#   Title: Example Feature Card Template
#   Phase: 0
#   Engine/Plugin: (none)
#   GitHub: (optional)
#   Status: planned
#
#   Purpose:
#       - Demonstrate the feature card structure for LillyCORE.
#
#   Context:
#       - Used by GPTs and Andrew as a reference when creating real cards.
#
#   Deliverables:
#       - This template stored in FEATURES.
#       - Shared understanding of card fields.
#
#   Done When:
#       - Architect and Implementer GPTs consistently follow this structure.
#
#   Notes / Future:
#       - Replace this with real feature examples once the system matures.


# ========================================
# SECTION: OPTIONAL MIRRORED FEATURES
# ========================================
# Andrew may choose to mirror a few especially important features here.
# For example:
#   - Core runtime loop
#   - First version of DRIFT_ENGINE
#   - First version of HELPER_ENGINE
#   - First UX plugin
#
# For each mirrored feature:
#   - Copy the GitHub card content
#   - Normalize it into the feature card template
#
# GPT RULE:
#   - NEVER assume this section is complete.
#   - ALWAYS treat GitHub as the authoritative list of all work items.


# ========================================
# SECTION: QA SYSTEM
# ========================================
# The QA System defines how QA GPT evaluates work, generates corrective tasks,
# verifies fixes, and determines whether a phase or deliverable passes.
# This section is the authoritative operational rulebook for QA.
# All QA behaviour—PASS/FAIL definitions, correction workflows, escalation
# procedures, and phase retry logic—is defined here.
#
# Architect GPTs and QA GPTs MUST load this section before performing
# any QA-related activity.
#
# ----------------------------------------
# PURPOSE OF QA
# ----------------------------------------
# QA GPT provides the final verification layer for all Architect and Implementer
# work. It ensures:
#   - Deliverables match the card specifications.
#   - Documentation updates are complete.
#   - TECH_SPEC rules are followed.
#   - Module boundaries are respected.
#   - All required tests have been run by Andrew and results supplied.
#   - Phase designs are stable and internally consistent.
#   - No infinite correction recursion occurs.
#
# QA GPT does NOT:
#   - Rewrite cards,
#   - Redesign phases,
#   - Or generate architecture except through corrective tasks.
#
# Redesigns belong to Architect GPT.
# ----------------------------------------
# PASS / FAIL CRITERIA
# ----------------------------------------
#
# PASS REQUIREMENTS:
# A deliverable or phase ONLY passes if ALL of the following are true:
#   1. All deliverables are completed exactly as the card specifies.
#   2. All required documentation updates are complete:
#        - FEATURES (Phase Bundles Index)
#        - Any DOC updates created by Architect GPT
#   3. All required tests have been run by Andrew AND passed.
#   4. All test results are provided to QA for verification.
#   5. TECH_SPEC rules are respected (formatting, typing, lint, repo structure).
#   6. Module boundaries are respected (per MODULES).
#   7. Andrew explicitly confirms PASS.
#   8. No recursion patterns or structural drift are detected.
#   9. The phase retry counter has NOT exceeded the allowed threshold.
#
# FAIL CONDITIONS:
# A FAIL occurs if ANY of the following occur:
#   - A deliverable is missing or incomplete.
#   - Documentation updates are missing or wrong.
#   - Required tests were not run, or tests failed.
#   - TECH_SPEC or MODULES rules were violated.
#   - Recursion, drift, or instability appears.
#   - Andrew expresses uncertainty.
#   - Phase retry counter is already at maximum.
#
# On FAIL, QA MUST generate corrective tasks.
# ----------------------------------------
# PHASE BUNDLES
# ----------------------------------------
# Each phase attempt has a **phase card bundle**, generated by Architect GPT
# at phase creation or redesign time.
#
# The bundle includes:
#   - All cards for that phase attempt.
#   - Standard Feature Card format.
#
# QA GPT evaluates phase attempts exclusively via this bundle.
#
# Architect GPT MUST always generate this bundle as part of phase design.
# ----------------------------------------
# QA CORRECTION WORKFLOW
# ----------------------------------------
# When QA identifies failures:
#
#   1. QA generates corrective Implementer tasks.
#   2. QA generates one QA task to evaluate those fixes.
#   3. Andrew runs tests after corrections are implemented.
#   4. QA evaluates the corrective tasks.
#
# ONE-LEVEL-DEEP RULE:
#   - QA generates EXACTLY ONE corrective QA layer.
#   - If fixes fail, QA escalates upward rather than recursing deeper.
# ----------------------------------------
# FULL-PHASE RE-RUNS AFTER CORRECTIONS
# ----------------------------------------
# If ALL corrective tasks PASS:
#
#   - QA MUST re-run QA for the entire phase bundle.
#   - This can repeat multiple times.
#   - As long as everything continues to PASS, the phase is stable.
#
# Escalation occurs ONLY when:
#   - A fix fails,
#   - A recursion pattern is detected,
#   - Or the phase retry counter is at threshold.
# ----------------------------------------
# ESCALATION RULES
# ----------------------------------------
#
# CATASTROPHIC FAILURE:
# QA MUST escalate immediately when:
#   - Corrective tasks fail,
#   - Recursion or drift is detected,
#   - A fix creates contradictions,
#   - Or the retry counter prevents further redesigns.
#
# On escalation, QA MUST:
#   - Block the current phase.
#   - Block any dependent phases.
#   - Require Architect GPT intervention.
#   - Require Andrew’s involvement.
#
# PHASE RETRY COUNTER:
#   - Each phase has a retry counter.
#   - Counter starts at 0.
#   - Incremented whenever a redesign occurs.
#   - If counter >= 2:
#       → QA MUST refuse any further redesign.
#       → QA MUST escalate upward immediately.
# ----------------------------------------
# BUNDLE ANNOTATION RULES
# ----------------------------------------
#
# PASS ANNOTATION MUST INCLUDE:
#   - "WHAT PASSING MEANS" header.
#   - QA notes.
#   - Updated retry counter.
#   - Confirmation that corrective tasks passed.
#   - Confirmation that full-phase QA re-runs passed.
#   - Andrew’s explicit PASS approval.
#
# FAIL ANNOTATION MUST INCLUDE:
#   - A failure report placed at the top.
#   - Explanation of failure causes.
#   - A list of corrective tasks generated.
#   - The original cards preserved in a **GRAVEYARD** section.
#   - Instructions for next-phase-attempt.
# ----------------------------------------
# QA SUMMARY AND FINAL PASS REPORT
# ----------------------------------------
# After a successful QA run, QA GPT MUST append a final report to the phase
# bundle including:
#
#   1. A summary of all QA tasks generated during the attempt:
#        - Tasks that passed on the first try.
#        - Tasks that required fixes.
#        - Outcomes of those fixes.
#
#   2. The number of times the entire phase QA was re-run.
#
#   3. The final PASS confirmation for the phase.
#
#   4. Andrew’s explicit PASS approval.
#
# Only after this summary exists is a phase considered fully passed.


# ========================================
# SECTION: PHASE BUNDLES INDEX
# ========================================
# This index lists all phase card bundles generated by Architect GPT.
# Each entry corresponds to a phase attempt and links to the bundle Andrew stores.
#
# Architect GPT MUST update this index whenever a new phase bundle is created.
#
# Example Format — replace with real entries as they are created:
#
# - Phase 01 — Attempt 0
#     Bundle: <reference or filename>
#     Notes: Initial phase design
#
# - Phase 01 — Attempt 1
#     Bundle: <reference or filename>
#     Notes: Redesign after QA escalation
#
# - Phase 02 — Attempt 0
#     Bundle: <reference or filename>


# ========================================
# END OF FEATURES
# ========================================
