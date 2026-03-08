# Best Practices Learned

> **Executive Summary:** Ten categories of best practices distilled from real projects, each shown as a concrete problem, wrong approach, right approach with working code, and a verification command. The source material spans the VOX Client v2.0.21 deployment and multiple backend API projects. Every practice here was learned the hard way.

| Metadata | Value |
|----------|-------|
| Type     | Example |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [Case Study: VOX Client](case-study-vox-client.md), [Command Reference](../quick-ref/command-reference.md), [Verification Protocol](../workflows/verification-protocol.md) |

---

## Summary Table

| # | Category | Core Practice | Verification Command |
|---|----------|---------------|---------------------|
| 1 | Verification | Check before acting; never assume state | `test -f /path && echo exists` |
| 2 | Error Handling | Fail loudly with context and suggested fixes | `curl -sf url \|\| echo "FAILED"` |
| 3 | Testing | Write the test before the implementation | `pytest tests/ -v --cov=app` |
| 4 | Code Organization | One class, one responsibility | (code review) |
| 5 | Documentation | Docstrings with Args, Returns, Raises, Example | (code review) |
| 6 | Deployment | Automated deploy script with rollback | `./deploy.sh && curl -sf .../health` |
| 7 | Security | Validate input; never interpolate into SQL | `bandit -r app/` |
| 8 | Performance | Eager load; cache expensive queries | `EXPLAIN ANALYZE SELECT ...` |
| 9 | Cross-Platform | Use `pathlib`; enforce line endings in `.gitattributes` | `file script.ps1` |
| 10 | Version Control | Conventional commits; branch per feature | `git log --oneline -10` |

---

## 1. Verification Before Action

**Problem:** Code assumes files, services, and commands exist without checking. Failures appear as cryptic errors far from the actual missing dependency.

**Wrong approach:**

```python
# Assumes file exists; crashes with unhelpful FileNotFoundError
with open('/path/to/config.json', 'r') as f:
    config = json.load(f)
```

```bash
# Assumes dotnet is installed; fails with "command not found"
dotnet build MyApp.csproj
```

**Right approach:**

```python
import os
from pathlib import Path

config_path = Path('/path/to/config.json')
if not config_path.exists():
    raise FileNotFoundError(
        f"Configuration file not found: {config_path}\n"
        f"Create it by copying: cp config.example.json {config_path}"
    )
with config_path.open() as f:
    config = json.load(f)
```

```bash
# Check prerequisite; give actionable error if missing
if ! command -v dotnet &> /dev/null; then
    echo "ERROR: .NET SDK not installed"
    echo "Install from: https://dotnet.microsoft.com/download"
    exit 1
fi
dotnet build MyApp.csproj
```

**Verification command:** `test -f /path/to/config.json && echo "OK" || echo "MISSING"`

---

## 2. Error Handling

**Problem:** Operations fail silently or with generic messages, leaving no trail for diagnosis and no guidance for the user.

**Wrong approach:**

```python
# No try-catch; database error surfaces as a 500 with no context
def create_user(email: str, password: str):
    user = User(email=email, password=hash_password(password))
    db.session.add(user)
    db.session.commit()
    return user
```

```bash
# Exit code ignored; script continues as if request succeeded
curl http://localhost:8000/api/users
echo "Done"
```

**Right approach:**

```python
import logging
from sqlalchemy.exc import IntegrityError

def create_user(email: str, password: str) -> User:
    """Create a new user account.

    Raises:
        ValueError: If email is already registered.
    """
    try:
        if not email or '@' not in email:
            raise ValueError(f"Invalid email format: {email!r}")
        user = User(email=email, password=hash_password(password))
        db.session.add(user)
        db.session.commit()
        logging.info("User created: %s", email)
        return user
    except IntegrityError:
        db.session.rollback()
        raise ValueError(f"Email already registered: {email}")
    except Exception:
        db.session.rollback()
        logging.exception("Unexpected error creating user %s", email)
        raise
```

```bash
# Check exit code; give diagnosis and possible solutions
if ! curl -sf http://localhost:8000/api/users; then
    echo "ERROR: Request to /api/users failed"
    echo "Checks:"
    echo "  systemctl is-active myservice"
    echo "  ss -tulpn | grep :8000"
    exit 1
fi
echo "Request succeeded"
```

**Verification command:** `curl -sf http://localhost:8000/health && echo "OK" || echo "FAILED"`

---

## 3. Testing Strategy

**Problem:** Code is written and then "tested" manually, leaving regressions undetected and edge cases unexplored.

**Wrong approach:**

```python
# Implemented without tests; edge cases not considered
def calculate_total(items):
    total = sum(item.price * item.quantity for item in items)
    return total * 1.21
```

**Right approach (TDD cycle):**

