# Prompt Engineering Library v2

> **Executive Summary:** A modular library of specialized prompts and agent definitions for professional software development with Claude Code. It enforces four non-negotiable principles — verify before acting, test-driven development, multi-agent specialization, and evidence-based reporting — so that every Claude Code session produces reliable, auditable results.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [INDEX.md](INDEX.md), [CONTRIBUTING.md](CONTRIBUTING.md) |

---

## Quick Reference Card

| Want to... | Go to |
|------------|-------|
| Start a new session | Copy [core/base-programming.md](core/base-programming.md) condensed prompt |
| Use a specialist agent | See Agent Roster below, then open `agents/<name>.md` |
| Run tasks in parallel | [core/multi-agent-orchestration.md](core/multi-agent-orchestration.md) |
| Prevent common errors | [core/error-prevention.md](core/error-prevention.md) |
| Validate completed work | [core/real-validation.md](core/real-validation.md) |
| Improve prompt quality | [core/prompting-techniques.md](core/prompting-techniques.md) |
| Navigate everything | [INDEX.md](INDEX.md) |

---

## Full Content

### What This Library Is

The library provides ready-to-use prompts that configure Claude Code sessions with professional-grade discipline. Instead of ad-hoc instructions, you load a proven prompt and immediately get a session that verifies before acting, writes tests first, delegates to the right specialist, and refuses to mark anything done without real evidence.

It ships with 11 specialist agents, 3 workflows, 3 templates, and 4 core documents. All content is technology-agnostic and designed to remain stable over time.

### Quick Start

```bash
# Option 1: Load the base prompt at session start
# Copy the condensed block from core/base-programming.md and paste it
# as your first message in Claude Code.

# Option 2: Invoke a specific agent
/task "Act as the backend-developer agent defined in agents/backend-developer.md.
Implement a REST endpoint for user registration with TDD."

# Option 3: Run a multi-agent workflow
/task "Use multi-agent-orchestration workflow:
  - Agent 1 (backend-developer): POST /api/auth/register endpoint + unit tests
  - Agent 2 (frontend-developer): RegisterForm component + component tests
  - Agent 3 (testing-engineer): E2E test for full registration flow
  Run Agent 1 and Agent 2 in parallel. Run Agent 3 after both complete.
  Each agent must produce evidence before handoff."
```

### Agent Roster

| Agent | Domain | When to Use |
|-------|--------|-------------|
| `backend-developer` | APIs, databases, business logic, server-side Python/Node | Building endpoints, services, migrations |
| `frontend-developer` | React/Vue/JS components, CSS, build tooling | UI features, component libraries, accessibility |
| `testing-engineer` | Unit, integration, E2E, performance, security tests | QA passes, coverage gaps, regression suites |
| `devops-engineer` | Docker, CI/CD, deployment scripts, infrastructure-as-code | Deploy pipelines, container config, monitoring |
| `data-analyst` | Data exploration, visualizations, reports, notebooks | Analysis tasks, dashboards, data cleaning |
| `data-detective` | Root-cause analysis, anomaly detection, log forensics | Debugging data issues, unexpected behavior |
| `ui-ux-specialist` | Design systems, WCAG accessibility, UX specifications | Design review, accessibility audits, mockups |
| `security-auditor` | Threat modeling, OWASP, CVE scanning, auth review | Pre-release security pass, dependency audit |
| `api-architect` | API design, contracts, versioning, OpenAPI specs | API design phase, breaking-change review |
| `performance-engineer` | Profiling, benchmarking, caching, query optimization | Latency issues, load testing, bottleneck analysis |
| `cloud-infrastructure` | AWS/GCP/Azure, IaC (Terraform/Pulumi), cost optimization | Cloud provisioning, scaling, cost review |

### Architecture

