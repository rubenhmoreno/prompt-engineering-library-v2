# Slash Commands Quick Reference

> **Executive Summary:** Slash commands are Markdown files stored in `.claude/commands/` that prime Claude with a specific role, checklist, or workflow at the start of a task. Instead of re-typing a long prompt, you type `/tdd` or `/verify` and Claude loads the full context. This file defines six production-ready commands you can copy into any project.

| Metadata | Value |
|----------|-------|
| Type     | Reference |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [workflows/tdd-workflow.md](../workflows/tdd-workflow.md), [workflows/verification-protocol.md](../workflows/verification-protocol.md), [workflows/explore-first.md](../workflows/explore-first.md), [agents/security-auditor.md](../agents/security-auditor.md) |

---

## How Slash Commands Work

Create a directory at the root of your project:

```bash
mkdir -p .claude/commands
```

Each `.md` file in that directory becomes a slash command. The filename (without extension) is the command name. When you type `/tdd` in Claude Code, it reads `.claude/commands/tdd.md` and injects its content as context before your message.

**File naming rules:**

| File | Command |
|------|---------|
| `.claude/commands/tdd.md` | `/tdd` |
| `.claude/commands/security-review.md` | `/security-review` |
| `.claude/commands/incident.md` | `/incident` |

Commands are project-local. They are not shared across repositories unless you copy the files. Commit `.claude/commands/` to version control so the whole team gets the same commands.

---

## /tdd

Invokes the Test-Driven Development workflow. Enforces RED-GREEN-REFACTOR discipline with mandatory coverage verification at the end.

**File:** `.claude/commands/tdd.md`

```markdown
You are operating in TDD mode. Follow this cycle strictly for the current task.

Phase 1 — RED
- Write one failing test that describes a single, specific behavior.
- Run the test and confirm it fails with the expected error (missing
  implementation, not a syntax error).
- Do not write any implementation code in this phase.

Phase 2 — GREEN
- Write the minimum code required to make the failing test pass.
- Run the test suite and confirm the new test passes and no existing
  tests regress.
- Do not refactor in this phase.

Phase 3 — REFACTOR
- Improve structure, naming, or duplication without changing behavior.
- Run the full test suite after every individual change.
- Stop when all tests pass and the code is clear.

Phase 4 — VERIFY COVERAGE
- Run: pytest tests/ -v --cov=app --cov-report=term-missing
- Coverage must be >= 80% on changed modules.
- If coverage is below threshold, return to Phase 1 with a new test
  for the uncovered branch.

Rules:
- Never skip the RED phase. If you cannot write a failing test, the
  requirement is not specific enough — ask for clarification.
- Never write more implementation than the current failing test demands.
- Never merge a commit where coverage dropped.

Reference: workflows/tdd-workflow.md
```

---

## /verify

Runs the verification protocol on completed work. Every claim about system state must be backed by evidence — an actual command and its actual output.

**File:** `.claude/commands/verify.md`

```markdown
You are in verification mode. Apply the evidence protocol to all claims.

Rules:
- NEVER assert system state without proof.
- For every claim, run the appropriate command and show its output.
- If the output contradicts the claim, update the claim to match reality.

Evidence format:

  Claim: The API is running on port 8000.
  Evidence:
    $ ss -tulpn | grep :8000
    tcp LISTEN 0 128 0.0.0.0:8000 0.0.0.0:* users:(("uvicorn",pid=1234))
  Status: CONFIRMED

Verification checklist for completed work:
1. All new files exist on disk (ls -lh)
2. All changed services are running (systemctl is-active / ps aux)
3. All tests pass (pytest tests/ -v)
4. Coverage is >= 80% (--cov-fail-under=80)
5. No linting errors (ruff check app/ || eslint src/)
6. No type errors (mypy app/ || tsc --noEmit)
7. Health endpoint responds (curl -sf http://localhost:PORT/health)
8. No secrets committed (git diff --staged | grep -i "password\|secret\|token")

Do not mark a task complete until all eight checks are satisfied and
evidence is on record.

Reference: workflows/verification-protocol.md
```

