# Verify FastAPI Stack

> **Executive Summary:** A verification checklist specific to the Python 3.11 + FastAPI + SQLAlchemy 2.0 + SQLite stack. Run after completing any feature, fix, or refactor. Produces evidence for each layer of the stack.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [verification-protocol.md](verification-protocol.md), [core/real-validation.md](../core/real-validation.md) |

---

## Quick Reference Card

Run these commands in order. Every command must produce output — no skips.

```bash
# 1. Tests + Coverage
pytest tests/ -v --cov=app --cov-report=term-missing

# 2. Linting
ruff check app/ tests/

# 3. Start server (background)
python3 run.py &
sleep 2

# 4. Health check
curl -s http://localhost:8080/health | python3 -m json.tool

# 5. Auth flow (if applicable)
curl -s -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=admin@itmva.com&password=admin123"

# 6. Exercise changed endpoints
curl -s http://localhost:8080/[CHANGED_ENDPOINT] | head -50

# 7. Database integrity
sqlite3 database.sqlite ".tables"
sqlite3 database.sqlite "SELECT COUNT(*) FROM [MAIN_TABLE];"

# 8. Stop server
kill %1
```

---

## Full Verification Protocol

### Layer 1: Tests

```bash
# Run full suite with coverage
pytest tests/ -v --cov=app --cov-report=term-missing

# Expected:
# - All tests PASSED
# - Coverage > 80%
# - No warnings about deprecated usage
```

**FAIL criteria:** Any test failure, coverage below 80%, import errors.

### Layer 2: Linting

```bash
# Check code quality
ruff check app/ tests/

# Expected: All checks passed!
```

**FAIL criteria:** Any ruff error (warnings acceptable if pre-existing).

### Layer 3: Server Start

```bash
# Start the application
cd /home/mva/[PROJECT]
python3 run.py &
sleep 2

# Verify it's listening
curl -sf http://localhost:8080/ > /dev/null && echo "Server UP" || echo "Server DOWN"
```

**FAIL criteria:** Server doesn't start, crashes on import, port conflict.

### Layer 4: Authentication

For projects with auth (tickets-soporte-v2 pattern):

```bash
# Login and capture session cookie
curl -s -c cookies.txt -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=admin@itmva.com&password=admin123" \
  -w "\nHTTP Status: %{http_code}\n"

# Verify authenticated access
curl -s -b cookies.txt http://localhost:8080/admin/dashboard \
  -w "\nHTTP Status: %{http_code}\n" | head -20

# Cleanup
rm -f cookies.txt
```

**FAIL criteria:** Login returns non-200, dashboard returns 401/403.

### Layer 5: Changed Endpoints

For each endpoint modified in the current task:

```bash
# GET endpoint
curl -si http://localhost:8080/[ENDPOINT] | head -20

# POST endpoint (with data)
curl -si -X POST http://localhost:8080/[ENDPOINT] \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'

# Error case (validation)
curl -si -X POST http://localhost:8080/[ENDPOINT] \
  -H "Content-Type: application/json" \
  -d '{}'
```

**FAIL criteria:** Wrong status code, unexpected response body, unhandled error.

### Layer 6: Database

```bash
# Tables exist
sqlite3 database.sqlite ".tables"

# Row counts for main tables
sqlite3 database.sqlite "SELECT 'users', COUNT(*) FROM users UNION ALL SELECT 'tickets', COUNT(*) FROM tickets;"

# Schema check (if migration was applied)
sqlite3 database.sqlite ".schema [TABLE_NAME]"
```

**FAIL criteria:** Missing tables, zero rows when data expected, schema mismatch.

### Layer 7: Cleanup

```bash
# Stop the server
kill %1 2>/dev/null

# Verify port is free
ss -tlnp | grep 8080 || echo "Port 8080 free"
```

---

## Evidence Report Template

```markdown
## Verification Report — [TASK NAME]

| Layer | Command | Result | Status |
|-------|---------|--------|--------|
| Tests | `pytest tests/ -v --cov=app` | 90 passed, 92% coverage | PASS |
| Lint | `ruff check app/ tests/` | All checks passed | PASS |
| Server | `python3 run.py` | Listening on :8080 | PASS |
| Auth | `curl POST /auth/login` | 200 + session cookie | PASS |
| Endpoint | `curl GET /admin/users` | 200 + JSON list | PASS |
| Database | `sqlite3 .tables` | 8 tables present | PASS |

### Verdict: PASS / FAIL
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Only running `pytest` and declaring done | Run all 7 layers | Tests don't catch server startup failures or DB issues |
| Testing with empty database | Use database with realistic data | Empty DB hides query issues and template rendering errors |
| Skipping error case curl | Test at least one validation error per endpoint | Happy path alone doesn't prove error handling works |
| Leaving server running after verification | Always `kill %1` at the end | Orphan processes cause port conflicts in next session |

---

## Related Documents

- [workflows/verification-protocol.md](verification-protocol.md) — Generic verification protocol
- [core/real-validation.md](../core/real-validation.md) — Evidence standards
- [core/coding-discipline.md](../core/coding-discipline.md) — Rules this verification enforces

*Last updated: 2026-03-28 | [Back to Index](../INDEX.md)*
