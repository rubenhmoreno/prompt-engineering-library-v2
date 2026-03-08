# Explore First Workflow
> **Executive Summary:** Before modifying any unfamiliar codebase, invest time in structured exploration. The cost of skipping this step is incorrect assumptions, broken conventions, and introduced regressions. This workflow defines four investigation phases that produce an Exploration Report — a shared artifact that any agent or developer can use to understand the codebase before writing a single line of code.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [riper-workflow.md](riper-workflow.md), [verification-protocol.md](verification-protocol.md), [task-decomposition.md](../templates/task-decomposition.md) |

---

## Quick Reference Card

### When to Use This Workflow

| Situation | Apply Explore First? |
|-----------|----------------------|
| Unfamiliar codebase or repository | Yes — always |
| Resuming work after a long break (more than one day) | Yes |
| Picking up a task handed off from another agent | Yes |
| Already explored this repo in the current session | No — skip, use your existing notes |
| Greenfield project you are creating from scratch | No — nothing to explore yet |

### Phase Command Reference

| Phase | Key Tools / Commands |
|-------|----------------------|
| 1 — Structure | `ls`, `find . -maxdepth 3 -type f`, directory tree tools |
| 2 — Context | Read `README`, `package.json`, `pyproject.toml`, `.env.example`, CI config files |
| 3 — Patterns | Read 2-3 existing source files, test files, and a migration or schema file |
| 4 — Dependencies | Read import graphs, `requirements.txt`, `go.mod`, lock files; trace call chains |

### Exploration Report Skeleton

```
Project type:       [web API / CLI / library / monorepo / ...]
Primary language:   [Python 3.11 / Node 20 / Go 1.22 / ...]
Framework:          [FastAPI / Express / Django / ...]
Entry point:        [src/main.py / cmd/server/main.go / index.js]
Test runner:        [pytest / jest / go test / ...]
Test location:      [tests/ / __tests__/ / *_test.go]
Key config files:   [list paths]
Naming convention:  [snake_case / camelCase / PascalCase]
Code style tool:    [ruff / eslint / gofmt / ...]
CI system:          [GitHub Actions / GitLab CI / none]
Breaking-change risk: [low / medium / high] — reason
Recommended approach: [...]
```

---

## Full Content

### Phase 1: Structure Mapping

Goal: understand the shape of the repository before reading any code.

**Commands to run:**

```bash
# Top-level directory listing
ls -la

# File tree up to depth 3 (adjust if the repo is very large)
find . -maxdepth 3 -not -path '*/.git/*' -not -path '*/node_modules/*' \
       -not -path '*/__pycache__/*' | sort

# Count files by extension to infer primary language
find . -type f -not -path '*/.git/*' | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -20
```

**What to record:**

- Top-level directories and their apparent purpose (`src/`, `tests/`, `docs/`, `migrations/`, `scripts/`)
- Entry point candidates (`main.py`, `app.py`, `index.js`, `cmd/`)
- Presence of Docker files, CI configs, Makefiles — these reveal how the project is built and deployed
- Monorepo signals: multiple `package.json` files, a `packages/` or `apps/` directory, a workspace config

**Output for the Exploration Report:**

```
Project type:    [filled in]
Entry point:     [filled in]
Key directories: [list with one-line purpose each]
```

---

### Phase 2: Context Gathering

Goal: understand the project's stated purpose, dependencies, and operational requirements.

**Files to read in priority order:**

```bash
# 1. Human-readable intent
cat README.md            # or README.rst, README.txt

# 2. Dependency manifest (read the whole file)
cat requirements.txt     # Python
cat pyproject.toml       # Python (modern)
cat package.json         # Node
cat go.mod               # Go
cat Cargo.toml           # Rust

# 3. Environment variables required
cat .env.example         # what secrets/config does the app need?

# 4. CI/CD pipeline
cat .github/workflows/*.yml
cat .gitlab-ci.yml
cat Makefile             # build targets reveal the intended workflow

# 5. Database schema or migration history
ls migrations/           # alembic, flyway, knex
cat alembic.ini          # confirms DB URL pattern
```

**What to record:**

- Framework name and version
- External services depended upon (DB engine, message queue, cache, third-party APIs)
- Environment variables that must be set before running
- The commands used to run tests, lint, and start the server (usually in README or Makefile)
- Any explicit coding guidelines, contribution rules, or linting configuration

**Output for the Exploration Report:**

```
Framework:        [filled in]
Dependencies:     [key ones, not the full list]
Env vars needed:  [list from .env.example]
Run tests with:   [exact command]
Lint with:        [exact command]
Start server:     [exact command]
```

---

### Phase 3: Pattern Recognition

Goal: understand the conventions the existing team uses, so your changes are indistinguishable from theirs.

**Files to read:**

```bash
# Read 2-3 representative source files — pick ones that are neither trivial nor huge
# For a Python API, good candidates are: a router file, a service file, a model file
# For a Node app: a controller, a middleware, a model

# Read 2-3 test files to learn the testing style
# Are tests in classes or flat functions? Do they use fixtures or inline setup?
# Do they mock at the boundary or at the implementation?

# Read one migration file to learn schema conventions
```

**What to record:**

- Naming conventions: files, functions, classes, variables, database columns
- Import style: absolute vs relative, aliased imports, barrel files
- Error handling pattern: exceptions vs result types vs error codes
- Authentication guard placement: middleware, decorator, or manual check in each route
- Test structure: fixture style, assertion library, naming pattern for test functions
- Comment density and docstring format

