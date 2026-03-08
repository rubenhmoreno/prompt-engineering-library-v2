# UX Checklist for Non-Technical Users

> **Executive Summary:** Plain-language checklist for evaluating whether an application is easy and pleasant to use. No design jargon, no code. Use this when reviewing any screen, page, or flow to catch usability problems before real users do. The AI should activate this checklist when a non-technical user asks to "make it better", "check if it's easy to use", or "review the interface".

| Metadata | Value |
|----------|-------|
| Type     | Reference |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [ui-ux-specialist](../agents/ui-ux-specialist.md), [frontend-developer](../agents/frontend-developer.md) |

---

## When to Use This

| User Says... | Activate This Checklist |
|-------------|----------------------|
| "Is this easy to use?" | Yes |
| "Review the interface" | Yes |
| "Make it look better" | Yes |
| "Users are confused" | Yes |
| "Something feels off about this page" | Yes |
| "I need specific WCAG compliance or design tokens" | No — use [ui-ux-specialist](../agents/ui-ux-specialist.md) instead |

---

## The Checklist

### 1. Can the user figure out what to do?

- [ ] The most important action on the page is obvious (big, colored, clearly labeled)
- [ ] The page has a clear title that tells the user where they are
- [ ] Buttons say what they do ("Save Invoice", "Send Message") not vague words ("Submit", "OK", "Click Here")
- [ ] The user does not need instructions to understand the page — if they do, the page is too complex

### 2. Can the user complete their task quickly?

- [ ] The main task can be completed in 3 steps or fewer
- [ ] The user is not asked to type information they already provided
- [ ] Related fields are grouped together (name fields near name fields, not scattered)
- [ ] Optional fields are clearly marked — or better, hidden behind "Show more options"
- [ ] The most common action is the easiest to reach (not buried in a menu)

### 3. Does the user know what happened?

- [ ] After clicking a button, something visible changes (message, page change, animation)
- [ ] Success messages appear in green and clearly say what succeeded ("Invoice saved")
- [ ] Error messages appear in red, say what went wrong, and tell the user how to fix it
- [ ] Loading states exist — the user is never staring at a frozen screen wondering if it worked
- [ ] Destructive actions (delete, cancel) ask for confirmation before executing

### 4. Does it work on a phone?

- [ ] Text is readable without zooming
- [ ] Buttons and links are big enough to tap with a finger (not tiny targets)
- [ ] The layout adjusts to the screen width — no horizontal scrolling
- [ ] Forms are usable on a small screen (fields stack vertically)
- [ ] Navigation is reachable (hamburger menu or bottom tabs)

### 5. Is it readable?

- [ ] Text has enough contrast against the background (dark text on light background, or vice versa)
- [ ] Body text is at least 16px (readable on all screens)
- [ ] Line spacing is comfortable — text does not feel cramped
- [ ] There is enough white space — the page does not feel cluttered
- [ ] Important information is not hidden inside tooltips or hover effects

### 6. Is it consistent?

- [ ] The same action looks the same everywhere (all "Save" buttons look identical)
- [ ] Navigation is in the same place on every page
- [ ] Colors mean the same thing everywhere (red = error, green = success)
- [ ] Font sizes follow a clear hierarchy (titles bigger than subtitles, subtitles bigger than body)
- [ ] Icons are used consistently — the same icon always means the same thing

### 7. Does it handle problems gracefully?

- [ ] If the user enters wrong data, the field is highlighted and the error explains what to fix
- [ ] If the page has no data to show, it displays a helpful empty state ("No invoices yet. Create your first one.")
- [ ] If the connection is slow, a loading indicator appears
- [ ] If something fails, the user can try again without losing their work
- [ ] The back button works as expected — it does not break the flow

---

## Quick Scoring

After going through the checklist, count how many items are checked:

| Score | Rating | Action |
|-------|--------|--------|
| 30-33 | Excellent | Minor polish only |
| 24-29 | Good | Fix the unchecked items before launch |
| 17-23 | Needs Work | Prioritize sections 1, 2, and 3 (core usability) |
| Below 17 | Significant Issues | Redesign the main flows before adding features |

---

## Common Fixes (Ranked by Impact)

If you can only fix a few things, fix these first:

| Priority | Problem | Fix |
|----------|---------|-----|
| 1 | User does not know what to do | Make the primary action a large, colored button with a clear label |
| 2 | User does not know if it worked | Add success/error messages after every action |
| 3 | Error messages are unhelpful | Change "Error" to "The email field requires a valid email address (example: name@company.com)" |
| 4 | Page is cluttered | Add white space between sections; hide optional fields behind "More options" |
| 5 | Does not work on phones | Add `<meta name="viewport" content="width=device-width, initial-scale=1">` and use percentage widths |
| 6 | Text is hard to read | Increase font size to 16px minimum; ensure dark text on light background |
| 7 | Inconsistent look | Pick one color for primary actions and use it everywhere; pick one font and stick to it |

---

## Related Documents

- [agents/ui-ux-specialist.md](../agents/ui-ux-specialist.md) — Full technical UX specification (design tokens, WCAG 2.2, component specs)
- [agents/frontend-developer.md](../agents/frontend-developer.md) — For implementing UX improvements in code
- [quick-ref/all-agents-cheatsheet.md](all-agents-cheatsheet.md) — When to activate which agent

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
