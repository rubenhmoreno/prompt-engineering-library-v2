# Changelog

> **Executive Summary:** Version history for the Prompt Engineering Library. Follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and [Semantic Versioning](https://semver.org/). Each entry describes what changed and why, not just what files were touched.

| Metadata | Value |
|----------|-------|
| Type     | Meta |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [CONTRIBUTING.md](CONTRIBUTING.md), [INDEX.md](INDEX.md) |

---

## [Unreleased]

### Added

- `agents/ui-ux-pro-max.md` — Industry-specific design intelligence agent based on ui-ux-pro-max-skill: 12+ product category design reasoning, 15+ named visual styles, 12 navigation rules, 12 animation rules, icon governance, chart selection guide, mobile UI rules, 7 landing page patterns, 30-item pre-delivery checklist

### Changed

- `agents/ui-ux-specialist.md` — Updated with cross-references to ui-ux-pro-max, complementary agent comparison table, 3-tier activation guidance
- Library now covers 16 agents (was 15)
- Updated README, INDEX, STANDARD_PROMPT, ACTIVATION_PROMPT, all-agents-cheatsheet with new agent

---

## [2.2.0] - 2026-03-28

### Added

- `core/coding-discipline.md` — 10 atomic rules against over-engineering: no premature abstractions, no unnecessary additions, no compatibility hacks, YAGNI, read-before-modifying, minimize file creation, parallel tool execution, retry with diagnosis
- `core/subagent-prompting.md` — Two-tier prompting doctrine: context-inheriting agents (directive prompts) vs fresh agents (comprehensive 6-part briefs). Worker protocol, synthesis responsibility rules, parallel dispatch patterns
- `workflows/post-implementation-review.md` — 3-agent parallel review workflow: Code Reuse (reinvented utilities, missed library functions), Code Quality (parameter sprawl, dead code, over-engineering), Efficiency (N+1 queries, missed concurrency, memory leaks). Aggregation format and fix protocol
- `workflows/dream-consolidation.md` — Periodic memory maintenance: 4-phase workflow (Orient → Gather Signal → Consolidate → Prune/Index) for reviewing, merging, and pruning persistent memory files. Includes automation via scheduled tasks

### Changed

- `core/real-validation.md` — Added: DONE criteria by surface type table (CLI/API/Browser/Library/DB/Background job), 7 false PASS red flags with explanations, discovery ladder for verification escalation
- `core/agentic-safety.md` — Added: 4-category action risk taxonomy (destructive, hard-to-reverse, shared-state, third-party uploads) with required preconditions per category. Renumbered sections 2→3, 3→4, 4→5, 5→6
- `INDEX.md` — Added navigation entries for all new documents, updated file listing
- Library now covers 11 core docs (was 9), 10 workflows (was 8)
- Version bumped to 2.2.0 across updated documents

### Source

New content derived from analysis of Claude Code's internal system prompts (Piebald-AI/claude-code-system-prompts), adapted and integrated into the library's existing structure and conventions.

---

## [2.1.0] - 2026-03-08

### Added

- `core/prompt-anatomy.md` - Anthropic's 10-component prompt structure, system vs user prompt separation, session composition guide
- `core/agentic-safety.md` - Scope definition, action blocklists, human checkpoints for autonomous agent sessions
- `core/hooks-guide.md` - Claude Code lifecycle hooks: 4 patterns (gate, transformer, side-effect, scanner) with examples
- `core/claudemd-guide.md` - How to create and maintain CLAUDE.md files for any project
- `workflows/explore-first.md` - Mandatory codebase investigation protocol before modification
- `workflows/riper-workflow.md` - Research/Innovate/Plan/Execute/Review constrained phases
- `workflows/incident-response.md` - Time-boxed incident response with P0-P3 severity levels
- `workflows/session-memory.md` - Session continuity patterns: Summary.md, checkpoints, cross-session handoff
- `agents/debugger.md` - Runtime error diagnosis and systematic debugging (separate from data-detective)
- `agents/git-workflow-manager.md` - Branch strategy, conventional commits, PR workflow
- `agents/database-architect.md` - Schema design, migrations, query optimization (separate from backend-developer)
- `agents/technical-writer.md` - API docs, ADRs, runbooks, changelogs
- `quick-ref/slash-commands.md` - 6 ready-to-use slash command definitions (/tdd, /verify, /explore, /decompose, /security-review, /incident)
- YAML frontmatter with model-tier and tool permissions on all agent files
- Named collaboration presets (feature, bugfix, security, performance, refactor, incident) in multi-agent-orchestration.md
- Orchestrator discipline rules, agent count constraints, concurrent batching, query classification, failure recovery in multi-agent-orchestration.md
- Extended Thinking and XML Tagging techniques in prompting-techniques.md
- Problem classification and agent count heuristics in task-decomposition.md
- Durable decisions block and agent briefing template in agent-handoff.md

### Changed

- All 11 existing agent files now include YAML frontmatter (name, description, tools, model)
- Version bumped to 2.1.0 across all documents
- Library now covers 15 agents (was 11), 7 workflows (was 4), 9 core docs (was 5)

---

## [2.0.0] - 2026-03-08

### Added

- 4 new specialized agents: security-auditor, api-architect, performance-engineer, cloud-infrastructure (library now covers 11 agents total)
- Quick Reference system (4 files in `quick-ref/`):
  - `all-agents-cheatsheet.md` - Single-page table of all 11 agents with selection decision tree
  - `workflow-decision-tree.md` - When to use TDD Workflow vs Parallel Development vs Verification Protocol
  - `command-reference.md` - All verification commands categorized by domain
  - `template-selector.md` - When to use Task Decomposition vs Evidence Report vs Agent Handoff
- `INDEX.md` master navigation file linking all library documents
- Executive Summary block (2-3 sentences, no jargon) at the top of every document
- Quick Reference Card section in all agent and workflow documents
- "When to Use / When NOT to Use" sections in all agent documents
- Anti-patterns tables in all documents showing the wrong approach alongside the right approach
- Universal document template applied consistently across the library

### Changed

- All documents translated to English (v1 Spanish originals preserved in `archive/v1-spanish/`)
- All documents condensed approximately 60% (16,254 lines in v1 reduced to approximately 6,500 lines in v2)
- `base-programming.md` moved and reorganized as `core/base-programming.md`
- `real-validation-prompt.md` moved and reorganized as `core/real-validation.md`
- Multi-agent orchestration documentation updated for 11 agents (v1 covered 7)
- All existing agents enhanced with modern tooling references and updated patterns
- `examples/case-study-vox-client.md` translated, condensed, and restructured around the 7-error summary table
- `examples/best-practices-learned.md` translated, restructured with consistent problem/wrong/right/verify pattern across all 10 categories
- `CONTRIBUTING.md` translated, condensed from 615 to approximately 300 lines, coding and documentation standards moved to concise tables

### Removed

- GitHub utility files moved to `archive/` (not core library content)
- `REVIEW.md` moved to `archive/` (superseded by Verification Protocol workflow)
- Speculative ecosystem and roadmap sections from all documents
- Duplicated content that appeared across multiple documents
- Spanish-only content from all active library files (originals preserved in `archive/v1-spanish/`)

---

## [1.0.0] - 2025-12-25

### Added

- Initial release with 24 files totaling approximately 16,254 lines
- 7 specialized agents: backend-developer, frontend-developer, testing-engineer, devops-engineer, data-analyst, data-detective, ui-ux-specialist
- 3 workflows: tdd-workflow, parallel-development, verification-protocol
- 3 templates: task-decomposition, evidence-report, agent-handoff
- 2 examples: case-study-vox-client (Spanish), best-practices-learned (Spanish)
- Core documents: base-programming, real-validation-prompt
- Supporting documents: CONTRIBUTING.md, CHANGELOG.md, README.md

---

## Version Numbering

| Change type | Version bump | Example |
|-------------|-------------|---------|
| Breaking change to core principles or file structure | MAJOR | 1.x.x to 2.0.0 |
| New agent, workflow, template, or Quick Reference file | MINOR | 2.0.x to 2.1.0 |
| Fixes, clarifications, examples within existing files | PATCH | 2.0.0 to 2.0.1 |

---

## Related Documents

- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute changes
- [INDEX.md](INDEX.md) - Full library navigation

*Last updated: 2026-03-08 | [Back to Index](INDEX.md)*
