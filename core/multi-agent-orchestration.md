# Multi-Agent Orchestration

> **Executive Summary:** A framework for dividing complex software tasks among specialized agents running in parallel. It defines all 11 available agents with their tools and outputs, a reusable orchestration template, and the rules that determine when to parallelize versus serialize. Typical time savings: 30-40% compared to sequential execution.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [base-programming.md](base-programming.md), [workflows/parallel-development.md](../workflows/parallel-development.md), [templates/agent-handoff.md](../templates/agent-handoff.md) |

---

## Quick Reference Card

Quick-start template — fill in the blanks and send to Claude Code:

```
Use multi-agent-orchestration for [FEATURE NAME]:

Agent 1 ([type]): [task description] — no dependencies
Agent 2 ([type]): [task description] — no dependencies
Agent 3 ([type]): [task description] — requires Agent 1 + 2 output

Execution:
  Phase 1 (parallel): Agent 1 + Agent 2
  Phase 2 (serial):   Agent 3

Each agent must produce evidence before handoff.
Final verification: [commands to run after all agents complete]
```

Decision table: parallel vs sequential

| Agents share no data at all | Run in parallel |
| Agent B needs Agent A's output files | Run sequentially (A then B) |
| Agent B only needs the API contract (not A's code) | Run in parallel using mocks |
| Agents write to the same file | Run sequentially |

---

## Full Content

### Three Fundamental Principles

**1. One Agent, One Responsibility**

Each agent has a single well-defined purpose, its own tool set, and isolated context. Mixing responsibilities in one agent produces untestable, unauditable work.

**2. Maximum Parallelization**

Identify which tasks have no data dependency on each other. Run those simultaneously. Serialize only when one agent genuinely needs the other's output to proceed.

**3. Explicit Handoffs**

When one agent finishes, it produces a documented handoff: what was built, what files were created, what the evidence is, and exactly what the next agent needs to know. Never assume the next agent will figure it out.

### All 11 Agents

| Agent | Purpose | Tools | Output | Verification |
|-------|---------|-------|--------|--------------|
| `backend-developer` | APIs, databases, server-side logic | Read, Write, Edit, Bash, Grep | Endpoints + unit tests | Tests pass, API responds correctly |
| `frontend-developer` | UI components, CSS, build tooling | Read, Write, Edit, Bash (npm) | Components + styles + frontend tests | Build succeeds, UI renders, tests pass |
| `testing-engineer` | Unit, integration, E2E, security QA | Bash (test runners), Read, Write | Full test suite + coverage report | All tests pass, coverage >80% |
| `devops-engineer` | Deployment, CI/CD, infrastructure | Bash (docker, systemctl), Read, Write | Deployment scripts + configs | Deploy succeeds, health checks pass |
| `data-analyst` | Data analysis, visualizations, reports | Read, Bash (Python/R), Write | Analysis + charts + insights | Results reproducible, outputs generated |
| `data-detective` | Root-cause analysis, anomaly detection, log forensics | Read, Bash, Grep | Root-cause report + hypothesis | Cause identified, fix confirmed |
| `ui-ux-specialist` | Design specs, accessibility, UX guidelines | Read, Write | Design specs + WCAG audit | WCAG compliant, responsive, consistent |
| `security-auditor` | Threat modeling, OWASP checks, CVE scanning | Read, Bash (scanners), Grep | Security report + remediation list | Zero critical vulnerabilities |
| `api-architect` | API design, OpenAPI specs, versioning strategy | Read, Write | OpenAPI spec + contract doc | Spec validates, breaking changes identified |
| `performance-engineer` | Profiling, benchmarking, caching, query optimization | Bash (profilers), Read | Benchmark report + optimization plan | P95 within SLA, regressions identified |
| `cloud-infrastructure` | AWS/GCP/Azure provisioning, IaC, cost optimization | Bash (terraform/pulumi), Read, Write | IaC files + cost analysis | Infrastructure provisions cleanly |

### Orchestration Template

Use this template to define any multi-agent task:

```markdown
# [PROJECT / FEATURE NAME]

## Objective:
[Clear statement of the end goal]

## Agent Assignments:

### Agent 1: [TYPE] — [TASK NAME]
Responsibility: [What this agent must do]
Input:          [What information it needs to start]
Output:         [What it must produce]
Success criteria:
  - [Verifiable criterion 1]
  - [Verifiable criterion 2]
Dependencies:   None (can run in parallel)

### Agent 2: [TYPE] — [TASK NAME]
Responsibility: [What this agent must do]
Input:          [What information it needs to start]
Output:         [What it must produce]
Success criteria:
  - [Verifiable criterion 1]
  - [Verifiable criterion 2]
Dependencies:   None (can run in parallel with Agent 1)

### Agent 3: [TYPE] — [TASK NAME]
Responsibility: [What this agent must do]
Input:          [Output from Agent 1 + Agent 2]
Output:         [What it must produce]
Success criteria:
  - [Verifiable criterion 1]
  - [Verifiable criterion 2]
Dependencies:   Requires Agent 1 AND Agent 2 to complete first

## Execution Order:

Phase 1 (parallel):
  Agent 1  +  Agent 2

Phase 2 (serial, after Phase 1):
  Agent 3

## Final Verification:
[Commands to run after all agents complete to confirm end-to-end success]
```

### JWT Authentication Example (Condensed)

This is the canonical example showing the execution diagram. For full code detail, see `examples/case-study-vox-client.md`.

**Phase 1 — Parallel:**

```
+-------------------------+    +-------------------------+
|  Agent 1: backend       |    |  Agent 2: frontend      |
|  POST /api/auth/login   |    |  LoginForm component    |
|  POST /api/auth/register|    |  AuthContext            |
|  JWT token generation   |    |  Protected routes       |
|  Unit tests (pytest)    |    |  Component tests (jest) |
+-------------------------+    +-------------------------+
           |                              |
           +──────────────────────────────+
                          |
                          v
```

**Phase 2 — Sequential:**

```
           +-------------------------+
           |  Agent 3: testing       |
           |  E2E: register flow     |
           |  E2E: login flow        |
           |  Security: XSS, SQLi    |
           |  Performance: <200ms    |
           +-------------------------+
```

**Time saved:** 50 min total vs 80 min sequential = 37.5% faster

**Final verification:**
```bash
pytest backend/tests/ -v          # Agent 1 output
npm test --prefix frontend        # Agent 2 output
npm run test:e2e                  # Agent 3 output
curl -X POST http://localhost:8000/api/auth/login \
  -d '{"email":"test@example.com","password":"Test123!"}'
# Expected: {"token":"eyJ...", "user":{...}}
```

### Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Time reduction vs sequential | >30% | Total wall-clock time |
| First-attempt success rate | >80% | Tasks completed without rework |
| Test coverage across all agents | >85% | Combined coverage report |
| Integration failures at handoff | <5% | Failed handoffs / total handoffs |

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| One agent doing backend + frontend + tests | Three separate agents | Mixed responsibility produces untestable output |
| Running Agent 2 after Agent 1 when they are independent | Run both in parallel | Sequential execution wastes the primary benefit of multi-agent |
| "The next agent will know what to do" | Explicit handoff document with artifacts listed | Implicit context transfer almost always loses critical details |
| Passing agent output to the next agent without verifying it | Each agent produces evidence before handoff | Unverified output propagates failures silently |
| Using the same conversation context for all agents | Isolated context per agent | Context contamination causes agents to reference stale or irrelevant state |

---

## Related Documents

- [core/base-programming.md](base-programming.md) — Master session prompt with parallel execution principle
- [workflows/parallel-development.md](../workflows/parallel-development.md) — Detailed parallel workflow with git worktrees
- [templates/agent-handoff.md](../templates/agent-handoff.md) — Standard handoff document format
- [templates/task-decomposition.md](../templates/task-decomposition.md) — How to break large tasks into agent assignments
- [INDEX.md](../INDEX.md) — Full agent roster with links

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
