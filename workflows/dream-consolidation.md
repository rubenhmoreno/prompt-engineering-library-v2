# Dream Consolidation

> **Executive Summary:** A periodic memory maintenance workflow that reviews, consolidates, prunes, and verifies persistent memory files. Run it between sessions (or on a schedule) to keep memory accurate, compact, and free of stale references. Named after the brain's memory consolidation during sleep — processing raw experience into durable knowledge.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.2.0 |
| Updated  | 2026-03-28 |
| Related  | [session-memory.md](session-memory.md), [core/claudemd-guide.md](../core/claudemd-guide.md) |

---

## Quick Reference Card

```
Phase 1: Orient     — Read MEMORY.md index + list all memory files
Phase 2: Gather     — Grep for signals (stale dates, dead references, contradictions)
Phase 3: Consolidate — Merge duplicates, update outdated entries, add missing context
Phase 4: Prune      — Remove obsolete memories, verify file references, trim index
```

### When to Run

- After completing a major feature or project milestone
- When starting a session and memories feel stale or contradictory
- Periodically (weekly or bi-weekly) via scheduled task
- After a project is archived or abandoned

---

## Full Content

### Phase 1: Orient

Read the current state of the memory system without modifying anything.

```
1. Read MEMORY.md (the index file)
2. List all .md files in the memory directory
3. Read each memory file's frontmatter (name, description, type)
4. Build a mental inventory:
   - How many memories by type (user, feedback, project, reference)?
   - Which are oldest? (check dates in content)
   - Any obvious duplicates from titles alone?
```

**Output:** An inventory table.

```markdown
| File | Type | Age | Summary |
|------|------|-----|---------|
| project_digesto.md | project | 10 days | Digesto municipal analysis |
| feedback_testing.md | feedback | 30 days | Use real DB in tests |
```

### Phase 2: Gather Signal

Scan memory files for problems. Use narrow, targeted searches — not exhaustive reads.

**Check for these signals:**

| Signal | How to Detect | Action |
|--------|--------------|--------|
| **Dead file reference** | Memory names a file path → `ls` that path | If gone: update or remove the memory |
| **Dead function/flag reference** | Memory names a function → `grep` for it | If gone: update or remove |
| **Stale project status** | Memory says "in progress" but git shows no commits in 30+ days | Update status to dormant/archived |
| **Duplicate content** | Two memories cover the same topic with overlapping content | Merge into one, delete the other |
| **Contradictory memories** | Memory A says X, Memory B says not-X | Keep the newer one, verify against current state |
| **Relative dates** | "Last week", "yesterday", "recently" | Convert to absolute dates or remove if context lost |
| **Oversized memory** | File > 50 lines | Trim to essentials; move details to project docs |
| **MEMORY.md index drift** | Index lists files that don't exist, or files exist that aren't indexed | Sync index with actual files |

**Rules:**
- Grep narrowly. Don't read entire codebases looking for references.
- If a memory is ambiguous, verify against the current state (git log, file system) before deciding.
- When in doubt, keep the memory but mark it with `[UNVERIFIED]`.

### Phase 3: Consolidate

Apply changes based on Phase 2 findings.

**Merge duplicates:**
```
1. Identify the richer/more accurate of the two memories
2. Copy any unique information from the other into it
3. Delete the duplicate file
4. Update MEMORY.md index
```

**Update outdated entries:**
```
1. Read the current state (git log, file system, code)
2. Rewrite the memory to reflect current reality
3. Update the date in the content
4. Keep the frontmatter type and description accurate
```

**Add missing context:**
```
1. If a memory records a decision but not WHY → add the rationale
2. If a memory has a Why but no How-to-apply → add the application guidance
3. Convert all relative dates to absolute dates
```

**Consolidation rules:**
- Never merge memories of different types (user + project = wrong)
- Preserve the original insight — don't dilute with generic text
- Keep each memory file under 50 lines
- Use the standard frontmatter format

### Phase 4: Prune and Index

Final cleanup pass.

**Prune criteria — remove a memory if:**
- The project it references is archived/abandoned AND the insight is project-specific
- The feedback was about a tool/version that is no longer used
- The information is now documented in CLAUDE.md or project docs (single source of truth)
- The memory is a duplicate that was consolidated in Phase 3

**Do NOT prune if:**
- The insight applies to future projects (even if the original project is done)
- The memory records a user preference that hasn't changed
- The memory records a lesson learned from a failure (these compound in value)

**Rebuild the index:**
```
1. List all remaining .md files in memory/ (excluding MEMORY.md)
2. For each file, write one index line: `- [Title](file.md) — one-line hook`
3. Keep index under 200 lines (truncation threshold)
4. Sort semantically by topic, not chronologically
5. Write the updated MEMORY.md
```

---

## Output Format

After completing all 4 phases, produce a consolidation report:

```markdown
## Dream Consolidation Report — [DATE]

### Changes Made
| Action | File | Detail |
|--------|------|--------|
| Merged | feedback_x.md + feedback_y.md → feedback_x.md | Duplicate topic |
| Updated | project_digesto.md | Status: analysis → dormant (no commits 30d) |
| Pruned | reference_old_api.md | API no longer exists |
| Added context | feedback_testing.md | Added Why and How-to-apply |

### Memory Stats
- Before: X files, Y total lines
- After: A files, B total lines
- Reduction: Z%

### Warnings
- [UNVERIFIED] project_digesto.md — referenced file /home/mva/digesto/spec.md does not exist yet
```

---

## Automation

### As a Scheduled Task

Use the `schedule` skill to run dream consolidation on a cron:

```
Schedule: weekly on Monday at 08:00
Prompt: "Run the dream consolidation workflow on /root/.claude/projects/-home-mva/memory/.
         Read all memory files, check for stale references, merge duplicates,
         prune obsolete entries, and rebuild MEMORY.md.
         Output the consolidation report."
```

### As a Manual Command

At the start of any session where memories feel stale:

```
Run dream consolidation on my memory files.
```

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Reading the entire codebase to verify memory references | Targeted `ls` and `grep` on specific paths named in memories | Exhaustive reads waste tokens and context |
| Deleting memories because they are "old" | Delete only if the insight is no longer applicable | Age alone doesn't make a memory obsolete |
| Adding new memories during consolidation | Only modify/delete existing memories; new memories come from sessions | Consolidation is maintenance, not creation |
| Skipping the index rebuild | Always rebuild MEMORY.md as the last step | Index drift causes memories to be invisible in future sessions |
| Pruning user preferences because the project changed | User preferences persist across projects | Preferences are about the person, not the project |

---

## Related Documents

- [workflows/session-memory.md](session-memory.md) — Session continuity patterns that generate memories
- [core/claudemd-guide.md](../core/claudemd-guide.md) — CLAUDE.md as the primary configuration layer

*Last updated: 2026-03-28 | [Back to Index](../INDEX.md)*
