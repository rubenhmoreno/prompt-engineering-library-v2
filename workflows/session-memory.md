# Session Memory and Continuity

> **Executive Summary:** Claude Code has no memory between sessions. This document defines the patterns that preserve work, decisions, and context across session boundaries so that each new session picks up exactly where the last one left off — without re-explaining the project from scratch.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [core/claudemd-guide.md](../core/claudemd-guide.md), [core/base-programming.md](../core/base-programming.md), [workflows/verification-protocol.md](verification-protocol.md) |

---

## The Core Problem

Every Claude Code session starts with a blank slate. No memory of previous conversations, no awareness of what was tried and failed, no context about why a decision was made. Without deliberate continuity patterns, each session wastes the first 20–30 minutes reconstructing state that already existed.

The patterns in this document treat session memory as an engineering problem: write state to disk explicitly, read it at the start of the next session, and never rely on implicit recall.

---

## Pattern 1: Summary.md

Write a summary file at the end of every session. The next session reads it first, before any other action.

### File location

```
project-root/
  .claude/
    summary.md      # Current session state
    memory/         # Persistent learnings (see Pattern 3)
```

### Summary template

```markdown
# Session Summary

Updated: <ISO 8601 timestamp>

## Current State

<One paragraph: where the system is right now. What runs, what is broken,
what is partial. Be specific — name files and line numbers if relevant.>

## What Was Completed

- <Concrete item 1 with evidence of completion>
- <Concrete item 2 with evidence of completion>
- <Concrete item 3 with evidence of completion>

## What Is Pending

- [ ] <Task with enough detail to resume without re-explaining>
- [ ] <Task — include the file to edit and the exact change needed>
- [ ] <Task — include any relevant context about why it was deferred>

## Key Decisions Made

| Decision | Rationale | Alternatives Rejected |
|----------|-----------|----------------------|
| <What was decided> | <Why> | <What else was considered and why it lost> |

## Blockers

- <Blocker 1: what is stuck, what was tried, what is needed to unblock>
- <None> if no blockers

## Next Session Start

Read this file, then run:
  <the exact command to verify current system state, e.g., pytest tests/ -v>
Confirm state matches "Current State" above before proceeding.
```

### How to use it

At the end of every session, instruct Claude:

```
Write a session summary to .claude/summary.md using the template.
```

At the start of the next session, instruct Claude:

```
Read .claude/summary.md and confirm the current state before doing anything else.
```

---

## Pattern 2: Checkpoints

A checkpoint is a summary written at a natural milestone during a session, not just at the end. Natural milestones are: completing a feature, passing a test suite, finishing a phase of a larger task.

### When to checkpoint

- After every green TDD cycle that closes a user story
- After a successful deployment to any environment
- Before attempting a risky change (database migration, dependency upgrade)
- After resolving a bug that took more than 30 minutes to find

### Checkpoint file format

Name checkpoints by milestone so they can be found and read later:

```
.claude/checkpoints/
  2026-03-08-auth-module-complete.md
  2026-03-08-pre-migration.md
  2026-03-08-deployment-staging.md
```

### Checkpoint content (abbreviated form)

```markdown
# Checkpoint: <milestone name>

Timestamp: <ISO 8601>

State at this point:
- Tests: <pass count> passing, 0 failing
- Coverage: <X>%
- Files changed: <list>

Safe to resume from here if the next attempt fails.

Resume command: <exact command to verify this state is intact>
```

The key property of a checkpoint is that it is a known-good state. If subsequent work fails, you can rewind to the checkpoint rather than debugging forward from a broken state.

---

## Pattern 3: Cross-Session Learnings via CLAUDE.md Memory Directory

Some knowledge should persist permanently, not just until the end of the session. This goes into the project's persistent memory directory.

### Directory structure

```
project-root/
  .claude/
    memory/
      environment.md      # How this specific environment works
      gotchas.md          # Things that went wrong and their fixes
      decisions.md        # Architectural decisions and their rationale
      tools.md            # Tool quirks and workarounds discovered
```

### When to write to memory

Write to a memory file when you discover something that would save significant time if it were known at the start of a future session:

- A tool behaves differently than documented on this system
- A configuration value that is non-obvious but required
- A pattern that the codebase enforces implicitly
- An error that is cryptic but has a simple fix

### Example: gotchas.md entry

```markdown
## SQLite WAL Mode Required

Date discovered: 2026-03-08

When running concurrent pytest workers with SQLite, tests fail with
"database is locked" errors unless WAL mode is enabled.

Fix: Add this to conftest.py:

    @pytest.fixture(scope="session", autouse=True)
    def enable_wal(db_engine):
        with db_engine.connect() as conn:
            conn.execute(text("PRAGMA journal_mode=WAL"))

Without this fix, `-n auto` parallelism causes random test failures.
```

