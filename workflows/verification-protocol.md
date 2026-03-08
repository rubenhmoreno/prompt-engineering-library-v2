# Verification Protocol
> **Executive Summary:** Every task must be verified with real command output before it is marked complete. The golden rule is: NEVER mark a task as completed without EVIDENCE. "It should work" and "I tested it locally" are not evidence — actual command output is evidence.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [evidence-report.md](../templates/evidence-report.md), [tdd-workflow.md](tdd-workflow.md), [agent-handoff.md](../templates/agent-handoff.md) |

---

## Quick Reference Card

### The Golden Rule

```
NEVER mark a task as completed without EVIDENCE.
Evidence = actual command output, not a statement about expected behavior.
```

### Evidence Type Reference Table

| Context | Minimum Commands to Run | Expected Output |
|---------|------------------------|-----------------|
| Code / build | `npm run build` or `python -m py_compile src/` | Zero errors; artifact files created |
| Linting | `ruff check .` or `npm run lint` | 0 errors, 0 warnings |
| Tests | `pytest tests/ -v --cov` or `npm test` | All tests PASSED; coverage percentage shown |
| API endpoint | `curl -i http://localhost:PORT/endpoint` | HTTP status code + JSON body |
| Database | `psql -c "\dt"` and `psql -c "SELECT COUNT(*) FROM table"` | Table list; row counts |
| Migration | `alembic upgrade head` | "Running upgrade ... OK" for each migration |
| Frontend | `curl -I http://localhost:3000` + visual description | HTTP 200; elements described |
| Service / container | `systemctl status SERVICE` or `docker ps` | "active (running)" or container Up |
| SSL / HTTPS | `curl -vI https://domain 2>&1 \| grep -E "SSL\|subject\|verify"` | "SSL certificate verify ok" |
| Data analysis | `print(df.shape)` + `print(df.describe())` | Non-zero shape; stats table printed |

### Verification Levels

| Level | When to Use | Required Evidence |
|-------|-------------|------------------|
| Quick check | Bug fix, single-file change | Tests pass + functionality confirmed with 1-2 curl commands |
| Standard | Feature completion, new endpoint | Tests pass + coverage + all endpoints curled + service running |
| Full audit | Major feature, security change, migration | All of Standard + performance check + error cases verified + logs reviewed |

---

## Full Content

### Why Evidence Matters

An agent that says "I implemented the endpoint" but does not show command output may have:
- Written code that does not import correctly
- Introduced a syntax error outside the tested path
- Left a service stopped
- Created files in the wrong location

Real command output eliminates all of these failure modes. The protocol requires capturing output at the moment the command runs, not reconstructing it from memory.

---

### Evidence by Context

#### Code — Build and Lint

```bash
# Python: verify all files compile
python -m py_compile src/services/user_service.py
# No output = success

# Python: lint
ruff check src/
# Expected: All checks passed!

# JavaScript: build
npm run build
# Expected: Build complete with artifact sizes listed, no errors

# TypeScript: type check
npm run typecheck
# Expected: Found 0 errors.
```

The following are **not** sufficient evidence:
- "The code looks correct"
- "I checked it and it should compile"
- Showing source code without running it

---

#### Tests

```bash
pytest tests/ -v --cov=src --cov-report=term-missing

# Required output to capture:
tests/test_user_service.py::test_create_user_with_valid_data PASSED     [ 25%]
tests/test_user_service.py::test_create_user_invalid_email PASSED       [ 50%]
tests/test_auth.py::test_login_valid PASSED                             [ 75%]
tests/test_auth.py::test_login_invalid PASSED                           [100%]

---------- coverage: platform linux, python 3.11 ----------
Name                    Stmts   Miss  Cover
-------------------------------------------
src/services/user.py       45      2    96%
src/auth/jwt.py            32      1    97%
-------------------------------------------
TOTAL                      77      3    97%

========== 4 passed in 1.84s ==========
```

Generate an HTML coverage report for browsing uncovered lines:

```bash
pytest --cov=src --cov-report=html
ls -lh htmlcov/index.html
# -rw-r--r-- 1 user group 45K Mar 08 12:05 htmlcov/index.html
```

Coverage below 80% is not acceptable without a written justification.

---

#### API Endpoints

Every implemented endpoint must be exercised with `curl` and the full output captured.

```bash
# Health check first
curl -i http://localhost:8000/health
# HTTP/1.1 200 OK
# {"status": "ok", "version": "1.0.0"}

# Happy path
curl -i -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "SecurePass1"}'
# HTTP/1.1 201 Created
# {"id": 1, "email": "test@example.com", "created_at": "2026-03-08T12:00:00Z"}

# Error path — validation must also be verified
curl -i -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "not-an-email"}'
# HTTP/1.1 400 Bad Request
# {"error": "Invalid email format"}
```

---

#### Database