```
prompt-engineering-library-v2/
│
├── CORE (start here every session)
│   ├── core/base-programming.md       <- Master prompt: 10 principles + workflows
│   ├── core/error-prevention.md       <- Verification protocol: 7 categories
│   ├── core/multi-agent-orchestration.md  <- Parallel execution framework
│   ├── core/prompting-techniques.md      <- CoT, Few-Shot, ReAct techniques
│   └── core/real-validation.md        <- Evidence rules: no fake "done"
│
├── AGENTS (load when you need a specialist)
│   ├── agents/backend-developer.md
│   ├── agents/frontend-developer.md
│   ├── agents/testing-engineer.md
│   ├── agents/devops-engineer.md
│   ├── agents/data-analyst.md
│   ├── agents/data-detective.md
│   ├── agents/ui-ux-specialist.md
│   ├── agents/security-auditor.md      [NEW in v2]
│   ├── agents/api-architect.md         [NEW in v2]
│   ├── agents/performance-engineer.md  [NEW in v2]
│   └── agents/cloud-infrastructure.md  [NEW in v2]
│
├── WORKFLOWS (orchestrate multi-step processes)
│   ├── workflows/tdd-workflow.md
│   ├── workflows/parallel-development.md
│   └── workflows/verification-protocol.md
│
├── TEMPLATES (reusable communication formats)
│   ├── templates/task-decomposition.md
│   ├── templates/evidence-report.md
│   └── templates/agent-handoff.md
│
└── EXAMPLES
    ├── examples/case-study-vox-client.md
    └── examples/best-practices-learned.md
```

Data flows top-down: the **core** layer establishes invariants for every session. **Agents** operate within those invariants with specialized tools. **Workflows** coordinate multiple agents. **Templates** standardize communication between agents and to the user.

### Four Fundamental Principles

**1. VERIFY, DON'T ASSUME**

Never assume a file exists, a command is installed, a service is running, or a port is free. Verify with actual commands before acting. The cost of a 2-second `ls` is zero. The cost of acting on a wrong assumption can be hours of debugging.

```bash
ls -lh /path/to/file          # Does it exist?
command -v python3            # Is it installed?
systemctl status myservice    # Is it running?
file script.sh                # What encoding?
```

**2. TEST-DRIVEN DEVELOPMENT**

Write the failing test first (RED), then write the minimum code to make it pass (GREEN), then improve without breaking the test (REFACTOR). Never mark a feature done without test evidence. Minimum coverage: 80%.

```python
# RED: write the test first
def test_user_password_is_hashed():
    user = UserService().create("a@b.com", "Secret123")
    assert user.password != "Secret123"

# GREEN: minimal implementation
# REFACTOR: improve structure, keep tests passing
```

**3. MULTI-AGENT SPECIALIZATION**

One agent, one responsibility. Identify which tasks are independent and run those agents in parallel. Only serialize when there is a real data dependency. Document what each agent produces and what the next agent needs.

```
Phase 1 (parallel):  backend-developer  +  frontend-developer
Phase 2 (serial):    testing-engineer   (needs Phase 1 output)
```

**4. EVIDENCE-BASED REPORTING**

"Completed" means nothing without proof. Every claim must be backed by terminal output, test results, curl responses, or screenshots. If you cannot show evidence, mark the item as "implemented but not validated" — never as done.

```bash
# Evidence of tests passing
$ pytest tests/ -v --cov=app
15 passed, coverage: 94%

# Evidence of service running
$ curl http://localhost:8000/health
{"status": "healthy", "version": "2.0.0"}
```

### Success Metrics

| Metric | Target |
|--------|--------|
| First-attempt success rate | >80% (baseline without prompts: ~30%) |
| Wasted version iterations | <3 per feature |
| Features with automated tests | 100% |
| Debugging time as fraction of total | <20% |
| Tasks completed with evidence | 100% |

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| "It should work" | Run it and show the output | Assumptions are the root cause of most wasted iterations |
| One agent doing backend + frontend + tests | Three separate agents, parallel where possible | Mixed responsibility produces untestable, unauditable code |
| Mark task done without output | Always attach terminal output or screenshot | Reviewers and future agents need real evidence, not claims |
| Skip to production from local | staging -> smoke tests -> production -> health check | Unverified deployments create outages |
| Generic commit: `git commit -m "fix"` | `git commit -m "fix: resolve DB timeout in user creation"` | Auditable history is non-negotiable |

---

## Related Documents

- [INDEX.md](INDEX.md) — Full navigation by role, task, and situation
- [core/base-programming.md](core/base-programming.md) — Master session prompt
- [core/multi-agent-orchestration.md](core/multi-agent-orchestration.md) — Parallel agent coordination
- [core/error-prevention.md](core/error-prevention.md) — Verification protocol
- [core/prompting-techniques.md](core/prompting-techniques.md) — CoT, Few-Shot, ReAct and more
- [core/real-validation.md](core/real-validation.md) — Evidence standards
- [CONTRIBUTING.md](CONTRIBUTING.md) — How to contribute
- [LICENSE](LICENSE) — MIT License

*Last updated: 2026-03-08 | Version 2.0.0 | MIT License*
