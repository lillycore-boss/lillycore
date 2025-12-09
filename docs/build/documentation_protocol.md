# LillyCORE Build Documentation Protocol

## 1. Purpose & Scope

This protocol defines **how build/system documentation is kept in sync with actual behaviour** in LillyCORE.

It answers:

- Which docs must be considered when work is done.
- Who updates which docs.
- When GPTs must **stop and ask Andrew** instead of editing docs.
- How QA treats documentation as part of “Done When”.

This file is a **procedural overlay** on top of existing rules in:

- PROJECT_CANON  
- LILLYCORE_ROADMAP  
- TECH_SPEC  
- MODULES  
- FEATURES (including QA System)  
- GPT_RESOURCE_INDEX  
- `docs/documentation_governance.md` (documentation governance)

Those documents remain authoritative for ontology, technical standards, roadmap, and taxonomy. This protocol **does not redefine** any of them; it only describes **how to behave** when updating documentation.


## 2. Relationship to Other Docs

This protocol:

- **Follows**:
  - PROJECT_CANON §1–§2 (Prime Directive, ask-before-acting, no assumptions).  
  - PROJECT_CANON §4 (documentation standards: every change updates docs; atomic file updates).  
  - PROJECT_CANON §7–§10 (role boundaries for Architect, Implementer, QA).  
- **Respects**:
  - TECH_SPEC §3 (repository layout and docs/build location).  
  - TECH_SPEC docs layout rules (build/system docs vs user-facing docs).  
  - MODULES (module boundaries and responsibilities).  
  - FEATURES (feature card template and QA system).  
  - GPT_RESOURCE_INDEX (master directory of canonical docs).  
  - `docs/documentation_governance.md` (doc layers, allowed/forbidden doc categories).

When this protocol appears to conflict with any of the above:

1. **Andrew’s explicit instruction wins.**  
2. Then PROJECT_CANON, LILLYCORE_ROADMAP, TECH_SPEC, MODULES, FEATURES, and GPT_RESOURCE_INDEX are updated as needed via feature cards.  
3. This protocol is adjusted afterward to match.

- GPT_BEHAVIOUR_SPEC
  - Defines how GPT roles (Architect, Implementer, QA) behave, ingest docs, and
    interact with Andrew and with each other during the build process.
  - This protocol assumes GPT_BEHAVIOUR_SPEC for behavioural semantics and focuses
    only on documentation procedures and update triggers.


## 3. Roles & Documentation Responsibilities

This section summarizes **who does what for docs**. It does not change any role definitions from Canon; it just makes them operational for documentation work.

### 3.1 Andrew

- Final authority on:
  - System meaning and ontology (PROJECT_CANON).
  - Phase sequencing and intentions (LILLYCORE_ROADMAP).
  - Whether new docs become canonical and are added to GPT_RESOURCE_INDEX.
- Approves:
  - Any change to PROJECT_CANON or LILLYCORE_ROADMAP.
  - Any change that alters repository taxonomy (via Architect-designed cards).
  - Any new canonical document type in documentation_governance.

**Andrew must be asked** explicitly before:

- Any Canon or Roadmap text is changed.
- Any new canonical doc type is introduced.
- Any structural/taxonomy change is made in TECH_SPEC §3.

### 3.2 Architect GPT

- Designs phases and feature cards consistent with:
  - PROJECT_CANON, LILLYCORE_ROADMAP, MODULES, TECH_SPEC.
- Owns:
  - Updates to LILLYCORE_ROADMAP (with Andrew).  
  - Updates to MODULES when engines/plugins become real or change boundary/phase.  
  - Updates to GPT_RESOURCE_INDEX when new canonical docs are introduced or existing docs change meaning.  
  - System-level conceptual docs (including documentation_governance).

Architect MUST:

- Ensure every structural/taxonomy change has an explicit card and corresponding TECH_SPEC / MODULES updates.
- Ensure new canonical docs are:
  - Added to GPT_RESOURCE_INDEX.
  - Placed in locations allowed by TECH_SPEC and documentation_governance.
- Include documentation deliverables in every phase/feature bundle.

Architect MUST NOT:

- Modify PROJECT_CANON or LILLYCORE_ROADMAP without Andrew’s explicit approval.
- Invent new doc layers or categories outside documentation_governance.

### 3.3 Implementer GPT

- Executes **one leaf-level card** at a time (PROJECT_CANON §9).
- Is **always responsible** for documentation updates that follow from that card’s changes.

Implementer MUST:

