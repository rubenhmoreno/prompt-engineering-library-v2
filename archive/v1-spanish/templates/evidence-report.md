# Evidence Report Template
## Documentación de Completitud con Pruebas Verificables

**Propósito:** Documentar la finalización de tareas con evidencia concreta y verificable
**Usar cuando:** Al completar cualquier subtarea, feature o milestone
**Basado en:** Verification Protocol

---

## 📋 Template

```markdown
# Evidence Report: [NOMBRE DE LA TAREA/FEATURE]

**Fecha:** YYYY-MM-DD
**Agente:** [Nombre del agente responsable]
**Versión:** [X.Y.Z]
**Estado:** ✅ Completado / ⏸️ Bloqueado / ❌ Fallido

---

## 1. Resumen Ejecutivo

**Tarea completada:**
[Descripción breve de qué se implementó]

**Criterios de aceptación cumplidos:**
- [x] [Criterio 1]
- [x] [Criterio 2]
- [x] [Criterio 3]

**Tiempo invertido:** [X horas]
**Tiempo estimado original:** [Y horas]
**Variación:** [+/- Z%]

---

## 2. Implementación Realizada

### Archivos Creados

```
/path/to/new/file1.py
/path/to/new/file2.ts
/path/to/new/config.yaml
```

**Evidencia:**
```bash
$ ls -lh path/to/new/
-rw-r--r-- 1 user group 2.4K Dec 25 10:30 file1.py
-rw-r--r-- 1 user group 1.8K Dec 25 10:35 file2.ts
-rw-r--r-- 1 user group 0.5K Dec 25 10:40 config.yaml
```

---

### Archivos Modificados

**Archivo:** `/path/to/existing/file.py`
**Líneas modificadas:** 45-67, 123-145
**Cambios:**
- Agregada función `process_data()`
- Refactorizada lógica de validación
- Actualizado manejo de errores

**Diff:**
```diff
@@ -45,3 +45,12 @@
+def process_data(data: dict) -> ProcessedData:
+    """Process incoming data with validation."""
+    validator = DataValidator()
+    if not validator.validate(data):
+        raise ValidationError("Invalid data format")
+    return ProcessedData(**data)
```

---

### Archivos Eliminados

```
/path/to/deprecated/old_module.py
/path/to/deprecated/legacy_config.json
```

**Razón:** Reemplazados por nueva implementación en file1.py

---

## 3. Evidencia de Funcionalidad

### Backend / API

**Endpoints implementados:**

#### POST /api/users
```bash
$ curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "SecurePass123"}'

# Response:
{
  "id": 1,
  "email": "test@example.com",
  "created_at": "2025-12-25T10:30:00Z"
}

# Status: 201 Created ✅
```

#### GET /api/users
```bash
$ curl http://localhost:8000/api/users

# Response:
[
  {
    "id": 1,
    "email": "test@example.com",
    "created_at": "2025-12-25T10:30:00Z"
  }
]

# Status: 200 OK ✅
```

**Error handling verificado:**
```bash
$ curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "invalid-email", "password": "weak"}'

# Response:
{
  "error": "Invalid email format"
}

# Status: 400 Bad Request ✅
```

---

### Frontend / UI

**Componentes implementados:**

#### UserForm Component
```bash
# Visual verification:
$ npm run dev
Server running at http://localhost:3000

# Screenshot: UserForm rendered correctly
# - Email input field visible ✅
# - Password input field with show/hide toggle ✅
# - Submit button disabled when invalid ✅
# - Error messages display on validation failure ✅
```

**Responsive behavior:**
```
Desktop (1920px):  Layout correct, all elements visible ✅
Tablet (768px):    Single column, touch targets 44px+ ✅
Mobile (375px):    Stacked layout, readable text ✅
```

**Accessibility:**
```bash
$ npm run test:a11y

# axe violations: 0 ✅
# WCAG AA compliance: Pass ✅
# Keyboard navigation: All interactive elements focusable ✅
# Screen reader: Labels announced correctly ✅
```

---

### Database / Migrations

**Migration executed:**
```bash
$ alembic upgrade head

