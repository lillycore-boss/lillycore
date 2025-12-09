# LillyCORE Documentation Governance

## Purpose

This document defines the **conceptual documentation layers and categories** for LillyCORE at the system level.

It is intentionally **file-path agnostic** where possible: it describes **what kinds of documentation the project should have, who owns them, how they relate to each other, and which are allowed or forbidden**, without redesigning the repository layout. Physical locations and tooling details remain governed by **TECH_SPEC Section 3** and **GPT_RESOURCE_INDEX**.

This file is itself a **system-level conceptual doc**. It exists to:

- Give humans and GPTs a shared mental model of documentation layers.
- Clarify which docs are authoritative versus exploratory.
- Prevent “random spec files” that drift outside GPT_RESOURCE_INDEX or conflict with Canon / Tech Spec.


## Doc Layers & Categories

This section describes **doc layers** conceptually. Individual documents and their physical locations are still indexed and governed by **GPT_RESOURCE_INDEX** and **TECH_SPEC**.

For each layer:

- **Purpose** – why this category exists.
- **Audience** – who is expected to read it.
- **Ownership** – who is responsible for maintaining it.
- **Lifecycle** – whether it is **build-only** (safe to discard with the repo) or **system-level** (part of LillyCORE’s long-lived meaning).


### 1. Build / System Docs (Engineering & Control Docs)

**Examples (non-exhaustive):**

- PROJECT_CANON  
- LILLYCORE_ROADMAP  
- TECH_SPEC  
- MODULES  
- GPT_RESOURCE_INDEX  
- Phase/feature bundles and similar “control plane” docs.  

**Purpose**

- Define **global rules, technical standards, roadmap, and module boundaries**.
- Act as the **single source of truth** for how LillyCORE is structured and built.  

**Audience**

- Andrew (final authority).
- Architect, Implementer, and QA GPT roles.
- Human contributors working on the codebase.

**Ownership**

- PROJECT_CANON and LILLYCORE_ROADMAP: **Andrew + Architect** (ontology, planning, phase evolution).  
- TECH_SPEC: **Andrew + Architect + Implementers** (technical standards and repo layout).:contentReference[oaicite:14]{index=14}  
- MODULES: **Architect**, with Implementers updating details when modules become real.:contentReference[oaicite:15]{index=15}  
- GPT_RESOURCE_INDEX: **Andrew + Architect**, kept in sync whenever new docs become authoritative.:contentReference[oaicite:16]{index=16}  

**Lifecycle**

- These are **system-level** docs: they define how LillyCORE is meant to behave and evolve.
- They are **not ephemeral**; they change over time but should never be treated as disposable.
- Physically, early-phase build/control docs are stored under `docs/build/` as defined in TECH_SPEC; this document does not relocate them.  

**Governance**

- Must be **indexed in GPT_RESOURCE_INDEX** before they are treated as canonical.:contentReference[oaicite:18]{index=18}  
- Must stay consistent with PROJECT_CANON’s ontology and planning rules.:contentReference[oaicite:19]{index=19}  
- **Authoritative specifications** for engines, plugins, DOC layers, and taxonomy belong here or in explicitly related specs, not in ad-hoc files.

#### Build-Process vs Runtime Build Docs

Within the Build/System Docs layer, LillyCORE distinguishes between:

- **Runtime Build Docs**  
  - Define the behaviour, architecture, and evolution of the runtime system itself.  

- **Build-Process Docs**  
  - Define how humans and GPTs collaborate to build and maintain LillyCORE, without
    becoming part of the runtime system.  
  - Examples: GPT_BEHAVIOUR_SPEC, future CONTRIBUTING-style process docs.  

Both categories live under `docs/build/` in early phases, but build-process docs are
explicitly about the development workflow (e.g. GPT roles, ingestion rules), not runtime
behaviour. Runtime system specs MUST NEVER rely on build-process docs as behavioural
authority.


### 2. System-Level Conceptual Docs

**Examples (conceptual, not exhaustive):**

- `docs/documentation_governance.md` (this file).
- High-level architecture overviews and “how LillyCORE fits together” narratives.
- System DOC overviews that explain how System DOC, Plugin DOC, and User DOC relate (without redefining their schemas).  

**Purpose**

- Provide **narrative explanations** and mental models that bridge core/build docs and everyday work.
- Explain how the **ontology from PROJECT_CANON** and the **repo layout from TECH_SPEC** map onto concrete workflows and behaviours.  

