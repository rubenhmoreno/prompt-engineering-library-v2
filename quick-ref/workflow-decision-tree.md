# Workflow Decision Tree

> **Executive Summary:** Three workflows cover the full development lifecycle. TDD Workflow drives implementation, Parallel Development coordinates multiple agents simultaneously, and Verification Protocol proves that work is actually complete. This document helps you pick the right one in under 60 seconds.

| Metadata | Value |
|----------|-------|
| Type     | Reference |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [All Agents Cheatsheet](all-agents-cheatsheet.md), [Template Selector](template-selector.md) |

---

## Decision Tree

```
What do you need to do?
|
+-- Write new code or fix a bug?
|       |
|       +-- Single agent, single component?
|       |       --> TDD Workflow
|       |
|       +-- Multiple agents or parallel tracks?
|               --> Parallel Development Workflow
|
+-- Prove that existing work is complete and correct?
|       --> Verification Protocol
|
+-- AI output is shallow, wrong, or inconsistent?
|       --> Apply a Prompting Technique (CoT, Few-Shot, ReAct...)
|           See core/prompting-techniques.md Activation Table
|
+-- Combination of all three?
        --> Start with Parallel Development,
            apply TDD inside each track,
            close with Verification Protocol
```

### Quick One-Line Rules

- **Writing code** → TDD Workflow
- **Multiple agents working together** → Parallel Development
- **Proving completion to a stakeholder** → Verification Protocol
- **AI gives bad output** → Prompting Techniques (CoT, Few-Shot, Step-Back, ReAct)

---

## Workflow Comparison Table

| Workflow | When to Use | Primary Input | Primary Output | Typical Duration | Agents Involved |
|----------|-------------|---------------|----------------|-----------------|-----------------|
| **TDD Workflow** | Implementing any new feature, fixing a bug, adding an endpoint | Requirements or failing test | Working code with passing tests | 30 min - 4 hours | 1-2 (usually backend-developer or testing-engineer) |
| **Parallel Development** | Task spans multiple domains simultaneously | Decomposed task list | Integrated deliverable from multiple agents | 2 - 8 hours | 3-7 agents in parallel tracks |
| **Verification Protocol** | Confirming a task is done, validating a deployment, closing a PR | Claimed completion state | Evidence report with proof commands | 15 - 45 min | Any agent performing the work |

---

## TDD Workflow

**File:** [workflows/tdd-workflow.md](../workflows/tdd-workflow.md)

**Core cycle:**

```
1. RED   - Write a failing test for the requirement
2. GREEN - Write the minimum code to make it pass
3. REFACTOR - Clean up without breaking the test
4. VERIFY - Run full test suite, confirm coverage
```

**Use when:**
- Starting a new feature or endpoint
- Fixing a regression
- Refactoring existing code safely
- A single agent can own the full implementation

**Do not use when:**
- The task requires simultaneous work by multiple agents (use Parallel Development)
- The task is purely operational with no code change (use Verification Protocol)

---

## Parallel Development Workflow

**File:** [workflows/parallel-development.md](../workflows/parallel-development.md)

**Core structure:**

```
Orchestrator decomposes task
         |
    +---------+---------+
    |         |         |
Track A   Track B   Track C
(agent 1) (agent 2) (agent 3)
    |         |         |
    +---------+---------+
         |
  Integration & Verification
```

**Use when:**
- A feature requires backend + frontend + tests simultaneously
- An incident requires investigation + fix + deployment in parallel
- Time pressure makes sequential work unacceptable
- The task has clearly separable sub-tasks with minimal dependencies

**Do not use when:**
- Tracks have hard sequential dependencies (use TDD Workflow sequentially)
- Only one agent is needed (overhead is not worth it)

---

## Verification Protocol

**File:** [workflows/verification-protocol.md](../workflows/verification-protocol.md)

**Core principle:**

```
Every claim must be backed by a command and its output.
NO: "The service is running"
YES: $ systemctl is-active myservice
     active
```

**Use when:**
- Closing out a task and need proof of completion
- Validating a deployment before declaring success
- Reviewing another agent's work
- A stakeholder needs evidence, not just assertions

**Verification command categories:**

```
Files exist?        ls -lh /path/to/file
Service running?    systemctl is-active service-name
Port open?          ss -tulpn | grep :8000
Tests pass?         pytest tests/ -v
Endpoint responds?  curl -sf http://localhost:8000/health
DB accessible?      psql -U user -d db -c "SELECT 1"
```

**Do not use as a substitute for development.** Verification Protocol confirms work is done. TDD Workflow is how you do the work.

---

## Combining Workflows

Most real projects use all three in sequence:

```
Phase 1: Planning
  - Use Task Decomposition template
  - Identify which agents run in parallel (Parallel Development)

Phase 2: Implementation
  - Each agent applies TDD Workflow in their track
  - Orchestrator monitors for integration conflicts

Phase 3: Completion
  - All agents run Verification Protocol on their outputs
  - Orchestrator compiles Evidence Report template
  - Handoff via Agent Handoff template if work continues
```

---

## Related Documents

- [All Agents Cheatsheet](all-agents-cheatsheet.md) - Which agent to use
- [Template Selector](template-selector.md) - Which template to use
- [TDD Workflow](../workflows/tdd-workflow.md) - Full TDD documentation
- [Parallel Development](../workflows/parallel-development.md) - Full parallel workflow
- [Verification Protocol](../workflows/verification-protocol.md) - Full verification documentation
- [Prompting Techniques](../core/prompting-techniques.md) - Improve AI output quality
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
