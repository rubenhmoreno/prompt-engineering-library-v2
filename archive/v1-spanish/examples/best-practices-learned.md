# Best Practices Learned
## Colección de Mejores Prácticas de Proyectos Reales

**Propósito:** Referencia rápida de mejores prácticas aprendidas de experiencia real
**Actualización:** Continua (se agregan nuevas lecciones de cada proyecto)
**Fuente:** VOX Client v2.0.21, proyectos de correlación de datos, y más

---

## 📋 Índice Rápido

1. [Verification Before Action](#1-verification-before-action)
2. [Error Handling](#2-error-handling)
3. [Testing Strategy](#3-testing-strategy)
4. [Code Organization](#4-code-organization)
5. [Documentation](#5-documentation)
6. [Deployment](#6-deployment)
7. [Security](#7-security)
8. [Performance](#8-performance)
9. [Cross-Platform Compatibility](#9-cross-platform-compatibility)
10. [Version Control](#10-version-control)

---

## 1. Verification Before Action

### ❌ Antipatrón: Asumir

```python
# ❌ MAL: Asumir que archivo existe
with open('/path/to/file.txt', 'r') as f:
    data = f.read()
```

```bash
# ❌ MAL: Asumir que comando existe
dotnet build
```

```powershell
# ❌ MAL: Asumir ubicación de archivos
$exe = ".\VoxClient.GUI.exe"
Copy-Item $exe "C:\Program Files\VoxClient\"
```

---

### ✅ Best Practice: Verificar Siempre

```python
# ✅ BIEN: Verificar antes de abrir
import os

file_path = '/path/to/file.txt'
if not os.path.exists(file_path):
    raise FileNotFoundError(f"File not found: {file_path}")

with open(file_path, 'r') as f:
    data = f.read()
```

```bash
# ✅ BIEN: Verificar prerequisite
if ! command -v dotnet &> /dev/null; then
    echo "ERROR: .NET no está instalado"
    echo "Instalar desde: https://dotnet.microsoft.com/download"
    exit 1
fi

dotnet build
```

```powershell
# ✅ BIEN: Buscar archivo dinámicamente
$possiblePaths = @(
    ".\VoxClient.GUI.exe",
    ".\bin\Publish_v2.0.21\VoxClient.GUI.exe",
    ".\bin\Release\VoxClient.GUI.exe"
)

$exe = $null
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $exe = $path
        Write-Host "Ejecutable encontrado: $exe" -ForegroundColor Green
        break
    }
}

if (-not $exe) {
    Write-Host "ERROR: No se encontró VoxClient.GUI.exe" -ForegroundColor Red
    Write-Host "Buscado en:" -ForegroundColor Yellow
    $possiblePaths | ForEach-Object { Write-Host "  - $_" }
    exit 1
}

Copy-Item $exe "C:\Program Files\VoxClient\"
```

---

### Comandos de Verificación Esenciales

#### Sistema de Archivos
```bash
# Verificar que archivo existe
test -f /path/to/file && echo "Exists" || echo "Not found"
ls -lh /path/to/file

# Verificar que directorio existe
test -d /path/to/dir && echo "Exists" || echo "Not found"
ls -ld /path/to/dir

# Buscar archivos
find /path -name "*.py"
find /path -type f -name "*.log" -mtime -1  # Modified in last 24h
```

#### Procesos y Servicios
```bash
# Verificar que proceso está corriendo
ps aux | grep python3 | grep -v grep
pgrep -f "notification_server"

# Verificar servicio systemd
systemctl is-active myservice
systemctl status myservice

# Verificar puerto abierto
netstat -tulpn | grep :8000
ss -tulpn | grep :8000
lsof -i :8000
```

#### Software y Versiones
```bash
# Verificar que comando existe
command -v python3 &> /dev/null && echo "Installed" || echo "Not installed"
which python3

# Verificar versión
python3 --version
node --version
docker --version
```

#### Base de Datos
```bash
# Verificar conexión PostgreSQL
psql -U admin -d mydb -c "SELECT 1"

# Verificar que tabla existe
psql -U admin -d mydb -c "\dt users"

# Verificar registros
psql -U admin -d mydb -c "SELECT COUNT(*) FROM users"
```

---

## 2. Error Handling

### ❌ Antipatrón: Fallar Silenciosamente

```python
# ❌ MAL: Sin try-catch
def create_user(email, password):
    user = User(email=email, password=hash_password(password))
    db.session.add(user)
    db.session.commit()
    return user
```

```bash
# ❌ MAL: Sin verificar exit code
curl http://localhost:8000/api/users
echo "Request completed"  # Siempre se ejecuta, incluso si falla
```

---

### ✅ Best Practice: Error Handling Robusto

```python
# ✅ BIEN: Try-catch con contexto
import logging

def create_user(email, password):
    try:
        # Validación
        if not email or '@' not in email:
            raise ValueError(f"Invalid email format: {email}")

        # Hash password
        hashed = hash_password(password)

        # Create user
        user = User(email=email, password=hashed)
        db.session.add(user)
        db.session.commit()

        logging.info(f"User created successfully: {email}")
        return user

    except IntegrityError as e:
        db.session.rollback()
        logging.error(f"Database integrity error creating user {email}: {e}")
        raise ValueError(f"User with email {email} already exists")

    except Exception as e:
        db.session.rollback()
        logging.error(f"Unexpected error creating user {email}: {e}")
        raise
```

```bash
# ✅ BIEN: Verificar exit codes
if ! curl -f http://localhost:8000/api/users; then
    echo "ERROR: Failed to fetch users"
    echo "Possible causes:"
    echo "  1. Service not running (check: systemctl status myservice)"
    echo "  2. Port 8000 not open (check: netstat -tulpn | grep 8000)"
    echo "  3. Network issue (check: ping localhost)"
    exit 1
fi

echo "Request completed successfully"
```

```python
# ✅ BIEN: Context managers para cleanup automático
from contextlib import contextmanager

@contextmanager
def database_transaction():
    """Context manager para manejar transacciones de DB."""
    try:
        yield db.session
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        logging.error(f"Transaction failed: {e}")
        raise
    finally:
        db.session.close()

# Uso:
with database_transaction():
    user = User(email="test@example.com", password="hashed")
    db.session.add(user)
    # Commit automático si todo OK, rollback si hay error
```

---

### Mensajes de Error Útiles

```python
# ❌ MAL: Error vago
raise Exception("Error")

# ✅ BIEN: Error descriptivo con contexto
raise ValueError(
    f"Invalid email format: '{email}'. "
    f"Expected format: user@domain.com. "
    f"Please check the input and try again."
)
```

```bash
# ❌ MAL: Exit sin mensaje
test -f /path/to/file || exit 1

# ✅ BIEN: Mensaje con contexto y soluciones
if [ ! -f /path/to/file ]; then
    echo "ERROR: File not found: /path/to/file"
    echo ""
    echo "This file is required for the application to start."
    echo ""
    echo "Possible solutions:"
    echo "  1. Check if the file was deleted accidentally"
    echo "  2. Restore from backup: cp /backup/file /path/to/file"
    echo "  3. Regenerate with: ./scripts/generate_config.sh"
    echo ""
    echo "For more help, see: docs/troubleshooting.md"
    exit 1
fi
```

---

## 3. Testing Strategy

### Test Pyramid

```
         /\
        /  \  E2E (5-10%)
       /----\
      /      \ Integration (20-30%)
     /--------\
    /          \ Unit (60-70%)
   /____________\
```

### ❌ Antipatrón: No Tests

```python
# ❌ MAL: Código sin tests
def calculate_total(items):
    total = sum(item.price * item.quantity for item in items)
    tax = total * 0.21
    return total + tax

# Deployado sin verificar, bugs en producción
```

---

### ✅ Best Practice: TDD (Test-Driven Development)

```python
# ✅ BIEN: Test PRIMERO (Red)
def test_calculate_total_with_single_item():
    """
    GIVEN: Un item de $100 con cantidad 2
    WHEN: Se calcula el total
    THEN: Debe retornar $242 (200 + 21% tax)
    """
    items = [Item(price=100, quantity=2)]
    total = calculate_total(items)
    assert total == 242.0

def test_calculate_total_with_multiple_items():
    """
    GIVEN: Dos items ($100 x 2, $50 x 1)
    WHEN: Se calcula el total
    THEN: Debe retornar $302.5 (250 + 21% tax)
    """
    items = [
        Item(price=100, quantity=2),
        Item(price=50, quantity=1)
    ]
    total = calculate_total(items)
    assert total == 302.5

def test_calculate_total_with_zero_items():
    """
    GIVEN: Lista vacía de items
    WHEN: Se calcula el total
    THEN: Debe retornar $0
    """
    items = []
    total = calculate_total(items)
    assert total == 0.0

# Ejecutar tests (deben fallar - RED)
# $ pytest tests/test_cart.py
# FAILED (no existe calculate_total)

# ✅ Implementar MÍNIMO para pasar (Green)
def calculate_total(items):
    if not items:
        return 0.0

    subtotal = sum(item.price * item.quantity for item in items)
    tax = subtotal * 0.21
    return subtotal + tax

# Ejecutar tests (deben pasar - GREEN)
# $ pytest tests/test_cart.py
# 3 passed ✅

# ✅ Refactor (mejorar sin romper tests)
def calculate_total(items, tax_rate=0.21):
    """
    Calculate total with tax.

    Args:
        items: List of items with price and quantity
        tax_rate: Tax rate (default 21%)

    Returns:
        Total amount including tax
    """
    if not items:
        return 0.0

    subtotal = sum(
        Decimal(str(item.price)) * item.quantity
        for item in items
    )
    tax = subtotal * Decimal(str(tax_rate))
    return float(subtotal + tax)

# Tests siguen pasando ✅
```

---

### Testing Checklist

```markdown
# Testing Checklist por Feature

## Unit Tests
- [ ] Happy path (caso ideal)
- [ ] Edge cases (valores límite)
- [ ] Error cases (inputs inválidos)
- [ ] Null/empty inputs
- [ ] Boundary conditions
- [ ] Coverage >80%

## Integration Tests
- [ ] API endpoints (request/response)
- [ ] Database operations (CRUD)
- [ ] External service calls (mocked)
- [ ] Authentication/authorization
- [ ] Error responses (400, 401, 404, 500)

## E2E Tests
- [ ] User flows completos
- [ ] Cross-browser (Chrome, Firefox, Safari)
- [ ] Mobile responsive
- [ ] Performance (response times)
- [ ] Accessibility (WCAG AA)

## Manual Testing
- [ ] Testing en entorno limpio (VM/container)
- [ ] Testing con diferentes usuarios
- [ ] Testing con datos reales (sanitizados)
- [ ] Edge cases extremos
```

---

## 4. Code Organization

### ❌ Antipatrón: Todo en Un Archivo

```python
# ❌ MAL: app.py con 2000 líneas
from flask import Flask, request, jsonify
import psycopg2
import bcrypt
# ... 50 más imports

app = Flask(__name__)

# ... 300 líneas de configuración
# ... 500 líneas de modelos
# ... 800 líneas de routes
# ... 400 líneas de helpers
```

---

### ✅ Best Practice: Estructura Modular

```
project/
├── app/
│   ├── __init__.py          # App factory
│   ├── config.py            # Configuración
│   ├── models/              # Database models
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── product.py
│   │   └── order.py
│   ├── routes/              # API endpoints
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── users.py
│   │   └── products.py
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   ├── user_service.py
│   │   ├── auth_service.py
│   │   └── email_service.py
│   ├── repositories/        # Data access
│   │   ├── __init__.py
│   │   ├── user_repository.py
│   │   └── product_repository.py
│   ├── validators/          # Input validation
│   │   ├── __init__.py
│   │   └── user_validator.py
│   └── utils/               # Helpers
│       ├── __init__.py
│       ├── password.py
│       └── email.py
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── migrations/              # Database migrations
├── docs/                    # Documentation
├── scripts/                 # Utility scripts
├── requirements.txt
├── .env.example
└── README.md
```

---

### Single Responsibility Principle

```python
# ❌ MAL: Clase hace demasiado
class UserService:
    def create_user(self, email, password):
        # Validación
        if not email or '@' not in email:
            raise ValueError("Invalid email")

        # Hash password
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(password.encode(), salt)

        # Insert en DB
        conn = psycopg2.connect("postgresql://...")
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users ...")
        conn.commit()

        # Enviar email
        smtp = smtplib.SMTP("smtp.gmail.com")
        smtp.send_message(...)

        # Logging
        with open('/var/log/app.log', 'a') as f:
            f.write(f"User created: {email}\n")

        return user
```

```python
# ✅ BIEN: Separación de responsabilidades
class UserValidator:
    """Valida inputs de usuario."""
    @staticmethod
    def validate_email(email: str) -> bool:
        return email and '@' in email and '.' in email

    @staticmethod
    def validate_password(password: str) -> tuple[bool, str]:
        if len(password) < 8:
            return False, "Password must be at least 8 characters"
        return True, ""


class PasswordHasher:
    """Maneja hashing de passwords."""
    @staticmethod
    def hash(password: str) -> str:
        salt = bcrypt.gensalt()
        return bcrypt.hashpw(password.encode(), salt).decode()

    @staticmethod
    def verify(password: str, hashed: str) -> bool:
        return bcrypt.checkpw(password.encode(), hashed.encode())


class UserRepository:
    """Acceso a datos de usuarios."""
    def __init__(self, db_session):
        self.db = db_session

    def create(self, email: str, password_hash: str) -> User:
        user = User(email=email, password=password_hash)
        self.db.add(user)
        self.db.commit()
        return user

    def get_by_email(self, email: str) -> Optional[User]:
        return self.db.query(User).filter_by(email=email).first()


class EmailService:
    """Envío de emails."""
    def send_welcome_email(self, user: User):
        # ... lógica de envío


class UserService:
    """Orquesta creación de usuarios."""
    def __init__(
        self,
        repository: UserRepository,
        email_service: EmailService
    ):
        self.repository = repository
        self.email_service = email_service
        self.validator = UserValidator()
        self.hasher = PasswordHasher()

    def create_user(self, email: str, password: str) -> User:
        # Validar
        if not self.validator.validate_email(email):
            raise ValueError("Invalid email format")

        is_valid, error = self.validator.validate_password(password)
        if not is_valid:
            raise ValueError(error)

        # Hash password
        hashed = self.hasher.hash(password)

        # Crear en DB
        user = self.repository.create(email, hashed)

        # Enviar email de bienvenida
        self.email_service.send_welcome_email(user)

        logging.info(f"User created: {email}")
        return user
```

**Beneficios:**
- Cada clase tiene una responsabilidad
- Fácil de testear (mock de dependencies)
- Fácil de extender (agregar validaciones sin tocar repository)
- Reusable (PasswordHasher usado en múltiples lugares)

---

## 5. Documentation

### ❌ Antipatrón: Sin Documentación

```python
# ❌ MAL: Función sin docstring
def calc(a, b, c=0.21):
    return a * b * (1 + c)
```

```bash
# ❌ MAL: Script sin comentarios
#!/bin/bash
find /var/log -name "*.log" -mtime +30 -delete
tar -czf backup.tar.gz /etc/
scp backup.tar.gz user@remote:/backups/
```

---

### ✅ Best Practice: Documentación Clara

```python
# ✅ BIEN: Docstring completo
def calculate_total_with_tax(
    subtotal: Decimal,
    quantity: int,
    tax_rate: Decimal = Decimal('0.21')
) -> Decimal:
    """
    Calculate total amount including tax.

    Args:
        subtotal: Price per unit (without tax)
        quantity: Number of units
        tax_rate: Tax rate as decimal (default: 0.21 for 21%)

    Returns:
        Total amount including tax

    Raises:
        ValueError: If subtotal or quantity is negative
        TypeError: If inputs are not numeric

    Example:
        >>> calculate_total_with_tax(Decimal('100'), 2, Decimal('0.21'))
        Decimal('242.00')

        >>> calculate_total_with_tax(Decimal('50'), 1)
        Decimal('60.50')
    """
    if subtotal < 0:
        raise ValueError(f"Subtotal cannot be negative: {subtotal}")

    if quantity < 0:
        raise ValueError(f"Quantity cannot be negative: {quantity}")

    amount = subtotal * quantity
    tax = amount * tax_rate
    return amount + tax
```

```bash
# ✅ BIEN: Script documentado
#!/bin/bash
# cleanup_logs.sh
# Limpia logs antiguos y crea backup de configuración
#
# Uso:
#   ./cleanup_logs.sh [días] [directorio_remoto]
#
# Argumentos:
#   días: Logs más antiguos que este número serán eliminados (default: 30)
#   directorio_remoto: Directorio en servidor remoto para backup (default: /backups)
#
# Ejemplo:
#   ./cleanup_logs.sh 60 /backups/prod
#
# Requisitos:
#   - Permisos de escritura en /var/log
#   - SSH configurado para user@remote
#   - tar y gzip instalados
#
# Autor: DevOps Team
# Fecha: 2025-12-25

set -euo pipefail  # Exit on error, undefined var, pipe failure

# Configuration
DAYS=${1:-30}
REMOTE_DIR=${2:-/backups}
LOG_DIR="/var/log"
BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Limpiar logs antiguos
echo "Eliminando logs más antiguos que $DAYS días..."
find "$LOG_DIR" -name "*.log" -mtime +"$DAYS" -delete

# Crear backup de /etc/
echo "Creando backup de configuración..."
tar -czf "$BACKUP_FILE" /etc/

# Subir a servidor remoto
echo "Subiendo backup a servidor remoto..."
scp "$BACKUP_FILE" "user@remote:$REMOTE_DIR/"

echo "Completado exitosamente"
```

---

### README Structure

```markdown
# Project Name

Brief description of what this project does.

## Features

- Feature 1
- Feature 2
- Feature 3

## Prerequisites

- Python 3.11+
- PostgreSQL 16+
- Node.js 20+

## Installation

```bash
# Clone repository
git clone https://github.com/user/project.git
cd project

# Install dependencies
pip install -r requirements.txt

# Setup database
createdb mydb
alembic upgrade head

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Run application
python main.py
```

## Usage

```bash
# Start development server
python main.py

# Run tests
pytest tests/

# Build for production
docker build -t myapp:latest .
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| DATABASE_URL | PostgreSQL connection string | `postgresql://localhost/mydb` |
| SECRET_KEY | Secret key for JWT | (required) |
| PORT | Server port | `8000` |

## API Documentation

See [docs/api.md](docs/api.md) for full API documentation.

Quick example:

```bash
# Create user
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "SecurePass123"}'
```

## Testing

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app tests/

# Run specific test file
pytest tests/test_users.py -v
```

## Deployment

See [docs/deployment.md](docs/deployment.md) for deployment instructions.

## Troubleshooting

### Common Issues

**Issue:** Database connection fails
**Solution:** Check DATABASE_URL in .env and verify PostgreSQL is running

**Issue:** Port 8000 already in use
**Solution:** Change PORT in .env or stop other service using port 8000

For more issues, see [docs/troubleshooting.md](docs/troubleshooting.md)

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

MIT License - see [LICENSE](LICENSE) file

## Contact

- Author: Team Name
- Email: team@example.com
- Project: https://github.com/user/project
```

---

## 6. Deployment

### ❌ Antipatrón: Deployment Manual

```bash
# ❌ MAL: Pasos manuales propensos a error
ssh user@server
cd /opt/myapp
git pull
pip install -r requirements.txt  # ¿Qué pasa si falla?
sudo systemctl restart myapp      # ¿Downtime?
# ¿Qué pasa si algo falla? ¿Cómo rollback?
```

---

### ✅ Best Practice: Automated Deployment

```bash
# ✅ BIEN: deploy.sh con verificaciones y rollback
#!/bin/bash
set -euo pipefail

APP_NAME="myapp"
APP_DIR="/opt/$APP_NAME"
BACKUP_DIR="/opt/backups"
SYSTEMD_SERVICE="$APP_NAME.service"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 1. Pre-deployment checks
log_info "Running pre-deployment checks..."

# Check if running as correct user
if [ "$(whoami)" != "deploy" ]; then
    log_error "Must run as 'deploy' user"
    exit 1
fi

# Check if service is running
if ! systemctl is-active --quiet "$SYSTEMD_SERVICE"; then
    log_warning "Service is not running, will start after deployment"
fi

# Check disk space
AVAILABLE=$(df -BG "$APP_DIR" | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$AVAILABLE" -lt 1 ]; then
    log_error "Insufficient disk space: ${AVAILABLE}GB available"
    exit 1
fi

# 2. Create backup
log_info "Creating backup..."
BACKUP_FILE="$BACKUP_DIR/${APP_NAME}_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$BACKUP_FILE" -C "$APP_DIR" .
log_info "Backup created: $BACKUP_FILE"

# 3. Pull latest code
log_info "Pulling latest code..."
cd "$APP_DIR"
git fetch origin
CURRENT_COMMIT=$(git rev-parse HEAD)
git pull origin main

# 4. Install dependencies
log_info "Installing dependencies..."
if ! pip install -r requirements.txt; then
    log_error "Failed to install dependencies, rolling back..."
    git reset --hard "$CURRENT_COMMIT"
    exit 1
fi

# 5. Run database migrations
log_info "Running database migrations..."
if ! alembic upgrade head; then
    log_error "Migration failed, rolling back..."
    alembic downgrade -1
    git reset --hard "$CURRENT_COMMIT"
    pip install -r requirements.txt
    exit 1
fi

# 6. Run tests
log_info "Running tests..."
if ! pytest tests/ -v; then
    log_error "Tests failed, rolling back..."
    # Rollback migration, code, dependencies
    alembic downgrade -1
    git reset --hard "$CURRENT_COMMIT"
    pip install -r requirements.txt
    exit 1
fi

# 7. Restart service (zero-downtime with systemd)
log_info "Restarting service..."
sudo systemctl reload-or-restart "$SYSTEMD_SERVICE"

# 8. Health check
log_info "Waiting for service to start..."
sleep 5

HEALTH_URL="http://localhost:8000/health"
MAX_RETRIES=10
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f -s "$HEALTH_URL" > /dev/null; then
        log_info "Health check passed!"
        break
    fi

    RETRY_COUNT=$((RETRY_COUNT + 1))
    log_warning "Health check failed, retrying ($RETRY_COUNT/$MAX_RETRIES)..."
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    log_error "Health check failed after $MAX_RETRIES attempts"
    log_error "Rolling back to previous version..."

    # Restore from backup
    tar -xzf "$BACKUP_FILE" -C "$APP_DIR"
    sudo systemctl restart "$SYSTEMD_SERVICE"

    log_error "Deployment failed and rolled back"
    exit 1
fi

# 9. Cleanup old backups (keep last 10)
log_info "Cleaning up old backups..."
ls -t "$BACKUP_DIR"/${APP_NAME}_*.tar.gz | tail -n +11 | xargs -r rm

# 10. Success
NEW_COMMIT=$(git rev-parse HEAD)
log_info "Deployment successful!"
log_info "  Previous commit: $CURRENT_COMMIT"
log_info "  New commit: $NEW_COMMIT"
log_info "  Backup: $BACKUP_FILE"
```

**Uso:**
```bash
# Deployment simple
./deploy.sh

# Con notificaciones
./deploy.sh && notify-send "Deployment successful" || notify-send "Deployment failed"
```

---

### CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov

      - name: Run tests
        run: pytest tests/ -v --cov=app --cov-report=term

      - name: Check coverage
        run: |
          coverage report --fail-under=80

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v3

      - name: Deploy to server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /opt/myapp
            ./deploy.sh

      - name: Notify on success
        if: success()
        run: |
          curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
            -d '{"text":"✅ Deployment to production successful"}'

      - name: Notify on failure
        if: failure()
        run: |
          curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
            -d '{"text":"❌ Deployment to production failed"}'
```

---

## 7. Security

### Input Validation

```python
# ❌ MAL: Sin validación
@app.route('/api/users/<user_id>')
def get_user(user_id):
    user = db.execute(f"SELECT * FROM users WHERE id = {user_id}")
    return jsonify(user)
```

```python
# ✅ BIEN: Validación + prepared statements
from pydantic import BaseModel, EmailStr, validator

class UserCreate(BaseModel):
    email: EmailStr  # Valida formato de email
    password: str
    age: int

    @validator('password')
    def password_strength(cls, v):
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters')
        if not any(c.isupper() for c in v):
            raise ValueError('Password must contain uppercase letter')
        if not any(c.isdigit() for c in v):
            raise ValueError('Password must contain number')
        return v

    @validator('age')
    def age_valid(cls, v):
        if v < 18:
            raise ValueError('Must be 18 or older')
        if v > 120:
            raise ValueError('Invalid age')
        return v

@app.route('/api/users', methods=['POST'])
def create_user():
    try:
        # Pydantic valida automáticamente
        user_data = UserCreate(**request.json)
    except ValidationError as e:
        return jsonify({"error": e.errors()}), 400

    # SQL injection prevention con ORM
    user = User(
        email=user_data.email,
        password=hash_password(user_data.password),
        age=user_data.age
    )
    db.session.add(user)
    db.session.commit()

    return jsonify(user.to_dict()), 201
```

---

### Authentication & Authorization

```python
# ✅ JWT Authentication
from functools import wraps
import jwt
from datetime import datetime, timedelta

SECRET_KEY = os.getenv("SECRET_KEY")  # Never hardcode!

def create_token(user_id: int) -> str:
    """Create JWT token."""
    payload = {
        'user_id': user_id,
        'exp': datetime.utcnow() + timedelta(hours=24),
        'iat': datetime.utcnow()
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')

def token_required(f):
    """Decorator to require valid JWT token."""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')

        if not token:
            return jsonify({'error': 'Token missing'}), 401

        try:
            # Remove 'Bearer ' prefix
            token = token.split()[1] if token.startswith('Bearer ') else token

            # Verify token
            payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
            current_user_id = payload['user_id']

        except jwt.ExpiredSignatureError:
            return jsonify({'error': 'Token expired'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'error': 'Invalid token'}), 401

        return f(current_user_id, *args, **kwargs)

    return decorated

# Usage:
@app.route('/api/users/me')
@token_required
def get_current_user(current_user_id):
    user = User.query.get(current_user_id)
    return jsonify(user.to_dict())
```

---

### Secrets Management

```bash
# ❌ MAL: Hardcoded secrets
DATABASE_URL="postgresql://admin:SuperSecret123@localhost/mydb"
SECRET_KEY="my-super-secret-key-12345"
```

```bash
# ✅ BIEN: Environment variables
# .env (gitignored!)
DATABASE_URL=postgresql://admin:${DB_PASSWORD}@localhost/mydb
SECRET_KEY=${SECRET_KEY}
STRIPE_API_KEY=${STRIPE_API_KEY}

# .env.example (committed to git)
DATABASE_URL=postgresql://user:password@localhost/dbname
SECRET_KEY=your-secret-key-here
STRIPE_API_KEY=sk_test_your_key
```

```python
# Load from environment
import os
from dotenv import load_dotenv

load_dotenv()  # Load from .env file

DATABASE_URL = os.getenv("DATABASE_URL")
SECRET_KEY = os.getenv("SECRET_KEY")

# Verify required vars
if not SECRET_KEY:
    raise ValueError("SECRET_KEY environment variable not set")
```

---

## 8. Performance

### Database Optimization

```python
# ❌ MAL: N+1 query problem
def get_users_with_orders():
    users = User.query.all()
    result = []

    for user in users:  # 1 query
        orders = user.orders.all()  # N queries (one per user!)
        result.append({
            'user': user.to_dict(),
            'orders': [o.to_dict() for o in orders]
        })

    return result
# Total: 1 + N queries
```

```python
# ✅ BIEN: Eager loading
def get_users_with_orders():
    # 1 query con JOIN
    users = User.query.options(
        joinedload(User.orders)
    ).all()

    result = [
        {
            'user': user.to_dict(),
            'orders': [o.to_dict() for o in user.orders]
        }
        for user in users
    ]

    return result
# Total: 1 query
```

---

### Caching

```python
# ✅ Redis caching
from functools import wraps
import redis
import json

redis_client = redis.Redis(host='localhost', port=6379, db=0)

def cache(expire_time=300):
    """Cache decorator."""
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            # Create cache key from function name and args
            cache_key = f"{f.__name__}:{str(args)}:{str(kwargs)}"

            # Try to get from cache
            cached = redis_client.get(cache_key)
            if cached:
                return json.loads(cached)

            # Execute function
            result = f(*args, **kwargs)

            # Store in cache
            redis_client.setex(
                cache_key,
                expire_time,
                json.dumps(result)
            )

            return result

        return decorated
    return decorator

# Usage:
@cache(expire_time=600)  # Cache for 10 minutes
def get_popular_products():
    # Expensive query
    return Product.query.filter_by(popular=True).all()
```

---

## 9. Cross-Platform Compatibility

### File Paths

```python
# ❌ MAL: Hardcoded paths
config_file = "C:\\Users\\Admin\\config.json"  # Solo Windows
log_file = "/var/log/app.log"  # Solo Linux
```

```python
# ✅ BIEN: Os-agnostic paths
import os
from pathlib import Path

# Usar pathlib para paths cross-platform
config_file = Path.home() / "config.json"
log_dir = Path("/var/log") if os.name == 'posix' else Path("C:/ProgramData/logs")
log_file = log_dir / "app.log"

# O usar os.path
config_file = os.path.join(os.path.expanduser("~"), "config.json")
```

---

### Line Endings

```bash
# ✅ .gitattributes para auto-conversión
* text=auto

# Windows scripts
*.bat text eol=crlf
*.ps1 text eol=crlf

# Unix scripts
*.sh text eol=lf

# Python files
*.py text eol=lf

# Config files
*.yml text eol=lf
*.yaml text eol=lf
*.json text eol=lf
*.md text eol=lf
```

---

## 10. Version Control

### Commit Messages

```bash
# ❌ MAL: Commit messages vagos
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"
```

```bash
# ✅ BIEN: Conventional Commits
git commit -m "feat: Add user authentication with JWT"
git commit -m "fix: Resolve database connection timeout issue"
git commit -m "docs: Update API documentation for /users endpoint"
git commit -m "refactor: Extract password hashing to separate service"
git commit -m "test: Add integration tests for auth flow"
git commit -m "chore: Update dependencies to latest versions"
```

**Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting (no code change)
- `refactor`: Code change that neither fixes bug nor adds feature
- `test`: Adding tests
- `chore`: Maintenance

---

### Branching Strategy

```
main (production)
  ├── develop (integration)
  │   ├── feature/user-auth
  │   ├── feature/payment-integration
  │   └── feature/dashboard
  ├── hotfix/critical-security-issue
  └── release/v1.2.0
```

**Workflow:**
1. Create feature branch from `develop`:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/user-authentication
   ```

2. Work on feature with frequent commits:
   ```bash
   git add .
   git commit -m "feat: Add JWT token generation"
   ```

3. Push and create Pull Request:
   ```bash
   git push origin feature/user-authentication
   # Create PR on GitHub: feature/user-authentication → develop
   ```

4. After review and tests pass, merge to `develop`

5. When ready for release:
   ```bash
   git checkout develop
   git pull
   git checkout -b release/v1.2.0
   # Final testing, bump version, update changelog
   git checkout main
   git merge release/v1.2.0
   git tag v1.2.0
   git push origin main --tags
   ```

---

## 📚 Quick Reference

### Comandos Más Usados

```bash
# Verificación de archivos
ls -lh /path/to/file
find /path -name "pattern"
test -f /path && echo "exists"

# Verificación de procesos
ps aux | grep process_name
systemctl status service_name
netstat -tulpn | grep :8000

# Verificación de software
command -v python3 || echo "not installed"
python3 --version

# Database
psql -U user -d db -c "SELECT 1"
psql -U user -d db -c "\dt"

# Testing
pytest tests/ -v --cov
npm test
docker build -t image:tag .

# Git
git status
git diff
git log --oneline -10
git commit -m "feat: description"

# Deployment
./deploy.sh
docker-compose up -d
systemctl restart service
```

---

**Última actualización:** 2025-12-25
**Proyectos analizados:** VOX Client v2.0.21 + otros
**Lecciones documentadas:** 50+ best practices
