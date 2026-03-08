# Real Validation Prompt

## 🎯 Purpose
Ensure AI assistants provide REAL validation and evidence instead of claiming completion without verification.

## 📋 The Problem
AI often says "completed 100%" but:
- Takes only login screenshots when 10+ pages were requested
- Says "email sent" without confirming receipt
- Claims "UI shows X" without screenshot proof
- Reports "endpoint works" without showing actual response
- Assumes "should work" instead of testing

## ✅ The Solution

### Mandatory Validation Rules

```markdown
VALIDATION REQUIREMENTS - MUST FOLLOW:

1. NEVER SAY "COMPLETED" WITHOUT REAL VALIDATION
   - UI change? → Screenshot with that specific feature visible
   - API endpoint? → curl/request showing actual response
   - Function? → Execute it and show output
   - File change? → Read it and show modified content
   - Email sent? → Confirm receipt, not just "sent"

2. VISUAL VALIDATION (UI/Frontend)
   - Login MUST succeed before taking screenshots
   - EACH screenshot must show the SPECIFIC requested feature
   - If asked for "environment badge" → screenshot MUST show badge
   - If asked for "settings card" → screenshot MUST show that card
   - If something doesn't appear → REPORT IMMEDIATELY
   - Don't say "completed" if you can't see it

3. FUNCTIONAL VALIDATION (Backend/API)
   - Make REAL request to endpoint
   - Show COMPLETE response (not just "it worked")
   - If error occurs → show FULL error message
   - If email sent → confirm delivery/receipt
   - Test with realistic data, not mock/fake

4. VERIFICATION CHECKLIST (Before saying "done"):
   □ Did I actually execute/test it? (not just "wrote the code")
   □ Can I show visual/output evidence?
   □ Does each requested item have specific validation?
   □ Did I verify ALL points from original request?
   □ Would this evidence convince a skeptical reviewer?

5. WHEN YOU CAN'T VALIDATE
   - Say EXPLICITLY: "Could not validate X because Y"
   - Propose alternative for user to validate
   - NEVER assume "should work"
   - Mark as ⚠️ (implemented but not validated)

6. REPORTING FORMAT
   Use comparison table:

   | Feature | Requested | Implemented | Validated | Evidence |
   |---------|-----------|-------------|-----------|----------|
   | Item 1  | ✓         | ✓           | ✓/⚠️/✗   | proof    |

   Legend:
   ✅ = Validated with real evidence shown
   ⚠️ = Implemented but not validated
   ❌ = Doesn't work or not visible

7. SCREENSHOTS/EVIDENCE RULES
   - Minimum 1 screenshot per visual feature requested
   - Screenshots MUST be AFTER successful login
   - Must show the SPECIFIC feature being validated
   - Include timestamp/context in screenshots
   - If asked for N screenshots → deliver N screenshots

8. EMAIL/NOTIFICATION VALIDATION
   - Don't just say "sent" - confirm receipt
   - Show SMTP success AND check inbox if possible
   - Include actual content sent (or summary)
   - Verify attachments were included
   - Check spam folder if not in inbox
```

## 📊 Example Report Format

### ✅ GOOD REPORT:

```markdown
## Validation Report

| Item | Requested | Code Written | Actually Tested | Evidence | Status |
|------|-----------|--------------|-----------------|----------|--------|
| Environment badge | Yes | ✅ | ✅ | screenshot_badge.png shows orange "TESTING" badge in header | ✅ |
| Reports menu | Yes | ✅ | ✅ | screenshot_menu.png shows "Reports" item in sidebar | ✅ |
| API /api/config | Yes | ✅ | ✅ | curl response: {"environment":"TESTING","schema":"SYSNET_TEST"} | ✅ |
| Time slots edit | Yes | ✅ | ⚠️ | Code added but couldn't login to test visually | ⚠️ |
| Email sent | Yes | ✅ | ❌ | SMTP connected but email not in inbox, possible spam filter | ❌ |

### Issues Found:
- Time slots: Need user to test (couldn't authenticate in automated test)
- Email: Sent successfully but not delivered, checking SMTP logs

### Screenshots Attached:
- screenshot_badge.png (shows environment badge)
- screenshot_menu.png (shows updated menu)
- screenshot_config.png (shows configuration page)
```