```bash
# Connection
psql -h localhost -U admin -d mydb -c "SELECT version();"
# PostgreSQL 16.1 on x86_64-pc-linux-gnu ...

# Tables exist
psql -h localhost -U admin -d mydb -c "\dt"
# Schema | Name     | Type  | Owner
# public | users    | table | admin
# public | products | table | admin

# Migration applied
alembic upgrade head
# INFO  [alembic.runtime.migration] Running upgrade -> abc123, create users table ... OK
# INFO  [alembic.runtime.migration] Running upgrade abc123 -> def456, add email index ... OK

# Data present
psql -h localhost -U admin -d mydb -c "SELECT COUNT(*) FROM users;"
#  count
# -------
#   1000
```

---

#### Frontend / UI

```bash
# Dev server starts
npm run dev
# VITE v5.0.0  ready in 234 ms
# Local:   http://localhost:3000/

# Returns HTML
curl -I http://localhost:3000
# HTTP/1.1 200 OK
# Content-Type: text/html

# Component tests pass
npm test
#  PASS  src/components/LoginForm.test.tsx
#    LoginForm
#      pass renders login form (45 ms)
#      pass shows validation errors on empty submit (89 ms)
#      pass submits valid credentials (123 ms)
# Tests: 3 passed, 3 total
```

**Visual verification** (required when there is a UI):

```
Verified at http://localhost:3000:
- Login form renders with email field, password field, and "Sign In" button
- Submitting with empty fields shows inline validation errors
- Submitting with valid credentials redirects to /dashboard
- Dashboard shows "Welcome, [email]"
- Layout verified at 375px (mobile), 768px (tablet), 1440px (desktop)
```

---

#### Deployment and Infrastructure

```bash
# Service status
systemctl status myapp.service
# Active: active (running) since Sun 2026-03-08 12:00:00 UTC; 5min ago
# Main PID: 12345 (python3)

# Remote health check
curl -f https://example.com/health
# {"status": "healthy", "uptime": 300, "version": "1.0.0"}

# Recent logs — no errors
journalctl -u myapp -n 20 --no-pager
# Mar 08 12:00:01 server python3[12345]: INFO: Application started on port 8000
# Mar 08 12:01:15 server python3[12345]: GET /api/users - 200 OK - 45ms
# [no ERROR or CRITICAL lines]

# SSL valid
curl -vI https://example.com 2>&1 | grep -E "SSL|subject|verify"
# * SSL connection using TLSv1.3
# *  subject: CN=example.com
# *  SSL certificate verify ok.
```

---

#### Data Analysis

```python
import pandas as pd

df = pd.read_csv("data.csv")
print(f"Shape: {df.shape}")           # Shape: (10000, 15)
print(f"Nulls:\n{df.isnull().sum()}") # Must show per-column null counts
print(df.describe())                  # Must show statistics for numeric columns

# Output file verification
df.to_csv("output/results.csv", index=False)

import os
size = os.path.getsize("output/results.csv")
print(f"Output file size: {size} bytes")   # Must be non-zero
```

---

### Common Insufficient Evidence Patterns

The following statements are never acceptable as evidence:

| Claim Made | Why It Is Insufficient | What Is Required Instead |
|------------|----------------------|--------------------------|
| "The endpoint is implemented" | Code may not start | `curl` output showing HTTP status and response body |
| "Tests should pass" | Tests were not run | `pytest` output showing all tests PASSED |
| "I tested it locally" | No output captured | The actual terminal output from that local test |
| "The database is set up" | Tables may be missing or empty | `\dt` and `SELECT COUNT(*)` output |
| "The service is deployed" | Container may have crashed on start | `systemctl status` or `docker ps` showing "running" |
| "The build succeeded" | Build cache may have masked an error | Full build output with artifact sizes |

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Report completion based on code review alone | Run every relevant command and capture the output | Code that looks correct may fail to import, compile, or start |
| Run tests once at the start and never again after refactoring | Run the full test suite after every refactor step | Refactoring introduces regressions; only running tests detects them |
| Curl only the happy path | Also curl at least one validation error case | Error handling is as important as success behavior |
| Check service status but skip the health endpoint | Check both `systemctl status` and `curl /health` | A service can be "running" but returning 500 on every request |
| Accept 60% test coverage on a security-sensitive module | Require explicit written justification when below 80% | Under-covered security code is a known liability |
| Verify locally but not document which environment | State the environment (dev, staging, prod) in every evidence block | Evidence from the wrong environment gives false confidence |
| Mark a task done, then run tests afterward | Run tests, capture output, then mark done | Order matters; evidence must precede the status change |

---

## Related Documents

- [evidence-report.md](../templates/evidence-report.md) — Template for assembling all evidence into a structured report
- [tdd-workflow.md](tdd-workflow.md) — How tests are written and verified during development
- [agent-handoff.md](../templates/agent-handoff.md) — Evidence requirements when passing work between agents
- [parallel-development.md](parallel-development.md) — Sync point evidence requirements between parallel groups

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
