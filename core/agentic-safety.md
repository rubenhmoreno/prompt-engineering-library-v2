# Agentic Safety Controls

> **Executive Summary:** Safety controls for autonomous Claude Code agent sessions. Defines how to bound an agent's scope before launch, which action patterns to block unconditionally, when to insert human checkpoints, and how to detect and stop scope drift at runtime. Apply these controls to every session that gives an agent write access to files, databases, or external services.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [base-programming.md](base-programming.md), [multi-agent-orchestration.md](multi-agent-orchestration.md), [real-validation.md](real-validation.md), [prompt-anatomy.md](prompt-anatomy.md) |

---

## Quick Reference Card

### Pre-Launch Checklist

Before starting any autonomous agent session, confirm:

- [ ] Scope is written down: what the agent CAN touch and CANNOT touch
- [ ] Action blocklist is loaded into the system prompt
- [ ] Human checkpoint triggers are defined
- [ ] Agent has read-only access to everything outside its declared scope
- [ ] A rollback plan exists (git branch, DB backup, snapshot)

### Blocklist — Block These Unconditionally

```
BLOCKED ACTIONS (agent must not execute):
- rm -rf, rmdir /s, del /f — recursive deletion
- DROP TABLE, TRUNCATE, DELETE without WHERE
- git push --force, git reset --hard on shared branches
- Any command reading or transmitting files matching: *.env, *.pem, *.key, id_rsa*
- curl/wget piped directly to bash or sh
- chmod 777 on any path
- Modifying files outside the declared scope directory
```

---

## Full Content

### 1. Scope Definition Before Launch

Scope must be written explicitly before an agent session begins. An agent without a written scope will expand to fill whatever the task description implies, which is almost always wider than intended.

**Scope definition template:**

```
AGENT SCOPE — [task name] — [date]

PERMITTED:
- Read and write files under: /home/project/src/
- Run: pytest, ruff, mypy, git status, git diff, git add, git commit
- Query the development database: dev.sqlite (SELECT, INSERT, UPDATE only)
- Create new branches: feature/* prefix only

FORBIDDEN:
- Modifying files outside /home/project/src/
- Any git push
- DROP, TRUNCATE, or DELETE without a WHERE clause
- Reading .env files or any file matching *.key, *.pem
- Installing system packages (apt, brew, pip at system level)
- Any network request to external services
```

Paste this scope block into the system prompt as a `RULES` section. Claude treats explicit rules as hard constraints when they are placed in the system prompt.

**Why scope definition matters:** An agent given "fix the authentication bug" without a written scope may decide that fixing the bug requires updating the deployment configuration, which requires pushing to the remote, which requires... Each step is locally reasonable but the cumulative drift from the original intent is dangerous.

---

### 2. Action Risk Taxonomy

Before executing any non-trivial action, classify it into one of four risk categories. Higher categories require more caution.

| Category | Risk Level | Examples | Required Before Executing |
|----------|-----------|---------|--------------------------|
| **Destructive** | Critical | `rm -rf`, `DROP TABLE`, `git reset --hard`, `docker system prune -a`, killing processes | Written scope permission + explicit human confirmation |
| **Hard to Reverse** | High | `git push --force`, amending published commits, removing/downgrading dependencies, modifying CI/CD pipelines, database migrations on production | Human confirmation + rollback plan documented |
| **Shared State** | Medium | `git push`, creating/closing/commenting on PRs/issues, sending messages (Slack, email, GitHub), modifying shared infrastructure or permissions | Human confirmation for first occurrence; scope-limited repeat approval |
| **Third-Party Uploads** | Medium | Uploading to pastebins, diagram renderers, gists, external APIs | Consider sensitivity — content may be cached/indexed even if later deleted |

**Key rules:**
- Approval for one action does **not** grant blanket authorization for similar actions
- A user asking "is it possible to...?" is **not** authorization to do it
- When encountering an obstacle, do not use destructive actions as a shortcut — identify root causes first
- If you discover unexpected state (unfamiliar files, branches, configuration), **investigate before deleting** — it may be the user's in-progress work

### 3. Action Blocklist Patterns

Some action patterns must be blocked regardless of context. These are unconditional rules, not guidelines.

#### Destructive Commands

```
Patterns to block:
  rm -rf *
  find . -delete
  DROP TABLE
  TRUNCATE TABLE
  DELETE FROM <table>          # without WHERE
  git push --force
  git push --force-with-lease  # also blocked on main/master
  git reset --hard
  git checkout -- .
  git clean -fd
```

**Implementation:** Load these patterns into the system prompt rules section. For tool-use agents (agents that execute bash commands), add a pre-execution hook that pattern-matches the command string before execution. See [hooks-guide.md](hooks-guide.md) for hook implementation.

#### Secrets Exfiltration Patterns

An agent that reads credentials and then makes a network request has exfiltrated secrets, even if unintentionally.

```
Block any sequence that:
1. Reads a file matching: .env, *.pem, *.key, id_rsa*, credentials.json
   followed by:
2. Any network operation: curl, wget, requests.get, fetch, httpx

Also block direct transmission of:
- Strings matching: sk-*, ghp_*, AWS_*, POSTGRES_PASSWORD=*
- Environment variable dumps: env, printenv, os.environ (when output is logged externally)
```

