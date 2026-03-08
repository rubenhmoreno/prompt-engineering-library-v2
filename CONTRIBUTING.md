# Contributing to Prompt Engineering Library

> **Executive Summary:** This document covers everything needed to contribute to the library: the underlying philosophy, what types of contributions are welcome, branch and commit conventions, quality standards, and the PR process. Read the Philosophy section first; it explains why the rules exist.

| Metadata | Value |
|----------|-------|
| Type     | Meta |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [CHANGELOG.md](CHANGELOG.md), [INDEX.md](INDEX.md) |

---

## Philosophy

This library exists to make AI-assisted development more reliable and repeatable. Every contribution must serve that goal. The five principles that govern the library also govern contributions:

1. **Verify, do not assume.** Every code example must work. Every claim must be backed by evidence. If you cannot run the command and show the output, do not include the claim.
2. **Evidence-based development.** Practices documented here come from real projects with real failures. Opinions without evidence do not belong here.
3. **Test-Driven Development.** Code examples show tests before implementation. The TDD cycle (Red, Green, Refactor) is modeled in examples, not just described.
4. **Generic, technology-agnostic content.** The library documents principles that survive technology churn. Avoid naming specific libraries unless they are the only option in their category.
5. **Multi-agent orchestration.** Examples show agents working together. Do not contribute single-agent examples when a multi-agent example would be more realistic.

---

## Contribution Types

### What belongs in this library

| Type | Description | Example |
|------|-------------|---------|
| Agent documentation | New or improved agent prompts | Adding api-architect agent |
| Workflow documentation | New development workflow patterns | Adding a code-review workflow |
| Templates | Reusable structured prompts | Improving evidence-report template |
| Case studies | Real project post-mortems with lessons | VOX Client case study |
| Best practices | Evidence-backed practices with code | Lessons from production incidents |
| Quick reference | Cheatsheets, decision trees, command tables | Agent cheatsheet, command reference |

### What does not belong here

| Type | Where it belongs |
|------|-----------------|
| Tool-specific tutorials (e.g., "How to use Celery") | Separate repository or external docs |
| Framework comparisons (React vs Vue) | External blog or wiki |
| Rapidly-changing best practices | External reference, linked not embedded |
| Project-specific configuration | The project itself |

---

## Branch Naming

```
feature/short-description        New content or capability
fix/issue-number-description     Correction to existing content
docs/what-changed                Documentation-only change
refactor/component-name          Restructuring without behavior change
```

Examples:

```
feature/cloud-infrastructure-agent
fix/42-tdd-workflow-typo
docs/add-golang-verification-commands
refactor/condense-backend-developer-agent
```

---

## Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>

<optional body: why, not what>

<optional footer: Closes #issue>
```

| Type | When to use |
|------|-------------|
| `feat` | New agent, workflow, template, or example |
| `fix` | Correction to broken example, wrong command, or bad link |
| `docs` | Prose improvements, typo fixes, clarifications |
| `refactor` | Structural reorganization without content change |
| `test` | Adding or improving example tests |
| `chore` | Dependency updates, maintenance |

Examples:

```
feat(agents): add cloud-infrastructure agent for K8s and Terraform workflows

fix(examples): correct psql connection command in best-practices-learned.md
Closes #31

docs(quick-ref): add Docker section to command-reference.md

