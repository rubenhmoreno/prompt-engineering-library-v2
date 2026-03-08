# CLAUDE.md Guide

> **Executive Summary:** CLAUDE.md is the entry point for every Claude Code project. This guide teaches how to create one that is grounded in what the codebase actually does, not what you wish it would do.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [base-programming.md](base-programming.md), [error-prevention.md](error-prevention.md), [real-validation.md](real-validation.md), [prompting-techniques.md](prompting-techniques.md) |

---

## What CLAUDE.md Is

CLAUDE.md is a plain Markdown file placed at the root of a repository. Claude Code reads it automatically at the start of every session, before the user sends a single message. It acts as standing instructions: persistent context that does not need to be re-stated each time.

Think of it as the onboarding document you would hand to a new engineer on their first day — except that new engineer forgets everything between days. Every session is day one. CLAUDE.md must therefore contain everything Claude needs to work correctly in isolation.

Key properties:

- Read at session start, not on demand.
- Applies to every task in the session, not just the first.
- Survives conversation resets because it lives in the file system.
- Takes precedence over default Claude Code behavior when they conflict.

What CLAUDE.md is not: it is not a vision document, a style manifesto, or a wish list. Every line should be actionable and verifiable against the actual codebase.

---

## Required Sections

### 1. Project Overview

One or two sentences. State what the repository does and for whom. This is the frame through which every subsequent instruction is interpreted.

**Template:**

```
## Project

<Name> is a <type of system> that <core function> for <intended users>.
```

**Good example:**

```markdown
## Project

inventory-api is a REST API that manages warehouse stock levels for
warehouse operators at mid-size retail companies.
```

**Bad example:**

```markdown
## Project

This project is a modern, scalable solution built with best practices
in mind for enterprise use cases.
```

The bad example contains no facts. It could describe anything.

---

### 2. Build and Run Commands

Exact commands, not descriptions. If the command differs between environments, list both.

**Template:**

```markdown
## Commands

### Install
pip install -r requirements.txt

### Run (development)
uvicorn app.main:app --reload --port 8000

### Run (production)
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000

### Database migrations
alembic upgrade head
```

Do not write "run the application with uvicorn." Write the command. Claude does not guess flags.

---

### 3. Test Commands

Include flags that affect output: `-v` for visibility, `--cov` for coverage, `-x` to stop on first failure.

**Template:**

```markdown
## Tests

### Run all tests
pytest tests/ -v

### Run with coverage
pytest tests/ -v --cov=app --cov-report=term-missing --cov-fail-under=80

### Run a single test file
pytest tests/test_inventory.py -v

### Run tests matching a keyword
pytest tests/ -k "auth" -v
```

If there are multiple test suites (unit, integration, e2e), document each separately with its command.

---

### 4. Code Style Tools

The formatter, linter, and type checker triad. Document all three. If one is missing, say so explicitly so Claude does not invent a tool that is not installed.

**Template:**

```markdown
## Code Style

### Format
black app/ tests/

### Lint
ruff check app/ tests/

### Type check
mypy app/ --strict

Run all three before committing:
black app/ tests/ && ruff check app/ tests/ && mypy app/ --strict
```

**Alternative (JavaScript):**

```markdown
## Code Style

### Format
prettier --write "src/**/*.{ts,tsx}"

### Lint
eslint src/ --ext .ts,.tsx

### Type check
tsc --noEmit
```

---

### 5. Architecture Overview

A directory tree annotated with purpose, plus naming conventions Claude must follow.

**Template:**

```markdown
## Architecture

app/
  main.py          # FastAPI application factory
  models/          # SQLModel table definitions
  routers/         # One file per resource (users.py, items.py)
  services/        # Business logic, no database calls
  repositories/    # Database access layer
  schemas/         # Pydantic request/response models
tests/
  unit/            # Pure function tests, no database
  integration/     # Tests that hit a real SQLite test database

Naming conventions:
- Router files: plural noun (users.py, orders.py)
- Service functions: verb_noun (create_user, cancel_order)
- Test functions: test_<function>_<scenario> (test_create_user_duplicate_email)
```

---

### 6. Key Constraints

Things Claude must NOT do. This section prevents the most common mistakes. Use explicit negation.

**Template:**

```markdown
## Constraints

- Do NOT modify migrations/ directly; generate migrations with `alembic revision --autogenerate -m "description"`
- Do NOT add dependencies without updating requirements.txt and noting the reason in the PR description
- Do NOT use `SELECT *`; always name columns explicitly
- Do NOT store secrets in code; use environment variables loaded via python-dotenv
- Do NOT bypass the repository layer by calling the database from routers
- Do NOT push to main; all changes go through pull requests
```

Each constraint should name the forbidden action and, where useful, the permitted alternative.

---

### 7. Security Considerations