**Concrete signals to look for:**

| Signal | What It Tells You |
|--------|-------------------|
| `snake_case` filenames | Python conventions; match them |
| Barrel `index.ts` exports | Node/TS pattern; add new files to the barrel |
| `@pytest.fixture` decorators in `conftest.py` | Shared test fixtures; use them, do not duplicate |
| `# type: ignore` comments | The project tolerates some typing gaps; note which ones |
| Long functions with no helpers | Refactoring is not the norm here; do not introduce it unilaterally |
| Tests that seed a real database | Integration tests use actual storage; do not add mocks without approval |

**Output for the Exploration Report:**

```
Naming convention:  [snake_case / camelCase / PascalCase]
Test pattern:       [flat functions / class-based / BDD]
Error handling:     [exceptions / result types / error codes]
Style tool:         [ruff / eslint / gofmt / none]
Notable conventions: [anything that differs from language defaults]
```

---

### Phase 4: Dependency Analysis

Goal: identify what depends on what, so you can predict which parts of the codebase will be affected by your change.

**Commands to run:**

```bash
# Python: find all files that import the module you plan to change
grep -r "from services.user_service import" src/ tests/
grep -r "import user_service" src/ tests/

# Node/TS: find all files that import the module
grep -r "from './userService'" src/
grep -r "require('./userService')" src/

# Find all callers of a specific function
grep -r "create_user\|CreateUser\|createUser" src/ tests/

# Check if the module is re-exported (barrel files)
grep -r "user_service" src/index.ts

# Identify shared state: global variables, singletons, module-level DB connections
grep -r "^db = \|^engine = \|^app = " src/
```

**What to record:**

- Files directly importing the module you plan to change
- Functions with many callers (high fan-in = high breaking-change risk)
- Shared state that multiple modules mutate
- Public API surface (routes, exported functions, CLI commands) — changes here break external consumers

**Breaking-change risk matrix:**

| Change Type | Risk Level | Why |
|-------------|------------|-----|
| Rename internal private function | Low | Only one file is affected |
| Change function signature (add required param) | High | All callers must be updated |
| Add optional param with default value | Low | All callers remain compatible |
| Rename a database column | High | ORM models, raw queries, and migrations all break |
| Change a REST endpoint URL | High | Clients and tests will fail immediately |
| Change response JSON shape | Medium-High | Clients parsing specific keys will break |
| Add a new endpoint | Low | No existing code is affected |

**Output for the Exploration Report:**

```
Files affected by planned change: [list]
High-risk callers:                [list function names and call sites]
Breaking-change risk:             [low / medium / high]
Recommended approach:             [proceed / refactor first / propose interface change]
```

---

### Exploration Report — Full Template

Produce this report as a code block comment or a standalone artifact before starting any implementation work.

```
=== EXPLORATION REPORT ===
Date:               2026-03-08
Codebase:           [repo name or path]
Explorer:           [agent or developer name]

--- STRUCTURE ---
Project type:       [web API / CLI / library / monorepo]
Primary language:   [language + version]
Framework:          [framework + version]
Entry point:        [file path]
Key directories:
  src/              [purpose]
  tests/            [purpose]
  migrations/       [purpose]
  [other]           [purpose]

--- CONTEXT ---
Dependencies:       [key libs]
Env vars needed:    [list]
Run tests with:     [command]
Lint with:          [command]
Start server with:  [command]
CI system:          [system or none]

--- PATTERNS ---
Naming convention:  [convention]
Test structure:     [structure]
Error handling:     [strategy]
Style tool:         [tool or none]
Notable conventions: [list]

--- DEPENDENCIES ---
Files I plan to change:    [list]
Files that import them:    [list]
High fan-in functions:     [list]
Breaking-change risk:      [low / medium / high]
Risk reason:               [one sentence]

--- RECOMMENDED APPROACH ---
[One paragraph: what to do, in what order, what to avoid]
=== END REPORT ===
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Open the first file that looks relevant and start editing | Complete all four phases before touching any file | The first file that looks relevant is rarely the right entry point |
| Infer the framework from the file extension (`.py` = Django, `.ts` = Next.js) | Read `pyproject.toml` or `package.json` to confirm the actual framework | Many Python projects use Flask, FastAPI, or no framework at all |
| Skip test discovery because "we'll add tests later" | Find the test runner and test location in Phase 2 | Not knowing how tests run leads to tests written in the wrong format |
| Assume naming conventions from memory of other projects | Read existing source files and match exactly what is there | Inconsistent naming creates noise in diffs and confuses future readers |
| Skip dependency analysis for "a small change" | Always trace who imports what, even for one-line changes | A one-line signature change can break twenty callers silently |
| Produce the Exploration Report mentally without writing it down | Write the report as a concrete artifact | Unwritten understanding is not transferable and is lost when the session ends |
| Run the project before reading the README | Read the README first; it often contains mandatory setup steps | Missing a required env var or migration step causes confusing startup errors |

---

## Related Documents

- [riper-workflow.md](riper-workflow.md) — Structured five-phase workflow that uses the Exploration Report as input to the Research phase
- [verification-protocol.md](verification-protocol.md) — How to produce evidence that your changes work after exploration is complete
- [task-decomposition.md](../templates/task-decomposition.md) — Breaking the work into safe, independently verifiable steps once exploration is done
- [agent-handoff.md](../templates/agent-handoff.md) — How to pass the Exploration Report to another agent continuing the work

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
