# Real Validation

> **Executive Summary:** A protocol that prevents the most common failure mode in AI-assisted development: claiming a task is complete without real evidence. Eight mandatory rules define what counts as valid proof for UI changes, API endpoints, file modifications, emails, and test results. No task is done until evidence is shown.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [base-programming.md](base-programming.md), [error-prevention.md](error-prevention.md), [templates/evidence-report.md](../templates/evidence-report.md) |

---

## Quick Reference Card

Before saying "done", answer every question:

| # | Question | If NO... |
|---|----------|----------|
| 1 | Did I actually execute or run it? | Run it now, show output |
| 2 | Can I show visual or terminal evidence? | Capture it before reporting |
| 3 | Does each requested item have specific proof? | Validate each item individually |
| 4 | Did I verify ALL points from the original request? | Re-read the request, check each item |
| 5 | Would this evidence convince a skeptical reviewer? | Get more evidence |

Validation status legend:

| Symbol | Meaning |
|--------|---------|
| Validated | Validated with real evidence shown |
| Implemented | Implemented but not yet validated |
| Failed | Does not work or not visible |

---

## Full Content

### The Problem

AI assistants frequently report "completed 100%" when in fact:

- Only a login screenshot was taken when 10 specific pages were requested
- "Email sent" was reported without confirming inbox receipt
- "UI shows X" was claimed without a screenshot proving it
- "Endpoint works" was stated without showing the actual HTTP response
- "Should work" was used as a substitute for running the code

This document establishes the rules that eliminate these failures.

### The 8 Mandatory Validation Rules

**Rule 1: Never say "completed" without real validation**

Every claim of completion must be backed by evidence:
- UI change → screenshot showing that specific feature
- API endpoint → curl or request showing the actual response body and status code
- Function → execute it and show the terminal output
- File change → show the file content after modification
- Email sent → confirm receipt, not just "sent"

**Rule 2: Visual validation for UI and frontend**

- Login must succeed before any screenshot is taken
- Each screenshot must show the specific feature requested — not just the page
- If asked for "environment badge" → the screenshot must show the badge
- If asked for "settings card" → the screenshot must show that card
- If something does not appear → report it immediately
- Do not say "completed" if the feature is not visible in the screenshot

**Rule 3: Functional validation for backend and APIs**

- Make a real request to the endpoint — not a mock or test double
- Show the complete response, including status code and full body
- If an error occurs → show the full error message, not a summary
- Test with realistic data, not placeholder values
- If email was sent → verify SMTP success AND confirm inbox receipt where possible

**Rule 4: Verification checklist before reporting done**

Before writing "completed" or "done":
- [ ] Did I actually execute/test it (not just write the code)?
- [ ] Can I show visual or output evidence?
- [ ] Does each requested item have specific, individual validation?
- [ ] Did I verify ALL points from the original request?
- [ ] Would this evidence convince a skeptical code reviewer?

**Rule 5: When you cannot validate**

Say explicitly: "Could not validate X because Y."

Then:
- Propose a specific alternative the user can run to validate
- Mark the item as "Implemented" (not validated)
- Never use "should work" as a substitute for testing
- Never mark as validated what was not validated

**Rule 6: Reporting format**

Use the comparison table for every completion report:

```
| Feature          | Requested | Implemented | Validated | Evidence            |
|------------------|-----------|-------------|-----------|---------------------|
| Environment badge | Yes       | Yes         | Yes       | screenshot_badge.png shows orange TESTING badge |
| Reports menu      | Yes       | Yes         | Yes       | screenshot_menu.png shows Reports in sidebar    |
| API /api/config   | Yes       | Yes         | Yes       | curl: {"environment":"TESTING"}                 |
| Time slots edit   | Yes       | Yes         | No        | Could not login to test; needs manual check     |
| Email delivery    | Yes       | Yes         | Failed    | SMTP OK but not in inbox; check spam            |
```

**Rule 7: Screenshots and evidence rules**