### Reading memory at session start

Add this to CLAUDE.md:

```markdown
## Memory

At the start of each session, read all files in .claude/memory/ before
taking any action. These files contain environment-specific facts that
override general assumptions.
```

---

## Pattern 4: /rewind as Recovery

When a path of work fails — tests that will not pass, a migration that corrupts state, a refactor that broke more than it fixed — do not debug forward from the broken state. Rewind to the last checkpoint and try a different approach.

### When to rewind

- Three or more attempts to fix the same test have all failed
- A change caused cascading failures in unrelated modules
- The system is in a state that cannot be explained by the changes made

### Rewind procedure

```
1. Stop all current work.

2. Read the most recent checkpoint:
   cat .claude/checkpoints/<most-recent-checkpoint>.md

3. Restore to that state:
   git stash           # save current broken state in case it is useful
   git checkout <checkpoint-commit-hash>
   # or, if no git commit was made at the checkpoint:
   git checkout -- .   # discard all changes

4. Verify the restored state is clean:
   pytest tests/ -v    # must match the checkpoint's test count

5. Write down what was learned from the failed attempt:
   cat >> .claude/memory/gotchas.md << 'EOF'
   ## <date>: <what failed>
   Tried: <approach>
   Failed because: <root cause>
   Do not retry: <specific action to avoid>
   EOF

6. Start a fresh attempt with the new information.
```

Rewinding is not failure. It is the fastest path to success when forward progress has stalled. The cost of rewinding is minutes. The cost of continuing to debug a broken state is often hours.

---

## Pattern 5: Session Forking

When there are two or more viable approaches to a problem and it is not clear which is better without trying both, fork the session into parallel paths.

### How to fork

```
1. Write a checkpoint at the decision point.

2. Label the approaches:
   Branch A: <approach name and one-sentence description>
   Branch B: <approach name and one-sentence description>

3. Implement Branch A fully (or until it clearly fails).
   Write its result to: .claude/forks/branch-a-result.md

4. Rewind to the checkpoint.

5. Implement Branch B fully.
   Write its result to: .claude/forks/branch-b-result.md

6. Compare results and choose.
   Write the decision to .claude/memory/decisions.md.
```

### Fork result file format

```markdown
# Fork Result: Branch <A/B>

Approach: <name>
Date: <ISO 8601>

Outcome: SUCCESS / FAILURE / PARTIAL

Evidence:
  <test results, benchmarks, or other measurable outcome>

Tradeoffs:
  Pros: <list>
  Cons: <list>

Recommendation: <adopt / reject / needs more investigation>
```

---

## Anti-Patterns

| Anti-Pattern | Consequence | Fix |
|---|---|---|
| No session summary | Next session spends 20–30 min reconstructing state | Write .claude/summary.md before ending every session |
| Relying on session memory | Context degrades over a long session as earlier messages drop out of the window | Write checkpoints at milestones; do not trust recollection |
| Checkpoints too infrequent | A failure late in a session requires rewinding to the very beginning | Checkpoint after every completed, tested unit of work |
| Summary without evidence | "Tests are passing" — which tests? how many? | Every state claim in the summary must reference a command and its output |
| Overwriting summary without archiving | A previous session's state is lost when the next session writes a new summary | Keep checkpoints in .claude/checkpoints/ and only overwrite summary.md |
| Memory files that grow without pruning | Memory files become walls of text that are not read | Archive resolved entries; keep active files under 100 lines |

---

## Quick Reference Card

```
Session start:
  cat .claude/summary.md
  cat .claude/memory/*.md
  <run verification command from summary>

During session (at each milestone):
  Write .claude/checkpoints/<date>-<milestone>.md

Session end:
  Write .claude/summary.md (overwrite with current state)
  Append new learnings to .claude/memory/gotchas.md

When stuck (3+ failed attempts):
  Read last checkpoint
  git stash && git checkout <checkpoint>
  Append to .claude/memory/gotchas.md
  Start fresh
```

---

## Related Documents

- [core/claudemd-guide.md](../core/claudemd-guide.md) - How to configure CLAUDE.md to load memory automatically
- [core/base-programming.md](../core/base-programming.md) - Session-start prompt that works with these patterns
- [workflows/verification-protocol.md](verification-protocol.md) - Evidence standards for state claims in summaries
- [workflows/explore-first.md](explore-first.md) - Protocol for reading state when no summary exists
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
