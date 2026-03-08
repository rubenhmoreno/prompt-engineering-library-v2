# Case Study: VOX Client v2.0.21

> **Executive Summary:** A Windows desktop notification client (C# WPF + Python FastAPI backend) required 7 fix iterations before reaching a stable release. This case study documents each error, the wrong approach taken, the correct fix, and the lesson that generalizes to any project. Estimated 3 hours of avoidable debugging had the Verification Protocol been applied from the start.

| Metadata | Value |
|----------|-------|
| Type     | Example |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [Best Practices Learned](best-practices-learned.md), [Verification Protocol](../workflows/verification-protocol.md), [Command Reference](../quick-ref/command-reference.md) |

---

## Error Summary Table

| # | Error | Category | Root Cause | Fix |
|---|-------|----------|------------|-----|
| 1 | Installer could not find the binary | File system assumption | Script looked in current directory; binary was in `bin/Publish_v2.0.21/` | Dynamic path search with clear error messages |
| 2 | PowerShell parse failure | Encoding | UTF-8 characters (checkmarks, accented letters) in script | Strip to ASCII-only output strings |
| 3 | "Not a valid PowerShell script" on Windows | Line endings | Script authored on Linux had LF; Windows PowerShell requires CRLF | Convert with `sed` or `unix2dos`; enforce via `.gitattributes` |
| 4 | Double UAC prompt appeared | Privilege escalation | Both the `.bat` launcher and the `.ps1` script requested admin elevation | One entry point owns elevation; the other assumes it already has it |
| 5 | Installation failed silently | Error handling | No try-catch; no informative messages | Wrap every critical operation in try-catch with context and suggested fixes |
| 6 | Multiple releases had the same filename | Versioning | Sub-versions (a, b, c...) not reflected in distribution filename | Update version string and filename on every change |
| 7 | Bugs reached end users | Testing gap | No clean-environment test before release | Test on a clean VM with a 15-step checklist before distribution |

---

## Project Architecture

```
Backend (Linux)                     Client (Windows)
+-----------------+    HTTP    +-------------------------------+
| FastAPI (REST)  |<---------->|   VoxClient.GUI.exe (WPF)    |
+-----------------+            |   - System tray              |
         |                     |   - Real-time notifications  |
         | HTTP                +-------------------------------+
         v                                  ^
+-----------------------+                   | WebSocket
| Flask-SocketIO        |-------------------+
| (Notification Server) |
+-----------------------+
```

**Stack:** Python 3.11, FastAPI, Flask-SocketIO, PostgreSQL, systemd (Linux) / C# .NET 8.0, WPF, PowerShell (Windows)

---

## Error 1: Assuming File Location

**What went wrong:** The PowerShell installer assumed the executable was in the current directory. The binary was actually inside `bin/Publish_v2.0.21/`. The script window opened and immediately closed with no output.

**Wrong approach:**

```powershell
# Assumes the binary is wherever the script runs from
$ExePath = ".\VoxClient.GUI.exe"
if (Test-Path $ExePath) {
    # ... install
}
# Silent failure when file is not here
```

**Right approach:**

```powershell
# Search known locations; fail loudly if none found
$candidates = @(".\VoxClient.GUI.exe", ".\bin\Publish_v2.0.21\VoxClient.GUI.exe")
$ExePath = $null
foreach ($path in $candidates) {
    if (Test-Path $path) { $ExePath = $path; break }
}
if (-not $ExePath) {
    Write-Host "[ERROR] VoxClient.GUI.exe not found. Searched: $($candidates -join ', ')"
    exit 1
}
Write-Host "[OK] Binary found at: $ExePath"
```

**Lesson:** Run `ls` or `find` before writing any path into a script. Never hard-code a single location; search candidates and fail with a clear message naming every location checked.

---

## Error 2: UTF-8 Characters in PowerShell Scripts

**What went wrong:** Script contained checkmark symbols and accented characters. Windows PowerShell misread them as syntax tokens, producing a parse error on a line that looked correct.

**Wrong approach:**

```powershell
# UTF-8 characters break Windows PowerShell parsing
Write-Host "Instalacion completada" -ForegroundColor Green
Write-Host "Configuracion actualizada" -ForegroundColor Cyan
```

**Right approach:**

```powershell
# Pure ASCII - safe across all Windows encodings
Write-Host "[OK] Installation complete" -ForegroundColor Green
Write-Host "[INFO] Configuration updated" -ForegroundColor Cyan
```

```bash
# Verify encoding before shipping
file Install.ps1
# Must show: ASCII text, with CRLF line terminators
# If UTF-8, convert:
iconv -f UTF-8 -t ASCII//TRANSLIT Install.ps1 > Install_ascii.ps1
```

**Lesson:** For any script targeting Windows, author in pure ASCII. Use `file` to verify encoding before distributing. Bracket prefixes like `[OK]` and `[ERROR]` are readable without any special characters.

---

## Error 3: LF Line Endings on Windows

**What went wrong:** The script was written on Linux (LF line endings). Windows PowerShell 5 requires CRLF and rejected the file as invalid syntax with no useful error.

**Wrong approach:**

```bash
# Linux default: LF endings
$ file Install.ps1
Install.ps1: ASCII text
# Silently incompatible with Windows PowerShell
```

**Right approach:**

```bash
# Convert to CRLF
sed -i 's/$/\r/' Install.ps1

# Verify
file Install.ps1
# Install.ps1: ASCII text, with CRLF line terminators

# Enforce permanently in .gitattributes
echo "*.ps1 text eol=crlf" >> .gitattributes
echo "*.bat text eol=crlf" >> .gitattributes
echo "*.sh  text eol=lf"   >> .gitattributes
echo "*.py  text eol=lf"   >> .gitattributes
```

**Lesson:** Any cross-platform project touching Windows scripts must have a `.gitattributes` file enforcing line endings per file type. Add it at project start, not as a fix.

---

## Error 4: Double UAC Elevation Prompt

**What went wrong:** `INSTALAR.bat` requested admin rights, then immediately launched `Install.ps1`, which also requested admin rights. Users saw two UAC prompts in sequence.

**Wrong approach:**

```batch
:: INSTALAR.bat - also tries to elevate (wrong)
@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
powershell -File "%~dp0Install.ps1"
```

```powershell
# Install.ps1 - also tries to elevate (redundant)
if (-NOT ([Security.Principal.WindowsPrincipal]...IsInRole("Administrator"))) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}
```

**Right approach:**

```batch
:: INSTALAR.bat - only launches; elevation handled by Install.ps1
@echo off
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install.ps1"
pause
```

```powershell
# Install.ps1 - single owner of elevation logic
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")) {
    Write-Host "[INFO] Requesting administrator privileges..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
# All remaining code runs with confirmed admin rights
```

**Lesson:** One entry point owns privilege escalation. Every other script in the chain assumes it already has the required permissions.

---

## Error 5: Silent Failure with No Error Context

**What went wrong:** File copy and configuration operations had no error handling. When they failed, the script window closed and users had no idea what went wrong or how to fix it.

**Wrong approach:**

```powershell
# No try-catch; no messages; no context
Copy-Item $ExePath $DestinationPath
Update-ConfigFile $ConfigPath
Register-Autostart
```

**Right approach:**

```powershell
try {
    Write-Host "[INFO] Copying executable to $DestinationPath..."
    Copy-Item $ExePath $DestinationPath -ErrorAction Stop
    Write-Host "[OK] Executable copied"
} catch {
    Write-Host "[ERROR] Failed to copy executable"
    Write-Host "  Source:  $ExePath"
    Write-Host "  Target:  $DestinationPath"
    Write-Host "  Reason:  $($_.Exception.Message)"
    Write-Host ""
    Write-Host "Possible fixes:"
    Write-Host "  1. Close VoxClient.GUI.exe if it is running"
    Write-Host "  2. Verify write permission on $DestinationPath"
    exit 1
}
```

**Lesson:** Wrap every critical operation in try-catch. The error message must name the files involved, the exception text, and at least two suggested fixes. A user with a clear error can self-recover; a user with a silent failure cannot.

---

## Error 6: Inconsistent Versioning Across Files

**What went wrong:** Sub-release versions (a, b, c...) were tracked in the script header but the distribution ZIP file retained the original name. Users received updated files with no way to tell which iteration they had.

**Wrong approach:**

```
# All patches shipped with the same filename:
VoxClient_v2.0.21_Windows.zip  (actually contains v2.0.21a)
VoxClient_v2.0.21_Windows.zip  (actually contains v2.0.21b, same name)
```

**Right approach:**

```powershell
# Version constant at the top of every installer script
$Version = "2.0.21g"
Write-Host "VOX Client Installer v$Version"
```

```
# Distribution filename includes version suffix:
VoxClient_v2.0.21a_Windows.zip   <- fix: binary path
VoxClient_v2.0.21b_Windows.zip   <- fix: encoding
VoxClient_v2.0.21c_Windows.zip   <- fix: line endings
VoxClient_v2.0.21d_Windows.zip   <- fix: syntax errors
VoxClient_v2.0.21e_Windows.zip   <- fix: double UAC
VoxClient_v2.0.21f_Windows.zip   <- improve: error handling
VoxClient_v2.0.21g_Windows.zip   <- final: verified on clean VM
```

**Lesson:** Every change, no matter how small, increments the version string and the distribution filename. Keep a one-line changelog entry for every increment.

---

## Error 7: No Testing on a Clean Environment

**What went wrong:** The installer was tested on the development machine which already had .NET, the correct directory structure, and admin access. None of the deployment-specific bugs were caught before distribution. End users found all seven issues.

**Wrong approach:**

```
# "Testing" = running on the dev machine where everything
# already works by accident:
# - .NET already installed
# - Binary already in expected path
# - Running as admin by default
# - Antivirus exceptions already in place
# Result: 7 bugs discovered by end users across 7 iterations
```

**Right approach:**

```markdown
Pre-release checklist (run on a CLEAN VM, standard user account):

Environment preparation:
- [ ] Windows 10 or 11 fresh installation
- [ ] .NET Runtime NOT pre-installed (test auto-install)
- [ ] Standard user account (not admin)
- [ ] Windows Defender active

Installation verification:
- [ ] Extract ZIP to C:\Temp\VoxClient
- [ ] Run INSTALAR.bat as standard user
- [ ] Verify exactly one UAC prompt appears
- [ ] Verify installation completes with no errors
- [ ] Verify executable present in C:\Program Files\VoxClient\
- [ ] Verify desktop shortcut created
- [ ] Reboot machine
- [ ] Verify VoxClient.GUI.exe starts automatically after reboot
- [ ] Verify a test notification is received

Uninstallation verification:
- [ ] Run DESINSTALAR.bat
- [ ] Verify all application files removed
- [ ] Verify autostart registry entry removed
- [ ] Verify no leftover files in Program Files
```

**Lesson:** The only valid test environment for a Windows installer is a clean Windows VM with a standard user account. Everything else is not testing; it is hoping.

---

## Metrics

| Phase | Time Spent | Avoidable? |
|-------|-----------|------------|
| Initial development | 3 hours | No |
| First installer | 1 hour | No |
| Debugging iterations (a through g) | 4 hours | Yes, ~3h with Verification Protocol |
| Testing and validation | 1 hour | No (should have come first) |
| **Total** | **9 hours** | **~3 hours recoverable** |

**Root cause of all 7 errors:** No verification step between "code written" and "shipped to users."

---

## Prevention Principles

These 7 errors collapse into 3 rules:

1. **Verify before assuming.** Run `ls` or `find` before writing any path. Run `file` before shipping any script. Use commands, not assumptions.

2. **Fail loudly with context.** Every error message must name the file, the operation, the exception, and at least one suggested fix. Silent failures always cost more time than verbose ones.

3. **Test in the target environment.** The only valid test for a deployment artifact is running it fresh on the exact environment where it will be used, with the exact permissions it will have.

---

## Related Documents

- [Best Practices Learned](best-practices-learned.md) - Generalizations of these lessons across 10 categories
- [Verification Protocol](../workflows/verification-protocol.md) - The workflow that prevents all 7 errors
- [Command Reference](../quick-ref/command-reference.md) - File, process, and network verification commands
- [TDD Workflow](../workflows/tdd-workflow.md) - Test-first development approach
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
