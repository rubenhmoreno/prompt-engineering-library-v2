# Claude Code Lifecycle Hooks Guide

> **Executive Summary:** A practical guide to Claude Code's hook system. Hooks intercept the agent lifecycle at defined points to enforce rules, transform outputs, trigger side effects, and scan for security violations — without modifying the prompts themselves. This document covers when each hook fires, the four fundamental hook patterns, how to register hooks in `settings.json`, and three production-ready examples.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [base-programming.md](base-programming.md), [agentic-safety.md](agentic-safety.md), [real-validation.md](real-validation.md) |

---

## Quick Reference Card

### Hook Firing Points

| Hook | Fires when | Typical use |
|------|-----------|-------------|
| `pre-tool` | Before any tool call executes | Block forbidden actions |
| `post-tool` | After a tool call completes | Transform or log output |
| `pre-task` | Before the agent starts a new task | Load context, set up environment |
| `post-task` | After the agent reports task complete | Verify evidence, send notifications |
| `on-file-write` | Before any file is written to disk | Enforce code style, check for secrets |
| `on-bash` | Before any bash command runs | Security scan, scope check |

### The Four Patterns at a Glance

| Pattern | Blocks execution? | Modifies output? | Triggers external action? |
|---------|------------------|-----------------|--------------------------|
| Pre-execution gate | Yes | No | No |
| Post-execution transformer | No | Yes | No |
| Side-effect trigger | No | No | Yes |
| Security scanner | Yes (on violation) | No | Optional (alerting) |

---

## Full Content

### What Hooks Are

Hooks are scripts or commands registered in `settings.json` that Claude Code calls at defined points in its lifecycle. They run outside Claude's context window — they are not prompts and they do not consume tokens. A hook receives a structured JSON payload describing the event and can:

1. Exit with code `0` to allow the action to proceed unchanged.
2. Exit with a non-zero code to block the action (pre-hooks only).
3. Write modified content to stdout to replace the original output (transformer hooks).
4. Run any external command as a side effect.

Hooks are the correct place for enforcement logic that must be consistent and cannot be overridden by conversational instructions. A rule in a system prompt can be talked around. A hook that exits non-zero cannot.

---

### Hook Firing Points in Detail

**pre-tool**

Fires before any tool invocation (bash, file read, file write, web fetch, etc.). Receives the tool name and arguments. Use this to block specific tool calls based on the arguments before any execution occurs.

```json
{
  "event": "pre-tool",
  "tool": "bash",
  "arguments": {
    "command": "rm -rf /project/src"
  }
}
```

**post-tool**

Fires after a tool call returns. Receives the tool name, arguments, and the output. Use this to log results, transform output, or trigger follow-up actions based on what the tool returned.

**pre-task**

Fires once when the agent receives a new task. Use this to inject context, verify environment preconditions, or create a git branch checkpoint before any work begins.

**post-task**

Fires once when the agent marks the task as complete. Use this to run a verification suite, check that evidence requirements are met, or send a notification to the developer.

**on-file-write**

Fires before any file write operation commits to disk. Receives the target path and the full new content. This is the last interception point before a file changes on disk. Use this for formatting enforcement and secrets scanning.

**on-bash**

Fires before every bash command execution. Similar to `pre-tool` with `tool=bash` but fires even for bash commands triggered internally by other tools. Use this for the broadest command-level security scanning.

---

### How to Register Hooks

Hooks are registered in the Claude Code `settings.json` file. The default location is:

```
~/.claude/settings.json           # user-level (applies to all projects)
/project/.claude/settings.json    # project-level (applies to this project only)
```

Project-level settings override user-level settings for the same hook event.

**settings.json format:**

```json
{
  "hooks": {
    "pre-tool": [
      {
        "name": "destructive-command-blocker",
        "command": "/project/.claude/hooks/block-destructive.sh",
        "timeout_ms": 2000
      }
    ],
    "on-file-write": [
      {
        "name": "secrets-scanner",
        "command": "/project/.claude/hooks/scan-secrets.sh",
        "timeout_ms": 3000
      },
      {
        "name": "auto-formatter",
        "command": "/project/.claude/hooks/format-python.sh",
        "timeout_ms": 5000
      }
    ],
    "post-task": [
      {
        "name": "completion-notifier",
        "command": "/project/.claude/hooks/notify-done.sh",
        "timeout_ms": 1000
      }
    ]
  }
}
```

Multiple hooks can be registered for the same event. They execute in the order listed. If any hook in a pre-hook chain exits non-zero, execution stops and the action is blocked.

---

### Pattern 1 — Pre-Execution Gate

**Purpose:** Block an action if it violates a rule. The hook inspects the incoming event payload and exits non-zero to prevent execution.

**Example: TDD Guard — blocks file writes that have no corresponding test**

```bash
#!/usr/bin/env bash
# .claude/hooks/tdd-guard.sh
# Fires on: on-file-write
# Blocks writes to src/ if no matching test file exists.

set -euo pipefail

# Read the JSON payload from stdin
PAYLOAD=$(cat)
FILE_PATH=$(echo "$PAYLOAD" | python3 -c "import sys,json; print(json.load(sys.stdin)['path'])")

# Only enforce on source files, not tests themselves
if [[ "$FILE_PATH" != */src/* ]]; then
  exit 0
fi

# Derive the expected test file path
BASENAME=$(basename "$FILE_PATH" .py)
TEST_PATH=$(dirname "$FILE_PATH" | sed 's|/src/|/tests/|')"/test_${BASENAME}.py"

if [[ ! -f "$TEST_PATH" ]]; then
  echo "TDD GUARD: Blocked write to $FILE_PATH" >&2
  echo "Expected test file not found: $TEST_PATH" >&2
  echo "Create the test file first, then implement." >&2
  exit 1
fi

exit 0
```

