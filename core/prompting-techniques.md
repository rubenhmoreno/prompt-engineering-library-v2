# Prompting Techniques for Software Development

> **Executive Summary:** Six proven prompting techniques that improve the quality of AI-generated code, debugging, and architectural decisions. Each technique includes when to activate it, a reusable template, and a concrete software development example. Use the activation table below to know which technique to apply in your current situation.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [base-programming.md](base-programming.md), [multi-agent-orchestration.md](multi-agent-orchestration.md), [error-prevention.md](error-prevention.md) |

---

## Quick Reference Card

### Activation Table

Use this table to decide which technique to apply right now:

| You are... | Use this technique | Why |
|------------|-------------------|-----|
| Debugging a complex error | Chain of Thought | Forces step-by-step reasoning, catches wrong assumptions |
| Wanting a specific output format (JSON, SQL, YAML) | Few-Shot | Examples teach the pattern better than descriptions |
| Stuck on implementation details | Step-Back | Zooming out to principles reveals the right approach |
| Making a critical architecture decision | Self-Consistency | Multiple reasoning paths reduce the risk of a bad choice |
| Evaluating multiple solution approaches | Tree of Thoughts | Explores branches before committing to one |
| Needing the AI to verify its own work | ReAct | Interleaves reasoning with actual command execution |
| Irreversible architectural decisions, complex dependency analysis, security threat modeling | Extended Thinking | Forces deeper reasoning at higher token cost. Use `effort: max` for critical decisions, `effort: medium` for standard work (saves ~76% output tokens) |

### One-Line Rules

- Complex logic or math? Add **"Let's think step by step"** (CoT)
- Need consistent format? Give **2-3 examples** of the desired output (Few-Shot)
- Stuck? Ask **"What are the general principles behind this problem?"** first (Step-Back)
- Critical decision? Ask the **same question 3 different ways** and compare (Self-Consistency)
- Multiple valid approaches? Ask to **list pros/cons of each before choosing** (ToT)
- Need proof? Ask to **run the command and show the output** before concluding (ReAct)

---

## Full Content

### 1. Chain of Thought (CoT)

**What it is:** Instruct the AI to show its reasoning step by step before giving a final answer. This prevents the AI from jumping to conclusions and makes errors in logic visible.

**When to activate:**
- Debugging errors with multiple possible causes
- Writing complex business logic (calculations, state machines, workflows)
- Reviewing code for subtle bugs
- Any task where the answer depends on multiple connected facts

**Template:**
```
[Your task description]

Think through this step by step:
1. What is the current state?
2. What is the expected state?
3. What could cause the difference?
4. What is the most likely root cause?
5. What is the minimum fix?
```

**Software development example — Debugging a race condition:**
```
The user creation endpoint sometimes returns duplicate users.
The code uses: check if email exists → create user.

Think through this step by step:
1. What happens if two requests arrive at the same time?
2. Can both pass the "email exists" check before either creates?
3. What database-level protection would prevent this?
4. Show the fix with a unique constraint and proper error handling.
```

The AI will reason through the time-of-check-time-of-use (TOCTOU) problem instead of just adding a random lock, producing a better solution: a unique DB constraint with an IntegrityError handler.

**When NOT to use:** Simple, deterministic tasks where the answer is obvious (renaming a variable, adding an import). CoT adds tokens without value when the task is trivial.

---

### 2. Few-Shot Prompting

**What it is:** Provide 2-3 examples of input-output pairs before your actual request. The AI learns the pattern from examples and applies it consistently.

**When to activate:**
- You need a specific output format (JSON, YAML, SQL, test structure)
- Converting between formats (migration scripts, API transformations)
- Generating repetitive but structured code (CRUD endpoints, test cases)
- The AI keeps giving output in the wrong format despite instructions

**Template:**
```
[Task description]

Example 1:
Input: [example input]
Output: [example output]

Example 2:
Input: [example input]
Output: [example output]

Now apply the same pattern:
Input: [your actual input]
Output:
```

**Software development example — Generating consistent test cases:**
```
Write pytest test cases for the UserService class.

Example 1:
Method: create_user(email, password)
Test:
def test_create_user_hashes_password():
    user = UserService().create_user("a@b.com", "Secret123")
    assert user.email == "a@b.com"
    assert user.password != "Secret123"
    assert verify_hash(user.password, "Secret123")

Example 2:
Method: create_user(email, password) with duplicate email
Test:
def test_create_user_duplicate_email_raises():
    svc = UserService()
    svc.create_user("a@b.com", "Secret123")
    with pytest.raises(ValueError, match="already exists"):
        svc.create_user("a@b.com", "Other456")

Now apply the same pattern:
Method: update_email(user_id, new_email)
Test:
```

The AI will generate a test that follows the exact same structure: descriptive name, arrange-act-assert, specific assertions.

**When NOT to use:** Creative or exploratory tasks where you want the AI to surprise you with its approach. Few-shot constrains creativity by design.

---

### 3. Step-Back Prompting

**What it is:** Before tackling the specific problem, ask the AI to first consider the general principles or broader context. Then use that background to inform the specific solution.

