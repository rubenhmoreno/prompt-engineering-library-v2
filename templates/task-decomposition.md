# Task Decomposition Template
> **Executive Summary:** This template breaks a complex requirement into specific, assignable, verifiable subtasks before any code is written. Decomposing first prevents scope creep, reveals parallelization opportunities, and ensures every agent has an unambiguous definition of "done" before starting.

| Metadata | Value |
|----------|-------|
| Type     | Template |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [parallel-development.md](../workflows/parallel-development.md), [agent-handoff.md](agent-handoff.md), [verification-protocol.md](../workflows/verification-protocol.md) |

---

## Quick Reference Card

### When to Use This Template

| Situation | Use Full Template? |
|-----------|-------------------|
| Feature taking more than 1 day | Yes — full template |
| Multiple agents or layers involved | Yes — full template |
| New project or major architectural change | Yes — full template |
| Single-agent feature under 2 hours | No — use minimal variant |
| Bug fix or documentation change | No — use minimal variant |

### Minimal Variant (5 fields, for simple tasks)

```markdown
## Task: [NAME]

**Requirement:** [One sentence — what must be true when done]
**Agent:** [Who does it]
**Dependencies:** [What must exist first, or "None"]
**Outputs:** [Files produced or APIs available]
**Done when:** [Verifiable command or observable result]
```

### Full Template Section Map

| Section | Purpose |
|---------|---------|
| 1. Requirement | Original ask, verbatim; acceptance criteria |
| 2. Components | What must be built (frontend / backend / DB / tests) |
| 3. Dependency diagram | Which tasks block which others |
| 4. Subtasks | Detailed specification per task, grouped by parallel set |
| 5. Interface contracts | API, data, and component shapes agreed before coding |
| 6. Execution strategy | Which group runs when; estimated timeline |

---

## Full Content

### Full Template

```markdown
# Task Decomposition: [FEATURE / PROJECT NAME]

---

## 1. Requirement

**Original description (verbatim):**
[Copy exactly what the user or ticket said]

**Context:**
[Any background information relevant to the implementation]

**Acceptance criteria:**
- [ ] [Criterion 1 — observable, testable]
- [ ] [Criterion 2 — observable, testable]
- [ ] [Criterion 3 — observable, testable]

---

## 2. Components

### Frontend
- [ ] [UI component or page]
- [ ] [State management or hook]

### Backend
- [ ] [Endpoint: METHOD /path]
- [ ] [Service or business logic class]

### Database
- [ ] [Table or schema change]
- [ ] [Migration file]
- [ ] [Index]

### Tests
- [ ] [Unit tests: which module]
- [ ] [Integration tests: which boundary]
- [ ] [E2E tests: which user flow]

---

## 3. Dependency Diagram

```
[Component A] ──> [Component C] ──> [E2E Tests] ──> [Deploy]
[Component B] ──┘
[Component D] ──────────────────────────────────> [Deploy]
```

**Reading the diagram:**
- Tasks on the same horizontal level with no arrows between them can run in parallel
- An arrow from A to B means B cannot start until A is complete and verified

---

## 4. Subtasks

### GROUP 1: Foundation (parallel — no dependencies)

#### Subtask 1.1: [Name]
**Agent:** [Role]
**Estimated time:** [X hours]
**Dependencies:** None

**What to build:**
[Specific description]

**Inputs available:**
[Files, schemas, or contracts the agent can use from the start]

**Expected outputs:**
[Files produced, endpoints available, tables created]

**Done when:**
- [ ] [Verifiable criterion — command output or observable result]
- [ ] [Tests pass]

---

#### Subtask 1.2: [Name]
**Agent:** [Role]
**Estimated time:** [X hours]
**Dependencies:** None

[Same structure as 1.1]

---

### GROUP 2: Core Features (depends on GROUP 1 sync)

#### Subtask 2.1: [Name]
**Agent:** [Role]
**Estimated time:** [X hours]
**Dependencies:** Subtask 1.1

[Same structure as 1.1]

---

### GROUP 3: Integration and Testing (depends on GROUP 2 sync)

[Continue pattern]

---

### GROUP 4: Deployment (sequential — depends on GROUP 3 sync)

[Continue pattern]

---

## 5. Interface Contracts

Define every shared boundary before parallel work starts.

### API Contract

```yaml
POST /api/[resource]:
  request:
    field1: type   # required/optional
    field2: type
  response:
    201: { schema }
    400: { error: string }
    401: { error: string }

