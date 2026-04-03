# Index — Prompt Engineering Library v2

> **Executive Summary:** Master navigation page for the library. Find any document by role, task, or situation without reading every file. Every table entry links directly to the relevant resource.

| Metadata | Value |
|----------|-------|
| Type     | Reference |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [README.md](README.md) |

---

## Quick Reference Card

| Navigation path | Use when... |
|-----------------|-------------|
| By Role | You know your job title / hat for this session |
| By Task | You know the concrete thing you need to do |
| By Situation | Something went wrong or you are stuck |
| Quick References | You need a one-screen command/checklist lookup |
| Full File Listing | You want to browse the entire library tree |

---

## Full Content

### Navigate by Role

Who are you in this session? Start with the agents and documents most relevant to your current hat.

| Role | Primary Agents | Supporting Docs |
|------|---------------|-----------------|
| Backend engineer | [backend-developer](agents/backend-developer.md) | [tdd-workflow](workflows/tdd-workflow.md), [error-prevention](core/error-prevention.md) |
| Frontend engineer | [frontend-developer](agents/frontend-developer.md), [ui-ux-specialist](agents/ui-ux-specialist.md) | [tdd-workflow](workflows/tdd-workflow.md), [verification-protocol](workflows/verification-protocol.md) |
| QA / test engineer | [testing-engineer](agents/testing-engineer.md) | [tdd-workflow](workflows/tdd-workflow.md), [real-validation](core/real-validation.md) |
| DevOps / SRE | [devops-engineer](agents/devops-engineer.md), [cloud-infrastructure](agents/cloud-infrastructure.md) | [verification-protocol](workflows/verification-protocol.md), [error-prevention](core/error-prevention.md) |
| Data engineer / analyst | [data-analyst](agents/data-analyst.md), [data-detective](agents/data-detective.md) | [real-validation](core/real-validation.md) |
| Security engineer | [security-auditor](agents/security-auditor.md), [pentester-auditor](agents/pentester-auditor.md), [blue-team-engineer](agents/blue-team-engineer.md), [red-team-researcher](agents/red-team-researcher.md) | [security-audit](workflows/security-audit.md), [security-frameworks-reference](core/security-frameworks-reference.md) |
| API designer | [api-architect](agents/api-architect.md), [backend-developer](agents/backend-developer.md) | [tdd-workflow](workflows/tdd-workflow.md) |
| Performance engineer | [performance-engineer](agents/performance-engineer.md) | [real-validation](core/real-validation.md), [verification-protocol](workflows/verification-protocol.md) |
| Tech lead / architect | All agents as orchestrator | [multi-agent-orchestration](core/multi-agent-orchestration.md), [parallel-development](workflows/parallel-development.md) |
| DBA | [database-architect](agents/database-architect.md) | [tdd-workflow](workflows/tdd-workflow.md), [verification-protocol](workflows/verification-protocol.md) |
| Tech writer | [technical-writer](agents/technical-writer.md) | [evidence-report](templates/evidence-report.md) |
| Incident responder | [data-detective](agents/data-detective.md), [backend-developer](agents/backend-developer.md), [blue-team-engineer](agents/blue-team-engineer.md) | [incident-response](workflows/incident-response.md), [security-audit](workflows/security-audit.md) |
| Pentester | [pentester-auditor](agents/pentester-auditor.md), [red-team-researcher](agents/red-team-researcher.md) | [security-audit](workflows/security-audit.md), [security-frameworks-reference](core/security-frameworks-reference.md) |

### Navigate by Task

What are you trying to accomplish right now?

