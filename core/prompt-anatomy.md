# Prompt Anatomy for Claude

> **Executive Summary:** A structured breakdown of Anthropic's 10-component prompt model for Claude. Use this document to build prompts that are complete, unambiguous, and consistent across sessions. The Session Composition Guide at the end maps every common task type to the exact library files that should be injected into the prompt.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [base-programming.md](base-programming.md), [prompting-techniques.md](prompting-techniques.md), [multi-agent-orchestration.md](multi-agent-orchestration.md), [agentic-safety.md](agentic-safety.md) |

---

## Quick Reference Card

### The 10 Components at a Glance

| # | Component | Where it goes | Required? |
|---|-----------|---------------|-----------|
| 1 | Task context | System or user | Yes |
| 2 | Tone context | System | Yes |
| 3 | Background data | User | Situational |
| 4 | Rules and constraints | System | Yes |
| 5 | Examples | User | Strongly recommended |
| 6 | Conversation history | Managed by API | Auto |
| 7 | Immediate task | User | Yes |
| 8 | Chain of thought | User | Situational |
| 9 | Output format | System or user | Yes |
| 10 | Prefilled response | Removed in Claude 4.6 | Never use |

### Thin Prompt vs Full Prompt

**Thin prompt (3-4 components) — use for simple, low-stakes tasks:**
```
[Task context] You are a senior Python engineer.
[Rules] Follow PEP 8.
[Immediate task] Rename this variable to something descriptive: x = get_users()
[Output format] Return only the new line of code, no explanation.
```

**Full prompt (all applicable components) — use for complex or agentic tasks:**
```
[Task context] You are a senior backend engineer working on a FastAPI service.
[Tone context] Technical, concise, no filler phrases.
[Background data] The service uses SQLModel with a PostgreSQL database. The current
  endpoint mixes query logic and HTTP response logic in the same function.
[Rules] Never modify existing tests. Keep backward compatibility. Follow the
  repository's existing naming conventions.
[Examples] See: tests/test_users.py for the expected test style.
[Immediate task] Refactor the /users endpoint to separate DB logic into a service layer.
[Chain of thought] Before writing code: list the files you will touch, the interfaces
  you will introduce, and any risk of breaking changes.
[Output format] Produce file diffs in unified diff format. List changed files first.
```

---

## Full Content

### The 10 Components Explained

**1. Task Context**

Tells Claude what domain and role it is operating in. This is the "who are you in this session" signal. A precise task context reduces hallucination and keeps all outputs within the relevant technical domain.

```
You are a senior DevOps engineer. The system runs on Ubuntu 22.04 with
Docker Compose. All services write structured JSON logs to stdout.
```

A vague task context ("You are a helpful assistant") produces generic answers. A precise one produces answers calibrated to your actual stack.

**2. Tone Context**

Sets the formality level, audience, and communication style. Without this, Claude defaults to a neutral, slightly verbose academic tone that is often not what engineers want.

```
Tone: technical and direct. Omit phrases like "Great question!" or
"Certainly!". Use active voice. Prefer bullet points over paragraphs
for lists of steps.
```

**3. Background Data**

Relevant information about the current state of the system, codebase, or problem. This is where you paste error logs, relevant file contents, schema definitions, or any facts Claude needs that are not in its training data.

```
Current error (from application log):
  sqlalchemy.exc.IntegrityError: UNIQUE constraint failed: users.email
  Context: POST /api/users called at 14:32:01 with {"email": "a@b.com"}
```

Keep background data focused. Pasting an entire 2000-line file when only 30 lines are relevant adds noise and increases token cost.

**4. Rules and Constraints**

Hard limits that must not be violated. These are non-negotiable boundaries that override Claude's default behavior.

```
Rules:
- Never delete files. Use soft-delete (is_deleted = True) only.
- Never hardcode secrets. All credentials must come from environment variables.
- All SQL must use parameterized queries. No string interpolation in queries.
- Every new function must have a corresponding pytest test before implementation.
```

**5. Examples**

Input/output pairs that demonstrate the expected behavior. Examples are the most powerful calibration tool available. They teach format, length, style, and edge-case handling better than any description.

```
Example — function documentation style:
Input:  def get_user(user_id: int) -> User:
Output:
  def get_user(user_id: int) -> User:
      """
      Retrieve a single user by primary key.

      Args:
          user_id: The integer primary key of the user record.

      Returns:
          User model instance.

      Raises:
          NotFoundError: If no user exists with the given ID.
      """
```

Provide at least two examples for formatting tasks, and at least one for structural tasks. If you cannot provide examples, use Few-Shot prompting with synthetic data.

**6. Conversation History**

Prior turns in the session. Managed automatically by the API when you maintain the `messages` array. You do not construct this manually, but you do manage it:

- Keep the history to the last 8-12 turns for most tasks.
- Summarize and compress old turns when context window pressure is high.
- Start a new session when the task fundamentally changes to avoid stale context contaminating new instructions.

**7. Immediate Task**

The specific request for this turn. This is the core directive. It should be one focused action, not a list of five things. If you have multiple tasks, use separate turns or a multi-agent setup.

