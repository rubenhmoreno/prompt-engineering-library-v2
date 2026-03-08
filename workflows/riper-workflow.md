# RIPER Workflow
> **Executive Summary:** RIPER is a five-phase constraint pattern that prevents the most common failure mode in AI-assisted development: jumping directly to implementation without adequate understanding or planning. Each phase has a single allowed output type. You cannot skip a phase, combine two phases, or return to a previous phase without restarting from it. RIPER wraps TDD — the Execute phase uses RED-GREEN-REFACTOR internally.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [tdd-workflow.md](tdd-workflow.md), [explore-first.md](explore-first.md), [verification-protocol.md](verification-protocol.md), [task-decomposition.md](../templates/task-decomposition.md) |

---

## Quick Reference Card

### Phase Summary Table

| Phase | Allowed Actions | Forbidden Actions | Output |
|-------|----------------|-------------------|--------|
| 1 — RESEARCH | Read files, ask questions, run read-only commands | Suggest solutions, write code, propose changes | Understanding summary |
| 2 — INNOVATE | Propose 2-3 approaches with tradeoffs | Choose an approach, write implementation code | Options matrix |
| 3 — PLAN | Write a numbered step-by-step plan, get approval | Implement anything, start any file changes | Approved numbered plan |
| 4 — EXECUTE | Implement the approved plan exactly, step by step | Deviate from the plan, add unplanned features | Working code + tests |
| 5 — REVIEW | Verify each plan step was completed correctly | Make new changes, add features, skip evidence | Evidence report |

### Phase Transition Rules

```
RESEARCH  -->  INNOVATE  : only after writing the understanding summary
INNOVATE  -->  PLAN      : only after the user acknowledges the options matrix
PLAN      -->  EXECUTE   : only after the user explicitly approves the numbered plan
EXECUTE   -->  REVIEW    : only after all plan steps are done and tests pass
REVIEW    -->  done      : only after every plan step has evidence

If a deviation is discovered during EXECUTE:
  Stop. Return to PLAN. Propose the deviation as an amendment. Get approval. Re-enter EXECUTE.
```

### RIPER vs Jumping to Code

| Dimension | Jump to Code | RIPER |
|-----------|-------------|-------|
| First action | Write code | Read and understand |
| Assumptions | Implicit and unverified | Explicit and written down |
| Plan | None or improvised | Written and approved before any code |
| Deviations | Happen silently | Require explicit approval |
| Review | "Looks good to me" | Evidence matched against plan step by step |
| Rework rate | High | Low |

---

## Full Content

### Phase 1: RESEARCH

**Purpose:** Build a complete, accurate understanding of the problem and the existing codebase before forming any opinion about the solution.

**Allowed actions:**
- Read source files, configuration files, test files
- Run read-only commands (`ls`, `cat`, `grep`, `git log`, `git diff`, `psql -c "SELECT"`)
- Ask the user clarifying questions
- Use the [Explore First workflow](explore-first.md) to structure the investigation

**Forbidden actions:**
- Suggesting a solution, even tentatively ("we could probably...")
- Writing any code, even pseudocode
- Stating a preference for one approach over another

**Required output — Understanding Summary:**

```
=== RESEARCH SUMMARY ===
Problem statement:     [what must be built or fixed, in one sentence]
Current behavior:      [what happens today]
Expected behavior:     [what must happen after the change]
Affected files:        [list of files relevant to the change]
Constraints found:     [performance requirements, compatibility limits, security rules]
Unknowns remaining:    [questions that must be answered before planning]
=== END SUMMARY ===
```

Do not proceed to INNOVATE while any unknowns remain. Resolve them with the user or with additional investigation first.

---

### Phase 2: INNOVATE

**Purpose:** Generate 2-3 distinct implementation approaches and surface their tradeoffs. The goal is to make the choice conscious and deliberate, not to advocate for a particular option.

**Allowed actions:**
- Describe approaches at the conceptual level (no code)
- List specific tradeoffs for each approach
- Identify which approach best fits the constraints found in RESEARCH

**Forbidden actions:**
- Writing implementation code (including pseudocode in executable form)
- Choosing an approach unilaterally — the user must choose
- Proposing only one option (that is a recommendation, not an innovation exercise)

**Required output — Options Matrix:**

```
=== OPTIONS MATRIX ===
Option A: [name]
  Description:  [2-3 sentences]
  Pros:         [bullet list]
  Cons:         [bullet list]
  Best when:    [specific condition]

Option B: [name]
  Description:  [2-3 sentences]
  Pros:         [bullet list]
  Cons:         [bullet list]
  Best when:    [specific condition]

Option C: [name]  (optional)
  Description:  [2-3 sentences]
  Pros:         [bullet list]
  Cons:         [bullet list]
  Best when:    [specific condition]

Recommended:    [Option X — one sentence justification based on constraints]
Decision needed: please select an option before planning begins.
=== END MATRIX ===
```

Wait for the user to select an option before moving to PLAN.

---

### Phase 3: PLAN

**Purpose:** Translate the chosen option into a concrete, numbered, step-by-step implementation plan that is specific enough to be executed mechanically. Every step must be independently verifiable.

**Allowed actions:**
- Write the plan in detail (file paths, function names, test names)
- Identify which steps carry risk and note mitigation
- Ask for clarification on any ambiguous requirement

**Forbidden actions:**
- Starting any implementation work
- Writing any code, even "just to illustrate" a step
- Moving to EXECUTE before the user explicitly approves the plan

**Required output — Numbered Plan:**