#### Scope Creep Signals

These are not immediate blocks but are signals that the agent is drifting outside its assigned task:

- Modifying a file that was not mentioned in the original task
- Running a command that installs new software
- Creating a new git remote or modifying `.git/config`
- Accessing a database other than the one named in scope
- Making an outbound HTTP request to a domain not in the approved list

When a scope creep signal is detected, the agent should pause and state what it is about to do and why, before proceeding.

---

### 4. Human Checkpoint Triggers

These events must pause autonomous execution and require explicit human confirmation before continuing.

| Trigger | Why it requires confirmation |
|---------|------------------------------|
| About to delete any file, even temporarily | Deletion is often irreversible even with git |
| About to run a migration on a non-development database | Schema changes are hard to reverse |
| Task requires touching more than 5 files | Wide impact increases the chance of unintended breakage |
| An error occurred and the agent proposes a workaround | Workarounds often mask the real problem |
| The agent cannot find a file it expected to exist | Assumption failure — the scope may be wrong |
| The agent proposes adding a new dependency | Dependencies affect the whole project, not just the task |
| Confidence is low or the agent expresses uncertainty | If the agent is unsure, the human should decide |

**Checkpoint format** — when an agent hits a checkpoint, it must output:

```
CHECKPOINT — Human confirmation required.
Action I am about to take: [exact command or change]
Reason: [why this action is needed for the task]
Risk: [what could go wrong]
Alternatives: [what I could do instead if you say no]
Awaiting your go/no-go.
```

---

### 5. Dual-Layer Security Model

Agent safety requires two independent layers. One layer alone is insufficient.

**Layer 1 — Rules Layer (what is allowed)**

Defined in the system prompt. Enumerates permitted and forbidden actions explicitly. This layer is fast but static — it cannot reason about context.

```
# In system prompt:
RULES (non-negotiable):
- Only modify files under /project/src/
- Never run destructive SQL
- Never read credential files
- Pause and ask before any action not covered by these rules
```

**Layer 2 — Evaluation Layer (is this specific action within scope?)**

Applied at execution time. Before each significant action, the agent evaluates:

1. Is this action type on the permitted list?
2. Does this specific target (file path, table name, endpoint) fall within the declared scope?
3. Does this action have side effects that extend beyond the scope boundary?
4. Has this action type already been confirmed by the human in this session?

The evaluation layer catches actions that are technically permitted by type but wrong in context. Example: the agent is permitted to run `git commit` but is about to commit a file that contains a hardcoded API key. The rules layer allows it; the evaluation layer catches it.

---

### 6. Runtime Drift Detection

Scope drift is gradual. A single step outside scope may be acceptable (or at least low-risk), but three steps outside scope in sequence means the agent has fundamentally misunderstood or abandoned the original task.

**Drift detection heuristics:**

- **File distance:** Is the agent touching files more than two directory levels above the declared scope root?
- **Command novelty:** Is the agent running a command type it has not run before in this session, without explaining why?
- **Task distance:** Is the current action directly traceable to the original task description? If the agent needs more than two reasoning steps to connect the action to the task, it has drifted.
- **Escalating permissions:** Is the agent requesting elevated access (sudo, admin credentials, write access to production)?

**When drift is detected:**

```
DRIFT ALERT — Agent output:
Original task: [restate the task from the beginning of the session]
Current action: [what I am about to do]
Connection to original task: [my reasoning — if I cannot state this clearly, I stop]
I am pausing because this action is outside my declared scope.
Please confirm, redirect, or terminate this session.
```

---

## Anti-Patterns

| Anti-pattern | Consequence | Correct approach |
|---|---|---|
| Giving write access to all directories for an auditor agent | Auditor modifies files it was only supposed to read | Auditor agents get read-only filesystem access by default |
| No scope boundaries in the system prompt | Agent expands task scope based on its own judgment | Always define explicit PERMITTED / FORBIDDEN sections |
| Trusting agent self-assessment ("I'm confident this is safe") | Agents are confident when wrong more often than humans expect | Require external verification for all destructive actions |
| No rollback plan before autonomous session | One wrong command produces an unrecoverable state | Always create a git branch and DB backup before launch |
| Single-layer security (rules only, no evaluation) | Static rules miss context-dependent violations | Pair rules with a per-action evaluation step |
| Human checkpoints only at the end of the session | Damage accumulates undetected throughout the session | Insert checkpoints at high-risk action types, not just at the end |
| Vague forbidden list ("don't do anything harmful") | Agent interprets "harmful" in ways that differ from intent | Enumerate specific forbidden commands and file patterns |

---

## Related Documents

- [base-programming.md](base-programming.md) — Core engineering principles including the "verify before act" mandate
- [multi-agent-orchestration.md](multi-agent-orchestration.md) — How to coordinate multiple agents safely
- [real-validation.md](real-validation.md) — Evidence requirements that apply to agent output verification
- [hooks-guide.md](hooks-guide.md) — Implementation of pre-execution safety hooks
- [prompt-anatomy.md](prompt-anatomy.md) — How to structure the system prompt to enforce safety rules