| Task | Workflow / Template | Agents Involved |
|------|--------------------|-----------------|
| Build a new feature end-to-end | [parallel-development](workflows/parallel-development.md) | backend-developer, frontend-developer, testing-engineer |
| Review code quality after implementation | [post-implementation-review](workflows/post-implementation-review.md) | 3 parallel review agents |
| Write tests for existing code | [tdd-workflow](workflows/tdd-workflow.md) | testing-engineer |
| Debug a production issue | [verification-protocol](workflows/verification-protocol.md), [data-detective](agents/data-detective.md) | data-detective, backend-developer |
| Deploy to staging or production | [verification-protocol](workflows/verification-protocol.md) | devops-engineer, cloud-infrastructure |
| Deploy for the first time (non-technical) | [simple-deployment](workflows/simple-deployment.md) | devops-engineer |
| Check if the interface is easy to use | [ux-checklist](quick-ref/ux-checklist.md) | ui-ux-specialist |
| Design an API from scratch | [task-decomposition](templates/task-decomposition.md) | api-architect, backend-developer |
| Run a security audit | [security-audit](workflows/security-audit.md) | pentester-auditor, security-auditor, blue-team-engineer, red-team-researcher |
| Penetration test | [security-audit](workflows/security-audit.md) | pentester-auditor, red-team-researcher |
| Harden a server | [agents/blue-team-engineer.md](agents/blue-team-engineer.md) | blue-team-engineer, security-auditor |
| Threat modeling | [agents/red-team-researcher.md](agents/red-team-researcher.md) | red-team-researcher |
| Security framework reference | [core/security-frameworks-reference.md](core/security-frameworks-reference.md) | Any security agent |
| Profile and optimize performance | [real-validation](core/real-validation.md) | performance-engineer, backend-developer |
| Analyze a dataset | — | data-analyst |
| Hand off work between agents | [agent-handoff](templates/agent-handoff.md) | Any pair |
| Report completion of a task | [evidence-report](templates/evidence-report.md) | Any |
| Decompose a large task | [task-decomposition](templates/task-decomposition.md) | Tech lead role |
| Prevent encoding / platform errors | [error-prevention](core/error-prevention.md) | Any |
| Improve prompt quality for better AI output | [prompting-techniques](core/prompting-techniques.md) | Any |
| Debug a runtime error | [agents/debugger.md](agents/debugger.md) | data-detective, debugger |
| Set up git workflow | [agents/git-workflow-manager.md](agents/git-workflow-manager.md) | git-workflow-manager |
| Design a database schema | [agents/database-architect.md](agents/database-architect.md) | database-architect |
| Write project documentation | [agents/technical-writer.md](agents/technical-writer.md) | technical-writer |
| Start a new Claude Code project | [core/claudemd-guide.md](core/claudemd-guide.md) | Any |
| Respond to production incident | [workflows/incident-response.md](workflows/incident-response.md) | data-detective, backend-developer |
| Explore unfamiliar codebase | [workflows/explore-first.md](workflows/explore-first.md) | Any |
| Set up Claude Code hooks | [core/hooks-guide.md](core/hooks-guide.md) | Any |
| Learn prompt construction | [core/prompt-anatomy.md](core/prompt-anatomy.md) | Any |
| Design UI for a specific industry/product | [agents/ui-ux-pro-max.md](agents/ui-ux-pro-max.md) | ui-ux-pro-max + ui-ux-specialist |

### Navigate by Situation

Something unexpected happened. Which document addresses it?

