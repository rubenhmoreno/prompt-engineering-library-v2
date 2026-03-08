# Contributing to Prompt Engineering Library

Thank you for your interest in contributing to the Prompt Engineering Library! This project aims to provide a comprehensive, evidence-based framework for working with AI assistants like Claude Code.

## Philosophy

This library follows these core principles:

1. **NO SUPONER - VERIFICAR** (Don't assume - Verify)
2. **Evidence-based development**
3. **Test-Driven Development (TDD)**
4. **Multi-agent orchestration**
5. **Generic, technology-agnostic practices**

## Table of Contents

- [How Can I Contribute?](#how-can-i-contribute)
- [Contribution Guidelines](#contribution-guidelines)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Documentation Standards](#documentation-standards)
- [Community Guidelines](#community-guidelines)

---

## How Can I Contribute?

### 1. Reporting Issues

Found a bug, unclear documentation, or have a suggestion?

**Before creating an issue:**
- Check existing issues to avoid duplicates
- Verify you're using the latest version
- Test with minimal reproduction case

**When creating an issue, include:**
- Clear, descriptive title
- Step-by-step reproduction (if bug)
- Expected vs actual behavior
- Environment details (Claude Code version, OS, etc.)
- Evidence (logs, screenshots, code snippets)

**Issue Labels:**
- `bug`: Something isn't working as documented
- `documentation`: Improvements or additions to docs
- `enhancement`: New feature or request
- `question`: Further information is requested
- `good first issue`: Good for newcomers

### 2. Suggesting Enhancements

Have ideas for new agents, workflows, or principles?

**Guidelines:**
- Explain the problem your enhancement solves
- Provide use cases and examples
- Consider how it fits with existing architecture
- Keep suggestions **generic** and **technology-agnostic**

**What belongs in this repo (CORE):**
- Universal development principles
- Generic workflows applicable to any tech stack
- Fundamental agent roles (backend, frontend, testing, etc.)
- Evidence-based practices and verification protocols

**What belongs in separate repos:**
- Specific tool recommendations (matplotlib, React, etc.)
- Technology-specific implementations
- Framework comparisons
- Rapidly-changing best practices

### 3. Contributing Code/Documentation

**Areas needing contributions:**
- Additional case studies from real projects
- Translations to other languages
- Enhanced examples with edge cases
- Additional verification commands for error-prevention.md
- More workflow patterns (CI/CD, code review, etc.)

---

## Contribution Guidelines

### Branch Naming Convention

```
feature/short-description    # New features
fix/issue-number-description # Bug fixes
docs/what-changed           # Documentation only
refactor/component-name     # Code restructuring
```

**Examples:**
- `feature/security-audit-agent`
- `fix/23-tdd-workflow-typo`
- `docs/add-golang-examples`
- `refactor/improve-evidence-template`

### Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>

<optional body>

<optional footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code restructuring without behavior change
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(agents): Add security-audit-agent for vulnerability analysis

This agent specializes in identifying security vulnerabilities
across multiple layers: dependencies, code patterns, and
infrastructure configuration.

Closes #42
```

```
docs(workflows): Fix typo in TDD cycle explanation

Changed "verfication" to "verification" in red-green-refactor
section.
```

```
fix(templates): Correct evidence-report.md markdown formatting

- Fixed nested list indentation
- Added missing code fence closures
- Improved readability of test results section
```

### Quality Standards

All contributions must meet these standards:

**1. Evidence-Based**
- No assumptions without verification
- Include verification commands where applicable
- Provide real examples from actual projects

**2. Test Coverage** (for code examples)
- All code examples must include tests
- Follow TDD principles (Red → Green → Refactor)
- Include both positive and negative test cases

**3. Documentation**
- Clear, concise language
- Examples for each concept
- Cross-references to related sections
- Updated README.md if structure changes

**4. Generic and Stable**
- Technology-agnostic (avoid "use React" → prefer "use component framework")
- Long-lasting principles (not flavor-of-the-month trends)
- Applicable across different project types

**5. Multi-Layer Review**
- Self-review using REVIEW.md methodology
- Check coherence across all related files
- Verify examples actually work

---

## Pull Request Process

### Before Submitting

- [ ] Read and follow contribution guidelines
- [ ] Branch from `main` with appropriate naming
- [ ] Write clear commit messages following convention
- [ ] Test all code examples
- [ ] Update documentation (README.md, affected .md files)
- [ ] Add entry to CHANGELOG.md under `[Unreleased]`
- [ ] Self-review using 5-layer methodology from REVIEW.md

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## Related Issues
Closes #(issue number)

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing Evidence
Describe tests you ran and provide evidence:
- [ ] All code examples tested
- [ ] Documentation renders correctly
- [ ] Cross-references validated

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing tests pass
- [ ] I have updated CHANGELOG.md

## Screenshots (if applicable)
Add screenshots or terminal outputs
```

### Review Process

1. **Automated Checks** (when CI/CD is set up)
   - Markdown linting
   - Link validation
   - Code example syntax checking

2. **Human Review**
   - Maintainer reviews against contribution guidelines
   - Checks for coherence with existing content
   - Verifies examples and evidence
   - Suggests improvements if needed

3. **Approval and Merge**
   - At least 1 maintainer approval required
   - Squash and merge (clean history)
   - Auto-close related issues

### After Merge

- Your contribution will be included in next release
- You'll be added to contributors list (if first contribution)
- Issue will be closed automatically
- CHANGELOG.md updated in next version

---

## Coding Standards

### Markdown Style

**File Structure:**
```markdown
# Title (H1 - only one per file)

Brief description

## Table of Contents (for files >200 lines)

## Section 1 (H2)

### Subsection 1.1 (H3)

Content with examples
```

**Code Blocks:**
- Always specify language for syntax highlighting
- Include comments explaining non-obvious parts
- Keep examples realistic and testable

```python
# Good: Specific language, clear comments
def calculate_total(items: list) -> float:
    """Calculate total price with tax (21% IVA)."""
    subtotal = sum(item.price for item in items)
    return subtotal * 1.21

# Test
assert calculate_total([Item(10), Item(5)]) == 18.15
```

```
# Bad: No language, no context
def calc(x):
    return x * 1.21
```

**Lists:**
- Use `-` for unordered lists (consistent)
- Use `1.` for ordered lists (auto-numbering)
- Indent nested lists with 2 spaces

**Links:**
- Use relative links for internal references: `[error prevention](../core/error-prevention.md)`
- Use descriptive text, not "click here"
- Verify all links work

**Emphasis:**
- `**bold**` for important concepts
- `*italic*` for emphasis
- `` `code` `` for inline code, commands, filenames

### Code Example Standards

**Python:**
```python
# Use type hints
def process_data(data: dict, validate: bool = True) -> list:
    """Process data with optional validation.

    Args:
        data: Input dictionary with raw data
        validate: Whether to validate before processing

    Returns:
        List of processed items

    Raises:
        ValueError: If validation fails
    """
    if validate:
        _validate_data(data)
    return [process_item(item) for item in data['items']]

# Include tests
def test_process_data_with_validation():
    """GIVEN valid data, WHEN process_data called, THEN returns processed list"""
    data = {'items': [{'id': 1}, {'id': 2}]}
    result = process_data(data, validate=True)
    assert len(result) == 2
```

**Bash:**
```bash
#!/bin/bash
# Always include shebang
# Use set -e for safety in scripts
set -euo pipefail

# Clear variable names
INPUT_FILE="${1:-default.txt}"
OUTPUT_DIR="${2:-./output}"

# Verify prerequisites
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found: $INPUT_FILE"
    exit 1
fi

# Actual work
echo "Processing $INPUT_FILE..."
```

**SQL:**
```sql
-- Use clear formatting
SELECT
    u.id,
    u.email,
    COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at >= '2025-01-01'
GROUP BY u.id, u.email
HAVING COUNT(o.id) > 0
ORDER BY order_count DESC;
```

---

## Documentation Standards

### Agent Documentation

When contributing new agents, follow this structure:

```markdown
# Agent Name

## Role

One-sentence description of primary responsibility

## Expertise Areas

- Area 1
- Area 2
- Area 3

## Responsibilities

### Input Analysis
What this agent receives

### Core Work
What this agent does

### Output Delivery
What this agent produces

## Workflow Integration

How this agent fits in multi-agent orchestration

## Key Practices

### Practice 1
Description with examples

### Practice 2
Description with examples

## Tools and Verification

Commands and tools this agent commonly uses

## Anti-Patterns

Common mistakes to avoid

## Example Interaction

Real conversation showing agent in action

## Handoff Protocol

How to transfer work to/from this agent
```

### Workflow Documentation

When contributing new workflows:

```markdown
# Workflow Name

## Purpose

What problem this workflow solves

## When to Use

Scenarios where this workflow applies

## Steps

### Step 1: Name
Description
Commands/code examples

### Step 2: Name
Description
Commands/code examples

## Example

Complete end-to-end example

## Integration

How this workflow combines with other workflows

## Evidence Requirements

What proof of completion is needed
```

---

## Community Guidelines

### Code of Conduct

We follow a simple code of conduct:

**Our Standards:**
- Be respectful and inclusive
- Welcome newcomers
- Focus on what's best for the community
- Show empathy towards others
- Accept constructive criticism gracefully

**Unacceptable Behavior:**
- Harassment or discriminatory language
- Trolling or insulting comments
- Public or private harassment
- Publishing others' private information
- Other conduct inappropriate in a professional setting

**Enforcement:**
- First offense: Warning from maintainers
- Second offense: Temporary ban (1 week)
- Third offense: Permanent ban

**Reporting:**
Report issues to: mcaprio@gmail.com

### Getting Help

**Questions about contribution process:**
- Open a GitHub Discussion (preferred)
- Tag issue with `question` label
- Email maintainer: mcaprio@gmail.com

**Questions about using the library:**
- Check existing documentation first
- Search closed issues (may already be answered)
- Open new issue with `question` label

### Recognition

Contributors are recognized in several ways:

1. **Contributors List**: Added to README.md after first merged PR
2. **Changelog Attribution**: Mentioned in CHANGELOG.md for significant contributions
3. **Author Credits**: Co-authorship for major features or rewrites

---

## Development Setup

### Prerequisites

- Git
- Markdown editor (VSCode, Typora, etc.)
- Basic knowledge of the technologies you're documenting

### Local Setup

```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/YOUR_USERNAME/prompt-engineering-library.git
cd prompt-engineering-library

# Add upstream remote
git remote add upstream https://github.com/mcapriotti74/prompt-engineering-library.git

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes...

# Commit following convention
git add .
git commit -m "feat(scope): description"

# Push to your fork
git push origin feature/your-feature-name

# Open PR on GitHub
```

### Keeping Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge into your main
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

---

## Release Process

(Maintainers only)

1. Update CHANGELOG.md (move `[Unreleased]` to `[X.Y.Z]`)
2. Update version references in README.md
3. Create release commit: `chore: Release vX.Y.Z`
4. Tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
5. Push: `git push && git push --tags`
6. Create GitHub Release with changelog excerpt

**Versioning:**
- **MAJOR** (X.0.0): Breaking changes to core principles
- **MINOR** (0.X.0): New agents, workflows, or significant features
- **PATCH** (0.0.X): Bug fixes, documentation improvements, small enhancements

---

## Questions?

Still have questions? We're here to help!

- **GitHub Discussions**: https://github.com/mcapriotti74/prompt-engineering-library/discussions
- **Issues**: https://github.com/mcapriotti74/prompt-engineering-library/issues
- **Email**: mcaprio@gmail.com

---

**Thank you for contributing to the Prompt Engineering Library!**

Your contributions help developers worldwide work more effectively with AI assistants.

---

**Last Updated:** 2025-12-25
**Version:** 1.0.0
