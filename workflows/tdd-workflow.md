# TDD Workflow
> **Executive Summary:** Test-Driven Development (TDD) is a discipline where you write a failing test before writing any implementation code. The RED-GREEN-REFACTOR cycle produces high-coverage, well-designed code with minimal debugging overhead. Use it for all business-logic-heavy work; skip it only for pure configuration or trivial glue code.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [verification-protocol.md](verification-protocol.md), [evidence-report.md](../templates/evidence-report.md) |

---

## Quick Reference Card

### The TDD Cycle

| Phase | Action | Success Signal |
|-------|--------|---------------|
| RED | Write one failing test for one behavior | Test fails with the right error (missing implementation, not a syntax bug) |
| GREEN | Write the minimum code to make it pass | Test passes; no other tests broken |
| REFACTOR | Improve structure without changing behavior | All tests still pass after every change |
| REPEAT | Pick the next behavior, return to RED | Coverage grows with each cycle |

### TDD Decision Guide

| Situation | Use TDD? | Reason |
|-----------|----------|--------|
| Business logic, calculations, domain rules | Yes | High ROI; catches edge cases early |
| Data transformations and parsing | Yes | Many corner cases; fast feedback loop |
| API endpoint behavior | Yes | Contracts are directly testable |
| Authentication and authorization | Yes | Security-critical; must be explicit |
| Pure configuration files | No | Nothing to assert |
| Third-party API wrappers (no mock available) | No | Network dependency makes the cycle too slow |
| Database migrations | No | Schema changes need integration context |
| Simple one-liner utilities | Optional | Judgment call on complexity |

### Coverage Targets

| Test Type | Minimum | Target |
|-----------|---------|--------|
| Unit | 80% | 90%+ |
| Integration | 60% | 80% |
| E2E | All critical user flows | All critical paths passing |

---

## Full Content

### Phase 1: RED — Write a Failing Test

Write **one** test for **one** specific behavior before touching implementation. Use the GIVEN / WHEN / THEN pattern to make intent explicit.

**Python (pytest):**

```python
# tests/test_user_service.py
import pytest
from services.user_service import UserService

def test_create_user_returns_hashed_password():
    """
    GIVEN valid email and password
    WHEN  create_user() is called
    THEN  returns a User with a hashed password and a non-null id
    """
    service = UserService()
    user = service.create_user(email="test@example.com", password="SecurePass1")
    assert user.id is not None
    assert user.email == "test@example.com"
    assert user.password != "SecurePass1"   # must be hashed
```

**JavaScript (Jest):**

```javascript
test("createUser returns user with hashed password", () => {
    const service = new UserService();
    const user = service.createUser("test@example.com", "SecurePass1");
    expect(user.id).not.toBeNull();
    expect(user.password).not.toBe("SecurePass1");
});
```

**C# (xUnit):**

```csharp
[Fact]
public void CreateUser_ValidData_ReturnsHashedPassword()
{
    var service = new UserService();
    var user = service.CreateUser("test@example.com", "SecurePass1");
    Assert.NotNull(user.Id);
    Assert.NotEqual("SecurePass1", user.Password);
}
```

**Run the test — it must fail:**

```bash
pytest tests/test_user_service.py::test_create_user_returns_hashed_password -v
# FAILED — ImportError: cannot import name 'UserService'
```

Confirm the failure is caused by missing implementation, not by a bug in the test itself. A test failing due to a syntax error or wrong import path must be corrected before you proceed.

---

### Phase 2: GREEN — Write the Minimum Implementation

Write only enough code to make the single failing test pass. Do not add features, logging, or optimization at this stage.

```python
# services/user_service.py  (minimum viable for the test above)
import bcrypt
from dataclasses import dataclass
from typing import Optional

@dataclass
class User:
    id: Optional[int]
    email: str
    password: str

class UserService:
    def __init__(self):
        self._store = []
        self._next_id = 1

    def create_user(self, email: str, password: str) -> User:
        hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()
        user = User(id=self._next_id, email=email, password=hashed)
        self._store.append(user)
        self._next_id += 1
        return user
```

```bash
pytest tests/test_user_service.py::test_create_user_returns_hashed_password -v
# PASSED
```

Stop here. Do not optimize or add additional behaviors until after REFACTOR.

---

### Phase 3: REFACTOR — Improve Without Breaking

Identify structural weaknesses and fix them one step at a time. Run the full test suite after each individual change.

**Example: extract validation to a dedicated class**

```python
# validators/user_validator.py
import re

class UserValidator:
    _EMAIL_RE = re.compile(r'^[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,}$')

    def validate_email(self, email: str) -> None:
        if not self._EMAIL_RE.match(email):
            raise ValueError(f"Invalid email: {email}")

    def validate_password(self, password: str) -> None:
        if len(password) < 8:
            raise ValueError("Password must be at least 8 characters")
        if not any(c.isupper() for c in password):
            raise ValueError("Password must contain an uppercase letter")
        if not any(c.isdigit() for c in password):
            raise ValueError("Password must contain a digit")
```