**When to activate:**
- You are stuck on a specific implementation detail
- You need to choose between multiple design patterns
- The AI keeps giving shallow or generic answers
- You are working in an unfamiliar domain or technology

**Template:**
```
Step 1 (step back):
What are the general principles and best practices for [broad topic]?

Step 2 (apply):
Given those principles, [specific task or problem].
```

**Software development example — Choosing a caching strategy:**
```
Step 1:
What are the general principles of caching in web applications?
Consider: cache invalidation strategies, cache levels (browser,
CDN, application, database), consistency vs performance tradeoffs,
and common pitfalls.

Step 2:
Given those principles, design a caching strategy for our
product catalog API. The catalog has 50,000 products, updates
happen 3-4 times per day, and we need sub-100ms P95 response time.
Specify which cache level to use, TTL values, and invalidation approach.
```

Without the step-back, the AI might jump to "add Redis with a 1-hour TTL." With the step-back, it considers the full picture and proposes a layered strategy: CDN for static product images, Redis for product listings with event-driven invalidation, and no cache for inventory counts.

**When NOT to use:** When you already know the principles and just need the implementation. The step-back adds overhead if the general knowledge is not the bottleneck.

---

### 4. Self-Consistency

**What it is:** Ask the same question multiple times (or ask the AI to reason through the problem from multiple angles) and compare the answers. The most consistent answer across attempts is likely the most correct one.

**When to activate:**
- Making a critical architectural decision (database choice, auth strategy, service boundaries)
- Security-sensitive code where one wrong path has serious consequences
- Estimating complexity or feasibility of a task
- Verifying a diagnosis when debugging

**Template:**
```
I need to [decision/task]. Reason through this from three
different perspectives:

Perspective 1: Approach it from a performance standpoint.
Perspective 2: Approach it from a maintainability standpoint.
Perspective 3: Approach it from a security standpoint.

For each perspective, state your recommendation and why.
Then identify which recommendation is consistent across
all three perspectives.
```

**Software development example — Choosing between JWT and session-based auth:**
```
We need to implement authentication for a multi-tenant SaaS API.

Reason through the auth strategy from three perspectives:

1. Security: Which approach (JWT vs server-side sessions) has
   fewer attack vectors for our multi-tenant case?
2. Scalability: Which approach scales better when we add
   more API servers behind a load balancer?
3. Developer experience: Which approach is simpler to implement
   correctly and harder to misconfigure?

For each, state your recommendation with specific reasons.
Then identify the consensus recommendation.
```

If JWT wins 2/3 perspectives and sessions win 1/3, the reasoning is transparent and the decision is well-justified.

**When NOT to use:** Tasks with a single correct answer (syntax errors, straightforward implementations). The overhead of multi-perspective analysis is not justified.

---

### 5. Tree of Thoughts (ToT)

**What it is:** Instead of following one reasoning path, explore multiple solution branches in parallel, evaluate each one, then select the best. This is CoT applied to decision-making with multiple valid options.

**When to activate:**
- Designing a system architecture with multiple valid approaches
- Refactoring code where several patterns could apply
- Choosing between technologies or frameworks
- Planning migration strategies (multiple viable paths)

**Template:**
```
[Task description]

Explore three possible approaches:

Branch A: [Approach description]
- Implementation sketch
- Pros
- Cons
- Risk

Branch B: [Approach description]
- Implementation sketch
- Pros
- Cons
- Risk

Branch C: [Approach description]
- Implementation sketch
- Pros
- Cons
- Risk

Select the best branch based on [your criteria] and explain why.
Proceed with implementation.
```

**Software development example — Database migration strategy:**
```
We need to split the monolithic `users` table (2M rows) into
`users` + `user_profiles` without downtime.

Explore three migration approaches:

Branch A: Blue-green migration (create new tables, dual-write,
          backfill, switch reads, drop old columns)
Branch B: Online schema change (use gh-ost or pt-online-schema-change)
Branch C: Application-level migration (add new table, migrate
          reads/writes incrementally with feature flags)

Evaluate each for: downtime risk, rollback complexity,
development effort, and data consistency guarantees.

Select the best and produce the migration plan.
```

**When NOT to use:** When there is clearly one right answer, or when time pressure makes exploration impractical. ToT is for decisions worth thinking through carefully.

---

### 6. ReAct (Reason + Act)

**What it is:** The AI alternates between reasoning about the problem and taking actions (running commands, reading files, checking outputs) to gather real information. This is the antidote to hallucinated conclusions.

**When to activate:**
- Debugging with real systems (services, databases, file systems)
- Deploying and verifying a deployment
- Investigating production incidents
- Any task where the AI needs to verify its assumptions against reality

**Template:**
```
[Task description]

Follow this loop:
1. THOUGHT: State what you think the issue is and why
2. ACTION: Run a specific command to verify your thought
3. OBSERVATION: Report what the command actually returned
4. Repeat until the root cause is confirmed with evidence

Only propose a fix after you have confirmed the root cause
with real command output.
```

