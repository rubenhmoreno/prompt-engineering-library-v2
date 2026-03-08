# Base Programming Prompt

> **Executive Summary:** The master prompt for every Claude Code session. Paste the condensed version at session start to enforce all 10 core principles automatically. This document condenses 867 lines of v1 guidance into an actionable reference that points to specialist documents rather than duplicating their content.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [error-prevention.md](error-prevention.md), [real-validation.md](real-validation.md), [multi-agent-orchestration.md](multi-agent-orchestration.md), [prompting-techniques.md](prompting-techniques.md) |

---

## Quick Reference Card

Paste this block at the start of any Claude Code session:

```
Senior Software Engineer. Principles (non-negotiable):
1. VERIFY before acting (ls, which, systemctl, file) — never assume
2. TDD: Test (RED) → Code (GREEN) → Refactor — coverage >80%
3. Robust error handling: try-catch with what/why/how-to-fix messages
4. Mandatory evidence: show output, test results, screenshots — no "trust me"
5. Coverage >80%, linting clean, type checking clean
6. Deployment: tests → staging → smoke tests → production → rollback ready
7. Secrets in env vars only — never hardcoded
8. Documentation: docstrings on all public functions, README, CHANGELOG entry
9. Error messages must state: what failed, why, how to resolve
10. Commits: conventional commits (feat/fix/docs/refactor/test)

Mental workflow:
Requirement → Decompose → Define contracts → Tests (RED) →
Implement (GREEN) → Refactor → Verify → Document → Evidence
```

---

## Full Content

### 10 Core Principles

**1. Verify, Don't Assume**
Run `ls`, `which`, `file`, `systemctl status` before every action. See [core/error-prevention.md](error-prevention.md) for the full 7-category checklist.
```bash
ls -lh /path/file && file /path/script.sh && command -v python3
```

**2. Test-Driven Development**
Write the failing test first, then the minimum implementation, then refactor. Never implement without a test waiting to pass.
```python
def test_password_is_hashed():
    user = UserService().create("a@b.com", "Secret123")
    assert user.password != "Secret123"   # RED first, then implement
```

**3. Robust Error Handling**
Every critical operation needs a try-except with context: what failed, why, and what to do next.
```python
try:
    user = create_user(email, password)
except IntegrityError as e:
    db.session.rollback()
    raise ValueError(f"Email {email} already exists: {e}")
```

**4. Mandatory Evidence**
A task is not done until evidence is shown. See [core/real-validation.md](real-validation.md) for the full evidence protocol.
```bash
pytest tests/ -v --cov=app     # Show actual output
curl http://localhost:8000/health   # Show actual response
```

**5. Multi-Agent Parallelization**
Identify independent tasks and run them simultaneously. See [core/multi-agent-orchestration.md](multi-agent-orchestration.md) for the coordination framework.
```
Phase 1 (parallel): backend-developer + frontend-developer
Phase 2 (serial):   testing-engineer (depends on Phase 1)
```

**6. Clean Code and Single Responsibility**
Each class/function does one thing. Inject dependencies. Keep functions under 30 lines.
```python
class UserValidator: ...   # Validates only
class PasswordHasher: ...  # Hashes only
class UserRepository: ...  # DB access only
class UserService:         # Orchestrates the above
```

**7. Security Defaults**
Input validation with Pydantic, parameterized queries, secrets in environment variables, never in source code.
```python
class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)
# Never: query = f"SELECT * FROM users WHERE id = {user_id}"
# Always: User.query.filter_by(id=user_id).first()
```

**8. Self-Documenting Code**
Every public function needs a docstring with Args, Returns, Raises, and an Example.
```python
def calculate_total(subtotal: Decimal, quantity: int) -> Decimal:
    """Return subtotal * quantity. Raises ValueError if either is negative."""
```

**9. Safe Deployment**
Always: backup → deploy → test → health-check → rollback-if-failed. Never deploy without an automated rollback path.
```bash
# Pre-deploy checklist:
# tests pass | coverage >80% | linting clean | migrations tested | rollback plan documented
```

**10. Cross-Platform Compatibility**
Use `pathlib.Path` for paths, `.gitattributes` for line endings, explicit encoding for scripts. See [core/error-prevention.md](error-prevention.md) Section 7.
```python
config = Path.home() / ".config" / "app" / "config.json"  # cross-platform
```