INFO  [alembic.runtime.migration] Running upgrade -> abc123, create users table
INFO  [alembic.runtime.migration] Running upgrade abc123 -> def456, add email index

# Status: SUCCESS ✅
```

**Schema verification:**
```bash
$ psql -U admin -d mydb -c "\d users"

                Table "public.users"
   Column    |            Type             | Nullable
-------------+-----------------------------+----------
 id          | integer                     | not null
 email       | character varying(255)      | not null
 password    | character varying(255)      | not null
 created_at  | timestamp without time zone |
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
    "idx_users_email" UNIQUE, btree (email)

# ✅ Estructura correcta
```

**Data integrity:**
```bash
$ psql -U admin -d mydb -c "INSERT INTO users (email, password) VALUES ('test@example.com', 'hashed_password') RETURNING *;"

 id |       email       |    password     |      created_at
----+-------------------+-----------------+----------------------
  1 | test@example.com  | hashed_password | 2025-12-25 10:30:00

# ✅ Insert successful

$ psql -U admin -d mydb -c "INSERT INTO users (email, password) VALUES ('test@example.com', 'duplicate');"

ERROR:  duplicate key value violates unique constraint "idx_users_email"

# ✅ Unique constraint working
```

---

### Testing

**Unit Tests:**
```bash
$ pytest tests/test_user_service.py -v --cov=services

tests/test_user_service.py::test_create_user_with_valid_data PASSED     [ 25%]
tests/test_user_service.py::test_create_user_with_invalid_email PASSED  [ 50%]
tests/test_user_service.py::test_create_user_duplicate_email PASSED     [ 75%]
tests/test_user_service.py::test_authenticate_user PASSED               [100%]

---------- coverage: platform linux, python 3.11.5 -----------
Name                    Stmts   Miss  Cover
-------------------------------------------
services/user_service.py   45      2    96%
-------------------------------------------
TOTAL                      45      2    96%

# ✅ All tests passing
# ✅ Coverage >80% (96%)
```

**Integration Tests:**
```bash
$ pytest tests/integration/test_user_api.py -v

tests/integration/test_user_api.py::test_register_flow PASSED           [ 33%]
tests/integration/test_user_api.py::test_login_flow PASSED              [ 66%]
tests/integration/test_user_api.py::test_unauthorized_access PASSED     [100%]

# ✅ All integration tests passing
```

**E2E Tests:**
```bash
$ npx playwright test tests/e2e/user-registration.spec.ts

Running 3 tests using 3 workers

  ✓ [chromium] › user-registration.spec.ts:5:1 › user can register (2.3s)
  ✓ [firefox] › user-registration.spec.ts:5:1 › user can register (2.1s)
  ✓ [webkit] › user-registration.spec.ts:5:1 › user can register (2.5s)

  3 passed (7.2s)

# ✅ All E2E tests passing across browsers
```

---

### DevOps / Deployment

**Docker Build:**
```bash
$ docker build -t myapp:v1.0.0 .

[+] Building 45.2s (12/12) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 1.23kB
 => [1/7] FROM docker.io/library/python:3.11-slim
 => [2/7] WORKDIR /app
 => [3/7] COPY requirements.txt .
 => [4/7] RUN pip install --no-cache-dir -r requirements.txt
 => [5/7] COPY . .
 => exporting to image
 => => naming to docker.io/library/myapp:v1.0.0

# ✅ Build successful
```

**Container Running:**
```bash
$ docker run -d -p 8000:8000 --name myapp myapp:v1.0.0
a1b2c3d4e5f6

$ docker ps
CONTAINER ID   IMAGE          STATUS         PORTS                    NAMES
a1b2c3d4e5f6   myapp:v1.0.0   Up 10 seconds  0.0.0.0:8000->8000/tcp   myapp

# ✅ Container running

$ curl http://localhost:8000/health
{"status": "healthy", "version": "1.0.0"}

# ✅ Health check passing
```

**Service Status (systemd):**
```bash
$ sudo systemctl status myapp.service