```python
# Step 1 - RED: write tests first
def test_calculate_total_single_item():
    """GIVEN one item at $100 qty 2, WHEN total calculated, THEN $242."""
    assert calculate_total([Item(price=100, quantity=2)]) == 242.0

def test_calculate_total_empty_list():
    """GIVEN empty list, WHEN total calculated, THEN $0."""
    assert calculate_total([]) == 0.0

def test_calculate_total_negative_price_raises():
    """GIVEN negative price, WHEN total calculated, THEN ValueError."""
    with pytest.raises(ValueError):
        calculate_total([Item(price=-10, quantity=1)])

# Step 2 - GREEN: minimal implementation to pass all three
def calculate_total(items: list, tax_rate: float = 0.21) -> float:
    """Calculate total price including tax."""
    if not items:
        return 0.0
    for item in items:
        if item.price < 0:
            raise ValueError(f"Negative price not allowed: {item.price}")
    subtotal = sum(item.price * item.quantity for item in items)
    return round(subtotal * (1 + tax_rate), 2)

# Step 3 - REFACTOR: improve without breaking tests
```

**Verification command:** `pytest tests/ -v --cov=app --cov-fail-under=80`

---

## 4. Code Organization

**Problem:** All logic accumulates in one file or class, making each piece hard to test in isolation and impossible to reuse.

**Wrong approach:**

```python
# app.py - 2000+ lines mixing models, routes, business logic, email, logging
class UserService:
    def create_user(self, email, password):
        # validate + hash + insert SQL + send email + write log file
        # all in one method, untestable, unreusable
        ...
```

**Right approach:**

```
app/
  models/user.py          # Data shape only
  repositories/users.py   # Database access only
  services/users.py       # Business logic only (orchestrates above)
  routes/users.py         # HTTP layer only (calls service)
  validators/users.py     # Input validation only
  utils/password.py       # Hashing only
```

```python
# Each class has one job; each can be tested independently
class PasswordHasher:
    """Hashes and verifies passwords. No other responsibility."""
    @staticmethod
    def hash(plain: str) -> str:
        return bcrypt.hashpw(plain.encode(), bcrypt.gensalt()).decode()

    @staticmethod
    def verify(plain: str, hashed: str) -> bool:
        return bcrypt.checkpw(plain.encode(), hashed.encode())


class UserRepository:
    """Database access for users. No business logic."""
    def __init__(self, session): self.session = session

    def create(self, email: str, password_hash: str) -> User:
        user = User(email=email, password=password_hash)
        self.session.add(user)
        self.session.commit()
        return user


class UserService:
    """Orchestrates user creation. Calls repository and hasher."""
    def __init__(self, repo: UserRepository, hasher: PasswordHasher):
        self.repo = repo
        self.hasher = hasher

    def create_user(self, email: str, password: str) -> User:
        return self.repo.create(email, self.hasher.hash(password))
```

**Verification command:** `pytest tests/unit/ -v` (each unit is independently testable)

---

## 5. Documentation

**Problem:** Functions have no docstrings, scripts have no headers, and README is a single paragraph. The next developer (or the same developer in three months) has to read the full implementation to understand intent.

**Wrong approach:**

```python
# No docstring; reader must reverse-engineer intent
def calc(a, b, c=0.21):
    return a * b * (1 + c)
```

```bash
#!/bin/bash
find /var/log -name "*.log" -mtime +30 -delete
tar -czf backup.tar.gz /etc/
scp backup.tar.gz user@remote:/backups/
```

**Right approach:**

```python
from decimal import Decimal

def calculate_total_with_tax(
    unit_price: Decimal,
    quantity: int,
    tax_rate: Decimal = Decimal('0.21')
) -> Decimal:
    """
    Calculate total price including tax.

    Args:
        unit_price: Price per unit before tax. Must be >= 0.
        quantity: Number of units. Must be >= 0.
        tax_rate: Tax rate as a decimal fraction (default: 0.21 = 21%).

    Returns:
        Total amount including tax, as Decimal.

    Raises:
        ValueError: If unit_price or quantity is negative.

    Example:
        >>> calculate_total_with_tax(Decimal('100'), 2)
        Decimal('242.00')
    """
    if unit_price < 0:
        raise ValueError(f"unit_price must be >= 0, got {unit_price}")
    if quantity < 0:
        raise ValueError(f"quantity must be >= 0, got {quantity}")
    amount = unit_price * quantity
    return amount + (amount * tax_rate)
```

