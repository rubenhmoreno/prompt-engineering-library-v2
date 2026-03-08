# Error Prevention

> **Executive Summary:** A systematic protocol for eliminating errors caused by unverified assumptions. Seven verification categories cover the most common sources of failure — file structure, encoding, syntax, dependencies, testing, versioning, and cross-platform compatibility. Apply the pre-execution checklist before every non-trivial action.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [base-programming.md](base-programming.md), [real-validation.md](real-validation.md) |

---

## Quick Reference Card

Pre-execution checklist — stop and verify if any answer is NO:

| # | Question | Command to verify |
|---|----------|------------------|
| 1 | Did I verify the directory structure? | `ls -la` / `find . -name "*.ext"` |
| 2 | Did I check file encoding? | `file filename` |
| 3 | Did I read all related existing code? | Read before modifying |
| 4 | Did I verify syntax manually? | Count braces, check try-catch pairs |
| 5 | Did I confirm required dependencies exist? | `command -v tool` / `which tool` |
| 6 | Do I have a test plan? | Define before implementing |
| 7 | Is the version number updated? | Bump before packaging |
| 8 | Did I account for platform differences? | Check target OS explicitly |

**If any answer is NO — stop and verify first.**

---

## Full Content

### Category 1: File Structure and Directories

Before assuming where a file lives:

DO:
- Run `ls -la` to see the actual current structure
- Use `find . -name "pattern"` to locate files
- Run `pwd` to confirm the current working directory
- Use `ls -R` or `tree` to see the full hierarchy

NEVER:
- Assume a file is in the current directory
- Guess the structure without running a command
- Use relative paths without confirming the working directory
- Create files in unverified locations

```bash
# Correct pattern
ls -la                          # What is actually here?
find . -name "app.exe"          # Where is the file?
pwd                             # What directory am I in?

# Then act conditionally:
if [ -f "bin/publish/app.exe" ]; then
    cp "bin/publish/app.exe" /opt/app/
fi
```

### Category 2: Encoding and Line Endings

Before creating or modifying any script file:

DO:
- Run `file filename` to check the current encoding
- Know the target platform's requirements before writing
- Convert explicitly when needed and verify the result

NEVER:
- Assume UTF-8 works on all platforms (it fails in Windows PowerShell by default)
- Ignore LF vs CRLF differences
- Package scripts without verifying their encoding

Encoding reference by file type and platform:

| File Type | Platform | Required Encoding | Required Line Ending | Verification |
|-----------|----------|-------------------|----------------------|--------------|
| `.ps1` | Windows | ASCII | CRLF | `file script.ps1` shows "ASCII text, with CRLF" |
| `.bat` | Windows | ASCII | CRLF | `file script.bat` shows "DOS batch file" |
| `.sh` | Linux/Mac | UTF-8 | LF | `file script.sh` shows "UTF-8 text" |
| `.py` | Both | UTF-8 | LF | `file script.py` shows "UTF-8 text" |
| `.json` | Both | UTF-8 | LF | `file config.json` shows "UTF-8 text" |

Conversion commands:

```bash
# UTF-8 to ASCII (for Windows PowerShell scripts)
iconv -f UTF-8 -t ASCII//TRANSLIT script.ps1 > script_ascii.ps1

# LF to CRLF (for Windows)
sed -i 's/$/\r/' script.ps1

# CRLF to LF (for Linux)
dos2unix script.sh
# or manually:
tr -d '\r' < script.sh > script_clean.sh

# Verify result
file script.ps1   # Must show: ASCII text, with CRLF line terminators
```

### Category 3: Syntax and Code Logic

Before writing or modifying complex code blocks:

DO:
- Read ALL related existing code before touching any file
- Verify that every opening brace has a closing brace
- Count `try`/`catch`/`finally` blocks manually
- Trace the logic step by step mentally before running

NEVER:
- Modify a file without reading it fully first
- Copy code without understanding its context
- Leave incomplete `try-catch` structures
- Assume syntax is correct without a mental trace

```python
# Correct try-catch structure:
try:
    result = risky_operation()
    log.info(f"Success: {result}")
    return result
except SpecificError as e:
    db.session.rollback()
    log.error(f"SpecificError in risky_operation: {e}")
    raise ValueError(f"Operation failed: {e}")
except Exception as e:
    db.session.rollback()
    log.error(f"Unexpected error: {e}")
    raise

# Verification checklist for any block:
# [ ] Every try has a catch or finally
# [ ] Every { has a matching }
# [ ] Every if has a matching else (or is intentionally one-armed)
# [ ] Error messages include context, not just the exception object
```

### Category 4: Dependencies and Prerequisites

Before assuming a tool or command is available:

DO:
- Check command existence with `which tool` or `command -v tool`
- Check version with `tool --version`
- Document all dependencies in README with installation links
- Fail loudly with a clear message if a dependency is missing

NEVER:
- Assume a tool is installed because it is common
- Fail silently when a dependency is missing
- Use platform-specific commands without a check