**Audience**

- Andrew.
- GPT roles (Architect, Implementer, QA).
- Human contributors who need an orientation guide.

**Ownership**

- Primarily **Architect**, with **Implementers** updating descriptions as behaviour becomes real.
- Andrew has final say on meaning and intent.

**Lifecycle**

- **System-level and persistent**: these docs are part of the long-lived understanding of LillyCORE.
- They are expected to live under `docs/` (not `docs/build/`), reflecting their role as **shareable, persistent documentation** rather than build-only artefacts.
- Any structural or taxonomic changes that affect physical locations must still be designed and captured in TECH_SPEC and GPT_RESOURCE_INDEX via dedicated cards.  

**Governance**

- They **must not contradict** PROJECT_CANON, LILLYCORE_ROADMAP, or TECH_SPEC; if conflicts arise, Canon + Andrew’s explicit direction win, and follow-up tasks update these docs.  
- When a conceptual doc becomes authoritative (e.g. documentation_governance), it should be **referenced from GPT_RESOURCE_INDEX** in a future card so GPTs discover it reliably.:contentReference[oaicite:24]{index=24}  


### 3. Plugin-Specific Docs

**Examples**

- Conceptual overviews for each plugin (NOTES_PLUGIN, UX_INTERFACE, PROJECT_MANAGEMENT, PERSONAL_ASSISTANT, MULTI_USER, DEMOS_AND_CORP).  
- Per-plugin behaviour descriptions, DOC boundary explanations, and UX narratives.

**Purpose**

- Describe **what each plugin does**, how it uses core engines and System DOC, and what its Plugin DOC boundaries are.  

**Audience**

- Plugin authors and maintainers.
- Architect / Implementer GPTs working on that plugin.
- QA GPT verifying plugin behaviour.

**Ownership**

- **Plugin owner** (human or engine) for day-to-day updates.
- Architect for any **structural** changes to responsibilities or boundaries (mirrored in MODULES and TECH_SPEC where needed).  

**Lifecycle**

- **System-level for that plugin**: these docs are persistent as long as the plugin exists.
- Physical location: as of Phase 0, plugin docs are conceptually associated with the plugin and the `docs/` tree; exact file paths and any per-plugin folders remain governed by TECH_SPEC and future cards.  

**Governance**

- Plugin docs may **extend** but must not **redefine** System DOC or Plugin DOC ontology.
- Any plugin that defines new DOC schemas must do so **within the Plugin DOC layer** and respect the System DOC boundaries in core docs.  
- Authoritative plugin specs should be referenced from GPT_RESOURCE_INDEX once they exist, rather than living as unindexed files.:contentReference[oaicite:30]{index=30}  


### 4. User-Facing Docs (docs/user, docs/api, etc.)

**Examples (future, per TECH_SPEC):**

- `docs/user/` – official guides, onboarding, and narratives for human users.  
- `docs/api/` – API/SDK documentation exported or generated for external consumers.:contentReference[oaicite:31]{index=31}  

**Purpose**

- Provide **clear, stable explanations** of how to use LillyCORE and its public surfaces.
- Act as the **human-facing contract** for behaviour that is stable enough to publish.

**Audience**

- End users of LillyCORE and its plugins.
- External developers using APIs or SDKs.
- Support / Help Desk flows.

**Ownership**

- Primarily **Andrew + UX / plugin owners**, with Architect ensuring alignment to core behaviour.
- Implementer updates are allowed but must not silently change externally observable contracts.

**Lifecycle**

- **System-level and persistent**: part of what LillyCORE “promises” externally.
- Physically live under `docs/user/`, `docs/api/`, or related subtrees once those are created, as described in TECH_SPEC (this governance doc does not finalize those paths; it only defines the conceptual layer).:contentReference[oaicite:32]{index=32}  

**Governance**

- Must not diverge from the behaviour defined by Canon, Roadmap, Tech Spec, and plugin docs.
- When conflicts arise, user docs are updated to match reality; the underlying behaviour changes must still go through feature cards and spec updates.


### 5. Runtime-Generated Artefacts

**Examples**

- Logs and error envelopes.  
- Work event records and snapshots.  
- Transcripts and summaries stored via System DOC and Notes flows.  

**Purpose**