```bash
#!/bin/bash
# cleanup_and_backup.sh
#
# Purpose: Delete logs older than N days and back up /etc/ to remote server.
#
# Usage:
#   ./cleanup_and_backup.sh [DAYS] [REMOTE_DIR]
#
# Arguments:
#   DAYS        Logs older than this many days are deleted (default: 30)
#   REMOTE_DIR  Destination path on remote server (default: /backups)
#
# Requirements:
#   - SSH access to remote server as 'deploy' user
#   - Write permission on /var/log
set -euo pipefail
DAYS="${1:-30}"
REMOTE_DIR="${2:-/backups}"
find /var/log -name "*.log" -mtime +"$DAYS" -delete
tar -czf backup.tar.gz /etc/
scp backup.tar.gz "deploy@remote:$REMOTE_DIR/"
```

**Verification command:** `python3 -m doctest app/services/pricing.py -v`

---

## 6. Deployment

**Problem:** Deployments are a sequence of manual SSH commands. Any step can fail silently, there is no rollback plan, and the next person has no repeatable procedure.

**Wrong approach:**

```bash
# Undocumented manual steps; no error checking; no rollback
ssh user@server
cd /opt/myapp
git pull
pip install -r requirements.txt
sudo systemctl restart myapp
```

**Right approach:**

```bash
#!/bin/bash
# deploy.sh - automated deployment with pre-checks, migration, health check, rollback
set -euo pipefail

APP_DIR="/opt/myapp"
BACKUP_DIR="/opt/backups"
SERVICE="myapp.service"
HEALTH_URL="http://localhost:8000/health"

log() { echo "[$(date +%H:%M:%S)] $*"; }

# 1. Pre-flight checks
log "Checking disk space..."
available=$(df -BG "$APP_DIR" | awk 'NR==2 {print $4}' | tr -d G)
[ "$available" -lt 1 ] && { log "ERROR: Less than 1GB free"; exit 1; }

# 2. Backup current state
log "Creating backup..."
backup="$BACKUP_DIR/myapp_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$backup" -C "$APP_DIR" .

# 3. Deploy
log "Pulling latest code..."
current=$(git -C "$APP_DIR" rev-parse HEAD)
git -C "$APP_DIR" pull origin main

log "Installing dependencies..."
pip install -r "$APP_DIR/requirements.txt" || { git -C "$APP_DIR" reset --hard "$current"; exit 1; }

log "Running migrations..."
alembic -c "$APP_DIR/alembic.ini" upgrade head || { alembic downgrade -1; git -C "$APP_DIR" reset --hard "$current"; exit 1; }

# 4. Restart and health check
log "Restarting service..."
sudo systemctl restart "$SERVICE"
sleep 5

for i in $(seq 1 10); do
    curl -sf "$HEALTH_URL" && { log "Health check passed"; break; }
    [ "$i" -eq 10 ] && { log "Health check failed; restoring backup"; tar -xzf "$backup" -C "$APP_DIR"; sudo systemctl restart "$SERVICE"; exit 1; }
    sleep 3
done

log "Deployment complete"
```

**Verification command:** `curl -sf http://localhost:8000/health && echo "OK"`

---

## 7. Security

**Problem:** User input is trusted, interpolated directly into queries, and stored or logged as-is. Secrets appear in source code.

**Wrong approach:**

```python
# SQL injection vulnerability
@app.route('/api/users/<user_id>')
def get_user(user_id):
    result = db.execute(f"SELECT * FROM users WHERE id = {user_id}")
    return jsonify(result.fetchone())

# Hardcoded secret
SECRET_KEY = "my-super-secret-key-12345"
```

**Right approach:**

```python
from pydantic import BaseModel, EmailStr, field_validator
import os

# Input validation with Pydantic
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    age: int

    @field_validator('password')
    @classmethod
    def password_strong_enough(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters')
        if not any(c.isupper() for c in v):
            raise ValueError('Password must contain an uppercase letter')
        if not any(c.isdigit() for c in v):
            raise ValueError('Password must contain a digit')
        return v

# ORM prevents SQL injection by construction
@app.route('/api/users/<int:user_id>')
def get_user(user_id: int):
    user = db.session.get(User, user_id)
    if not user:
        return jsonify({"error": "Not found"}), 404
    return jsonify(user.to_dict())

# Secrets from environment only
SECRET_KEY = os.environ["SECRET_KEY"]  # raises KeyError if not set
```

```bash
# .env (gitignored)
SECRET_KEY=generate-with-openssl-rand-hex-32
DATABASE_URL=postgresql://user:pass@localhost/mydb

# .env.example (committed to git, no real values)
SECRET_KEY=your-secret-key-here
DATABASE_URL=postgresql://user:password@localhost/dbname
```

**Verification command:** `bandit -r app/ -ll` (reports medium and high severity findings)

---

## 8. Performance

**Problem:** Database queries multiply with data size (N+1 problem), and expensive operations repeat on every request with no caching.

**Wrong approach:**

```python
# N+1 problem: 1 query for users + 1 per user for orders
def get_users_with_orders():
    users = User.query.all()           # 1 query
    return [
        {"user": u.to_dict(), "orders": [o.to_dict() for o in u.orders]}
        for u in users                 # N queries, one per user
    ]
```

