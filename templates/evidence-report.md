# Evidence Report Template
> **Executive Summary:** An evidence report documents the completion of a task with concrete, reproducible proof — actual command output, not statements about expected behavior. Fill out this template immediately after finishing a task, before signaling completion to an orchestrator or the next agent in the pipeline.

| Metadata | Value |
|----------|-------|
| Type     | Template |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [verification-protocol.md](../workflows/verification-protocol.md), [agent-handoff.md](agent-handoff.md), [task-decomposition.md](task-decomposition.md) |

---

## Quick Reference Card

### Report Levels

| Level | Use When | Sections Required |
|-------|----------|------------------|
| Simple | Bug fix, single-file change, small task under 2 hours | Summary + Evidence + Sign-off |
| Medium | Feature completion, new endpoint, DB migration | Summary + Implementation + Evidence + Metrics + Next steps + Sign-off |
| Full | Major feature, security change, deployment | All 8 sections |

### Simple Report (3 sections, for small tasks)

```markdown
# Evidence Report: [TASK NAME]
Date: YYYY-MM-DD | Agent: [Role] | Status: COMPLETE

## Summary
What was done: [one sentence]
Acceptance criteria met: [list]

## Evidence
[Command + actual output for each verification point]

## Sign-off
All criteria verified with command output above.
Git commit: [hash]
```

### Full Report Section Map

| # | Section | Always Required? |
|---|---------|-----------------|
| 1 | Summary | Yes |
| 2 | Implementation | Yes |
| 3 | Evidence | Yes |
| 4 | Metrics | Yes (if performance targets exist) |
| 5 | Known issues | Yes (even if "none") |
| 6 | Next steps | Yes |
| 7 | Sign-off | Yes |
| 8 | Appendix | No — optional |

---

## Full Content

### Full Template

```markdown
# Evidence Report: [TASK / FEATURE NAME]

**Date:** YYYY-MM-DD
**Agent:** [Role — e.g., Backend Developer]
**Version:** [X.Y.Z if applicable]
**Status:** COMPLETE | BLOCKED | FAILED
**Completion:** [X]%

---

## 1. Summary

**Objective:** [One sentence — what this task was supposed to accomplish]

**Acceptance criteria:**
- [x] [Criterion 1 — mark as done]
- [x] [Criterion 2 — mark as done]
- [ ] [Criterion 3 — mark as NOT done if applicable, explain in Known Issues]

**Time:** [X hours actual] vs [Y hours estimated] ([+/- Z%] variance)

---

## 2. Implementation

### Files Created
```
/absolute/path/to/new/file1.py      [Backend service]
/absolute/path/to/new/file2.ts      [Frontend component]
/absolute/path/to/migration_001.sql [DB migration]
```

Verification:
```bash
ls -lh /absolute/path/to/
# -rw-r--r-- 1 user group 2.4K Mar 08 10:30 file1.py
# -rw-r--r-- 1 user group 1.8K Mar 08 10:35 file2.ts
# -rw-r--r-- 1 user group 0.5K Mar 08 10:40 migration_001.sql
```

### Files Modified
| File | Lines Changed | Nature of Change |
|------|--------------|-----------------|
| `/path/to/existing/service.py` | 45–67, 123–145 | Added validation logic |
| `/path/to/existing/routes.py` | 12–18 | Registered new endpoint |

### Files Deleted
```
/path/to/deprecated/old_module.py   [Replaced by file1.py]
```

---

## 3. Evidence

### Backend / API

```bash
# Health check
curl -i http://localhost:8000/health
# HTTP/1.1 200 OK
# {"status": "ok", "version": "1.0.0"}

# Happy path
curl -i -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "SecurePass1"}'
# HTTP/1.1 201 Created
# {"id": 1, "email": "test@example.com", "created_at": "2026-03-08T10:30:00Z"}

# Error path
curl -i -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "invalid-email"}'
# HTTP/1.1 400 Bad Request
# {"error": "Invalid email format"}
```

### Frontend / UI

```bash
curl -I http://localhost:3000
# HTTP/1.1 200 OK
# Content-Type: text/html

npm test
#  PASS  src/components/UserForm.test.tsx
#    UserForm
#      pass renders email and password fields (45 ms)
#      pass shows error on empty submit (89 ms)
#      pass redirects on valid credentials (123 ms)
# Tests: 3 passed, 3 total
```

Visual verification:
```
Verified at http://localhost:3000/login:
- Email field, password field, and Sign In button render correctly
- Empty submit shows "Email is required" below the email field
- Valid submit redirects to /dashboard showing "Welcome, test@example.com"
- Layout verified at 375px (mobile), 768px (tablet), 1440px (desktop)
```

### Database

```bash
alembic upgrade head
# INFO  [alembic.runtime.migration] Running upgrade -> abc123, create users table ... OK
# INFO  [alembic.runtime.migration] Running upgrade abc123 -> def456, add email index ... OK

psql -U admin -d mydb -c "\d users"
#    Column    |            Type             | Nullable
# -------------+-----------------------------+----------
#  id          | integer                     | not null
#  email       | character varying(255)      | not null
#  password    | character varying(255)      | not null
#  created_at  | timestamp without time zone |
# Indexes: "users_pkey" PRIMARY KEY, "idx_users_email" UNIQUE

psql -U admin -d mydb -c "SELECT COUNT(*) FROM users;"
#  count
# -------
#   1000
```

### Tests

```bash
pytest tests/ -v --cov=src --cov-report=term-missing

# tests/test_user_service.py::test_create_user_valid_data         PASSED  [ 25%]
# tests/test_user_service.py::test_create_user_invalid_email      PASSED  [ 50%]
# tests/test_user_service.py::test_create_user_duplicate_email    PASSED  [ 75%]
# tests/test_auth.py::test_authenticate_valid_credentials         PASSED  [100%]

