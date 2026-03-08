# Agent Handoff Template
> **Executive Summary:** An agent handoff transfers everything the receiving agent needs to continue work without asking questions — context, completed artifacts, interface contracts, known blockers, and precise next steps. A handoff that requires the receiving agent to ask clarifying questions is incomplete.

| Metadata | Value |
|----------|-------|
| Type     | Template |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [parallel-development.md](../workflows/parallel-development.md), [evidence-report.md](evidence-report.md), [verification-protocol.md](../workflows/verification-protocol.md) |

---

## Quick Reference Card

### When to Use This Template

| Situation | Use Full Template? |
|-----------|------------------|
| Agent A completes a major feature; Agent B continues | Yes — full template |
| Parallel group sync point; multiple agents hand off simultaneously | Yes — one per handoff pair |
| Bug fix, single-file change passed to reviewer | No — use minimal variant |
| Code review with no context change | No — PR description is sufficient |

### Minimal Handoff Variant (3 fields, for simple handoffs)

```markdown
## Handoff: [FROM] → [TO]

**What was done:** [One-paragraph summary]
**What to do next:** [Numbered list of actions with time estimates]
**Verify first:**
```bash
[Command to confirm the work is usable — e.g., health check or test run]
```
```

### Full Template Section Map

| # | Section | Purpose |
|---|---------|---------|
| 1 | Context | Project objective, agents involved, current status |
| 2 | Work completed | What was built; files changed; key decisions made |
| 3 | Artifacts produced | Each deliverable with its verification status |
| 4 | Interface contracts | API, data, and component shapes the receiving agent will consume |
| 5 | Blockers and risks | Known issues the receiving agent must be aware of |
| 6 | Next steps | Ordered, time-estimated actions for the receiving agent |

---

## Full Content

### Full Template

```markdown
# Agent Handoff: [FROM ROLE] → [TO ROLE]

**Date:** YYYY-MM-DD HH:MM UTC
**Task:** [Feature or project name]
**Handoff ID:** [feature-name-YYYY-MM-DD-NNN]
**Priority:** HIGH | MEDIUM | LOW

---

## 1. Context

**Project objective:**
[One paragraph — what the overall feature or project is trying to accomplish]

**Agents involved:**
| Agent | Role | Status |
|-------|------|--------|
| [Agent A] | [From role] | COMPLETE — handing off |
| [Agent B] | [To role] | STARTING — receiving this handoff |
| [Agent C] | [Other role] | IN PROGRESS — parallel work |

**Current status:**
- Overall progress: [X]% complete
- Phase: [Foundation / Core features / Integration / Testing / Deployment]
- This handoff covers: [specific subtasks being transferred]

---

## 2. Work Completed

**Summary of implementation:**
1. [Feature or component 1]: [One sentence — what it does and why it was built that way]
2. [Feature or component 2]: [One sentence]
3. [Feature or component 3]: [One sentence]

**Key decisions made (with reasoning):**
- [Decision 1]: [Why this approach was chosen over alternatives]
- [Decision 2]: [Why this approach was chosen over alternatives]

**Files created:**
```
/absolute/path/to/new/file1.py    [Backend API routes]
/absolute/path/to/new/service.py  [Business logic]
/absolute/path/to/migration.sql   [DB migration]
```

**Files modified:**
```
/absolute/path/to/existing/config.py   [Added DATABASE_URL env var handling]
/absolute/path/to/existing/models.py   [Added User.email_verified field]
```

**Evidence of completion:**
```bash
pytest tests/ -v --cov=src
# 15 passed in 2.34s | Coverage: 94%

curl -f http://localhost:8000/health
# {"status": "healthy", "version": "1.0.0"}
```

Full evidence report: [path or link to evidence-report.md]

---

## 3. Artifacts Produced

### Artifact: [Name — e.g., User Management API]

**Location:** `/absolute/path/to/file.py`
**Documentation:** `http://localhost:8000/docs#/users`
**Verification status:** TESTED — 94% coverage, all curl examples below return expected responses

**Quick smoke test:**
```bash
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "SecurePass1"}'
# Expected: HTTP 201, {"id": 1, "email": "test@example.com", ...}
```

---

### Artifact: [Name — e.g., Database Schema]

**Migration file:** `/absolute/path/to/migrations/abc123_create_users.py`
**Verification status:** APPLIED — migration ran successfully in dev