- Capture **what actually happened** at runtime: work, state changes, errors, and summaries.

**Audience**

- Core engines (DRIFT_ENGINE, HELPER_ENGINE, HELP_DESK_ENGINE, DREAM_ENGINE, SCRIPT_ENGINE) that read/write System DOC.  
- Plugins (e.g. NOTES_PLUGIN) that consume or summarize runtime history.  
- Andrew and maintainers for debugging and audits.

**Ownership**

- Generated and managed by **core runtime, engines, and plugins**, not by human editing.
- HELP_DESK_ENGINE and DREAM_ENGINE have specific responsibilities around interpreting and curating these artefacts in later phases.  

**Lifecycle**

- **Runtime-level**, potentially long-lived, but distinct from hand-written docs:
  - Stored in System DOC and/or plugin DOC as data, not as markdown spec files.  
- May be pruned, compressed, or transformed over time by DREAM_ENGINE and related systems.

**Governance**

- **Must not be treated as specification documents**.
- Human- or GPT-written specs must reference runtime artefacts (logs, events, transcripts) as evidence, but not replace build/system docs.


## Doc Categories & Requirements

This section defines **which categories we must have, should have, may have, and must not have**. It operates at the conceptual level and relies on GPT_RESOURCE_INDEX and TECH_SPEC for concrete file lists and locations.  


### 1. Must-Have Categories

These categories are **required** for LillyCORE to function as intended:

- **Core Build/System Docs**  
  - PROJECT_CANON  
  - LILLYCORE_ROADMAP  
  - TECH_SPEC  
  - MODULES  
  - GPT_RESOURCE_INDEX  
  - Phase/feature bundles as defined by Architect and QA flows.  

- **Documentation Governance**  
  - This file (`docs/documentation_governance.md`) or its successor is required as the **single place describing documentation layers** and the allowed/forbidden categories.

**Rules**

- These docs **must be kept in sync** with each other whenever code or architecture changes (per PROJECT_CANON §4.1).:contentReference[oaicite:40]{index=40}  
- Any new canonical doc type must be:
  - Added to GPT_RESOURCE_INDEX.
  - Placed in a location consistent with TECH_SPEC Section 3 (e.g., under `docs/build/` for build/system docs, or under `docs/` for persistent conceptual docs), unless Andrew explicitly overrides this.  


### 2. Should-Have Categories

These are **strongly encouraged** and expected to exist for a mature system:

- **System-Level Conceptual Overviews**  
  - Architecture overviews explaining how core, engines, plugins, and DOC layers relate.  

- **Per-Plugin Conceptual Docs**  
  - A short, structured explanation of each plugin’s responsibilities, inputs, outputs, and Plugin DOC boundaries.

- **User-Facing Docs** (once UX and external APIs exist)  
  - At least minimal guides under `docs/user/` and `docs/api/` explaining how to use the main surfaces.  

- **Module-Level Readmes (Optional but Helpful)**  
  - Brief `README`-style docs **inside engine or plugin folders** are allowed to orient contributors, provided:
    - They **do not redefine** canonical behaviour.
    - They **link back** to the relevant build/system docs and specs.
    - Any authoritative change is made in those specs first.

These “should-have” docs help prevent knowledge from living only in Andrew’s head or in scattered GitHub comments.


### 3. May-Have Categories

These are **allowed** but must be clearly treated as **non-authoritative** unless explicitly promoted:

- **Exploratory / scratch / design notes**  
  - Temporary notes, experiments, and brainstorming documents.
  - May live in GitHub issues, PR descriptions, or clearly marked scratch files.
  - If any such note becomes important, its content must be **promoted into build/system docs** and linked via GPT_RESOURCE_INDEX.

- **Generated Documentation**  
  - Auto-generated API references, diagrams, or schema dumps.
  - Stored under appropriate `docs/` subtrees (often under `docs/build/`), but clearly marked as generated and **not a source of truth** on their own.

Rule of thumb:

> **If a “may-have” document contradicts a must-have doc, the must-have doc and Andrew’s explicit instructions win.** The “may-have” doc should be updated or discarded.


### 4. Must-Not-Have Categories

These categories are **forbidden** because they create drift and confusion:

- **Unindexed Spec Files**  
  - Any markdown, text, or similar spec that:
    - Defines behaviour, rules, or architecture, **and**
    - Is not referenced in GPT_RESOURCE_INDEX **or** clearly marked as non-authoritative.
  - Example: `random_notes_on_engines.md` living in a code folder, claiming to redefine how DRIFT_ENGINE works, without any mention in GPT_RESOURCE_INDEX.

- **Shadow Copies of Canon / Tech Spec / Roadmap**  
  - Forked or partial copies of PROJECT_CANON, TECH_SPEC, or LILLYCORE_ROADMAP that:
    - Live outside `docs/` or `docs/build/`, **or**
    - Omit or change rules without explicit sign-off and a proper spec update.  

- **Plugin or Engine Specs that Bypass the Ontology**  
  - Docs that attempt to introduce new ontological categories (new meanings of “engine”, “plugin”, “DOC”, etc.) without going through Canon and Architect-level design.:contentReference[oaicite:45]{index=45}  

- **Runtime Artefacts Treated as Specs**  
  - Logs, snapshots, and transcripts that are mistaken for official behaviour definitions instead of evidence about behaviour.

If a must-not-have document appears, it must either:

1. Be deleted or clearly marked as deprecated, **or**  
2. Be turned into a legitimate must-have or should-have doc via:
   - An Architect or Implementer feature card, and  
   - Proper updates to GPT_RESOURCE_INDEX, TECH_SPEC, and other affected docs.


## docs/ vs docs/build/ (Conceptual Guidance)

Without changing the existing TECH_SPEC rules, this document clarifies **intent** for two key doc trees:​:contentReference[oaicite:46]{index=46}  

- **`docs/`**  
  - Conceptually: home for **persistent, system-level and shareable documentation** (like this file and future high-level narratives).
  - Treated as part of LillyCORE’s long-term “story”.

- **`docs/build/`**  
  - Conceptually: home for **build/system docs and engineering-time artefacts** that are required to build and maintain the system, but are tied to the repository and its internal processes.
  - All documents currently listed in GPT_RESOURCE_INDEX live here in Phase 0.  

Any change to the **actual physical layout** (e.g. moving canonical docs from `docs/build/` to another location) remains a **taxonomy change** that must be designed via Architect cards and reflected in TECH_SPEC and GPT_RESOURCE_INDEX. This file only describes **how to think about the layers**, not the mechanical migration plan.  

Documentation Hierarchy & Canonical Roles

This section defines the conceptual hierarchy of LillyCORE documentation and clarifies the explicit role played by each major file listed in GPT_RESOURCE_INDEX.
It complements TECH_SPEC §3, which remains the authoritative source for physical file layout and repository taxonomy.

1. Hierarchy Overview

LillyCORE documentation is organized into four conceptual layers:

Core Build/System Docs

Canon, Roadmap, Tech Spec, Modules, GPT_RESOURCE_INDEX, feature/phase bundles

Define rules, standards, ontology, module boundaries, and roadmap evolution

System-Level Conceptual Docs

Narrative and conceptual explanations (including this file)

Clarify relationships and mental models without redefining standards

Plugin/Engine Docs

Describe behaviour of individual plugins or engines

Must align with Build/System Docs and MODULES

User-Facing Docs

Public guides and API references

Follow the behaviour defined in Build/System Docs and plugin/engine docs

All layers inherit constraints from PROJECT_CANON (ontology & rules) and TECH_SPEC (technical standards & layout).

2. Canonical Document Roles

Below are the major Build/System Docs and their conceptual responsibilities.

PROJECT_CANON

Layer: Core Build/System Doc
Role:

Defines the ontology of engines, plugins, DOC layers, pipelines, agents

Defines AI behaviour rules and planning discipline

Highest-level meaning and constraints

Ownership: Andrew + Architect
Notes: Overrides all other documents when conflicts arise.

LILLYCORE_ROADMAP

Layer: Core Build/System Doc
Role:

Defines the order and intent of phases

Determines when subsystems appear and how major evolutions unfold

Ownership: Andrew + Architect
Notes: Must never be changed by Implementers.

TECH_SPEC

Layer: Core Build/System Doc
Role:

Defines the technical environment, coding standards, tools, and repository layout

Section 3 is the authoritative declaration of the physical file structure

All docs referencing file placement MUST defer to TECH_SPEC §3

Ownership: Andrew + Architect + Implementers
Notes: This governance doc must never contradict physical layout rules.

MODULES