---

## /explore

Runs the explore-first protocol before making any changes. Maps the codebase structure, reads key files, and identifies patterns before touching a single line.

**File:** `.claude/commands/explore.md`

```markdown
You are in explore mode. Do not modify any files until the exploration
is complete and you have confirmed your understanding with the user.

Exploration sequence:

Step 1 — Map structure
  find . -maxdepth 3 -type d | grep -v ".git" | sort

Step 2 — Read manifest
  cat pyproject.toml || cat package.json || cat Cargo.toml || cat go.mod

Step 3 — Read CLAUDE.md (if present)
  cat CLAUDE.md

Step 4 — Read entry point
  Identify main.py / index.ts / main.rs / main.go and read it fully.

Step 5 — Read tests
  ls tests/ || ls __tests__/ || ls spec/
  Read 2–3 representative test files to understand test patterns.

Step 6 — Read CI config
  cat .github/workflows/*.yml || cat .gitlab-ci.yml || cat Makefile

Step 7 — Summarize findings
  After completing steps 1–6, produce:
  - One-paragraph description of what the codebase does
  - List of frameworks and tools in use with versions
  - Directory map with one-line purpose for each directory
  - Naming conventions observed
  - Patterns to follow when adding new code
  - Anything ambiguous that needs clarification before proceeding

Do not begin implementation until the user confirms the summary is accurate.

Reference: workflows/explore-first.md
```

---

## /decompose

Breaks a complex task into agent-assignable subtasks with an explicit dependency graph. Use this before starting any task that touches more than two files or two systems.

**File:** `.claude/commands/decompose.md`

```markdown
You are in task decomposition mode. Break the stated task into
independently executable subtasks before any implementation begins.

Decomposition format:

  Task: <restate the original task in one sentence>

  Subtasks:
  ID  | Description                        | Depends on | Assignable to
  T1  | <specific, bounded action>         | none       | backend-developer
  T2  | <specific, bounded action>         | T1         | testing-engineer
  T3  | <specific, bounded action>         | none       | frontend-developer
  T4  | <specific, bounded action>         | T2, T3     | devops-engineer

  Parallel opportunities:
  - T1 and T3 can run simultaneously (no shared dependencies)
  - T4 must wait for T2 and T3

  Critical path: T1 → T2 → T4

  Contracts (interfaces each subtask must honor):
  T1 outputs: <describe the exact artifact or API shape>
  T3 outputs: <describe the exact artifact or API shape>
  T4 inputs:  <describe what it expects from T2 and T3>

Rules:
- Each subtask must be completable in a single session.
- Each subtask must have a clear, binary done/not-done criterion.
- Contracts must be defined before any subtask begins.
- Do not start implementation until the user approves the decomposition.

Reference: templates/task-decomposition.md
```

---

## /security-review

Runs a security audit against the OWASP Top 10 checklist. Use before any code is merged to a production branch.

**File:** `.claude/commands/security-review.md`

```markdown
You are a security auditor. Perform a structured review of the
specified code or system against the OWASP Top 10.

For each item, state: status (PASS / FAIL / NEEDS-REVIEW), evidence,
and remediation if applicable.

OWASP Top 10 Checklist (2021):

A01 Broken Access Control
  - Are authorization checks applied before every sensitive operation?
  - Can a user access another user's data by changing an ID in the URL?
  - Are directory listings disabled?

A02 Cryptographic Failures
  - Are passwords hashed with bcrypt, scrypt, or Argon2 (not MD5/SHA1)?
  - Is sensitive data encrypted at rest and in transit?
  - Are TLS certificates valid and not expired?

A03 Injection
  - Are all database queries parameterized or using an ORM?
  - Is user input validated before being passed to shell commands?
  - Is output encoded before being rendered in HTML?

A04 Insecure Design
  - Is there a threat model for the most sensitive workflows?
  - Are rate limits in place on authentication endpoints?

A05 Security Misconfiguration
  - Are default credentials changed?
  - Are error messages free of stack traces in production?
  - Are unnecessary features, ports, and services disabled?

A06 Vulnerable and Outdated Components
  - Run: pip audit || npm audit || cargo audit
  - Are there known CVEs in current dependencies?

A07 Identification and Authentication Failures
  - Are sessions invalidated on logout?
  - Is multi-factor authentication available for privileged accounts?
  - Are brute-force protections in place on login endpoints?

A08 Software and Data Integrity Failures
  - Are dependency checksums verified (lockfiles committed)?
  - Is CI/CD pipeline access restricted?

A09 Security Logging and Monitoring Failures
  - Are authentication failures logged with timestamp and source IP?
  - Are logs stored where the application cannot modify them?

A10 Server-Side Request Forgery
  - Is user-supplied input used to construct outbound HTTP requests?
  - If so, is the target URL validated against an allowlist?

Deliver findings as a table:

  | # | Item | Status | Evidence | Remediation |
  |---|------|--------|----------|-------------|

Reference: agents/security-auditor.md
```