GET /api/[resource]/{id}:
  response:
    200: { schema }
    404: { error: string }
```

### Data Contract

```typescript
interface ResourceResponse {
  id: number;
  name: string;
  created_at: string;   // ISO 8601
}
```

### Component Contract

```typescript
interface ComponentProps {
  data: ResourceResponse[];
  onSelect: (id: number) => void;
  loading?: boolean;
  error?: string;
}
```

---

## 6. Execution Strategy

```
Day 1:
  GROUP 1 (parallel):  [list tasks]    → Sync after ~[N] hours
  GROUP 2 (parallel):  [list tasks]    → Sync after ~[N] hours

Day 2:
  GROUP 3 (parallel):  [list tasks]    → Sync after ~[N] hours
  GROUP 4 (sequential): Deploy         → ~[N] hours

Total estimated time:   [X hours]
Sync points:            End of each group
```

---
```

---

### E-commerce Cart Feature — Dependency Diagram Example

The full decomposition document for this example would use the template above. The dependency diagram alone shows the parallelization structure at a glance:

```
DB Schema ──────────────────┬──> Backend Cart API ──┬──> Integration Tests ──┬──> E2E Tests ──> Deploy
                            └──> Backend Tests    ──┘                        │
Design System ──────────────────> Frontend Components ──> Component Tests ──┘
```

**Reading this diagram:**

- DB Schema and Design System have no dependencies — they run in GROUP 1, in parallel
- Backend Cart API and Frontend Components both depend on GROUP 1 outputs — they run in GROUP 2, in parallel
- Frontend uses a mock API during GROUP 2 so it does not wait for the real backend
- E2E Tests require both Backend and Frontend, so they run in GROUP 3
- Deployment is sequential after all GROUP 3 tests pass

**Cart API contract (defined before GROUP 2 starts):**

```typescript
// Agreed before backend or frontend writes any code
POST /api/cart/items
  Request:  { product_id: number; quantity: number }
  Response: { id: number; user_id: number; product_id: number; quantity: number;
              product: { name: string; price: number } }

GET /api/cart
  Response: { items: CartItem[]; subtotal: number; tax: number; total: number }

DELETE /api/cart/items/:id
  Response: 204 No Content
            404 { error: "Item not found" }
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Start coding before decomposing | Always decompose fully before any agent starts | Mid-task scope changes require rework across all parallel agents |
| Define interface contracts during or after implementation | Write all contracts before GROUP 1 starts | Agents building to incompatible contracts waste all their work |
| Assign two agents to the same file in the same group | One file, one agent per parallel group | Merge conflicts cost more time than the parallelism saves |
| Skip the dependency diagram for "simple" features | Draw the diagram even for 3-task work | The diagram consistently reveals hidden dependencies that would cause blocking |
| Write "done when: code is written" | Write "done when: `pytest` shows 8/8 passing and `curl` returns 201" | Vague criteria lead to disagreements about completion at sync points |
| Use the full template for a 30-minute bug fix | Use the minimal variant for small tasks | Template overhead must be proportional to task complexity |

---

## Related Documents

- [parallel-development.md](../workflows/parallel-development.md) — How to run the parallel groups produced by this template
- [agent-handoff.md](agent-handoff.md) — How to pass the output of a subtask to the next agent
- [verification-protocol.md](../workflows/verification-protocol.md) — Evidence requirements for each "done when" criterion
- [evidence-report.md](evidence-report.md) — Full evidence report for major task completions

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
