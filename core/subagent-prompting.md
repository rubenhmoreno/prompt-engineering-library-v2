# Sub-Agent Prompting Doctrine

> **Executive Summary:** How to write effective prompts for sub-agents. The core insight: sub-agents that inherit conversation context need different prompts than sub-agents that start fresh. Getting this wrong produces shallow, generic work regardless of agent capability.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [multi-agent-orchestration.md](multi-agent-orchestration.md), [base-programming.md](base-programming.md) |

---

## Quick Reference Card

| Agent Type | Has Context? | Prompt Style | Length |
|---|---|---|---|
| Context-inheriting | Yes (shares parent conversation) | Directive — focus on scope and output format | Short (3-8 lines) |
| Fresh (subagent_type set) | No (starts blank) | Comprehensive brief — goals, context, constraints | Long (15-40 lines) |

### The Cardinal Rule

> "Terse, command-style prompts produce shallow, generic work."
>
> Fresh sub-agents have zero context. Brief them the way you would brief a new contractor on their first day: provide goals, relevant background, files to read, approaches already tried, constraints, and the exact output format you need.

---

## Full Content

### Two-Tier Prompting Model

#### Tier 1: Context-Inheriting Sub-Agents

These agents share the parent conversation's context. They can see what you've already discussed, read, and decided. Their prompts should be **directive, not descriptive**.

**DO:**
- Focus on what to do, not background
- Specify scope boundaries (what files/modules to touch and NOT touch)
- Define the output format explicitly
- Avoid repeating information already in the conversation

**DON'T:**
- Re-explain the project architecture
- Repeat file contents already read
- Provide general coding guidelines (they inherit your system prompt)

**Example — Good:**
```
Search for all uses of `authenticate_user()` in the codebase.
For each call site, report: file path, line number, and whether it handles
the AuthenticationError exception.
Output as a markdown table. Do not modify any files.
```

**Example — Bad:**
```
We're working on a FastAPI project that uses SQLAlchemy for the database
and bcrypt for password hashing. The authentication system is in
app/auth/service.py. Can you look at the codebase and find where
authenticate_user is called?
```

The bad example wastes tokens on context the agent already has.

#### Tier 2: Fresh Sub-Agents (subagent_type set)

These agents start with a blank slate. They know nothing about your project, your decisions, or what you've tried. Their prompts must be **self-contained briefs**.

**The 6-Part Brief:**

```markdown
## Goal
What the agent must accomplish (1-2 sentences).

## Context
Project structure, relevant files, technology stack.
Include file paths and specific line numbers when possible.

## Constraints
What NOT to do. Scope boundaries. Files to avoid.
Time/resource limits if applicable.

## Approaches Already Tried
What was attempted and why it failed (prevents re-discovery).

## Expected Output
Exact format: markdown report, code changes, file list, etc.
Include an example of good output if the format is non-obvious.

## Verification
How to confirm the work is correct (test command, curl, etc.).
```

**Example — Good:**
```
## Goal
Fix the race condition in session cleanup that causes "database is locked"
errors under concurrent requests.

## Context
- Project: FastAPI + SQLAlchemy 2.0 + SQLite at /home/mva/tickets-soporte-v2/
- The cleanup runs in app/services/session_service.py:45-62
- SQLite is in WAL mode (configured in app/database.py:12)
- Tests: pytest tests/test_sessions.py

## Constraints
- Do NOT change the database engine or switch to PostgreSQL
- Do NOT modify the session model schema
- Fix must work with SQLite WAL mode

## Approaches Already Tried
- Adding a retry loop with exponential backoff — reduced frequency but
  didn't eliminate the issue
- Using `with db.begin()` instead of manual commit — same error

## Expected Output
- Modified file(s) with the fix
- Explanation of root cause (2-3 sentences)
- Test proving the fix works (pytest output)

## Verification
Run: pytest tests/test_sessions.py -v -n 4
Expected: all tests pass with 4 parallel workers, zero "database is locked"
```

### Synthesis Responsibility

**Never shift synthesis to sub-agents.** The orchestrator must synthesize agent outputs into a coherent result. Sub-agents produce raw findings; the orchestrator integrates them.

| Wrong | Right |
|-------|-------|
| "Research this and tell me what to do" | "Research this and report: findings as a table, your top 3 options with tradeoffs" |
| "Fix whatever you think is wrong" | "Check for X, Y, Z specifically. Report each as PASS/FAIL with evidence" |
| "Look at the code and improve it" | "Review app/auth/ for: SQL injection, missing input validation, hardcoded secrets. Report each finding with file:line" |

### Prompting for Parallel Agents

When dispatching multiple agents in a single message:

1. **Each agent gets a complete, independent prompt** — agents cannot see each other's prompts
2. **Define non-overlapping scopes** — if Agent A touches `app/auth/`, Agent B must not
3. **Specify the same output format** for all agents to simplify aggregation
4. **Include a "do not modify" list** to prevent conflicts between parallel agents

### Worker Protocol

For implementation sub-agents that will commit and push:

```
1. Implement the change
2. Run the project's test suite (not just the affected tests)
3. Run the end-to-end verification command: [specific command]
4. Commit with conventional format
5. Report: PR URL if created, or "PR: none — [reason]"
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| "Fix the bug" (to a fresh agent) | Full 6-part brief with file paths and failed approaches | Fresh agents have zero context — they'll waste time re-discovering what you already know |
| Re-explaining the entire project to a context-inheriting agent | "Search for X in app/services/. Output as markdown table." | Context-inheriting agents already have the conversation history |
| "Do your best" as expected output | "Output: markdown table with columns [File, Line, Issue, Severity]" | Vague output specs produce vague output |
| One prompt for 3 different tasks | Three separate agents, each with one focused task | Mixed prompts produce mixed quality — agents lose focus |
| Dispatching agents one at a time, waiting between each | All independent agents in a single message | Sequential dispatch wastes wall-clock time |

---

## Related Documents

- [core/multi-agent-orchestration.md](multi-agent-orchestration.md) — Agent coordination framework
- [core/base-programming.md](base-programming.md) — Core principles that agents inherit
- [templates/agent-handoff.md](../templates/agent-handoff.md) — Handoff format between agents
- [workflows/parallel-development.md](../workflows/parallel-development.md) — Parallel execution patterns

*Last updated: 2026-03-28 | [Back to Index](../INDEX.md)*