Layer: Core Build/System Doc
Role:

Defines engines and plugins

Sets boundaries, dependencies, and responsibilities of major subsystems

Ownership: Architect (Implementers update details as modules become real)
Notes: Serves as the map of the runtime ecosystem.

FEATURES

Layer: Core Build/System Doc
Role:

Defines the standard feature card format and GitHub integration rules

(Optionally) mirrors selected high-value feature cards

Ownership: Andrew + Architect
Notes: Implementers rely on pasted cards; this file does not list all work items.

GPT_RESOURCE_INDEX

Layer: Core Build/System Doc
Role:

Master directory of all authoritative documents

Defines which docs exist and must be checked/loaded

Provides conceptual names for use in prompts

Ownership: Andrew + Architect
Notes: A document is not canonical until listed here.

3. Allowed Future Doc Categories

Only the following classes of future docs may be added, and only via feature cards that update GPT_RESOURCE_INDEX and optionally TECH_SPEC §3:

Engine Specs

Deeper structured documentation for individual engines

Must align with MODULES and PROJECT_CANON ontology

Plugin Specs

Detailed behavioural specifications for plugins

Must respect Plugin DOC boundaries and System DOC schemas

DOC Schema Specs

System DOC schema

Plugin DOC schema

Must follow the DOC layer ontology defined in PROJECT_CANON and existing System DOC docs

User-Facing Documentation Sets

docs/user/

docs/api/

Additional published surfaces

Must follow UX and API semantics defined by engines/plugins

Generated Docs

Auto-generated API references, diagrams, schema dumps

Allowed but always non-authoritative

Any category not listed above is forbidden unless Andrew explicitly authorizes it.

4. Relationships Between Major Docs

PROJECT_CANON → defines meaning and ontology

LILLYCORE_ROADMAP → defines phase sequencing

TECH_SPEC → defines physical layout & technical rules

MODULES → defines subsystem boundaries

FEATURES → defines task structure and implementation workflow

GPT_RESOURCE_INDEX → binds all canonical docs together

System-level conceptual docs (such as this file) sit above the technical layout but below the ontology and rules, functioning as interpreters and guides.

Changes to physical layout must be expressed in TECH_SPEC §3, not here.

Changes to meaning/ontology must be expressed in PROJECT_CANON, not here.

## Criteria for Introducing New Document Types

This section defines **when new document types should exist** in LillyCORE and how they fit into the conceptual documentation model.

### 1. Purpose of New Document Types
New document types should be introduced only when:
- They capture **system-level meaning** that cannot live inside existing canonical docs.
- They define **persistent concepts**, not runtime data or ephemeral structures.
- They support architectural clarity (e.g., a new spec describing a new subsystem).
- They are needed for **cross-role coordination** between Architect, Implementer, and QA.

A document type MUST NOT be introduced simply to store scratch notes, partial designs, or exploratory drafts. Those belong outside GPT_RESOURCE_INDEX and are not treated as canonical.

### 2. Ownership and Authority
- **Andrew** is the final authority on whether a new document type is warranted.
- **Architect GPT** may propose new canonical document types but cannot approve them.
- **Implementer GPT** may create or update such docs only after approval and with an explicit feature card.

### 3. Relationship to GPT_RESOURCE_INDEX
Once a new document type becomes canonical:
- It MUST be added to **GPT_RESOURCE_INDEX**.
- GPT_RESOURCE_INDEX becomes the authoritative directory for its meaning, purpose, and physical path.
- GPTs MUST NOT treat a document as canonical unless it appears in GPT_RESOURCE_INDEX.

### 4. Prohibited Document Types
The following MUST NOT be treated as documents within GPT_RESOURCE_INDEX:
- Runtime logs
- Work event histories
- Transcripts or summaries created by System DOC or Notes flows
- Snapshots or temporary artifacts generated during execution

These belong to runtime storage layers and **must not be reinterpreted as specification**.

### 5. Lifecycle Expectations
- Canonical docs are **persistent** and evolve through approved feature cards.
- Conceptual and governance docs (e.g., documentation_governance, architectural narratives) must remain stable enough for long-term orientation.
- A new canonical doc must have:
  - A clear purpose
  - A stable owner
  - Defined relationships to the existing doc layers
  - An explicit place in the repo according to TECH_SPEC

Anything failing these criteria should remain non-canonical until clarified.