**Apply the migration:**
```bash
alembic upgrade head
# Expected: "Running upgrade -> abc123, create users table ... OK"
```

**Schema:**
```sql
CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    email       VARCHAR(255) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW()
);
CREATE INDEX idx_users_email ON users(email);
```

---

### Artifact: [Name — e.g., Docker Image]

**Image:** `myapp-backend:v1.0.0`
**Verification status:** BUILT AND RUNNING

**Start the service:**
```bash
docker-compose up -d backend
curl -f http://localhost:8000/health
# Expected: {"status": "healthy"}
```

---

## 4. Interface Contracts

These are the boundaries the receiving agent will consume. Do not change these contracts without coordinating with the handing-off agent.

### API Contract

**Base URL:** `http://localhost:8000/api`

```yaml
POST /auth/login:
  request:
    email: string       # required
    password: string    # required
  response:
    200: { token: string, user: { id, email, name? } }
    400: { error: "Invalid credentials" }
    429: { error: "Too many attempts" }

GET /users/{id}:
  headers:
    Authorization: "Bearer {token}"
  response:
    200: { id: number, email: string, name?: string, created_at: string }
    401: { error: "Unauthorized" }
    404: { error: "User not found" }

POST /users:
  request:
    email: string    # required
    password: string # required
    name?: string    # optional
  response:
    201: { id, email, name?, created_at }
    400: { error: string }
    409: { error: "Email already exists" }
```

**TypeScript types (if frontend is receiving agent):**

```typescript
// Available at /src/types/api.ts — do not redefine these
export interface UserResponse {
  id: number;
  email: string;
  name?: string;
  created_at: string;  // ISO 8601
}

export interface LoginResponse {
  token: string;       // JWT, expires in 30 minutes
  user: UserResponse;
}
```

### Data Contract (for testing agents)

```bash
# Export test data for seeding a test database
psql -U admin mydb \
  -c "COPY (SELECT id, email, created_at FROM users LIMIT 100) TO STDOUT WITH CSV HEADER" \
  > test_fixtures/users.csv

# Import into test DB
psql -U admin testdb \
  -c "COPY users (id, email, created_at) FROM STDIN WITH CSV HEADER" \
  < test_fixtures/users.csv
```

### Component Contract (for frontend agents)

```typescript
// Location: /src/components/UserForm.tsx
export interface UserFormProps {
  onSubmit: (data: { email: string; password: string }) => Promise<void>;
  loading?: boolean;    // disables submit button when true
  error?: string;       // displayed as a form-level error message
}

// Usage:
// <UserForm onSubmit={handleLogin} loading={isSubmitting} error={formError} />
```

---

## 5. Blockers and Risks

[State "None" explicitly if there are no blockers. Never leave this section blank.]

### Blocker 1: [Short description]
**Severity:** BLOCKING | HIGH | MEDIUM | LOW
**Symptom:** [What breaks or does not work]
**Root cause:** [If known]
**Workaround:** [Steps to proceed despite the blocker]
**Tracking:** [Issue number]
**Estimated resolution:** [Date or "unknown"]

**Example:**
```python
# Workaround for database connection timeout under high load:
# Add to config/settings.py before using the DB
SQLALCHEMY_POOL_RECYCLE = 300  # recycle connections every 5 minutes
```

---

## 6. Next Steps

Tasks are ordered by priority. Complete Priority 1 items before moving to Priority 2.

### Priority 1 — Required to unblock further work

- [ ] **[Action name]**
  - What: [Specific description]
  - Where: `/path/to/relevant/file` or `URL`
  - Command to verify: `[command]`
  - Estimated time: [X hours]

- [ ] **[Action name]**
  - What: [Specific description]
  - Estimated time: [X hours]

### Priority 2 — Complete before sign-off

- [ ] **[Action name]**
  - What: [Specific description]
  - Estimated time: [X hours]

### Priority 3 — Nice to have

- [ ] **[Action name]**
  - What: [Specific description]
  - Estimated time: [X hours]

**Acceptance criteria for this phase:**
- [ ] All Priority 1 and 2 items complete
- [ ] Tests passing with >80% coverage
- [ ] All contracts verified against live service
- [ ] Evidence report filed before signaling completion

---
```

---

### Example — Backend to Frontend Handoff

```markdown
# Agent Handoff: Backend Developer → Frontend Developer

**Date:** 2026-03-08 14:00 UTC
**Task:** User Authentication Feature
**Handoff ID:** user-auth-2026-03-08-001
**Priority:** HIGH