| Situation | Go to |
|-----------|-------|
| Agent produced output but I am not sure it actually works | [core/real-validation.md](core/real-validation.md) |
| File not found, path is wrong, directory structure is unclear | [core/error-prevention.md](core/error-prevention.md) — Section 1 |
| Script breaks on Windows but works on Linux (encoding, line endings) | [core/error-prevention.md](core/error-prevention.md) — Section 2 |
| Syntax error, unbalanced braces, broken try-catch | [core/error-prevention.md](core/error-prevention.md) — Section 3 |
| Command not found, dependency missing | [core/error-prevention.md](core/error-prevention.md) — Section 4 |
| Code is over-engineered or has unnecessary complexity | [core/coding-discipline.md](core/coding-discipline.md) |
| Sub-agent prompts produce shallow, generic work | [core/subagent-prompting.md](core/subagent-prompting.md) |
| Need to coordinate 3+ agents without chaos | [core/multi-agent-orchestration.md](core/multi-agent-orchestration.md) |
| Two agents are blocking each other (circular dependency) | [workflows/parallel-development.md](workflows/parallel-development.md) |
| Test coverage is below 80% | [workflows/tdd-workflow.md](workflows/tdd-workflow.md) |
| Not sure what changed between versions | [core/error-prevention.md](core/error-prevention.md) — Section 6 |
| Deployment went wrong and rollback needed | [agents/devops-engineer.md](agents/devops-engineer.md) |
| I need to put my app on a server for the first time | [workflows/simple-deployment.md](workflows/simple-deployment.md) |
| Users say the app is confusing or hard to use | [quick-ref/ux-checklist.md](quick-ref/ux-checklist.md) |
| Security vulnerability discovered post-deploy | [agents/security-auditor.md](agents/security-auditor.md), [workflows/security-audit.md](workflows/security-audit.md) |
| Need to harden server or infrastructure | [agents/blue-team-engineer.md](agents/blue-team-engineer.md) |
| Red team exercise planning | [agents/red-team-researcher.md](agents/red-team-researcher.md) |
| Penetration test of infrastructure | [agents/pentester-auditor.md](agents/pentester-auditor.md) |
| AI gives shallow, wrong, or inconsistent answers | [core/prompting-techniques.md](core/prompting-techniques.md) — Activation Table |
| Need to choose between multiple valid approaches | [core/prompting-techniques.md](core/prompting-techniques.md) — Tree of Thoughts |
| Debugging and AI keeps guessing instead of checking | [core/prompting-techniques.md](core/prompting-techniques.md) — ReAct |
| Agent is modifying code without understanding it first | [workflows/explore-first.md](workflows/explore-first.md) |
| Agent jumped to implementation before planning | [workflows/riper-workflow.md](workflows/riper-workflow.md) |
| Production is down | [workflows/incident-response.md](workflows/incident-response.md) |
| Starting a new project with Claude Code | [core/claudemd-guide.md](core/claudemd-guide.md) |
| Need to enforce quality automatically | [core/hooks-guide.md](core/hooks-guide.md) |
| Agent went out of scope during autonomous work | [core/agentic-safety.md](core/agentic-safety.md) |
| Lost context between sessions | [workflows/session-memory.md](workflows/session-memory.md) |
| Memories feel stale or contradictory | [workflows/dream-consolidation.md](workflows/dream-consolidation.md) |

### Quick References

Fast one-screen lookups (tables and checklists only, no prose).

| Reference | Contents |
|-----------|----------|
| [All Agents Cheatsheet](quick-ref/all-agents-cheatsheet.md) | All 19 agents: purpose, tools, and selection guide |
| [Workflow Decision Tree](quick-ref/workflow-decision-tree.md) | Choose the right workflow for your task |
| [Command Reference](quick-ref/command-reference.md) | All essential shell commands by category |
| [Template Selector](quick-ref/template-selector.md) | Choose the right template for your situation |
| [UX Checklist](quick-ref/ux-checklist.md) | Plain-language usability review (non-technical) |
| [Slash Commands](quick-ref/slash-commands.md) | 6 ready-to-use /command definitions |

---

## Complete File Listing

