# Template Selector

> **Executive Summary:** Three templates structure the three moments of any task: starting work (Task Decomposition), finishing work (Evidence Report), and transferring work (Agent Handoff). This guide helps you pick the right one and points to the full template file.

| Metadata | Value |
|----------|-------|
| Type     | Reference |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [Workflow Decision Tree](workflow-decision-tree.md), [All Agents Cheatsheet](all-agents-cheatsheet.md) |

---

## Decision Tree

```
Where are you in the task lifecycle?
|
+-- Starting a new task or feature?
|       --> Task Decomposition Template
|
+-- Finished a task and need to prove it is done?
|       --> Evidence Report Template
|
+-- Handing work to another agent or another session?
        --> Agent Handoff Template
```

### One-Line Rules

- **Beginning** → Task Decomposition
- **End** → Evidence Report
- **Transfer** → Agent Handoff

---

## Template Comparison Table

| Template | When to Use | Key Sections | Complexity | File |
|----------|-------------|--------------|------------|------|
| **Task Decomposition** | Before implementation starts; planning phase | Goal, sub-tasks, agent assignments, dependencies, acceptance criteria | Medium | [templates/task-decomposition.md](../templates/task-decomposition.md) |
| **Evidence Report** | After implementation; proving completion | Claims, commands, outputs, test results, verification checklist | Low-Medium | [templates/evidence-report.md](../templates/evidence-report.md) |
| **Agent Handoff** | When passing work between agents or sessions | Context, completed work, remaining work, decisions made, next steps | Low | [templates/agent-handoff.md](../templates/agent-handoff.md) |

---

## Task Decomposition Template

**Use when:** A task is too large for a single agent to complete in one pass, or when multiple agents will work in parallel.

**What it produces:**
- A numbered list of sub-tasks with clear owners
- Dependencies between sub-tasks
- Acceptance criteria for each sub-task
- Estimated complexity per track

**Typical structure:**

```
Goal: [One sentence]
Acceptance Criteria: [Measurable conditions for done]

Sub-tasks:
  1. [Task] → [Agent] [depends on: none]
  2. [Task] → [Agent] [depends on: 1]
  3. [Task] → [Agent] [depends on: 1]
  4. [Task] → [Agent] [depends on: 2, 3]

Parallel tracks:
  Track A: Tasks 1, 2 (backend-developer)
  Track B: Tasks 1, 3 (frontend-developer)
  Merge:   Task 4 (testing-engineer)
```

**Full template:** [templates/task-decomposition.md](../templates/task-decomposition.md)

---

## Evidence Report Template

**Use when:** Closing a task, submitting work for review, or responding to "is this done?" from an orchestrator or user.

**What it produces:**
- A claim-by-claim verification record
- Command + output pairs proving each claim
- Test results with pass/fail counts
- Known limitations or outstanding issues

**Typical structure:**

```
Task: [What was done]
Status: COMPLETE / PARTIAL / BLOCKED

Evidence:
  Claim 1: Service is running
  Command: systemctl is-active myservice
  Output:  active

  Claim 2: All tests pass
  Command: pytest tests/ -v
  Output:  42 passed, 0 failed

  Claim 3: Endpoint returns 200
  Command: curl -sf http://localhost:8000/health
  Output:  {"status": "ok"}

Known Issues: [None / list]
```

**Full template:** [templates/evidence-report.md](../templates/evidence-report.md)

---

## Agent Handoff Template

**Use when:** Transferring a task from one agent to another, or preserving context between sessions for the same agent.

**What it produces:**
- A summary of what is already complete
- The exact state of the codebase or environment
- Decisions already made and why
- Precise next steps for the receiving agent
- Files to look at first

**Typical structure:**

```
From: [Agent or session]
To:   [Agent or session]
Task: [What we are working on]

Completed:
  - [Item 1]
  - [Item 2]

Current state:
  - [Key files, branches, services]

Decisions made:
  - [Decision] because [reason]

Remaining work:
  1. [Next step]
  2. [Next step]

Start here: [File or command to orient the receiver]
```

**Full template:** [templates/agent-handoff.md](../templates/agent-handoff.md)

---

## Template Usage by Workflow

| Workflow | Templates Used |
|----------|---------------|
| TDD Workflow | Evidence Report (at close) |
| Parallel Development | Task Decomposition (at start) + Agent Handoff (between tracks) + Evidence Report (at close) |
| Verification Protocol | Evidence Report (primary output) |

---

## Related Documents

- [All Agents Cheatsheet](all-agents-cheatsheet.md) - Which agent to activate
- [Workflow Decision Tree](workflow-decision-tree.md) - Which workflow to use
- [Task Decomposition Template](../templates/task-decomposition.md) - Full template
- [Evidence Report Template](../templates/evidence-report.md) - Full template
- [Agent Handoff Template](../templates/agent-handoff.md) - Full template
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
