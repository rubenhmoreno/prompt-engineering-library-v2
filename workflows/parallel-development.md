# Parallel Development Workflow
> **Executive Summary:** Parallel development assigns independent work packages to separate agents simultaneously, reducing total elapsed time by 30–50% compared to sequential execution. The key discipline is defining all interface contracts before parallel work starts, so agents can proceed without waiting for each other's output.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [task-decomposition.md](../templates/task-decomposition.md), [agent-handoff.md](../templates/agent-handoff.md), [verification-protocol.md](verification-protocol.md) |

---

## Quick Reference Card

### Parallelization Decision Matrix

| Task Type | Can Parallelize? | Condition |
|-----------|-----------------|-----------|
| DB schema + UI design system | Yes | No shared dependencies |
| Backend API + Frontend components | Yes | Contract defined first; frontend uses mocks |
| Auth service + product service | Yes | Separate modules, same DB schema already done |
| Unit tests + integration tests | Yes | Test suites are independent |
| Migration + code that uses new schema | No | Schema must exist before code runs |
| Two agents editing the same file | No | Always sequential; merge conflicts guaranteed |
| Deployment + testing | No | Tests must pass before deployment starts |
| Sequential data pipeline steps | No | Each step depends on previous output |

### Time Savings Reference

| Sequential Total | Parallel Total | Savings |
|-----------------|----------------|---------|
| 23 hours (3 agents, 1 at a time) | 15 hours (3 agents, parallel groups) | ~35% |
| 8 hours (single agent, everything) | 4 hours (3 agents, 2 parallel groups) | ~50% |

### Pre-Flight Checklist

Before starting parallel execution:
- [ ] All requirements fully defined (no open questions)
- [ ] Dependency graph drawn; parallel groups identified
- [ ] Interface contracts written for every shared boundary
- [ ] Each agent assigned exactly one task with clear scope
- [ ] Sync points scheduled (end of each group)

---

## Full Content

### Phase 1: Analysis and Decomposition

**Step 1 — List all components** from the requirement, then draw a dependency diagram to find which ones can run in parallel.

**E-commerce system dependency diagram:**

```
DB Schema ──────────────────┬──> Backend API ──┬──> E2E Tests ──> Deploy
                            └──> Auth Service ──┘
Design System ──────────────────> Frontend UI ──┘
DevOps Setup ──────────────────────────────────────────────────> Deploy
```

**Step 2 — Group into parallel sets:**

```
GROUP 1 (no dependencies — run simultaneously):
  Agent A: DB Schema design
  Agent B: UI design system
  Agent C: DevOps infrastructure setup

GROUP 2 (depends on GROUP 1 — run simultaneously):
  Agent A: Backend API endpoints
  Agent B: Auth service
  Agent C: Frontend components (uses mock API)

GROUP 3 (depends on GROUP 2 — run simultaneously):
  Agent A: Payment integration
  Agent B: E2E tests
  Agent C: Unit and integration tests

GROUP 4 (sequential — depends on GROUP 3):
  Agent A: Final deployment and verification
```

**Sync point rule:** no group starts until all tasks in the previous group are verified complete with evidence.

---

### Phase 2: Interface Definition

Define all contracts **before** parallel work begins. Agents working in parallel must agree on the shape of every shared boundary so they can develop independently without waiting.

**API contract (written before backend or frontend touches any code):**

```yaml
# contracts/api-contract.yaml

POST /api/products:
  request:
    name: string        # required
    price: number       # required
    description: string # optional
  response:
    201: { id, name, price, description, created_at }
    400: { error: string }

GET /api/products:
  response:
    200: [{ id, name, price, description }]

POST /api/cart/items:
  request:
    product_id: number  # required
    quantity: number    # required
  response:
    201: { id, user_id, product_id, quantity }
    400: { error: string }
```

**Frontend development using the contract with a mock (no backend needed yet):**

```typescript
// src/api/mock.ts — frontend agent uses this while backend agent works in parallel
interface Product {
  id: number;
  name: string;
  price: number;
  description?: string;
}

const mockProducts: Product[] = [
  { id: 1, name: "Widget A", price: 29.99 },
  { id: 2, name: "Widget B", price: 49.99 },
];

export const api = {
  getProducts: (): Promise<Product[]> => Promise.resolve(mockProducts),
  // Replace with fetch('/api/products').then(r => r.json()) at integration time
};
```

**Data contract (TypeScript types shared between agents):**

```typescript
// contracts/types.ts — committed before GROUP 2 starts
export interface CartItem {
  id: number;
  user_id: number;
  product_id: number;
  quantity: number;
}

export interface CartSummary {
  items: CartItem[];
  subtotal: number;
  tax: number;
  total: number;
}
```

---

### Phase 3: Parallel Execution

**GROUP 1 — Foundation (all agents start simultaneously):**