```
prompt-engineering-library-v2/
│
├── STANDARD_PROMPT.md                      Universal prompt: repo URL + methodology
├── ACTIVATION_PROMPT.md                    3 copy-paste prompts (Minimal/Standard/Full)
├── README.md                               Core entry point and principles
├── INDEX.md                                This file — master navigation
├── CONTRIBUTING.md                         Contribution guidelines
├── CHANGELOG.md                            Version history
├── LICENSE                                 MIT
│
├── core/
│   ├── base-programming.md                 Master session prompt (10 principles)
│   ├── error-prevention.md                 Verification protocol (7 categories)
│   ├── multi-agent-orchestration.md        Parallel agent coordination
│   ├── prompting-techniques.md             CoT, Few-Shot, ReAct and more
│   ├── real-validation.md                  Evidence-based reporting rules
│   ├── prompt-anatomy.md                   10-component prompt structure  [NEW]
│   ├── agentic-safety.md                   Scope, blocklists, checkpoints  [NEW]
│   ├── hooks-guide.md                      Claude Code lifecycle hooks  [NEW]
│   ├── claudemd-guide.md                   CLAUDE.md creation and maintenance  [NEW]
│   ├── coding-discipline.md                10 atomic rules against over-engineering  [NEW v2.2]
│   ├── subagent-prompting.md               Two-tier prompting doctrine for sub-agents  [NEW v2.2]
│   └── security-frameworks-reference.md    Cybersecurity frameworks & tools index  [NEW v2.3]
│
├── agents/
│   ├── backend-developer.md                Server-side, APIs, databases
│   ├── frontend-developer.md               UI, components, build tooling
│   ├── testing-engineer.md                 QA, unit/integration/E2E
│   ├── devops-engineer.md                  Docker, CI/CD, deployment
│   ├── data-analyst.md                     Analysis, visualization, reports
│   ├── data-detective.md                   Root-cause, anomaly, log forensics
│   ├── ui-ux-specialist.md                 Design, accessibility, UX specs
│   ├── security-auditor.md                 Threat modeling, OWASP, CVE
│   ├── api-architect.md                    API design, contracts, versioning
│   ├── performance-engineer.md             Profiling, benchmarking, caching
│   ├── cloud-infrastructure.md             AWS/GCP/Azure, IaC, cost
│   ├── debugger.md                         Runtime errors, systematic debugging  [NEW]
│   ├── git-workflow-manager.md             Branch strategy, commits, PRs  [NEW]
│   ├── database-architect.md               Schema design, migrations, queries  [NEW]
│   ├── technical-writer.md                 API docs, ADRs, runbooks  [NEW]
│   ├── ui-ux-pro-max.md                   Industry design intelligence  [NEW]
│   ├── pentester-auditor.md               Pentesting, OSINT, vulnerability assessment  [NEW v2.3]
│   ├── blue-team-engineer.md              Defensive security, SOC, hardening  [NEW v2.3]
│   └── red-team-researcher.md             Threat intel, adversary emulation  [NEW v2.3]
│
├── workflows/
│   ├── tdd-workflow.md                     Red-Green-Refactor cycle
│   ├── parallel-development.md             Multi-agent parallel execution
│   ├── simple-deployment.md                Non-technical deploy guide
│   ├── verification-protocol.md            Evidence collection protocol
│   ├── explore-first.md                    Codebase investigation protocol  [NEW]
│   ├── riper-workflow.md                   Research/Innovate/Plan/Execute/Review  [NEW]
│   ├── incident-response.md                P0-P3 time-boxed incident handling  [NEW]
│   ├── session-memory.md                   Cross-session continuity patterns  [NEW]
│   ├── post-implementation-review.md       3-agent parallel code review  [NEW v2.2]
│   ├── dream-consolidation.md              Periodic memory maintenance  [NEW v2.2]
│   └── security-audit.md                  Security Audit Mode (5-phase)  [NEW v2.3]
│
├── templates/
│   ├── task-decomposition.md               Break large tasks into agent work
│   ├── evidence-report.md                  Standard completion report format
│   └── agent-handoff.md                    Context transfer between agents
│
├── examples/
│   ├── case-study-vox-client.md            Real case: 7 wasted iterations fixed
│   └── best-practices-learned.md           Lessons from production experience
│
├── quick-ref/
│   ├── all-agents-cheatsheet.md            All 15 agents at a glance
│   ├── workflow-decision-tree.md           Choose the right workflow
│   ├── command-reference.md                Shell commands by category
│   ├── template-selector.md                Choose the right template
│   ├── ux-checklist.md                     Plain-language usability review
│   └── slash-commands.md                   6 ready-to-use /command definitions  [NEW]
│
└── archive/
    └── v1-spanish/                         Original Spanish v1 source files
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Opening random files hoping to find what you need | Use the "by task" or "by situation" table above | Structured navigation saves time and reduces context switching |
| Loading every agent into one session | Load only the agent(s) for your current task | Agent context isolation prevents responsibility leakage |
| Skipping the core documents | Always load `base-programming.md` first | Core invariants apply to all agents and workflows |

---

## Related Documents

- [README.md](README.md) — Library overview and principles
- [core/base-programming.md](core/base-programming.md) — Start here for every session
- [CONTRIBUTING.md](CONTRIBUTING.md) — Add new agents or documents

*Last updated: 2026-03-08 | [Back to Index](INDEX.md)*