**Software development example — Debugging a failing health check:**
```
The /health endpoint returns 503 after deployment.
The service was working before the deploy.

Debug using the Reason-Act loop:
1. THOUGHT: State your hypothesis about why /health fails
2. ACTION: Run a command to verify (curl, docker logs, systemctl, etc.)
3. OBSERVATION: Show the actual output
4. Continue until root cause is confirmed

Do not propose a fix until you have evidence of the actual cause.
```

The AI will run something like:
```
THOUGHT: The service might not have started correctly.
ACTION:  docker ps --filter name=myapp
OBSERVATION: Container status: "Restarting (1) 30 seconds ago"

THOUGHT: Container is crash-looping. Check logs for error.
ACTION:  docker logs myapp --tail 20
OBSERVATION: "ModuleNotFoundError: No module named 'newdep'"

THOUGHT: A new dependency was added but not in requirements.txt.
ACTION:  diff requirements.txt requirements.txt.bak
OBSERVATION: + newdep==1.2.3 is missing from requirements.txt

ROOT CAUSE: Dependency 'newdep' was imported in code but not
added to requirements.txt. The container fails on import.
FIX: Add 'newdep==1.2.3' to requirements.txt and rebuild.
```

This technique connects directly to the library's **VERIFY, DON'T ASSUME** principle. ReAct is the structured method for enforcing it.

**When NOT to use:** Pure code generation tasks where no external verification is needed. ReAct adds latency from command execution.

---

### XML Tagging

Wrap distinct instruction sections in semantic tags to reduce ambiguity:
```xml
<context>Project uses FastAPI + PostgreSQL + React</context>
<constraints>No breaking changes to existing API</constraints>
<examples>See tests/test_auth.py for the expected pattern</examples>
<success_criteria>All tests pass, coverage > 80%</success_criteria>
```
When to use: any prompt with 3+ distinct instruction categories. Tags prevent Claude from confusing which instruction governs which behavior.

---

## Combining Techniques

Techniques work best in combination. Common pairings for software development:

| Situation | Combination | How |
|-----------|-------------|-----|
| Debug a complex production issue | ReAct + CoT | Reason step-by-step, verify each step with real commands |
| Design a new system component | Step-Back + ToT | Understand principles first, then explore approaches |
| Make a critical technology choice | ToT + Self-Consistency | Explore options, then evaluate from multiple perspectives |
| Generate consistent boilerplate | Few-Shot + CoT | Show examples, ask for reasoning about edge cases |
| Security-critical implementation | Self-Consistency + ReAct | Reason from multiple angles, then verify with scanners |

### Integration with Library Agents

Each agent benefits from specific techniques:

| Agent | Primary Technique | Why |
|-------|-------------------|-----|
| backend-developer | Few-Shot | Consistent API patterns, CRUD generation |
| frontend-developer | Few-Shot | Component structure consistency |
| testing-engineer | Few-Shot + CoT | Test pattern reuse + edge case reasoning |
| devops-engineer | ReAct | Must verify infrastructure state before acting |
| data-analyst | CoT | Step-by-step data analysis reasoning |
| data-detective | ReAct + CoT | Investigate with evidence, reason about anomalies |
| ui-ux-specialist | Step-Back | Design principles before specific UI decisions |
| security-auditor | Self-Consistency + ReAct | Multi-angle threat analysis, verify with tools |
| api-architect | Step-Back + ToT | Principles first, then explore design options |
| performance-engineer | ReAct + CoT | Profile with real data, reason about bottlenecks |
| cloud-infrastructure | ToT + ReAct | Evaluate cloud options, verify with IaC plan |

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Using CoT for a simple variable rename | Just ask directly | Unnecessary reasoning wastes tokens and time |
| Giving 10 few-shot examples | Give 2-3 high-quality examples | Diminishing returns after 3; more examples waste context window |
| Step-back on every single question | Step-back only when stuck or in unfamiliar territory | Adds latency without value on known problems |
| Running self-consistency on trivial decisions | Reserve for critical, hard-to-reverse choices | Multi-perspective analysis has high token cost |
| Using ToT when there is one obvious approach | Just proceed with the obvious approach | Exploring non-viable branches wastes time |
| Skipping ReAct and trusting the AI's guess | Always verify assumptions with real commands | Hallucinated conclusions cause cascading failures |
| Combining all 6 techniques in one prompt | Use 1-2 techniques per prompt, chosen by the activation table | Overloaded prompts confuse the model and dilute each technique |

---

## Related Documents

- [core/base-programming.md](base-programming.md) — Master session prompt (uses ReAct implicitly via "verify before acting")
- [core/error-prevention.md](error-prevention.md) — 7-category verification checklist (natural pairing with ReAct)
- [core/multi-agent-orchestration.md](multi-agent-orchestration.md) — Agent coordination (agents use different techniques)
- [core/real-validation.md](real-validation.md) — Evidence standards (ReAct produces the evidence this doc requires)
- [workflows/tdd-workflow.md](../workflows/tdd-workflow.md) — TDD cycle (CoT improves test design reasoning)
- [examples/best-practices-learned.md](../examples/best-practices-learned.md) — Lessons that motivate these techniques

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