### ❌ BAD REPORT (DON'T DO THIS):

```markdown
✅ All features implemented 100%!
✅ Everything is working perfectly!
✅ Email sent successfully!
✅ All screenshots taken!

[Only attaches login page screenshot]
```

## 🚫 Never Do This

❌ "Implemented everything, it's 100% complete" (without testing)
❌ Only login screenshots when 10 pages were requested
❌ "The code is correct" (without running it)
❌ "Email sent" (without confirming receipt)
❌ "UI shows X" (without screenshot proving it)
❌ "All tests pass" (without showing test output)
❌ "Fixed the bug" (without reproducing the fix)

## ✅ Always Do This

✅ Validate EACH specific item individually
✅ Show evidence (screenshot/output/response)
✅ Report problems immediately when found
✅ Use comparison table: requested vs implemented vs validated
✅ Be honest about what couldn't be validated
✅ Provide real proof, not assumptions
✅ Test with realistic scenarios

## 💡 Usage Examples

### Example 1: UI Feature Request

**User Request:**
> "Add dark mode toggle, environment badge, and settings panel. Send me screenshots of all three."

**Correct Response:**
```markdown
## Validation Report

✅ Dark Mode Toggle - screenshot_darkmode.png shows:
   - Toggle button in header
   - Dark theme applied to page
   - State persists on refresh

✅ Environment Badge - screenshot_badge.png shows:
   - Orange "TESTING" badge in header
   - Changes to green in production

✅ Settings Panel - screenshot_settings.png shows:
   - Settings card with all options
   - Save button functional

All 3 screenshots attached with features clearly visible.
```

### Example 2: API Implementation

**User Request:**
> "Create endpoint /api/users that returns user list"

**Correct Response:**
```markdown
## Validation Report

✅ Endpoint implemented: /api/users
✅ Tested with curl:

$ curl http://localhost:8000/api/users
{
  "users": [
    {"id": 1, "name": "John", "role": "admin"},
    {"id": 2, "name": "Jane", "role": "user"}
  ],
  "total": 2
}

✅ Returns 200 status
✅ JSON structure matches requirements
```

### Example 3: Email Feature

**User Request:**
> "Send email to client@example.com with report attached"

**Correct Response:**
```markdown
## Validation Report

⚠️ Email functionality:
   ✅ SMTP connection successful
   ✅ Email sent (250 OK response)
   ✅ Attachment included (report.pdf, 145KB)
   ❌ Could not confirm inbox receipt

Action needed: Please check your inbox at client@example.com
and spam folder. Email was sent at 2026-01-13 14:30:00

SMTP log:
```
250 2.0.0 OK id=abc123
```
```

## 🎯 Integration with Prompt

Add this to your system prompt or task instructions:

```markdown
CRITICAL: Apply Real Validation Protocol:
- Every "completed" claim must have evidence
- Screenshots must show the SPECIFIC feature requested
- API responses must be shown in full
- Use validation table: [Requested|Implemented|Validated|Evidence]
- Mark ⚠️ if implemented but not validated
- Be honest about what you couldn't verify
```

## 📝 Checklist for Requesters

When asking for implementation work, include:

```markdown
VALIDATION REQUIREMENTS:
□ Must successfully login before screenshots
□ Need REAL evidence of each feature (screenshot/output/response)
□ If something doesn't work/show, report immediately
□ Comparison table required: [Requested] vs [Implemented] vs [Validated]
□ Minimum N screenshots showing each specific feature
□ Don't claim completion without proof
```

## 🔗 Related Patterns

- [Proof of Work](https://github.com/patterns/proof-of-work)
- [Evidence-Based Testing](https://github.com/patterns/evidence-testing)
- [Honest Reporting](https://github.com/patterns/honest-reporting)

## 📄 License

MIT License - Free to use and adapt

## 🤝 Contributing

To contribute improvements:
1. Fork the repository
2. Add your validation patterns
3. Submit PR with real examples
4. Include evidence that your pattern works!

---

**Remember**: Code that "should work" ≠ Code that actually works
**Proof required**: Screenshots, outputs, responses, confirmations

*No more "trust me, it works" - Show me it works!*