● myapp.service - My Application Service
     Loaded: loaded (/etc/systemd/system/myapp.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-12-25 10:30:00 UTC; 5min ago
   Main PID: 12345 (python3)
      Tasks: 4 (limit: 4915)
     Memory: 45.2M
        CPU: 1.234s
     CGroup: /system.slice/myapp.service
             └─12345 /usr/bin/python3 /opt/myapp/main.py

Dec 25 10:30:00 server systemd[1]: Started My Application Service.
Dec 25 10:30:01 server python3[12345]: INFO: Application started on port 8000

# ✅ Service active and running
```

---

## 4. Performance Metrics

### Response Times

**Endpoint:** POST /api/users
```bash
$ ab -n 100 -c 10 http://localhost:8000/api/users

Requests per second:    145.23 [#/sec] (mean)
Time per request:       68.86 [ms] (mean)
Time per request:       6.89 [ms] (mean, across all concurrent requests)

Percentage of requests served within a certain time (ms)
  50%     65
  66%     70
  75%     73
  80%     75
  90%     82
  95%     90
  98%    102
  99%    115
 100%    145 (longest request)

# ✅ P95 < 100ms (target met)
```

### Database Query Performance
```bash
$ psql -U admin -d mydb -c "EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';"

Index Scan using idx_users_email on users  (cost=0.15..8.17 rows=1 width=100) (actual time=0.023..0.024 rows=1 loops=1)
  Index Cond: ((email)::text = 'test@example.com'::text)
Planning Time: 0.087 ms
Execution Time: 0.042 ms

# ✅ Query time < 1ms (index working)
```

### Memory Usage
```bash
$ docker stats myapp --no-stream

CONTAINER ID   NAME    CPU %     MEM USAGE / LIMIT     MEM %
a1b2c3d4e5f6   myapp   0.45%     48.2MiB / 512MiB      9.41%

# ✅ Memory usage within limits
```

---

## 5. Security Verification

### Password Hashing
```bash
$ python -c "
from services.user_service import UserService
service = UserService()
user = service.create_user('test@example.com', 'SecurePass123')
print(f'Password hashed: {user.password[:20]}...')
print(f'Hash length: {len(user.password)}')
print(f'Original password in hash: {\"SecurePass123\" in user.password}')
"

Password hashed: $2b$12$N9qo8uLOic...
Hash length: 60
Original password in hash: False

# ✅ Passwords properly hashed (bcrypt)
```

### SQL Injection Prevention
```bash
$ curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com OR 1=1--", "password": "pass"}'

{
  "error": "Invalid email format"
}

# ✅ SQL injection attempt blocked by validation
```

### Authentication
```bash
$ curl http://localhost:8000/api/users/me

{
  "error": "Not authenticated"
}
# Status: 401 Unauthorized ✅

$ curl http://localhost:8000/api/users/me \
  -H "Authorization: Bearer valid_token_here"

{
  "id": 1,
  "email": "test@example.com"
}
# Status: 200 OK ✅
```

---

## 6. Code Quality

### Linting
```bash
$ ruff check .

All checks passed!

# ✅ No linting errors
```

### Type Checking
```bash
$ mypy services/

Success: no issues found in 5 source files

# ✅ No type errors
```

### Code Formatting
```bash
$ black --check .

All done! ✨ 🍰 ✨
5 files would be left unchanged.

# ✅ Code properly formatted
```

---

## 7. Documentation

### API Documentation
```bash
$ curl http://localhost:8000/docs

# Swagger UI accessible at http://localhost:8000/docs ✅
# All endpoints documented ✅
# Request/response schemas present ✅
```

**Screenshot verification:**
```
Swagger UI:
- POST /api/users documented with example request ✅
- GET /api/users documented with response schema ✅
- Error responses documented (400, 401, 500) ✅
```

### Code Documentation
```bash
$ pydoc services.user_service

NAME
    services.user_service - User management service with authentication.

CLASSES
    UserService
     |  Service for user registration and authentication.
     |
     |  Methods:
     |      create_user(email, password) -> User
     |          Create a new user with hashed password.
     |
     |      authenticate(email, password) -> Optional[User]
     |          Authenticate user with credentials.

# ✅ All public methods documented
```

### README Updated
```bash
$ cat README.md | grep -A 5 "## User Management"

## User Management

New user registration and authentication features added.

### Endpoints
- POST /api/users - Register new user
- GET /api/users - List users
- POST /api/auth/login - Authenticate user

# ✅ README updated with new features
```

---

## 8. Dependencias y Prerequisitos

### Dependencies Added
```bash
$ cat requirements.txt | tail -5

bcrypt==4.1.2
pydantic==2.5.3
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
email-validator==2.1.0

# ✅ All dependencies documented
```

### Dependency Vulnerabilities
```bash
$ pip-audit

No known vulnerabilities found

# ✅ No security vulnerabilities in dependencies
```

---

## 9. Rollback Plan

**En caso de fallo, ejecutar:**

```bash
# 1. Revertir migration
alembic downgrade -1

# 2. Restaurar código anterior
git revert abc123def

# 3. Reiniciar servicio
sudo systemctl restart myapp.service

# 4. Verificar estado
curl http://localhost:8000/health
```

**Backup realizado:**
```bash
$ pg_dump -U admin mydb > backup_before_users_feature.sql

backup_before_users_feature.sql created (2.3 MB) ✅
```

---

## 10. Checklist de Completitud

### Implementación
- [x] Código implementado y commiteado
- [x] Tests escritos y pasando (coverage >80%)
- [x] Documentación actualizada (README, docstrings)
- [x] Code review aprobado (si aplica)
- [x] Linting y formatting aplicados

### Testing
- [x] Unit tests pasan (96% coverage)
- [x] Integration tests pasan
- [x] E2E tests pasan
- [x] Manual testing completado
- [x] Performance testing OK

### Seguridad
- [x] Input validation implementada
- [x] Passwords hasheados
- [x] SQL injection prevention verificada
- [x] Authentication/authorization funcional
- [x] Dependency vulnerabilities checked

### DevOps
- [x] Docker build exitoso
- [x] Container running correctamente
- [x] Health checks passing
- [x] Logs configurados
- [x] Monitoring en lugar

### Documentación
- [x] API docs actualizadas (Swagger)
- [x] Code comments/docstrings
- [x] README actualizado
- [x] Changelog entry agregado
- [x] Rollback plan documentado

### Performance
- [x] Response times < 100ms (P95)
- [x] Database queries optimized (indexes)
- [x] Memory usage within limits
- [x] No memory leaks detectados

---

## 11. Problemas Encontrados y Resoluciones

### Problema 1: Migration Conflict
**Descripción:** Migration abc123 conflicted with existing def456
**Impacto:** Medium - bloqueó deployment inicial
**Resolución:** Merged migrations into single migration file
**Tiempo perdido:** 30 minutos
**Lección aprendida:** Always pull latest migrations before creating new ones

### Problema 2: Test Flakiness
**Descripción:** E2E test intermittently failing due to timing
**Impacto:** Low - solo afectó CI pipeline
**Resolución:** Added explicit wait for element visibility
**Código:**
```typescript
// Antes:
await page.click('.submit-button');

// Después:
await page.waitForSelector('.submit-button', { state: 'visible' });
await page.click('.submit-button');
```
**Tiempo perdido:** 15 minutos

---

## 12. Métricas Finales

| Métrica | Objetivo | Resultado | Status |
|---------|----------|-----------|--------|
| Test Coverage | >80% | 96% | ✅ |
| P95 Response Time | <100ms | 90ms | ✅ |
| Build Time | <5min | 3.2min | ✅ |
| Docker Image Size | <500MB | 320MB | ✅ |
| Memory Usage | <512MB | 48MB | ✅ |
| Zero Vulnerabilities | 0 | 0 | ✅ |

---

## 13. Próximos Pasos

1. [ ] Monitorear performance en staging por 24h
2. [ ] Preparar deployment a producción
3. [ ] Crear documentación de usuario
4. [ ] Agregar más tests edge cases
5. [ ] Considerar rate limiting para endpoints públicos

---

## 14. Aprobación

**Completado por:** [Nombre del agente]
**Fecha:** 2025-12-25
**Revisado por:** [Nombre del reviewer] (si aplica)
**Aprobado para deployment:** ✅ Sí / ❌ No

**Firma digital:**
```
SHA256 de este report: abc123def456...
Git commit: abc123def
```

---
```

---

## 📝 Guía de Uso

### Cuándo usar este template:

✅ **Usar al completar:**
- Features nuevos
- Bug fixes complejos
- Refactorings mayores
- Migrations de base de datos
- Deployments
- Cambios de arquitectura

❌ **No necesario para:**
- Typos en documentación
- Cambios cosméticos mínimos
- Updates de dependencias rutinarias

---

### Secciones obligatorias vs opcionales:

**Obligatorias:**
1. ✅ Resumen Ejecutivo
2. ✅ Implementación Realizada
3. ✅ Evidencia de Funcionalidad
4. ✅ Testing
10. ✅ Checklist de Completitud
12. ✅ Métricas Finales

**Opcionales (según contexto):**
4. Performance Metrics (si hay requisitos de performance)
5. Security Verification (si hay cambios de autenticación/autorización)
7. Dependencias (si agregaste/actualizaste dependencias)
9. Rollback Plan (para cambios críticos)
11. Problemas Encontrados (si hubo blockers)

---

### Niveles de detalle según tipo de tarea:

**Feature Complejo (ejemplo: User Authentication):**
- Todas las secciones
- Screenshots de UI
- Multiple test scenarios
- Performance benchmarks
- Security audit completo

**Bug Fix Medio:**
- Resumen ejecutivo
- Evidencia de fix (antes/después)
- Tests de regresión
- Checklist básico

**Refactoring:**
- Diff de cambios
- Tests unchanged (still passing)
- Performance comparison (antes/después)
- No breaking changes verification

---

## 🎯 Ejemplo Condensado: Bug Fix

```markdown
# Evidence Report: Fix Login Timeout Bug

**Fecha:** 2025-12-25
**Agente:** Backend Developer
**Estado:** ✅ Completado

---

## 1. Resumen Ejecutivo

**Bug:** Login timeout después de 30s de inactividad
**Root cause:** Session expiration hardcoded a 30s
**Fix:** Cambiado a 30 minutos (configurable)

---

## 2. Implementación

**Archivo modificado:** `config/settings.py`

```diff
- SESSION_TIMEOUT = 30  # seconds
+ SESSION_TIMEOUT = int(os.getenv("SESSION_TIMEOUT", "1800"))  # 30 minutes default
```

---

## 3. Evidencia

**Antes:**
```bash
$ curl -X POST http://localhost:8000/api/auth/login ...
# Wait 31 seconds
$ curl http://localhost:8000/api/users/me -H "Authorization: Bearer $TOKEN"
{"error": "Session expired"}  # ❌
```

**Después:**
```bash
$ curl -X POST http://localhost:8000/api/auth/login ...
# Wait 31 seconds
$ curl http://localhost:8000/api/users/me -H "Authorization: Bearer $TOKEN"
{"id": 1, "email": "test@example.com"}  # ✅
```

---

## 4. Testing

```bash
$ pytest tests/test_session.py -v

tests/test_session.py::test_session_valid_after_30_seconds PASSED
tests/test_session.py::test_session_expires_after_30_minutes PASSED

# ✅ Both tests passing
```

---

## 5. Checklist

- [x] Bug fix implementado
- [x] Tests agregados
- [x] Configurable vía env var
- [x] No breaking changes
- [x] Documentado en CHANGELOG

---

**Aprobado para deployment:** ✅ Sí
```

---

## 🔄 Integración con Verification Protocol

Este template implementa los 7 tipos de evidencia del Verification Protocol:

1. **Terminal Output** → Sección 3 (curl commands, test runs)
2. **Test Results** → Sección 4 (pytest, E2E)
3. **File Contents** → Sección 2 (diffs, file listings)
4. **Build Success** → Sección 7 (Docker, linting)
5. **Service Status** → Sección 3 (systemctl, docker ps)
6. **Database State** → Sección 3 (SQL queries, schema)
7. **Performance Metrics** → Sección 4 (benchmarks, timing)

---

**Última actualización:** 2025-12-25
**Proyectos usando template:** TBD
**Reducción de bugs en producción:** TBD (meta: -50%)