---

## 1. Context

**Project objective:** Implement email/password authentication with JWT tokens and protected routes.

**Current status:** Backend complete and running. Frontend implementation not started.

---

## 2. Work Completed

1. **POST /api/auth/login**: Validates credentials, returns JWT token (30-minute expiry)
2. **GET /api/auth/me**: Returns current user data from the JWT payload
3. **Middleware**: All routes under `/api/protected/*` require a valid Bearer token

Key decision: JWT stored on client, not server sessions — stateless, horizontally scalable.

**Evidence:**
```bash
pytest tests/ -v --cov=src/auth
# 6 passed in 0.84s | Coverage: 95%

curl -X POST http://localhost:8000/api/auth/login \
  -d '{"email":"test@example.com","password":"SecurePass1"}'
# {"token": "eyJhbG...", "user": {"id": 1, "email": "test@example.com"}}
```

---

## 3. Artifacts Produced

**Auth API** — running at `http://localhost:8000`

Smoke test:
```bash
TOKEN=$(curl -s -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"SecurePass1"}' | jq -r .token)

curl http://localhost:8000/api/auth/me \
  -H "Authorization: Bearer $TOKEN"
# {"id": 1, "email": "test@example.com"}
```

---

## 4. Interface Contracts

```typescript
// POST /api/auth/login
interface LoginRequest  { email: string; password: string; }
interface LoginResponse { token: string; user: { id: number; email: string; name?: string }; }
// token expires in 30 minutes; store in memory (not localStorage for security)

// GET /api/auth/me  — requires Authorization: Bearer {token}
interface MeResponse    { id: number; email: string; name?: string; }
// Returns 401 if token is missing, expired, or invalid
```

---

## 5. Blockers and Risks

None.

---

## 6. Next Steps

### Priority 1 — Required

- [ ] **Implement LoginForm component**
  - What: Email + password fields, submit button, inline validation errors
  - Where: `/src/components/LoginForm.tsx`
  - Estimated time: 1 hour

- [ ] **Implement auth context and token storage**
  - What: React context that holds the JWT, exposes `login()` and `logout()`, provides `user` object
  - Store token in memory (not localStorage) to avoid XSS exposure
  - Estimated time: 45 minutes

### Priority 2 — Before sign-off

- [ ] **Protected route wrapper**
  - What: Component that redirects unauthenticated users to `/login`
  - Estimated time: 30 minutes

- [ ] **Component tests**
  - What: Jest + React Testing Library tests for LoginForm (render, validation, submit)
  - Estimated time: 45 minutes
```

---

### Common Handoff Flows

| From | To | Key Artifacts to Include |
|------|----|------------------------|
| Backend Developer | Frontend Developer | API contracts, base URL, curl examples, error codes, CORS config |
| Frontend Developer | Testing Engineer | Component props contracts, dev server URL, build output, visual specs |
| Backend Developer | DevOps Engineer | Docker image name, required env vars, migration commands, health check URL |
| Testing Engineer | DevOps Engineer | Test report (all passing), coverage %, performance benchmarks, approved PR link |
| Any agent | Orchestrator | Summary of what changed, evidence report link, next recommended action |

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Handoff without a working smoke test command | Always provide a command the receiving agent can run immediately to verify the work is usable | A broken handoff blocks the receiving agent from starting their own work |
| Describe interface contracts as "same as before" | Write out every field explicitly, even if unchanged | Implicit contracts break silently when either side changes independently |
| File the handoff document after starting the next task | File the handoff before signaling completion | The handoff IS the completion signal; it must precede any downstream work |
| Leave Section 5 (Blockers) blank when there are none | Write "None" explicitly | Blank sections are ambiguous and create doubt |
| Combine handoffs for two separate agent pairs into one document | One document per handoff pair | Mixed-audience documents lead to agents acting on instructions meant for others |
| List next steps without time estimates | Include estimated hours for each action | Time estimates let the orchestrator plan sync points and flag unrealistic scopes |

---

## Related Documents

- [parallel-development.md](../workflows/parallel-development.md) — How handoffs fit into sync points between parallel groups
- [evidence-report.md](evidence-report.md) — The evidence report that accompanies or precedes this handoff
- [task-decomposition.md](task-decomposition.md) — The decomposition that defined what each agent was responsible for
- [verification-protocol.md](../workflows/verification-protocol.md) — What counts as valid evidence in Section 2 and 3

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