- Identify which docs are affected by the work.
- Update:
  - **FEATURES**: card status, notes, and any mirrored content if the card lives there.  
  - **TECH_SPEC**: when technical standards, tools, or repo layout change as part of the card.  
  - **MODULES**: when a module’s responsibilities or dependencies become real or change (if within scope of the card).  
  - **GPT_RESOURCE_INDEX**: *only when* the card explicitly calls for adding or changing indexed docs, and Andrew/Architect have approved.  
  - Other build/system docs (e.g. documentation_protocol, documentation_governance) when the card explicitly includes such changes.

Implementer MUST:

- Present doc updates as **ready-to-paste sections**, not fragmented edits.
- Explicitly state if **no documentation changes are required** and why.

Implementer MUST NOT:

- Modify PROJECT_CANON or LILLYCORE_ROADMAP unless the card explicitly says so and Andrew has confirmed that intent in this conversation.
- Perform structural/taxonomy changes forbidden by TECH_SPEC §3.
- Treat unindexed spec files as canonical.

When unsure whether a doc should be updated, Implementer MUST:
- Stop and ask Andrew, or request an Architect clarification card.

### 3.4 QA GPT

- Verifies that **all required documentation updates** have been made for a given card/phase.
- Uses:
  - FEATURES → QA System and phase bundles.  
  - TECH_SPEC → technical and layout rules.  
  - MODULES → boundary and dependency rules.  
  - GPT_RESOURCE_INDEX → canonical doc list.  
  - documentation_governance → doc categories and allowed/forbidden patterns.

QA MUST:

- Fail any card/phase if doc updates are missing, incomplete, or inconsistent with canonical docs.
- Generate corrective cards when documentation is wrong or incomplete.
- Confirm that new canonical docs have been added to GPT_RESOURCE_INDEX when required.

QA MUST NOT:

- Edit docs directly.
- Redesign architecture or rewrite cards (except via corrective-task creation).


## 4. Update Triggers

This section lists **when** documentation MUST be considered and potentially updated.  
“Consider” means **explicitly thinking through whether a given doc is affected**, not blindly editing everything.

### 4.1 Code or Behaviour Change (Implementer)

Whenever code behaviour changes (new function, altered API, changed semantics, removed capability, etc.):

1. **FEATURES**
   - Update the feature card / phase bundle:
     - Mark status (in-progress → implemented).
     - Note key behavioural changes.
     - Link to any new docs or scripts created by the card (if relevant).

2. **TECH_SPEC**
   - Consider updates if:
     - Tools or baseline configs change (e.g. new required linter behaviour, new scripts conventions).
     - Repo layout or script expectations change.
     - Typing/linting/test requirements change.

3. **MODULES**
   - Consider updates if:
     - An engine or plugin moves from “planned” toward “implemented”.
     - Responsibilities or dependencies are clarified beyond what MODULES currently says.

4. **System-Level Conceptual Docs**
   - Update documentation_governance or other high-level conceptual docs **only** when the card explicitly includes that as a deliverable.

If in doubt about whether a behavioural change affects TECH_SPEC or MODULES, Implementer MUST ask Andrew.

### 4.2 Architecture or Planning Change (Architect)

When phase structure, ontology, or high-level module responsibilities change:

1. Update **LILLYCORE_ROADMAP** (phase sequences, intents).
2. Update **PROJECT_CANON** only when ontology / planning discipline changes and Andrew approves.
3. Update **MODULES** when engine/plugin responsibilities or phases change.
4. Update **GPT_RESOURCE_INDEX** when the canonical doc set changes.
5. Update relevant conceptual docs (e.g. documentation_governance) to match the new story.

All of the above require explicit Architect cards and Andrew’s approval.

### 4.3 New Canonical Document Type

When a new doc is meant to become canonical (e.g. engine spec, plugin spec, DOC schema spec):

1. Architect designs an appropriate feature/phase card.
2. Implementer (or Architect, depending on the card) creates the new doc at a location consistent with TECH_SPEC §3 and documentation_governance.
3. Architect/Implementer:
   - Adds the doc to **GPT_RESOURCE_INDEX** with:
     - name  
     - type  
     - status  
     - path  
     - description  
     - usage/access notes
4. QA verifies that:
   - The new doc is indexed.
   - Its location and category obey TECH_SPEC and documentation_governance.

Until this flow completes, the doc is treated as **non-authoritative**.

### 4.4 Taxonomy / Repo Layout Change