```
=== IMPLEMENTATION PLAN ===
Selected option:  [Option X from INNOVATE phase]
Total steps:      [N]

Step 1: [Specific action — e.g., "Create file src/services/payment_service.py with class PaymentService"]
  File:           [path]
  Verification:   [how to confirm this step is done]

Step 2: [Specific action]
  File:           [path]
  Verification:   [how to confirm this step is done]

...

Step N: [Run full test suite and confirm coverage above 80%]
  Command:        [exact command]
  Verification:   [expected output]

Risk steps:       [list step numbers that carry higher risk and why]

AWAITING APPROVAL — please confirm before execution begins.
=== END PLAN ===
```

The plan is immutable once approved. Any deviation discovered during EXECUTE requires returning to PLAN with an amendment proposal.

---

### Phase 4: EXECUTE

**Purpose:** Implement the approved plan exactly as written, one step at a time. After each step, confirm completion before moving to the next. Use TDD internally for any step that involves business logic.

**Allowed actions:**
- Implement steps in the approved order
- Use RED-GREEN-REFACTOR for each logical unit of behavior (see [tdd-workflow.md](tdd-workflow.md))
- Report step completion with the verification output specified in the plan

**Forbidden actions:**
- Implementing steps out of order
- Adding any feature, improvement, or cleanup not listed in the approved plan
- Continuing past a failing step without stopping and flagging it
- Silently fixing an unrelated bug discovered along the way (log it; address it in a separate task)

**Step completion report format:**

```
Step [N] — COMPLETE
  Action taken:   [what was done]
  Evidence:       [command output or file diff]
  Next step:      Step [N+1]: [description]
```

**TDD inside EXECUTE:**

For any step that creates or modifies business logic:

```
Step N — implementing create_payment()
  RED:     wrote test_create_payment_charges_correct_amount — FAILED (ImportError)
  GREEN:   implemented PaymentService.create_payment() — PASSED
  REFACTOR: extracted amount validation to _validate_amount() — all tests still PASSED
  Step N — COMPLETE
```

**When a deviation becomes necessary:**

```
EXECUTE PAUSED — deviation required
  Planned step:   [step N as written]
  Discovered:     [what makes the plan unexecutable as written]
  Proposed amendment: [new step N or replacement steps]
  Returning to PLAN for approval.
```

---

### Phase 5: REVIEW

**Purpose:** Verify that every approved plan step was completed correctly and that the resulting system behaves as described in the RESEARCH summary. This phase produces an evidence report, not a code review.

**Allowed actions:**
- Run any command needed to verify a plan step
- Compare actual output to the verification criteria in the plan
- Mark steps as VERIFIED or FLAG for issues

**Forbidden actions:**
- Making additional code changes (open a new task if problems are found)
- Skipping any plan step in the review
- Accepting "it should work" as evidence — every step needs actual output

**Required output — Evidence Report:**

```
=== EVIDENCE REPORT ===
Plan steps total:   [N]
Steps verified:     [N]
Steps flagged:      [0 or list]

Step 1 — VERIFIED
  Verification command:  [command run]
  Output:                [actual output]

Step 2 — VERIFIED
  Verification command:  [command run]
  Output:                [actual output]

...

Overall result:     [PASS / FAIL]
Original problem:   [restate from RESEARCH]
Current behavior:   [confirmed behavior after implementation]
Coverage:           [N% — from test run output]
Open issues:        [list or "none"]
=== END REPORT ===
```

See [evidence-report.md](../templates/evidence-report.md) for the full evidence report template.

---

### How RIPER Complements TDD

RIPER operates at the task level. TDD operates at the function level. They work at different granularities and do not conflict.

```
RIPER task lifecycle:
  RESEARCH  -> understand the feature
  INNOVATE  -> choose the design
  PLAN      -> define steps (each step = 1-3 TDD cycles)
  EXECUTE   -> for each step:
                 RED   (write failing test)
                 GREEN (implement minimum)
                 REFACTOR (clean up)
  REVIEW    -> verify all steps with evidence

TDD is the engine inside each EXECUTE step.
RIPER is the frame that ensures you build the right thing before you build it.
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Skip RESEARCH because the task "seems simple" | Always complete RESEARCH; simple-looking tasks often have hidden constraints | The constraint is usually not in the task itself but in the codebase surrounding it |
| Combine INNOVATE and PLAN in one step | Keep them strictly separate | INNOVATE is for generating options; PLAN is for detailing one option — merging them produces a plan without alternatives, which is a guess dressed up as a plan |
| Deviate from the approved plan during EXECUTE without flagging it | Pause EXECUTE, propose an amendment in PLAN, get approval, then resume | Silent deviations accumulate technical debt and produce a final state that no one approved |
| Write REVIEW as a narrative ("everything looks good") | Write REVIEW as a step-by-step evidence checklist with actual command output | Narrative reviews mask skipped verifications and produce false confidence |
| Present only one option in INNOVATE | Always present at least two | A single option is not a choice; it is a disguised directive |
| Use RIPER for a one-line typo fix | Use judgment; RIPER is for non-trivial tasks with design decisions | Applying RIPER to trivial changes creates process overhead with no benefit |

---

## Related Documents

- [tdd-workflow.md](tdd-workflow.md) — RED-GREEN-REFACTOR cycle used inside the Execute phase
- [explore-first.md](explore-first.md) — Structured codebase investigation used as the Research phase input
- [verification-protocol.md](verification-protocol.md) — Evidence standards applied during the Review phase
- [evidence-report.md](../templates/evidence-report.md) — Template for the Review phase output
- [task-decomposition.md](../templates/task-decomposition.md) — How to break a feature into RIPER-sized tasks before starting

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