**Right approach:**

```python
from sqlalchemy.orm import joinedload
import redis, json, functools

# Eager load: 1 query with JOIN
def get_users_with_orders():
    users = User.query.options(joinedload(User.orders)).all()
    return [
        {"user": u.to_dict(), "orders": [o.to_dict() for o in u.orders]}
        for u in users
    ]

# Cache expensive queries
_redis = redis.Redis(host='localhost', port=6379)

def cache(ttl: int = 300):
    def decorator(fn):
        @functools.wraps(fn)
        def wrapper(*args, **kwargs):
            key = f"{fn.__name__}:{args}:{kwargs}"
            cached = _redis.get(key)
            if cached:
                return json.loads(cached)
            result = fn(*args, **kwargs)
            _redis.setex(key, ttl, json.dumps(result))
            return result
        return wrapper
    return decorator

@cache(ttl=600)
def get_popular_products():
    return [p.to_dict() for p in Product.query.filter_by(popular=True).all()]
```

**Verification command:** `psql -U admin -d mydb -c "EXPLAIN ANALYZE SELECT ..."`

---

## 9. Cross-Platform Compatibility

**Problem:** File paths are hard-coded for one OS, line endings are ignored, and scripts fail silently on a different platform.

**Wrong approach:**

```python
# Platform-specific; breaks on Linux or Mac
config = open("C:\\Users\\Admin\\app\\config.json").read()
log_path = "/var/log/app.log"  # breaks on Windows
```

```bash
# No .gitattributes; Windows scripts arrive with LF endings
```

**Right approach:**

```python
from pathlib import Path
import os

# OS-agnostic paths using pathlib
config_path = Path.home() / "app" / "config.json"

# Platform-conditional paths when necessary
if os.name == 'posix':
    log_path = Path("/var/log/app.log")
else:
    log_path = Path(os.environ.get("APPDATA", "C:/ProgramData")) / "app" / "app.log"

log_path.parent.mkdir(parents=True, exist_ok=True)
```

```
# .gitattributes - enforce line endings per file type
* text=auto

*.bat  text eol=crlf
*.ps1  text eol=crlf
*.sh   text eol=lf
*.py   text eol=lf
*.yml  text eol=lf
*.json text eol=lf
*.md   text eol=lf
```

**Verification command:** `file Install.ps1` (must show `ASCII text, with CRLF line terminators`)

---

## 10. Version Control

**Problem:** Commits say "fix" or "update" with no context. Branches are unnamed or named "test". History is unusable for debugging or reverting.

**Wrong approach:**

```bash
git commit -m "fix"
git commit -m "update"
git commit -m "final"
git commit -m "final2"
```

**Right approach:**

```bash
# Conventional Commits format: type(scope): subject
git commit -m "feat(auth): add JWT token refresh endpoint"
git commit -m "fix(installer): detect binary in bin/Publish_v2.0.21/"
git commit -m "docs(api): add OpenAPI examples for /users endpoint"
git commit -m "refactor(users): extract password hashing to PasswordHasher class"
git commit -m "test(cart): add edge cases for calculate_total with empty list"
git commit -m "chore(deps): upgrade SQLModel to 0.0.21"
```

```
# Branch naming convention:
feature/jwt-refresh-endpoint
fix/23-installer-binary-path
docs/add-api-examples
refactor/extract-password-hasher
```

```bash
# Branching workflow
git checkout main && git pull
git checkout -b feature/jwt-refresh-endpoint
# ... implement and commit ...
git push origin feature/jwt-refresh-endpoint
# Open PR; squash and merge after review
```

**Verification command:** `git log --oneline -10` (each line should be self-explanatory)

---

## Quick Reference - Most Used Commands

```bash
# File system
test -f /path && echo "OK" || echo "MISSING"
find /path -name "*.py" -type f

# Services
systemctl is-active service-name
ss -tulpn | grep :8000

# Software
command -v python3 && python3 --version

# Database
psql -U admin -d mydb -c "SELECT COUNT(*) FROM users"

# Testing
pytest tests/ -v --cov=app --cov-fail-under=80

# Git
git log --oneline -10
git status

# Network
curl -sf http://localhost:8000/health && echo "OK"

# Docker
docker compose ps
docker logs -f myapp
```

---

## Related Documents

- [Case Study: VOX Client](case-study-vox-client.md) - Where most of these lessons originated
- [Command Reference](../quick-ref/command-reference.md) - Full categorized command reference
- [Verification Protocol](../workflows/verification-protocol.md) - How to use these practices in a workflow
- [TDD Workflow](../workflows/tdd-workflow.md) - Practice 3 expanded into a full workflow
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