Any change covered by TECH_SPEC §3’s taxonomy rules (e.g. top-level folder changes, docs layout changes) MUST:

- Be designed via an Architect card.
- Update:
  - TECH_SPEC §3 (and related sections).
  - MODULES (if engines/plugins mappings change).
  - GPT_RESOURCE_INDEX if canonical docs move or new top-level doc subtrees are created.
- Be validated by QA against the new taxonomy.

Implementers MUST NOT perform these changes under ordinary feature cards.

### 4.5 QA-Detected Drift

When QA detects that runtime behaviour and documentation disagree:

- QA creates corrective Implementer cards (and a QA card) per the QA System in FEATURES.
- Implementer:
  - Updates the relevant docs (FEATURES, TECH_SPEC, MODULES, etc.) to match reality.
  - Ensures changes are consistent with PROJECT_CANON and LILLYCORE_ROADMAP.
- QA re-runs checks for both:
  - The corrective cards.
  - The affected phase bundle.

If QA determines that docs are wrong because the **behaviour** is wrong, Architect may need to create redesign cards; documentation then follows the corrected design.


## 5. Standard Implementer Documentation Flow (Per Card)

For each Implementer leaf card:

1. **Before coding**
   - Read the card’s Purpose, Context, Deliverables, Done When.
   - Identify **which docs are likely relevant**:
     - FEATURE card/bundle itself.
     - TECH_SPEC (if tools, standards, or layout are affected).
     - MODULES (if engines/plugins are being realized or re-scoped).
     - Any specific doc mentioned in the card.

2. **After coding but before declaring “Done”**
   - For each relevant doc, decide:
     - Does the behaviour change require an update?
     - Is the card’s description still accurate?

3. **Apply updates**
   - Prepare **atomic, ready-to-paste blocks** for each affected doc.
   - For example:
     - An updated module entry in MODULES.
     - An updated section in TECH_SPEC.
     - An updated card or note in FEATURES or the phase bundle.
   - Do **not** partially patch random lines; replace coherent sections.

4. **Check canonical alignment**
   - Verify that:
     - No change contradicts PROJECT_CANON or LILLYCORE_ROADMAP.
     - Any new or changed responsibilities still respect MODULES and TECH_SPEC boundaries.
     - You are not accidentally introducing a new canonical doc type without going through GPT_RESOURCE_INDEX.

5. **Ask if uncertain**
   - If you are unsure whether a doc should be edited, or which one:
     - Stop and ask Andrew, or
     - Ask for an Architect clarification card.

6. **Report in output**
   - In the Implementer response, clearly list:
     - Which docs you changed (with snippets).
     - Which docs you considered but did not change (with a brief justification).
     - If no docs changed, why that is safe.


## 6. Ask-Before-Acting Rules (Documentation Edition)

The following are explicit cases where GPTs MUST stop and ask Andrew before editing docs or proceeding.

### 6.1 Canon, Roadmap, and Ontology

- Editing **PROJECT_CANON** in any way.
- Editing **LILLYCORE_ROADMAP**.
- Introducing new ontological categories (new meanings of “engine”, “plugin”, “DOC layer”, etc.).
- Reinterpreting Canon’s definitions for engines, plugins, pipelines, agents, DOC layers.

### 6.2 Repository Taxonomy and Docs Layout

- Adding, renaming, or removing:
  - Any top-level folder in the repo.
  - Any major docs subtrees under `docs/` (e.g. new `docs/api/`-like trees).
  - Any canonical file listed in GPT_RESOURCE_INDEX.
- Moving canonical docs out of `docs/build/` or changing where canonical docs live, beyond what TECH_SPEC §3 already states.

These require Architect cards and Andrew’s approval.

### 6.3 New Canonical Docs or Categories

- Creating a new document and intending it to be **canonical** (e.g. an engine spec, plugin spec, or DOC schema spec) when it is not yet mentioned in documentation_governance.
- Introducing a new category of documentation not listed in documentation_governance (e.g. a new persistent doc layer type).

### 6.4 Ambiguous Authority

- When two or more docs appear to contradict each other.
- When it is unclear which doc is the **source of truth**:
  - e.g. a README inside an engine folder vs MODULES vs TECH_SPEC.
- When a “scratch” or “exploratory” doc appears to have drifted into de-facto spec status.

In these cases, GPTs MUST ask Andrew which doc should win and then bring the rest in line via cards.

### 6.5 QA Edge Cases

- When QA would be forced to pass or fail a phase based on unclear or conflicting doc rules.
- When the QA System’s requirements appear to contradict TECH_SPEC or documentation_governance.