# Name                    Stmts   Miss  Cover
# -------------------------------------------
# src/services/user.py       45      2    96%
# src/auth/jwt.py            32      1    97%
# -------------------------------------------
# TOTAL                      77      3    97%

# ========== 4 passed in 1.84s ==========
```

```bash
# E2E tests
npx playwright test tests/e2e/user-registration.spec.ts

#   pass [chromium] user-registration.spec.ts:5 › user can register (2.3s)
#   pass [firefox]  user-registration.spec.ts:5 › user can register (2.1s)
#   pass [webkit]   user-registration.spec.ts:5 › user can register (2.5s)
# 3 passed (7.2s)
```

---

## 4. Metrics

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Test coverage | >80% | 97% | PASS |
| P95 response time | <100ms | 87ms | PASS |
| Build time | <5 min | 3.2 min | PASS |
| Docker image size | <500 MB | 320 MB | PASS |
| Memory usage | <512 MB | 48 MB | PASS |
| Critical vulnerabilities | 0 | 0 | PASS |

```bash
# Response time measurement
ab -n 100 -c 10 http://localhost:8000/api/users
# Percentage of requests served within a certain time (ms):
#   50%    65
#   90%    82
#   95%    87
#   99%   115

# Vulnerability scan
pip-audit
# No known vulnerabilities found
```

---

## 5. Known Issues

[State "None" explicitly if there are no issues. Never leave this section blank.]

### Issue 1: [Short description]
**Severity:** High / Medium / Low
**Impact:** [What fails or degrades]
**Workaround:** [Steps to work around it now]
**Tracking:** [Issue number or link]
**Resolution plan:** [What will fix it and when]

---

## 6. Next Steps

1. [ ] [Concrete action — who, what, when]
2. [ ] [Concrete action — e.g., "Monitor staging for 24h before production deploy"]
3. [ ] [Concrete action — e.g., "Add rate limiting to POST /api/users — tracked in #456"]

---

## 7. Sign-off

**Completed by:** [Agent role]
**Date:** YYYY-MM-DD HH:MM UTC
**Git commit:** [hash]
**Branch:** [branch name]
**Evidence report covers:** [list of tasks or subtask IDs]

All acceptance criteria verified with command output shown above.
Ready for: [next stage — e.g., "handoff to Testing Engineer" or "deploy to staging"]

---

## 8. Appendix (optional)

### Diff — key changes

```diff
# Show the most important change if reviewers need to understand the implementation
@@ -45,3 +45,12 @@
+def process_data(data: dict) -> ProcessedData:
+    validator = DataValidator()
+    if not validator.validate(data):
+        raise ValidationError("Invalid data format")
+    return ProcessedData(**data)
```

### Rollback procedure

```bash
# If this change needs to be reverted:
alembic downgrade -1
git revert [commit-hash]
sudo systemctl restart myapp.service
curl -f http://localhost:8000/health
```

---
```

---

### Example — Simple Report: Bug Fix

```markdown
# Evidence Report: Fix Session Timeout Bug

**Date:** 2026-03-08
**Agent:** Backend Developer
**Status:** COMPLETE

---

## Summary

**Objective:** Fix login sessions expiring after 30 seconds instead of 30 minutes.

**Acceptance criteria:**
- [x] Authenticated sessions survive 30+ seconds of inactivity
- [x] Sessions still expire after 30 minutes (configurable)
- [x] Regression tests added

**Time:** 45 min actual vs 1 hour estimated

---

## Evidence

Before fix:
```bash
curl -X POST http://localhost:8000/api/auth/login -d '{"email":"a@b.com","password":"Pass1"}'
# TOKEN=eyJhbG...
sleep 31
curl http://localhost:8000/api/users/me -H "Authorization: Bearer $TOKEN"
# {"error": "Session expired"}   <-- incorrect behavior
```

After fix:
```bash
sleep 31
curl http://localhost:8000/api/users/me -H "Authorization: Bearer $TOKEN"
# {"id": 1, "email": "a@b.com"}   <-- correct behavior
```

Tests:
```bash
pytest tests/test_session.py -v
# tests/test_session.py::test_session_survives_30_seconds  PASSED
# tests/test_session.py::test_session_expires_after_30min  PASSED
# 2 passed in 0.34s
```

---

## Sign-off

Git commit: d3f4a5b
All criteria verified. Ready for staging deploy.
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Write the report from memory after the fact | Capture command output in real time as each step completes | Memory is unreliable; output copied from a previous run may not reflect the current state |
| "Tests pass" with no output shown | Paste the full `pytest` output including test names and coverage line | Reviewers need to see which tests ran and what coverage was achieved |
| Skip Section 5 (Known Issues) when there are none | Write "None" explicitly | A blank section is ambiguous — it could mean "forgotten" rather than "none" |
| Use the Full template for a 30-minute fix | Use the Simple variant for small changes | Over-documentation creates noise that obscures signal |
| File the report days after task completion | File immediately upon completion, before signaling done | Delayed reports are filled with reconstructed rather than real evidence |
| Describe what the code should do in the evidence section | Show what the command actually returned | "Should return 201" is not evidence; "returned 201" is |

---

## Related Documents

- [verification-protocol.md](../workflows/verification-protocol.md) — Full reference for each evidence type (what to run and what to expect)
- [agent-handoff.md](agent-handoff.md) — How to include this report when passing work to the next agent
- [task-decomposition.md](task-decomposition.md) — The "done when" criteria in decomposition become the acceptance criteria here

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