When this hook exits `1`, Claude Code stops the file write, surfaces the error message to the agent, and the agent must create the test file before proceeding. The rule becomes structurally enforced rather than prompt-enforced.

---

### Pattern 2 — Post-Execution Transformer

**Purpose:** Modify the output of a tool call after it runs, before the result is returned to the agent. The hook reads the output, transforms it, and writes the new version to stdout.

**Example: Auto-format Python files after every write**

```bash
#!/usr/bin/env bash
# .claude/hooks/format-python.sh
# Fires on: on-file-write (post)
# Runs ruff format on every .py file Claude writes.

set -euo pipefail

PAYLOAD=$(cat)
FILE_PATH=$(echo "$PAYLOAD" | python3 -c "import sys,json; print(json.load(sys.stdin)['path'])")

if [[ "$FILE_PATH" != *.py ]]; then
  exit 0
fi

# Format in place
ruff format "$FILE_PATH" --quiet 2>/dev/null || true

# Transformer hooks must output the (possibly modified) content to stdout
cat "$FILE_PATH"
exit 0
```

The agent receives the formatted content as the result of its write operation. It never sees unformatted code and never needs to be reminded to run the formatter.

---

### Pattern 3 — Side-Effect Trigger

**Purpose:** Perform an external action without modifying the agent's execution flow. The hook exits `0` unconditionally so it never blocks, but triggers something outside Claude Code.

**Example: Desktop notification when a task completes**

```bash
#!/usr/bin/env bash
# .claude/hooks/notify-done.sh
# Fires on: post-task
# Sends a desktop notification when Claude marks a task complete.

PAYLOAD=$(cat)
TASK_SUMMARY=$(echo "$PAYLOAD" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('task_summary', 'Task complete'))
" 2>/dev/null || echo "Task complete")

# Linux desktop notification (requires libnotify-bin)
notify-send "Claude Code" "$TASK_SUMMARY" --icon=terminal 2>/dev/null || true

# macOS fallback
osascript -e "display notification \"$TASK_SUMMARY\" with title \"Claude Code\"" 2>/dev/null || true

# Always exit 0 — this hook must never block
exit 0
```

This hook is useful during long autonomous sessions. The developer can focus on other work and be notified when the agent finishes, without polling the terminal.

---

### Pattern 4 — Security Scanner

**Purpose:** Inspect all content passing through a hook point for security violations. Blocks on violation; allows on clean.

**Example: Secrets scanner on every file write**

```bash
#!/usr/bin/env bash
# .claude/hooks/scan-secrets.sh
# Fires on: on-file-write
# Blocks writes that contain patterns matching common secret formats.

set -euo pipefail

PAYLOAD=$(cat)
FILE_PATH=$(echo "$PAYLOAD" | python3 -c "import sys,json; print(json.load(sys.stdin)['path'])")
FILE_CONTENT=$(echo "$PAYLOAD" | python3 -c "import sys,json; print(json.load(sys.stdin).get('content', ''))")

# Patterns that indicate hardcoded secrets
SECRET_PATTERNS=(
  'sk-[a-zA-Z0-9]{20,}'          # OpenAI API key
  'ghp_[a-zA-Z0-9]{36}'          # GitHub personal access token
  'AKIA[0-9A-Z]{16}'             # AWS access key ID
  'password\s*=\s*["\x27][^"\x27]{8,}["\x27]'  # Hardcoded password assignment
  'secret\s*=\s*["\x27][^"\x27]{8,}["\x27]'    # Hardcoded secret assignment
)

VIOLATIONS=()
for PATTERN in "${SECRET_PATTERNS[@]}"; do
  if echo "$FILE_CONTENT" | grep -qE "$PATTERN"; then
    VIOLATIONS+=("$PATTERN")
  fi
done

if [[ ${#VIOLATIONS[@]} -gt 0 ]]; then
  echo "SECRETS SCANNER: Blocked write to $FILE_PATH" >&2
  echo "Matched secret pattern(s): ${VIOLATIONS[*]}" >&2
  echo "Move secrets to environment variables. See base-programming.md rule 7." >&2
  exit 1
fi

exit 0
```

This scanner fires on every file write regardless of what the agent or user requests. It is the last line of defense before a secret lands on disk and potentially in git history.

---

## Anti-Patterns

| Anti-pattern | Consequence | Fix |
|---|---|---|
| Hook that blocks every write pending human approval | Development grinds to a halt; agent cannot make progress | Block only specific forbidden patterns, not all writes |
| Hook with no error handling (set -e but no trap) | Hook crashes silently; error message is lost | Add `trap 'echo "Hook error: $BASH_COMMAND" >&2; exit 1' ERR` |
| Hook that modifies code silently without logging | Agent receives different code than it wrote; debugging becomes impossible | Log every transformation to a hook log file |
| Hook that calls external APIs with no timeout | Slow API blocks all agent execution indefinitely | Always set `timeout_ms` in settings.json and handle timeout exit codes |
| Registering the same enforcement logic as both a hook and a system prompt rule | Rule is bypassed in the prompt but still enforced by the hook, creating confusing behavior | Hooks own enforcement; system prompt rules are for guidance and context |
| Hook that reads the full repository on every file write | Enormous I/O cost on large codebases | Scope hook operations to the specific file or a small manifest |

---

## Related Documents

- [agentic-safety.md](agentic-safety.md) — Scope controls and blocklist patterns that hooks enforce
- [base-programming.md](base-programming.md) — Core principles including TDD and secrets management that hooks can structurally enforce
- [real-validation.md](real-validation.md) — Evidence requirements; post-task hooks can automate evidence collection