```bash
# Correct dependency check pattern
if ! command -v dotnet &>/dev/null; then
    echo "ERROR: .NET is not installed."
    echo "Install from: https://dotnet.microsoft.com/download"
    exit 1
fi

dotnet --version
dotnet publish --configuration Release
```

### Category 5: Testing and Verification

Before marking any task complete:

DO:
- Execute the code or script locally (not just lint it)
- Capture the real terminal output and include it in your report
- Verify generated files exist with `ls -lh`
- Document evidence of actual functionality

NEVER:
- Say "should work" without running it
- Mark a task done without showing output
- Equate linting success with functional correctness
- Report success without reproducible evidence

Verification report template:

```markdown
## Verification of [TASK NAME]

### Command executed:
pytest tests/test_auth.py -v --cov=app

### Actual output:
tests/test_auth.py::test_login_success PASSED
tests/test_auth.py::test_invalid_credentials PASSED
2 passed, coverage: 91%

### Files generated:
ls -lh app/routes/auth.py app/services/auth_service.py
-rw-r--r-- 1 user group 2.1K Mar 08 10:00 app/routes/auth.py

### Conclusion:
[PASS] Task completed. Evidence attached above.
```

### Category 6: Versioning and Change Tracking

Before releasing or packaging a new version:

DO:
- Increment the version number before making changes
- Document exactly what changed in each version
- Use consistent naming (semantic versioning preferred)
- Update CHANGELOG with date and summary

NEVER:
- Reuse the same version number after changes
- Make changes without updating the version
- Create versions without a clear purpose
- Assume users will infer what changed

Semantic versioning:

```
MAJOR.MINOR.PATCH
2.0.0  -> Breaking change or major rewrite
2.1.0  -> New feature, backward compatible
2.1.1  -> Bug fix, backward compatible

For iterative packaging (e.g., build artifacts):
v2.0.21a  -> First attempt (docs update)
v2.0.21b  -> Permission fix
v2.0.21c  -> PowerShell syntax correction
v2.0.21d  -> Encoding conversion
Always document the reason for each letter increment.
```

### Category 7: Cross-Platform Compatibility

Before assuming code works on both Windows and Linux:

DO:
- Identify the target platform explicitly before writing
- Use conditional logic for platform-specific code
- Use `pathlib.Path` for all file path operations
- Document platform limitations clearly

NEVER:
- Assume Unix paths work on Windows
- Mix `/` and `\` path separators
- Ignore file system case sensitivity differences
- Use platform-specific commands without a guard

```python
import os
import platform
from pathlib import Path

# Detect platform explicitly
if platform.system() == "Windows":
    install_path = Path(os.environ["PROGRAMFILES"]) / "MyApp"
    config_path = Path(os.environ["APPDATA"]) / "MyApp" / "config.json"
else:
    install_path = Path("/usr/local/bin/myapp")
    config_path = Path.home() / ".config" / "myapp" / "config.json"

# Always use pathlib -- never string concatenation for paths
exe = install_path / "bin" / "app"
```

`.gitattributes` for consistent line endings:
```
* text=auto
*.sh text eol=lf
*.ps1 text eol=crlf
*.py text eol=lf
*.json text eol=lf
```

### Practical Workflow

Apply in this order on every non-trivial action:

```
1. READ the full requirement
2. IDENTIFY files and directories involved
3. VERIFY with commands (ls, file, command -v)
4. PLAN the changes needed
5. VERIFY syntax and logic mentally (count braces)
6. EXECUTE changes
7. VERIFY result with commands
8. DOCUMENT evidence
9. REPORT to user with proof
```

### Alert Signals

If you notice any of these patterns, stop and return to the relevant category:

- Saying "it should work" without running it (Category 5)
- Creating version after version without understanding why it fails (Category 6)
- Repeated syntax errors in the same file (Category 3)
- "File not found" or path errors (Category 1)
- Unable to reproduce a reported error (Category 5)
- Script works locally but fails on target machine (Category 7)
- "Command not found" on target system (Category 4)

**Stop. Return to this document. Work through the relevant category.**

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Assume `app.exe` is in the current directory | `find . -name "app.exe"` first | File location is almost never what you expect on first run |
| Create `.ps1` in UTF-8 for Windows | Convert to ASCII + CRLF before packaging | PowerShell on Windows silently misreads UTF-8 BOM files |
| Write 150-line functions, check syntax visually | Count braces line by line; use a linter | Human visual checking misses unbalanced blocks at scale |
| `except: pass` to silence errors | Log with context, raise or return error state | Silenced errors resurface hours later with no trace |
| Release `v2.0.21` again after a bug fix | `v2.0.21b` with CHANGELOG entry | Version reuse makes rollback and audit impossible |
| Use `/` paths in Windows scripts | `os.path.join()` or `pathlib.Path` | Hardcoded separators break on the other platform |

---

## Related Documents

- [core/base-programming.md](base-programming.md) — Master session prompt
- [core/real-validation.md](real-validation.md) — Evidence and reporting standards
- [workflows/verification-protocol.md](../workflows/verification-protocol.md) — End-to-end verification workflow
- [examples/best-practices-learned.md](../examples/best-practices-learned.md) — Real cases: VOX Client encoding failures

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