After each refactor step, run:

```bash
pytest tests/test_user_service.py -v
# All tests must still PASS
```

If any test breaks after a refactor step, revert that step before continuing. Then add tests for the new behavior introduced:

```python
def test_create_user_rejects_invalid_email():
    service = UserService()
    with pytest.raises(ValueError, match="Invalid email"):
        service.create_user(email="not-an-email", password="SecurePass1")

def test_create_user_rejects_short_password():
    service = UserService()
    with pytest.raises(ValueError, match="at least 8 characters"):
        service.create_user(email="a@b.com", password="short")
```

---

### Phase 4: REPEAT — Next Behavior

Return to RED for the next item on the requirements list. One behavior per cycle; one commit per completed cycle.

**Example progression for a Task service:**

```
Cycle 1: create_task()   -> RED -> GREEN -> REFACTOR -> commit
Cycle 2: complete_task() -> RED -> GREEN -> REFACTOR -> commit
Cycle 3: list_pending()  -> RED -> GREEN -> REFACTOR -> commit
Cycle 4: delete_task()   -> RED -> GREEN -> REFACTOR -> commit
```

**Condensed example for one cycle (complete_task):**

```python
# RED
def test_complete_task_marks_it_done():
    svc = TaskService()
    task = svc.create_task(title="Buy milk")
    svc.complete_task(task.id)
    assert svc.get_task(task.id).completed is True

# GREEN (minimum)
def complete_task(self, task_id: int) -> None:
    task = next(t for t in self._tasks if t.id == task_id)
    task.completed = True

# REFACTOR — raise TaskNotFoundError if id is missing, extract to repository
```

---

### TDD for Different Test Types

| Test Type | Scope | Cycle Speed | TDD Approach |
|-----------|-------|-------------|--------------|
| Unit | Single function or class | Under 1 second | Strict RED-GREEN-REFACTOR per behavior |
| Integration | Service + DB or Service + API | 1–10 seconds | Use fixtures; test contracts between layers |
| E2E | Full browser flow | 10–60 seconds | Write the scenario first; implement the feature to satisfy it |

**Unit test fixture pattern (pytest):**

```python
# conftest.py
import pytest
from services.user_service import UserService

@pytest.fixture
def user_service():
    return UserService()   # fresh instance per test, no shared state
```

**Integration test pattern (in-memory DB):**

```python
@pytest.fixture(scope="session")
def db_session():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    with Session(engine) as session:
        yield session
        session.rollback()
```

**E2E test pattern (Playwright):**

```python
def test_user_can_register(page):
    page.goto("http://localhost:3000/register")
    page.fill("[name=email]", "test@example.com")
    page.fill("[name=password]", "SecurePass1")
    page.click("button[type=submit]")
    page.wait_for_selector("text=Welcome, test@example.com")
```

---

### Coverage Metrics

Run coverage after each feature is complete, not after each cycle:

```bash
pytest tests/ -v --cov=src --cov-report=term-missing

# Example output:
# Name                     Stmts   Miss  Cover
# --------------------------------------------
# src/services/user.py        45      2    96%
# src/validators/user.py      28      0   100%
# --------------------------------------------
# TOTAL                       73      2    97%
# ========== 12 passed in 1.84s ==========
```

Generate an HTML report to browse uncovered lines interactively:

```bash
pytest --cov=src --cov-report=html
open htmlcov/index.html
```

**Commit discipline:** one atomic commit per completed RED-GREEN-REFACTOR cycle.

```bash
git add src/services/ tests/test_user_service.py
git commit -m "feat(user): validate email format on create_user"
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Write all tests for a module before any implementation | Write one test, implement, refactor, repeat | Batch test writing loses the design feedback loop |
| Implement extra features during GREEN | Write only what the failing test requires | Over-implementation creates untested surface area |
| Refactor before reaching GREEN | Only refactor after all current tests pass | Refactoring on red mixes two distinct failure modes |
| Test implementation details (internal method names, private state) | Test observable behavior (return values, exceptions, side effects) | Tests coupled to internals break on every refactor |
| Tests that share mutable state or depend on execution order | Each test creates its own fixtures and tears down independently | Shared state causes intermittent failures that mask real bugs |
| Skip the refactor phase when "the code works" | Always refactor before moving to the next cycle | Accumulated tech debt makes later cycles progressively slower |
| Mark a feature done with under 80% coverage | Add edge-case tests until the target is met | Low coverage hides the exact bugs TDD was meant to prevent |

---

## Related Documents

- [verification-protocol.md](verification-protocol.md) — How to produce evidence that tests actually ran and passed
- [evidence-report.md](../templates/evidence-report.md) — Report template for documenting test results at task completion
- [parallel-development.md](parallel-development.md) — Running TDD cycles across multiple agents simultaneously
- [task-decomposition.md](../templates/task-decomposition.md) — Breaking a feature into TDD-sized behaviors before starting

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