In all such cases, QA MUST escalate to Andrew and/or Architect and request corrective cards rather than making unilateral interpretation changes.


## 7. QA Expectations for Documentation

QA uses the QA System section in FEATURES as the authoritative operational rulebook. This protocol summarizes how QA should apply those rules to documentation.

For any card/phase to PASS, QA MUST confirm:

1. **Docs updated where required**
   - FEATURES / phase bundle entries reflect:
     - Completed status.
     - Actual behaviour and deliverables.
   - TECH_SPEC reflects:
     - Any new technical standards, tools, or layout changes.
   - MODULES reflects:
     - Any changes to engine/plugin status, responsibilities, or dependencies.
   - GPT_RESOURCE_INDEX reflects:
     - Any new canonical docs or major changes to existing ones (when the card required it).

2. **No forbidden docs**
   - No “must-not-have” docs exist (per documentation_governance), such as:
     - Unindexed spec files that define behaviour.
     - Shadow copies of Canon, Tech Spec, or Roadmap with divergent rules.
     - Plugin/engine specs that bypass the ontology.

3. **Docs align with Canon and Tech Spec**
   - No doc claims behaviour or layout that violates:
     - PROJECT_CANON (ontology and AI rules).
     - TECH_SPEC §3 (layout and taxonomy) or other relevant sections.

4. **All updates are atomic and paste-ready**
   - The Implementer has provided coherent sections rather than ad-hoc line edits.
   - Documentation changes are realistically copy-pastable into the repo.

If any of these fail, QA MUST:

- Return **FAIL**.
- Generate corrective Implementer card(s) and a QA card per the QA System rules.


## 8. Quick Checklists

### 8.1 Implementer “Before Handing to QA”

For each leaf card:

- [ ] I updated or explicitly considered **FEATURES / phase bundle**.  
- [ ] I checked whether **TECH_SPEC** needs updates (tools, layout, technical rules).  
- [ ] I checked whether **MODULES** needs updates (status, responsibilities, dependencies).  
- [ ] If I created or promoted a doc to canonical, I ensured a plan exists to update **GPT_RESOURCE_INDEX**.  
- [ ] I did **not** touch PROJECT_CANON or LILLYCORE_ROADMAP unless Andrew explicitly said to.  
- [ ] All doc edits are provided as **ready-to-paste blocks**.  
- [ ] If something felt ambiguous, I asked Andrew or requested a clarifying card.

### 8.2 Architect “When Designing Cards”

For each phase or redesign:

- [ ] I checked PROJECT_CANON, LILLYCORE_ROADMAP, TECH_SPEC, MODULES, FEATURES, GPT_RESOURCE_INDEX, and documentation_governance.  
- [ ] I included **explicit documentation deliverables** for any change that affects behaviour, taxonomy, or canonical docs.  
- [ ] If new canonical docs are needed, I included tasks to:
  - Create them under allowed locations, and  
  - Add them to GPT_RESOURCE_INDEX.  
- [ ] I did not introduce new doc categories without Andrew’s approval.

### 8.3 QA “Doc-Focused Sanity Pass”

For each QA card:

- [ ] All docs listed in this protocol as relevant to the card/phase have been checked.  
- [ ] No forbidden doc categories are being relied upon.  
- [ ] Any new “important” doc has either been:
  - Explicitly marked non-authoritative, or  
  - Promoted through a card and indexed in GPT_RESOURCE_INDEX.  
- [ ] There is no visible contradiction between Canon, Roadmap, Tech Spec, Modules, Features, and the new work.  

## 9. Formatting & Replacement Standards

This section defines how GPTs FORMAT and PRESENT updates to build/system documentation so that docs stay durable, non-fragile, and easy to redraw.

These rules apply to:

- Canonical build/system docs under `docs/build/` (PROJECT_CANON, LILLYCORE_ROADMAP, TECH_SPEC, MODULES, GPT_RESOURCE_INDEX, DOCUMENTATION_PROTOCOL, etc.).
- System-level conceptual docs under `docs/` (such as `docs/documentation_governance.md`), when GPTs are asked to update them.

They do **not** replace the comment-style rules for code/config files defined in TECH_SPEC §2 (e.g. `# ========================================` inside Python or config comments); those still apply there.

### 9.1 Section Header Patterns (Markdown Docs)

For canonical markdown docs, GPTs MUST follow these header patterns when using ASCII “SECTION” blocks.

#### 9.1.1 Big Sections (1, 2, 3…)