Authentication patterns, secrets handling, and input validation rules specific to this codebase.

**Template:**

```markdown
## Security

- Secrets: loaded from .env via python-dotenv; .env is in .gitignore and must never be committed
- Authentication: JWT tokens issued by POST /auth/token; validated by the `require_auth` dependency in app/deps.py
- Passwords: hashed with bcrypt via passlib; never stored or logged in plaintext
- Input: all request bodies validated by Pydantic schemas before reaching service layer
- SQL: use ORM or parameterized queries only; no string interpolation in queries
- CORS: configured in app/main.py; add origins in the ALLOWED_ORIGINS env var, not in code
```

---

## How to Derive CLAUDE.md from an Existing Codebase

Never write CLAUDE.md from memory or assumption. Read the codebase first, then write what you find.

**Step 1: Read the package manifest.**

The manifest reveals the runtime, framework, and toolchain.

```bash
# Python
cat pyproject.toml
cat requirements.txt

# Node.js
cat package.json

# Rust
cat Cargo.toml

# Go
cat go.mod
```

Extract: Python/Node/Rust/Go version, framework name and version, test runner, formatter, linter.

**Step 2: Read CI configuration.**

CI configs contain the authoritative test and build commands, because they must actually work.

```bash
cat .github/workflows/*.yml
cat .gitlab-ci.yml
cat Makefile
```

Copy test commands from CI verbatim. These are proven to work.

**Step 3: Read linter and formatter configs.**

These define the actual style rules in effect.

```bash
cat .eslintrc.json
cat ruff.toml
cat .flake8
cat pyproject.toml   # may contain [tool.ruff] and [tool.mypy] sections
cat .prettierrc
```

**Step 4: Read the README.**

The README gives the project overview and may contain setup instructions that differ from what CI does.

```bash
cat README.md
```

**Step 5: Scan directory structure.**

```bash
find . -maxdepth 3 -type d | grep -v ".git" | sort
```

Map the directories to their purpose. Note naming patterns.

After completing all five steps, write CLAUDE.md with only facts you verified. Mark anything uncertain with "TBD — verify before using."

---

## Anti-Patterns

| Anti-Pattern | Example | Problem | Fix |
|---|---|---|---|
| Aspirational rules | "Write clean, maintainable code" | Unmeasurable; Claude already tries to do this | Replace with a specific, checkable rule: "All public functions must have type annotations" |
| Dead rules | "Run `npm run lint:fix` before committing" | The script was removed in a refactor; Claude will fail trying to run it | Verify every command exists before adding it to CLAUDE.md |
| Missing negation | "Use the repository pattern for database access" | Tells Claude what to do but not what to avoid | Add: "Do NOT call the database from routers directly" |
| Stale rules | "Deploy using `./deploy.sh`" | The script was replaced by a GitHub Actions workflow | Review CLAUDE.md after every major refactor |
| Glob patterns with no matches | "All `*.service.ts` files must have unit tests" | No files match that pattern in the actual codebase | Verify glob patterns with `find . -name "*.service.ts"` before adding them |
| Version assumptions | "Use Python 3.11 features freely" | The production runtime is 3.9 | Check `python --version` in CI and set the rule from that |

---

## Maintenance

CLAUDE.md becomes stale the moment the codebase changes without a corresponding update. Treat it as a living document with the same discipline as the code itself.

**When to update CLAUDE.md:**

- After adding or removing a dependency that changes the toolchain
- After renaming directories or changing the architecture
- After switching test runners, formatters, or linters
- After changing deployment procedures
- After adding or removing authentication patterns

**The claude-rules-doctor pattern:**

At any point, run this check to detect dead rules:

```bash
# For each command in CLAUDE.md, verify it exists
grep -E "^\s*(pytest|npm|yarn|ruff|black|mypy|eslint)" CLAUDE.md | while read cmd; do
    tool=$(echo "$cmd" | awk '{print $1}')
    command -v "$tool" && echo "OK: $tool" || echo "MISSING: $tool"
done
```

For glob-based rules, verify the pattern matches at least one file:

```bash
# Example: verify *.service.ts pattern has files
find . -name "*.service.ts" | head -5
```

If the find returns nothing, the rule is dead and should be removed or updated.

**Review cadence:** Review CLAUDE.md at the start of every major feature branch, not just at the end. Stale instructions cause wasted work mid-feature.

---

## Related Documents

- [base-programming.md](base-programming.md) - Session-start prompt that CLAUDE.md reinforces
- [error-prevention.md](error-prevention.md) - The 7-category checklist that feeds into constraint rules
- [real-validation.md](real-validation.md) - Evidence standards for verifying CLAUDE.md rules are followed
- [workflows/explore-first.md](../workflows/explore-first.md) - Protocol for reading a codebase before writing CLAUDE.md
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
