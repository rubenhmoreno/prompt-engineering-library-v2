# Coding Discipline

> **Executive Summary:** Atomic rules that prevent the most common forms of over-engineering in AI-assisted development. Each rule is one concept, one paragraph. Apply all of them on every code change — they complement the 10 core principles in base-programming.md by constraining *how much* you do, not just *how well* you do it.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [base-programming.md](base-programming.md), [error-prevention.md](error-prevention.md), [real-validation.md](real-validation.md) |

---

## Quick Reference Card

| # | Rule | One-liner |
|---|------|-----------|
| 1 | Read before modifying | Never propose changes to code you haven't read |
| 2 | No unnecessary additions | Don't add features, refactors, or improvements beyond what was asked |
| 3 | No premature abstractions | Three similar lines is better than a premature abstraction |
| 4 | No unnecessary error handling | Only validate at system boundaries — trust internal code |
| 5 | No compatibility hacks | Don't rename unused vars, re-export dead types, or comment "removed" |
| 6 | Minimize file creation | Prefer editing existing files over creating new ones |
| 7 | No time estimates | Focus on what needs to be done, not how long it might take |
| 8 | YAGNI ruthlessly | Don't design for hypothetical future requirements |
| 9 | Retry with diagnosis | Read the error, check assumptions, try a focused fix — don't retry blindly |
| 10 | Parallel tool execution | If tool calls have no dependencies, make all calls in a single message |

---

## Full Content

### Rule 1: Read Before Modifying

Do not propose changes to code you haven't read. If a user asks about or wants you to modify a file, read it first. Understand existing code before suggesting modifications.

**Why:** Changes based on assumptions about code structure are the #1 source of regressions in AI-assisted work.

### Rule 2: No Unnecessary Additions

Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability. Don't add docstrings, comments, or type annotations to code you didn't change.

**Why:** Unrequested changes create noise in diffs, make review harder, and introduce risk for zero user benefit.

### Rule 3: No Premature Abstractions

Don't create helpers, utilities, or abstractions for one-time operations. Three similar lines of code is better than a premature abstraction. The right amount of complexity is what the task actually requires — no speculative abstractions, but no half-finished implementations either.

**Why:** Premature abstractions add indirection that makes code harder to understand and maintain, and they are almost always wrong about what the future actually needs.

### Rule 4: No Unnecessary Error Handling

Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs). Don't use feature flags or backwards-compatibility shims when you can just change the code.

**Why:** Defensive code for impossible scenarios obscures the real logic and creates a false sense of safety.

### Rule 5: No Compatibility Hacks

Avoid backwards-compatibility hacks like renaming unused `_vars`, re-exporting types, adding `// removed` comments for removed code. If you are certain that something is unused, delete it completely.

**Why:** Dead code that is "preserved for compatibility" accumulates indefinitely and confuses future readers.

### Rule 6: Minimize File Creation

Do not create files unless they're absolutely necessary for achieving the goal. Prefer editing an existing file to creating a new one. This prevents file bloat and builds on existing work more effectively.

**Why:** Unnecessary files increase cognitive load, complicate navigation, and drift out of sync with the codebase.

### Rule 7: No Time Estimates

Avoid giving time estimates or predictions for how long tasks will take, whether for your own work or for users planning projects. Focus on what needs to be done, not how long it might take.

**Why:** AI time estimates are unreliable and create false expectations that lead to planning failures.

### Rule 8: YAGNI Ruthlessly

Don't design for hypothetical future requirements. Build what is needed now with clean interfaces. If the future requirement arrives, the clean code will be easy to extend. If it doesn't arrive, no time was wasted.

**Why:** Speculative design increases complexity immediately in exchange for benefits that may never materialize.

### Rule 9: Retry with Diagnosis

If an approach fails, diagnose why before switching tactics — read the error, check your assumptions, try a focused fix. Don't retry the identical action blindly, but don't abandon a viable approach after a single failure either.

**Why:** Blind retries waste cycles. Premature strategy switches abandon partially-working approaches.

### Rule 10: Parallel Tool Execution

If you intend to call multiple tools and there are no dependencies between them, make all independent tool calls in parallel. Maximize use of parallel tool calls to increase efficiency. If some calls depend on previous ones, call them sequentially.

**Why:** Sequential tool calls when parallel is possible wastes wall-clock time proportional to the number of calls.

---

## Decision Framework

When unsure whether to add something, ask these three questions:

1. **Did the user ask for this?** If no → don't add it.
2. **Does the task fail without this?** If no → don't add it.
3. **Is this the simplest way to achieve the goal?** If no → simplify.

If all three answers are yes, proceed. Otherwise, leave it out.

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Adding logging, error handling, and docstrings to a 2-line bug fix | Fix the bug, nothing else | Unrequested changes create review noise and risk |
| Creating `utils/helpers.ts` for a function used once | Inline the logic at the call site | Abstraction for one caller adds indirection with no benefit |
| `catch (error) { /* can't happen */ throw error }` | Remove the catch entirely | Dead error handling obscures control flow |
| `// TODO: remove this after migration` on deleted code | Delete the code outright | Comments about removed code outlive their relevance |
| Creating a new file when the function fits in an existing module | Add the function to the existing module | Fewer files = easier navigation and less drift |
| "This will take about 2-3 hours" | "Here's what needs to be done: [list]" | Time estimates are unreliable and create false expectations |
| Building a plugin system for one integration | Hardcode the integration, refactor later if needed | Plugin systems for one use case add complexity with no flexibility gain |

---

## Related Documents

- [core/base-programming.md](base-programming.md) — The 10 core principles (what to do well)
- [core/error-prevention.md](error-prevention.md) — Verification before action
- [core/real-validation.md](real-validation.md) — Evidence requirements
- [workflows/post-implementation-review.md](../workflows/post-implementation-review.md) — 3-agent review that catches violations

*Last updated: 2026-03-28 | [Back to Index](../INDEX.md)*