Use the full-bar pattern **without leading `#`** for major sections (top-level groups like OVERVIEW, DOCUMENT lists, core phases, etc.):

========================================
SECTION: <NAME>
========================================

Examples:

- `SECTION: OVERVIEW`
- `SECTION: DOCUMENT: PROJECT_CANON`
- `SECTION: PHASE 0 — FOUNDATIONS`

Big sections are used sparingly to mark major structural units in a file.

#### 9.1.2 Smaller Sections (1.1, 1.2, …)

Use the minimal underline style **without leading `#`** for smaller sections nested under a big section (per-doc semantics, e.g. individual document entries, module entries, or similar sub-blocks):

SECTION: <NAME>
----------------------------------------

Examples:

- `SECTION: DOCUMENT: TECH_SPEC`
- `SECTION: MODULE: CORE_RUNTIME`
- `SECTION: QA EXPECTATIONS`

Rule of thumb:

- Big section → full bar above and below (pattern 9.1.1).
- Small section → title line + single underline bar (pattern 9.1.2).

Docs MAY still use normal Markdown headings (`#`, `##`, `###`) where appropriate. These ASCII “SECTION” blocks are an additional structuring tool, typically used in index-like or highly structured spec files.

### 9.2 No Leading `#` in Markdown SECTION Blocks

For markdown-based build/system docs:

- GPTs MUST NOT prefix these SECTION header lines with `#` characters.
- The patterns in 9.1 are literal: they begin at column 0 with `=` or `-` or the word `SECTION:`, not `#`.

The only exception is when a SECTION-like pattern legitimately lives **inside a code fence or comment** in another language (for example, demonstrating a pattern in documentation, or using TECH_SPEC’s comment-style examples inside Python). In those cases, TECH_SPEC §2’s comment rules control the leading `#`.

### 9.3 Ready-to-Paste Block Updates

When updating documentation, Implementer GPT MUST:

- Provide changes as **standalone fenced code blocks** (e.g. ```markdown … ```), not as inline fragments buried inside prose.
- Each fenced block MUST represent a **coherent replacement unit**:
  - A whole section (e.g. an entire `## 4. Update Triggers` section),
  - Or a clearly scoped sub-block (e.g. a single MODULE entry in `MODULES` or a single DOCUMENT entry in `GPT_RESOURCE_INDEX`).

For each block, GPTs MUST:

- Clearly identify the target file (e.g. `docs/build/gpt_resource_index.md`).
- Clearly state whether the block should:
  - **Replace** an existing section with the same heading, or
  - **Be inserted** at a specific location (e.g. “insert after the SECTION: OVERVIEW block and before the first DOCUMENT entry”).

Inline “edit this one line in the middle” instructions are forbidden for GPT-generated updates; humans may still make small local edits directly in the repo when appropriate.

### 9.4 Full-Block Replacements and Partial Refactors

PROJECT_CANON §4.2 already states that we prefer **full block replacements** over partial inline edits. This protocol makes that operational:

- When the meaning or structure of a section changes, GPTs MUST replace the **entire section block** (from its SECTION header down to the line before the next SECTION header or the end of the file/parent section).
- When multiple related sections change, GPTs SHOULD:
  - Provide one fenced block per section, OR
  - Provide a single fenced block containing the full, updated parent section (when that is clearer and still copy-pasteable).

Partial refactors MUST NOT be expressed as “change just these two lines somewhere inside the section.” Instead:

- Rewrite the smallest coherent block that produces a stable, future-proof result.
- Present that entire block as a replacement in a code fence.

Exception (human-only):

- Human editors working directly in the repo MAY make trivial mechanical edits (typos, whitespace fixes) without going through full-section replacements, but GPTs MUST still present proposed changes as block replacements.

### 9.5 Durability and Redrawability

System docs must remain **durable and easy to redraw**:

- Section boundaries (SECTION headers and their blocks) SHOULD remain stable across edits whenever possible.
- GPTs SHOULD avoid formatting that depends on fragile alignment, inline spacing hacks, or ambiguous markers.
- When in doubt about how to structure a block for future redraws, GPTs MUST:
  - Choose the clearer, more atomic section boundary, and
  - Ask Andrew before inventing new block patterns.

If this section ever appears to conflict with PROJECT_CANON or TECH_SPEC (e.g. about comment styles or naming conventions), Andrew’s explicit instruction and those documents win, and this section MUST be updated to match.


---

_End of `docs/build/documentation_protocol.md`_