| Agent | Task | Est. Duration | Output |
|-------|------|--------------|--------|
| Backend Developer | DB schema + migrations | 2 h | `products`, `cart_items` tables live in dev DB |
| UI/UX Specialist | Design system tokens, component specs | 2 h | Color palette, spacing, component list |
| DevOps Engineer | docker-compose, CI skeleton, env files | 1 h | All services start with `docker-compose up` |

Sync point: all three outputs verified before GROUP 2 begins.

**GROUP 2 — Core features (all agents start simultaneously after GROUP 1 sync):**

| Agent | Task | Est. Duration | Dependency |
|-------|------|--------------|-----------|
| Backend Developer | REST API endpoints | 4 h | GROUP 1 DB schema |
| Backend Developer (2nd) | Auth service (JWT) | 3 h | GROUP 1 DB schema |
| Frontend Developer | UI components using mock API | 4 h | GROUP 1 design system |

Sync point: all three outputs integrated and smoke-tested.

**GROUP 3 — Integration and testing (all agents start simultaneously after GROUP 2 sync):**

| Agent | Task | Est. Duration | Dependency |
|-------|------|--------------|-----------|
| Backend Developer | Payment integration | 3 h | GROUP 2 Backend API |
| Testing Engineer | E2E tests | 3 h | GROUP 2 Backend + Frontend |
| Testing Engineer (2nd) | Unit and integration tests | 2 h | GROUP 2 code |

Sync point: all tests green, coverage meets targets.

**GROUP 4 — Deployment (sequential after GROUP 3 sync):**

```bash
# DevOps Engineer — estimated 2 hours
docker-compose build
docker-compose run backend alembic upgrade head
docker-compose up -d
curl -f http://localhost:8000/health
curl -f http://localhost:3000/
```

---

### Communication Patterns

**Contract-first handoff:** every agent publishes the interface they will produce before writing implementation code. The receiving agent can immediately start coding against that interface using stubs or mocks.

**Sync point checklist (run at the end of each group):**

```
[ ] All agents in the group confirm their task is done
[ ] Evidence provided: test output, health check, or file listing
[ ] Interfaces match the agreed contracts (spot check one or two calls)
[ ] No blocking issues that would prevent the next group from starting
[ ] Blocker list updated if any issues remain
```

**Branch strategy for parallel agents:**

```bash
# Each agent works on a dedicated branch
git checkout -b feature/db-schema          # Agent A
git checkout -b feature/auth-service       # Agent B
git checkout -b feature/frontend-cart      # Agent C

# Integration happens at sync points via PR merges to the shared feature branch
git checkout feature/cart-system
git merge feature/db-schema
git merge feature/auth-service
git merge feature/frontend-cart
```

---

### Time Savings Comparison

**Sequential execution (same 23 hours of work, one agent):**

```
Day 1:  DB Schema (2h) → Backend API (4h) → Auth (3h)       = 9h
Day 2:  Frontend UI (4h) → Payment (3h)                     = 7h
Day 3:  Tests (5h) → Deploy (2h)                            = 7h
Total:  23 hours across 3 days
```

**Parallel execution (same work, 3 agents):**

```
Day 1:
  GROUP 1 (parallel):  DB Schema (2h) | Design (2h) | DevOps (1h)  = 2h elapsed
  GROUP 2 (parallel):  Backend (4h)   | Auth (3h)   | Frontend (4h) = 4h elapsed

Day 2:
  GROUP 3 (parallel):  Payment (3h) | E2E Tests (3h) | Unit Tests (2h) = 3h elapsed

Day 3:
  GROUP 4 (sequential): Deploy (2h)

Total:  ~11 hours elapsed (3 days compressed to 2)
Savings: ~35% of calendar time
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Start parallel work before contracts are defined | Write and commit contracts first, then start parallel work | Without contracts, agents build incompatible interfaces and all work must be redone |
| Two agents modifying the same file simultaneously | Assign each file to exactly one agent per group | Guaranteed merge conflicts that cost more time than sequential work |
| Skip the sync point and let GROUP 2 start while GROUP 1 is still running | Block GROUP 2 until all GROUP 1 outputs are verified | Downstream agents blocked mid-task by upstream failures waste more time than the saved parallelism |
| Run parallel groups to save time on a 2-hour task | Use parallel development only for tasks with clear independent sub-components | Coordination overhead exceeds savings for small tasks |
| Integrate only at the very end | Integrate and test at every sync point | Late integration failures require rework across all agents |
| Assume an interface is correct without spot-checking at sync points | Verify at least one real call across the boundary at each sync point | Silent incompatibilities cause GROUP 3 failures that look like GROUP 3 bugs |

---

## Related Documents

- [task-decomposition.md](../templates/task-decomposition.md) — Template for drawing the dependency graph and defining groups
- [agent-handoff.md](../templates/agent-handoff.md) — How to pass work between agents at sync points
- [verification-protocol.md](verification-protocol.md) — Evidence requirements for each sync point sign-off
- [evidence-report.md](../templates/evidence-report.md) — Full report format for GROUP completion sign-off

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