```
Immediate task: Write a pytest fixture that creates a test SQLite database,
inserts three sample users, yields the session, then drops all tables on teardown.
```

**8. Chain of Thought**

Explicit instructions to reason before acting. Use this for debugging, architecture decisions, and any task where a wrong assumption early in the reasoning chain produces a completely wrong output.

```
Before writing any code:
1. Identify which files are affected.
2. State the interface you will introduce and why.
3. List any edge cases that could break the existing tests.
4. Only then produce the implementation.
```

See [prompting-techniques.md](prompting-techniques.md) for the full Chain of Thought, Tree of Thoughts, ReAct, and Self-Consistency patterns.

**9. Output Format**

Explicit specification of how the response must be structured. Without this, Claude makes a format choice that may not match your tooling or workflow.

```
Output format:
- Produce a unified diff (diff -u style).
- Follow the diff with a "Test plan" section listing the pytest commands to verify.
- Do not include explanatory prose inside the diff block.
```

**10. Prefilled Response (Removed in Claude 4.6)**

Older versions of the Claude API allowed an `assistant` turn prefix to steer the start of the response. This feature was removed in Claude 4.6. Sending a prefilled response in the API now returns HTTP 400. Do not use it. Use component 9 (output format) to control response structure instead.

---

### System Prompt vs User Prompt

The two message roles serve different purposes. Mixing them produces inconsistent behavior.

| Concern | System prompt | User prompt |
|---------|---------------|-------------|
| Role definition | Yes | No |
| Tone and style | Yes | No |
| Hard rules and constraints | Yes | Acceptable for session-specific rules |
| Background data | No | Yes |
| Examples | Rarely (global patterns only) | Yes |
| Immediate task | No | Yes |
| Chain of thought instructions | No | Yes |
| Output format | Yes (default format) | Yes (override for this turn) |

**Rule of thumb:** The system prompt defines who Claude is and what it must never do. The user prompt defines what Claude must do right now.

```
# System prompt (role definition only)
You are a senior Python backend engineer. You write production-quality code.
Rules: TDD, PEP 8, no hardcoded secrets, parameterized queries only.
Default output: unified diffs followed by a test plan.

# User prompt (task + context + examples)
Background: The /users endpoint currently does not validate email format.
Task: Add Pydantic email validation to the UserCreate schema.
Show your reasoning before writing code. Output as a unified diff.
```

---

### Session Composition Guide

Inject these library files into the session prompt for each task type. Load `base-programming.md` via `--append-system-prompt-file` to get 90% prompt caching cost reduction after the first turn — the large base file is cached and only the smaller user-prompt additions are billed at full rate.

| Task type | System prompt files | User prompt additions |
|-----------|---------------------|-----------------------|
| Debugging | base-programming + error-prevention | ReAct pattern from prompting-techniques |
| Architecture design | base-programming + prompting-techniques (ToT + Step-Back) | agents/api-architect |
| Multi-agent orchestration | base-programming + multi-agent-orchestration | relevant agent definitions |
| Security audit | base-programming + agentic-safety | agents/security-auditor + real-validation |
| New feature (TDD) | base-programming + real-validation | workflows/tdd-workflow + relevant agents |
| Performance optimization | base-programming + error-prevention | agents/performance-engineer + real-validation |

**Prompt caching note:** Anthropic's prompt caching activates when a system prompt prefix is reused across turns. Loading `base-programming.md` through `--append-system-prompt-file` (or by keeping the system prompt identical across turns in the API) reduces cost by approximately 90% after the first turn. The user prompt changes each turn and is always billed at full rate.

---

## Anti-Patterns

| Anti-pattern | What happens | Fix |
|---|---|---|
| Vague task context ("helpful assistant") | Generic, non-technical responses | Specify role, stack, and domain explicitly |
| Missing output format | Claude chooses format; rarely matches your tooling | Always specify format in system or user prompt |
| No examples for formatting tasks | Inconsistent structure across responses | Provide at least two input/output examples |
| Implicit requirements ("make it better") | Claude guesses what "better" means | State the specific quality dimension: speed, readability, test coverage |
| Mixing role definition and immediate task in system prompt | Stale task instructions bleed into future turns | Role definition in system; immediate task in user |
| Using prefilled response in Claude 4.6 | HTTP 400 error | Use output format component instead |
| Single massive user prompt with 10 tasks | Claude addresses some tasks partially or skips others | One task per turn, or use multi-agent for parallel work |
| Pasting entire files as background data | Context window waste, increased cost, diluted signal | Extract only the relevant 20-40 lines |

---

## Related Documents

- [base-programming.md](base-programming.md) — The master session prompt covering 10 core engineering principles
- [prompting-techniques.md](prompting-techniques.md) — CoT, Few-Shot, Step-Back, Self-Consistency, ToT, ReAct patterns
- [multi-agent-orchestration.md](multi-agent-orchestration.md) — Parallel agent coordination framework
- [agentic-safety.md](agentic-safety.md) — Scope controls and safety boundaries for autonomous agents
- [real-validation.md](real-validation.md) — Evidence protocol for proving tasks are complete