refactor(agents): split backend-developer into separate sections by domain
```

---

## Quality Standards

Every contribution must pass all five checks before a PR is opened.

| Standard | Requirement |
|----------|-------------|
| Evidence-based | All code examples are tested and produce the shown output |
| Language | English throughout; no mixed-language content |
| Document template | Universal template applied (Executive Summary, metadata table, Related Documents footer) |
| Cross-references | New files are linked from INDEX.md and from at least one Related section |
| Generic | No technology-specific content that will be outdated in 12 months |

### Code example requirements

- Specify language on every fenced code block
- Include comments on non-obvious lines
- Show both wrong approach and right approach for every practice
- Include a verification command that proves the right approach works

### Documentation requirements

- Every new file uses the universal template structure
- `H1` title: one per file
- `H2` for major sections
- `H3` for subsections
- Relative links for all internal references
- No broken links (verify with a markdown link checker before submitting)

---

## Coding Standards Reference

### Markdown

| Element | Convention |
|---------|-----------|
| Lists | `-` for unordered; `1.` for ordered |
| Emphasis | `**bold**` for key terms; `*italic*` for titles |
| Inline code | Backticks for commands, filenames, function names |
| Code blocks | Fenced with language identifier always |
| Links | Descriptive text; never "click here" |
| Headers | No emoji in headers |

### Code Examples

| Language | Standards |
|----------|----------|
| Python | Type hints, docstrings, `import` statements shown, PEP 8 |
| Bash | `set -euo pipefail` in scripts, shebang line, comments on flags |
| SQL | Uppercase keywords, one clause per line, aliases |
| PowerShell | Pure ASCII, CRLF endings, `[OK]`/`[ERROR]` prefix pattern |

---

## Pull Request Process

### Before submitting

- [ ] Branch from `main` with correct naming convention
- [ ] All code examples tested and producing shown output
- [ ] Universal document template applied to all new files
- [ ] New files linked in INDEX.md
- [ ] CHANGELOG.md updated under `[Unreleased]`
- [ ] No broken internal links

### PR description template

```markdown
## Description
One paragraph: what does this PR change and why?

## Type
- [ ] New content (agent, workflow, template, example)
- [ ] Fix (broken example, wrong command, bad link)
- [ ] Documentation improvement
- [ ] Refactoring / restructuring

## Evidence
- [ ] All code examples tested locally
- [ ] Commands produce the output shown
- [ ] Links verified

## Related Issues
Closes #(number)

## Checklist
- [ ] Branch naming convention followed
- [ ] Commit messages follow Conventional Commits
- [ ] Universal template applied to all new files
- [ ] INDEX.md updated
- [ ] CHANGELOG.md updated
```

### Review process

1. Automated checks: markdown linting, link validation
2. Maintainer review: content accuracy, coherence with existing library, template compliance
3. One maintainer approval required to merge
4. Squash and merge (clean linear history)

### After merge

- Contributor added to README acknowledgements on first contribution
- Related issues auto-closed
- Included in next versioned release with CHANGELOG attribution

---

## Development Setup

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR_USERNAME/prompt-engineering-library-v2.git
cd prompt-engineering-library-v2

git remote add upstream https://github.com/mcapriotti74/prompt-engineering-library-v2.git

git checkout -b feature/your-feature-name

# Make changes, then:
git add path/to/changed/files
git commit -m "feat(scope): description"
git push origin feature/your-feature-name
# Open PR on GitHub
```

### Keeping your fork current

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## Release Process (Maintainers)

1. Move `[Unreleased]` section in CHANGELOG.md to `[X.Y.Z] - YYYY-MM-DD`
2. Update version in README.md
3. Commit: `chore: release vX.Y.Z`
4. Tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
5. Push: `git push && git push --tags`
6. Create GitHub Release with the changelog section as body

**Versioning rules:**

| Change | Version bump |
|--------|-------------|
| Breaking change to core principles or structure | MAJOR (X.0.0) |
| New agent, workflow, template, or significant feature | MINOR (0.X.0) |
| Fixes, clarifications, new examples within existing files | PATCH (0.0.X) |

---

## Code of Conduct

We follow standard open source conduct norms. Be respectful, welcome newcomers, and focus critique on content rather than people. Report issues to the maintainer contact in CHANGELOG.md.

Full details: [Contributor Covenant v2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/)

---

## Questions

- GitHub Discussions for process and usage questions
- Issues with `question` label for content questions
- Check existing closed issues before opening a new one

---

## Related Documents

- [CHANGELOG.md](CHANGELOG.md) - Version history
- [INDEX.md](INDEX.md) - Full library navigation
- [Quick Reference](quick-ref/all-agents-cheatsheet.md) - Agent overview

*Last updated: 2026-03-08 | [Back to Index](INDEX.md)*
