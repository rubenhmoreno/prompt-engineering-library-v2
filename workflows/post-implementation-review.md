# Post-Implementation Review

> **Executive Summary:** A structured review workflow that runs three parallel agents on the git diff after implementation. Each agent specializes in one dimension: code reuse, code quality, and efficiency. The review catches over-engineering, missed reuse opportunities, and performance anti-patterns before the code is merged.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [verification-protocol.md](verification-protocol.md), [tdd-workflow.md](tdd-workflow.md), [core/coding-discipline.md](../core/coding-discipline.md) |

---

## Quick Reference Card

### When to Run

- After completing a feature or significant refactor
- Before creating a pull request
- After a TDD green-refactor cycle on a complex module

### Trigger Command

```bash
git diff main --stat    # Review scope: what changed
git diff main           # Full diff for agents to analyze
```

### 3-Agent Structure

```
git diff main
    │
    ├── Agent 1: Code Reuse       ──→ "Did we reinvent existing utilities?"
    ├── Agent 2: Code Quality     ──→ "Is the code clean and maintainable?"
    └── Agent 3: Efficiency       ──→ "Is there unnecessary work at runtime?"
    │
    ▼
Aggregate findings → Fix directly → Re-run tests
```

---

## Full Content

### Agent 1: Code Reuse Reviewer

**Mission:** Find code in the diff that duplicates functionality already available in the project or its dependencies.

**Check for:**

| Flag | Description |
|------|-------------|
| Reinvented utility | New helper that duplicates an existing function in the project |
| Missed library function | Custom code for something the framework/library already provides |
| Copy-paste between modules | Same logic in two places that should be extracted |
| Redundant wrapper | Thin wrapper around a library call that adds no value |
| Parallel implementation | New implementation of something that exists in a different module |

**Agent prompt template:**

```
Review this git diff for code reuse opportunities.

For each finding report:
- File:line where the new code appears
- What existing code or library function it duplicates
- Suggested fix (reference the existing code by file:line)

Scan the full project for existing utilities before reporting.
Output as a markdown table: [File:Line | New Code | Existing Alternative | Action]
```

### Agent 2: Code Quality Reviewer

**Mission:** Find structural and maintainability issues in the changed code.

**Check for:**

| Flag | Description |
|------|-------------|
| Redundant state | State that can be derived from other state instead of stored |
| Parameter sprawl | Functions with 5+ parameters that should use an object/config |
| Copy-paste code | Near-identical blocks that should be a single function |
| Leaky abstraction | Implementation details exposed through the public interface |
| Stringly-typed code | Strings used where enums, constants, or types should be |
| Unnecessary comments | Comments that restate what the code does instead of why |
| Dead code | Code that is unreachable or has no callers |
| Over-engineering | Abstractions, patterns, or configurability beyond what the task requires |

**Agent prompt template:**

```
Review this git diff for code quality issues.

For each finding report:
- File:line
- Issue category (from the flag list)
- Current code (brief quote)
- Suggested improvement

Severity levels: HIGH (must fix), MEDIUM (should fix), LOW (consider fixing).
Output as a markdown table: [File:Line | Category | Severity | Issue | Fix]
```

### Agent 3: Efficiency Reviewer

**Mission:** Find runtime inefficiencies in the changed code.

**Check for:**

| Flag | Description |
|------|-------------|
| Unnecessary work | Computation performed but result unused or redundant |
| Missed concurrency | Independent I/O operations executed sequentially instead of in parallel |
| Hot-path bloat | Heavy computation or I/O in a frequently-called path |
| No-op updates | State updates that write the same value (triggering unnecessary re-renders/queries) |
| TOCTOU | Time-of-check-to-time-of-use races (check existence then act without lock) |
| Memory leak | Resources allocated without cleanup (open files, event listeners, DB connections) |
| Overly broad operation | Loading entire tables/collections when only a subset is needed |
| N+1 queries | Querying inside a loop instead of batch-loading |

**Agent prompt template:**

```
Review this git diff for runtime efficiency issues.

For each finding report:
- File:line
- Issue category (from the flag list)
- Performance impact estimate (HIGH/MEDIUM/LOW)
- Suggested optimization

Output as a markdown table: [File:Line | Category | Impact | Issue | Optimization]
```

### Execution Protocol

```
1. Run all 3 agents in parallel on the same git diff
2. Collect results from all agents
3. Aggregate findings, remove duplicates
4. Prioritize: HIGH severity first, then MEDIUM
5. Fix HIGH and MEDIUM findings directly
6. Re-run the full test suite to confirm no regressions
7. LOW findings: fix only if trivial (< 5 min each)
8. Document any LOW findings deferred to future work
```

### Aggregation Format

After all three agents report, combine into a single summary:

```markdown
## Post-Implementation Review Summary

### Findings

| # | Agent | File:Line | Category | Severity | Issue | Status |
|---|-------|-----------|----------|----------|-------|--------|
| 1 | Reuse | app/utils.py:45 | Reinvented utility | HIGH | Duplicates `lib/helpers.py:12` | Fixed |
| 2 | Quality | app/service.py:23 | Parameter sprawl | MEDIUM | 6 params → use config object | Fixed |
| 3 | Efficiency | app/api.py:89 | N+1 queries | HIGH | Loop queries → batch load | Fixed |
| 4 | Quality | app/models.py:15 | Unnecessary comment | LOW | Restates the field name | Deferred |

### Test Results After Fixes
pytest tests/ -v --cov=app
[paste actual output]

### Verdict
[PASS: all HIGH/MEDIUM fixed, tests green] or [FAIL: outstanding issues]
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Running review on the entire codebase | Review only the git diff (changed files) | Full codebase review is noisy and wastes agent time |
| One agent doing all three reviews | Three specialized agents in parallel | Specialized focus produces deeper, more actionable findings |
| Fixing everything including LOW severity | Fix HIGH and MEDIUM; defer LOW if non-trivial | Diminishing returns on LOW severity fixes; risk of introducing regressions |
| Reviewing without re-running tests after fixes | Always re-run the full test suite after review fixes | Review fixes can introduce regressions just like any other code change |
| Skipping the review "because tests pass" | Tests verify behavior; review verifies quality | Tests don't catch over-engineering, missed reuse, or structural debt |

---

## Related Documents

- [workflows/verification-protocol.md](verification-protocol.md) — Evidence protocol applied after review fixes
- [workflows/tdd-workflow.md](tdd-workflow.md) — The development cycle that precedes this review
- [core/coding-discipline.md](../core/coding-discipline.md) — The rules this review enforces
- [core/multi-agent-orchestration.md](../core/multi-agent-orchestration.md) — Parallel agent execution patterns
- [templates/evidence-report.md](../templates/evidence-report.md) — Evidence format for the review summary

*Last updated: 2026-03-28 | [Back to Index](../INDEX.md)*