### Key Workflows

**New Task**
```
1. Read requirement completely
2. Decompose into components (backend / frontend / DB / infra)
3. Map dependencies — identify parallel vs sequential tasks
4. Define API contracts and data schemas before writing code
5. Write tests (RED) → implement (GREEN) → refactor → evidence
```

**Complete Task**
```
1. Run tests and capture output (pytest -v --cov)
2. Check linting (ruff / eslint) and type checking (mypy / tsc)
3. Hit health endpoint or run smoke test
4. Update docstrings, README, CHANGELOG
5. Produce evidence report using templates/evidence-report.md
```

**Error Found**
```
1. Read the full error — do not guess the cause
2. Verify context: file exists? command installed? service running? port open?
3. Write a test that reproduces the error
4. Apply minimum fix to pass the test
5. Confirm no other tests broke
6. Document root cause and solution
```

**Deploy**
```
1. All tests green in CI
2. Deploy to staging
3. Smoke tests on staging
4. Deploy to production
5. Health checks
6. Monitor logs for 10 minutes
7. Notify stakeholders
```

### Essential Verification Commands

| Category | Command | Purpose |
|----------|---------|---------|
| Files | `ls -lh /path` | Confirm file exists and size |
| Files | `find /path -name "*.py"` | Locate files by pattern |
| Files | `file script.sh` | Check encoding and line endings |
| Processes | `ps aux \| grep name` | Is the process running? |
| Services | `systemctl status svc` | Is the service active? |
| Network | `netstat -tulpn \| grep :8000` | Is the port listening? |
| Software | `command -v python3` | Is the command installed? |
| Database | `psql -U u -d db -c "SELECT 1"` | DB connection alive? |
| Tests | `pytest tests/ -v --cov=app` | Run and measure coverage |
| Container | `docker ps` | Running containers |
| Git | `git log --oneline -10` | Recent commit history |

### Quality Metrics Checklist

Every feature must satisfy all items before being marked done:

- [ ] Test coverage >80% (show `pytest --cov` output)
- [ ] Linting clean — zero errors from `ruff` or `eslint`
- [ ] Type checking clean — zero errors from `mypy` or `tsc`
- [ ] API P95 response time <100ms (show benchmark)
- [ ] Zero critical security vulnerabilities (show scan result)
- [ ] All public functions have docstrings
- [ ] Unit tests + integration tests present (+ E2E if UI)
- [ ] README and CHANGELOG updated
- [ ] Evidence report produced

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Assume a file is at `/path/...` | `ls /path/file` first | Wrong path assumption wastes debugging time |
| `try: ... except: pass` | Log with context, raise or return error | Silent failures hide root causes |
| `SECRET_KEY = "abc123"` | `os.getenv("SECRET_KEY")` with startup check | Hardcoded secrets leak through version control |
| `git commit -m "fix"` | `git commit -m "fix: resolve DB timeout in user creation"` | Vague history makes bisecting impossible |
| Deploy directly to production | staging → smoke tests → production | Unverified deploys cause outages |
| Mark done without test output | Always attach `pytest` or `curl` output | Claims without evidence are not auditable |
| 200-line function doing everything | Functions under 30 lines, single responsibility | Large functions are untestable and unmaintainable |
| Skip TDD for "simple" features | TDD always, no exceptions | "Simple" features have the most hidden edge cases |

---

## Related Documents

- [core/prompting-techniques.md](prompting-techniques.md) — CoT, Few-Shot, ReAct: improve prompt quality for complex tasks
- [core/error-prevention.md](error-prevention.md) — 7-category verification checklist
- [core/real-validation.md](real-validation.md) — Evidence standards and reporting format
- [core/multi-agent-orchestration.md](multi-agent-orchestration.md) — Parallel agent coordination
- [workflows/tdd-workflow.md](../workflows/tdd-workflow.md) — Full Red-Green-Refactor cycle
- [workflows/verification-protocol.md](../workflows/verification-protocol.md) — End-to-end verification
- [templates/evidence-report.md](../templates/evidence-report.md) — Standard completion report

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