- Minimum 1 screenshot per visual feature requested
- Screenshots must be taken after successful login
- Each screenshot must show the specific feature being validated
- If N screenshots were requested → deliver N screenshots

**Rule 8: Email and notification validation**

- Do not report "sent" — confirm receipt
- Show SMTP success log AND describe inbox check result
- Include the actual content sent (or a clear summary)
- Confirm attachments were included and their sizes
- Check spam folder if not found in inbox

### Good Report vs Bad Report

**Good report:**

```
## Validation Report

| Item              | Requested | Code Written | Tested | Evidence                                                        | Status |
|-------------------|-----------|--------------|--------|-----------------------------------------------------------------|--------|
| Environment badge | Yes       | Yes          | Yes    | screenshot_badge.png: orange "TESTING" badge visible in header  | Done   |
| Reports menu      | Yes       | Yes          | Yes    | screenshot_menu.png: "Reports" item visible in left sidebar     | Done   |
| API /api/config   | Yes       | Yes          | Yes    | curl response: {"environment":"TESTING","schema":"TEST_DB"}     | Done   |
| Time slots edit   | Yes       | Yes          | No     | Code added but could not authenticate in automated test         | Review |
| Email sent        | Yes       | Yes          | Failed | SMTP 250 OK but not in inbox — possible spam filter             | Action |

Issues found:
- Time slots: Manual user test needed (could not authenticate in automated context)
- Email: Successfully sent but not delivered; checking SMTP relay logs

Screenshots provided:
- screenshot_badge.png (environment badge in header)
- screenshot_menu.png (updated navigation menu)
- screenshot_config_page.png (configuration page rendered)
```

**Bad report (never do this):**

```
All features implemented 100%!
Everything is working perfectly!
Email sent successfully!
All screenshots taken!

[Attaches only the login page screenshot]
```

### Validation by Feature Type

| Feature Type | Required Evidence |
|--------------|------------------|
| UI / visual | Screenshot showing the specific element, taken after login |
| REST API endpoint | `curl` command + full response body + HTTP status code |
| Function / method | Execute and show terminal output |
| File modification | Show the file content (or relevant diff) after change |
| Email / notification | SMTP log entry + inbox confirmation or explicit "check spam" instruction |
| Test suite | `pytest -v --cov` or `npm test` output showing pass count and coverage % |
| Database migration | `SELECT` query result or schema describe output |
| Docker deployment | `docker ps` output + health endpoint response |
| Performance fix | Before/after benchmark numbers from the same test |

### Integration with Task Instructions

Add this block to any task prompt to enforce the protocol:

```
VALIDATION REQUIRED:
- Every "completed" claim must have evidence
- Screenshots must show the SPECIFIC feature requested
- API responses must be shown in full (status + body)
- Use the validation table: [Requested | Implemented | Validated | Evidence]
- Mark "Implemented" (not validated) if you cannot test it
- Be explicit about what you could not verify and why
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| "Implemented everything, it's 100% complete" (no testing done) | Run each item, show output, use the validation table | Claims without proof are not auditable and hide real failures |
| One login screenshot when 10 specific pages were requested | One screenshot per feature, each showing that specific feature | A single screenshot proves nothing about the other 9 pages |
| "The code is correct" without running it | Execute and show terminal output | Correct-looking code has bugs; running it is the only proof |
| "Email sent successfully" without confirming receipt | Show SMTP success log AND inbox check result | SMTP acceptance does not guarantee delivery |
| "All tests pass" without attaching test output | Attach `pytest -v` or `npm test` output | Test claims without output are unverifiable |
| "Fixed the bug" without reproducing the fix | Show the test that was failing, now passing | Fixes without reproduction may not address the real issue |

---

## Related Documents

- [core/base-programming.md](base-programming.md) — Master prompt including evidence principle (Principle 4)
- [core/error-prevention.md](error-prevention.md) — Pre-execution verification protocol (Category 5)
- [templates/evidence-report.md](../templates/evidence-report.md) — Standard evidence report template
- [workflows/verification-protocol.md](../workflows/verification-protocol.md) — End-to-end verification workflow

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