---

## /incident

Starts the incident response workflow with severity triage. Use immediately when a production system is degraded or down.

**File:** `.claude/commands/incident.md`

```markdown
You are the incident commander. Start the structured response protocol.

Step 1 — Triage (complete within 5 minutes)
  Answer each question with evidence, not assumption:
  - What is failing? (service name, endpoint, error message)
  - When did it start? (first alert timestamp)
  - What changed recently? (last deploy, config change, cron job)
  - How many users are affected? (error rate from logs or metrics)

  Assign severity:
  SEV-1: Total outage or data loss risk — page on-call immediately
  SEV-2: Major feature broken, workaround unavailable — respond within 30 min
  SEV-3: Degraded performance or partial failure — respond within 2 hours
  SEV-4: Minor issue with workaround available — schedule for next sprint

Step 2 — Stabilize (stop the bleeding)
  - Roll back the last deploy if a deploy correlates with the incident start
  - Disable the failing feature flag if one exists
  - Redirect traffic away from the unhealthy instance
  - Do NOT attempt root cause analysis until the system is stable

  Rollback command template:
    git revert HEAD --no-edit && git push origin main
    # or
    kubectl rollout undo deployment/<name>

Step 3 — Investigate (only after stabilization)
  - Read logs from the incident window:
      journalctl -u myservice --since "2026-03-08 14:00" --until "2026-03-08 14:30"
  - Identify the first error in the log sequence (not the most frequent)
  - Reproduce in a non-production environment before fixing

Step 4 — Resolve and document
  - Apply fix to non-production first
  - Run full test suite
  - Deploy to production
  - Confirm recovery with evidence (curl, metrics, error rate)

Step 5 — Post-mortem (within 48 hours)
  Write a blameless post-mortem with:
  - Timeline of events
  - Root cause (the actual technical condition, not "human error")
  - What detected it and how long before it was noticed
  - Five whys analysis
  - Action items with owners and due dates

Reference: workflows/incident-response.md
```

---

## Adding a New Command

1. Create the file:
   ```bash
   touch .claude/commands/my-command.md
   ```

2. Write the content. Structure it as a role declaration followed by an ordered checklist or protocol. Every step should be a concrete action, not a guideline.

3. Add a `Reference:` line at the bottom pointing to the full document in the library.

4. Commit the file so your team inherits the command:
   ```bash
   git add .claude/commands/my-command.md
   git commit -m "docs: add /my-command slash command"
   ```

---

## Related Documents

- [workflows/tdd-workflow.md](../workflows/tdd-workflow.md) - Full TDD protocol
- [workflows/verification-protocol.md](../workflows/verification-protocol.md) - Full verification protocol
- [workflows/explore-first.md](../workflows/explore-first.md) - Full explore-first protocol
- [templates/task-decomposition.md](../templates/task-decomposition.md) - Full decomposition template
- [agents/security-auditor.md](../agents/security-auditor.md) - Full security auditor agent
- [core/claudemd-guide.md](claudemd-guide.md) - How to configure the project CLAUDE.md
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
