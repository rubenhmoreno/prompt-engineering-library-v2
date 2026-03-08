# Agent Handoff Template
## Comunicación Estructurada entre Agentes Especializados

**Propósito:** Transferir contexto, outputs y próximos pasos entre agentes de forma clara y sin pérdida de información
**Usar cuando:** Un agente completa su trabajo y otro debe continuar
**Basado en:** Multi-Agent Orchestration Workflow

---

## 📋 Template

```markdown
# Agent Handoff: [AGENTE ORIGEN] → [AGENTE DESTINO]

**Fecha:** YYYY-MM-DD HH:MM
**Tarea:** [Nombre de la tarea/feature]
**Handoff ID:** [UUID o identificador único]
**Urgencia:** 🔴 Alta / 🟡 Media / 🟢 Baja

---

## 1. Contexto General

### Objetivo del Proyecto
[Descripción breve del feature/proyecto completo]

### Estado Actual
**Progreso:** [X%] completado
**Fase actual:** [Fundación / Core Features / Testing / Deployment]
**Grupo de paralelismo:** [GRUPO N]

### Agente Origen
**Rol:** [Backend Developer / Frontend Developer / etc.]
**Tareas completadas:**
- [x] [Tarea 1]
- [x] [Tarea 2]
- [x] [Tarea 3]

### Agente Destino
**Rol:** [Testing Engineer / DevOps / etc.]
**Tareas asignadas:**
- [ ] [Tarea siguiente 1]
- [ ] [Tarea siguiente 2]

---

## 2. Trabajo Completado

### Resumen de Implementación

**Funcionalidades implementadas:**
1. [Feature 1]: [Descripción breve]
2. [Feature 2]: [Descripción breve]
3. [Feature 3]: [Descripción breve]

**Archivos creados:**
```
/path/to/file1.py (Backend API)
/path/to/file2.ts (Frontend component)
/path/to/config.yaml (Configuration)
```

**Archivos modificados:**
```
/path/to/existing/file.py (lines 45-67, 123-145)
/path/to/another/file.ts (refactored validation logic)
```

---

### Evidencia de Completitud

**Tests passing:**
```bash
$ pytest tests/ -v --cov

================================ 15 passed in 2.34s ================================
Coverage: 94%

✅ All tests passing
✅ Coverage >80%
```

**Service running:**
```bash
$ curl http://localhost:8000/health

{
  "status": "healthy",
  "version": "1.0.0",
  "features": ["user_management", "authentication"]
}

✅ Service operational
```

**Deployment:**
```bash
$ docker ps

CONTAINER ID   IMAGE          STATUS         PORTS
a1b2c3d4e5f6   backend:v1.0   Up 5 minutes   0.0.0.0:8000->8000/tcp

✅ Container running
```

---

## 3. Outputs y Artefactos

### Artefacto 1: API Endpoint

**Endpoint:** POST /api/users
**Ubicación:** `/home/api_prod/backend/routes/users.py`
**Documentación:** http://localhost:8000/docs#/users/create_user

**Contrato (para consumo de Frontend):**
```typescript
interface CreateUserRequest {
  email: string;      // required, valid email format
  password: string;   // required, min 8 chars
  name?: string;      // optional
}

interface CreateUserResponse {
  id: number;
  email: string;
  name?: string;
  created_at: string; // ISO 8601
}

// Success: 201 Created
// Errors: 400 (validation), 409 (duplicate email), 500 (server error)
```

**Ejemplo de uso:**
```bash
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "SecurePass123"}'

# Response (201):
{
  "id": 1,
  "email": "test@example.com",
  "created_at": "2025-12-25T10:30:00Z"
}
```

---

### Artefacto 2: Database Schema

**Tabla:** `users`
**Migration:** `/home/api_prod/backend/migrations/abc123_create_users.py`

**Schema:**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
```

**Connection string:**
```
postgresql://admin:password@localhost:5432/mydb
```

**Test data:**
```sql
-- Sample user for testing
INSERT INTO users (email, password, name) VALUES
('test@example.com', '$2b$12$hashed_password', 'Test User');
```

---

### Artefacto 3: Configuration

**Archivo:** `/home/api_prod/backend/config/settings.py`

**Variables de entorno requeridas:**
```bash
# .env file
DATABASE_URL=postgresql://admin:password@localhost:5432/mydb
SECRET_KEY=your-secret-key-here
SESSION_TIMEOUT=1800  # 30 minutes
CORS_ORIGINS=http://localhost:3000,https://frontend.example.com
```

**Valores por defecto:**
```python
SESSION_TIMEOUT = int(os.getenv("SESSION_TIMEOUT", "1800"))
MAX_LOGIN_ATTEMPTS = int(os.getenv("MAX_LOGIN_ATTEMPTS", "5"))
PASSWORD_MIN_LENGTH = 8
```

---

### Artefacto 4: Docker Image

**Image name:** `myapp-backend:v1.0.0`
**Registry:** `localhost:5000/myapp-backend:v1.0.0` (si aplica)

**Build command:**
```bash
docker build -t myapp-backend:v1.0.0 -f backend/Dockerfile .
```

**Run command:**
```bash
docker run -d \
  -p 8000:8000 \
  -e DATABASE_URL=postgresql://... \
  -e SECRET_KEY=... \
  --name backend \
  myapp-backend:v1.0.0
```

**Health check:**
```bash
curl http://localhost:8000/health
# Expected: {"status": "healthy"}
```

---

## 4. Interfaces y Contratos

### API Contract (para Frontend Developer)

**Base URL:** `http://localhost:8000/api`

**Endpoints disponibles:**

#### Authentication
```yaml
POST /auth/login
  Request:
    email: string (required)
    password: string (required)
  Response:
    token: string (JWT)
    user: UserResponse
  Errors:
    400: Invalid credentials
    429: Too many attempts
```

#### Users
```yaml
GET /users
  Headers:
    Authorization: Bearer {token}
  Response:
    users: UserResponse[]
  Errors:
    401: Unauthorized

POST /users
  Request:
    email: string
    password: string
    name?: string
  Response:
    user: UserResponse (201 Created)
  Errors:
    400: Validation error
    409: Email already exists

GET /users/{id}
  Headers:
    Authorization: Bearer {token}
  Response:
    user: UserResponse
  Errors:
    401: Unauthorized
    404: User not found
```

**TypeScript types:**
```typescript
// Location: /home/api_prod/frontend/src/types/api.ts
interface UserResponse {
  id: number;
  email: string;
  name?: string;
  created_at: string;
}

interface LoginRequest {
  email: string;
  password: string;
}

interface LoginResponse {
  token: string;
  user: UserResponse;
}
```

---

### Data Contract (para Data Analyst / Testing)

**Database exports:**
```bash
# Exportar datos de prueba
psql -U admin mydb -c "COPY (SELECT * FROM users) TO STDOUT WITH CSV HEADER" > users_export.csv

# Importar para testing
psql -U admin testdb -c "COPY users FROM STDIN WITH CSV HEADER" < users_export.csv
```

**Sample data format:**
```csv
id,email,name,created_at,updated_at
1,test@example.com,Test User,2025-12-25 10:30:00,2025-12-25 10:30:00
2,admin@example.com,Admin User,2025-12-25 10:35:00,2025-12-25 10:35:00
```

---

### Component Contract (para UI/UX Specialist)

**Component props:**
```typescript
// Location: /home/api_prod/frontend/src/components/UserForm.tsx
interface UserFormProps {
  onSubmit: (data: CreateUserRequest) => Promise<void>;
  loading?: boolean;
  error?: string;
  initialData?: Partial<CreateUserRequest>;
}

// Usage example:
<UserForm
  onSubmit={handleCreateUser}
  loading={isSubmitting}
  error={formError}
/>
```

**Expected behavior:**
- Form validates on blur
- Submit button disabled while loading
- Error messages display below inputs
- Success callback triggers on 201 response

---

## 5. Dependencias y Prerequisites

### Software requerido

**Agente destino debe tener instalado:**
```bash
# Check versions
node --version       # v20.10.0+
npm --version        # v10.2.0+
docker --version     # v24.0.0+
postgres --version   # v16+
```

### Servicios que deben estar running

**Antes de comenzar, verificar:**
```bash
# 1. Database
psql -U admin -d mydb -c "SELECT 1"
# ✅ Expected: (1 row)

# 2. Backend API
curl http://localhost:8000/health
# ✅ Expected: {"status": "healthy"}

# 3. Docker daemon
docker ps
# ✅ Expected: list of containers (or empty)
```

### Dependencias de código

**Backend dependencies instaladas:**
```bash
cd /home/api_prod/backend
pip install -r requirements.txt
# ✅ All dependencies installed
```

**Frontend dependencies (si aplica):**
```bash
cd /home/api_prod/frontend
npm install
# ✅ All dependencies installed
```

---

## 6. Configuración del Entorno

### Variables de entorno

**Copiar archivo de ejemplo:**
```bash
cp .env.example .env
```

**Editar valores:**
```bash
# .env
DATABASE_URL=postgresql://admin:password@localhost:5432/mydb
SECRET_KEY=generated-secret-key-here  # Cambiar en producción
CORS_ORIGINS=http://localhost:3000
SESSION_TIMEOUT=1800
```

### Base de datos

**Ejecutar migrations:**
```bash
cd /home/api_prod/backend
alembic upgrade head

# Expected output:
# INFO  [alembic.runtime.migration] Running upgrade -> abc123, create users table
# ✅ Migration successful
```

**Seed data (opcional):**
```bash
python scripts/seed_db.py

# Creates:
# - 1 admin user
# - 5 test users
# ✅ Seed data inserted
```

---

## 7. Próximos Pasos (para Agente Destino)

### Tareas Inmediatas

**Priority 1 (Blocker):**
1. [ ] Ejecutar integration tests contra API
   - Ubicación: `/home/api_prod/backend/tests/integration/`
   - Comando: `pytest tests/integration/ -v`
   - Expected: All tests pass
   - Time estimate: 30 min

2. [ ] Escribir E2E test para flujo completo de registro
   - User visit page → fill form → submit → verify creation
   - Framework: Playwright
   - Location: `/home/api_prod/e2e/tests/user-registration.spec.ts`
   - Time estimate: 1 hour

**Priority 2 (Important):**
3. [ ] Configurar CI/CD pipeline
   - Agregar tests al workflow de GitHub Actions
   - Verificar build de Docker image
   - Deploy a staging
   - Time estimate: 1.5 hours

4. [ ] Performance testing
   - Load test con 100 concurrent users
   - Verificar response times <100ms (P95)
   - Identificar bottlenecks
   - Time estimate: 1 hour

**Priority 3 (Nice to have):**
5. [ ] Security audit
   - OWASP Top 10 verification
   - Dependency vulnerability scan
   - SQL injection prevention test
   - Time estimate: 45 min

---

### Criterios de Aceptación

**Esta fase está completa cuando:**
- [ ] All integration tests passing (>80% coverage)
- [ ] E2E test passing across 3 browsers (Chrome, Firefox, Safari)
- [ ] CI/CD pipeline green
- [ ] Performance metrics met (P95 <100ms)
- [ ] Zero critical security vulnerabilities
- [ ] Documentation updated (README, API docs)
- [ ] Deployed to staging and verified

---

### Recursos de Apoyo

**Documentación:**
- API Docs: http://localhost:8000/docs
- README: `/home/api_prod/README.md`
- Architecture: `/home/api_prod/docs/architecture.md`

**Contactos (si necesario):**
- Backend Developer: [contact info]
- DevOps Engineer: [contact info]
- Product Owner: [contact info]

**Slack channels:**
- #backend-team (questions about API)
- #devops (deployment issues)
- #qa (testing discussions)

---

## 8. Problemas Conocidos y Workarounds

### Problema 1: Database Connection Timeout

**Síntoma:** Connection timeout después de 10 minutos de inactividad

**Causa:** PostgreSQL cierra conexiones idle

**Workaround:**
```python
# Agregar a config:
SQLALCHEMY_POOL_RECYCLE = 300  # Recycle connections every 5 min
```

**Issue tracking:** #123 (GitHub)

---

### Problema 2: CORS Error en Desarrollo

**Síntoma:** Frontend recibe CORS error al llamar API

**Causa:** Frontend en http://localhost:3000 no está en CORS_ORIGINS

**Workaround:**
```bash
# Agregar a .env:
CORS_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

**Nota:** Solo para desarrollo. Producción usa dominio real.

---

### Problema 3: Docker Build Lento

**Síntoma:** Docker build toma >5 minutos

**Causa:** No usa cache de layers

**Workaround:**
```dockerfile
# Usar multi-stage build:
FROM python:3.11-slim AS builder
# ... build steps ...

FROM python:3.11-slim
COPY --from=builder /app /app
```

**Mejora:** Reduce build time a ~2 minutos

---

## 9. Estado de Tests

### Tests Existentes (heredados)

**Unit tests:**
```bash
$ pytest tests/unit/ -v

tests/unit/test_user_service.py::test_create_user PASSED
tests/unit/test_user_service.py::test_authenticate PASSED
tests/unit/test_validators.py::test_email_validation PASSED

15 passed in 1.23s
Coverage: 94%

✅ All unit tests passing
```

**Integration tests:**
```bash
$ pytest tests/integration/ -v

tests/integration/test_user_api.py::test_create_user_endpoint PASSED
tests/integration/test_user_api.py::test_login_endpoint PASSED

5 passed in 2.45s

✅ All integration tests passing
```

---

### Tests Pendientes (para Agente Destino)

**E2E tests:**
- [ ] User registration flow
- [ ] Login flow
- [ ] Password reset flow
- [ ] Session timeout behavior

**Performance tests:**
- [ ] Load test (100 concurrent users)
- [ ] Stress test (find breaking point)
- [ ] Spike test (sudden traffic increase)

**Security tests:**
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Rate limiting

---

## 10. Archivos de Referencia

### Documentos clave

**Backend:**
```
/home/api_prod/backend/
├── README.md (setup instructions)
├── requirements.txt (dependencies)
├── .env.example (environment variables)
├── alembic.ini (database migrations config)
└── docs/
    ├── api.md (API documentation)
    └── deployment.md (deployment guide)
```

**Tests:**
```
/home/api_prod/backend/tests/
├── conftest.py (pytest fixtures)
├── unit/ (unit tests)
├── integration/ (integration tests)
└── fixtures/ (test data)
```

**Deployment:**
```
/home/api_prod/
├── docker-compose.yml (local development)
├── Dockerfile (production build)
└── .github/
    └── workflows/
        └── ci.yml (CI/CD pipeline)
```

---

### Commits relevantes

**Último commit del Agente Origen:**
```bash
commit abc123def456789
Author: Backend Developer <backend@example.com>
Date:   Thu Dec 25 10:30:00 2025 +0000

    feat: Implement user management API

    - Add POST /api/users endpoint
    - Add GET /api/users endpoint
    - Implement password hashing with bcrypt
    - Add email validation
    - Create users table migration
    - Add unit and integration tests (94% coverage)

    Closes #42
```

**Branch:**
```bash
feature/user-management
```

**Merge status:** ⏸️ Pending review and testing

---

## 11. Definición de "Done" para Handoff

### Checklist del Agente Origen (debe estar ✅)

- [x] Código implementado y testeado
- [x] Tests unitarios pasan (>80% coverage)
- [x] Integration tests pasan
- [x] Documentación actualizada
- [x] API contracts definidos
- [x] Configuration documentada
- [x] Evidence report creado
- [x] Handoff document creado (este documento)
- [x] Code pushed a branch

### Checklist del Agente Destino (antes de aceptar handoff)

- [ ] Leí y entendí el contexto completo
- [ ] Verifiqué que todos los prerequisites están cumplidos
- [ ] Probé los endpoints manualmente (smoke test)
- [ ] Ejecuté los tests existentes y todos pasan
- [ ] Tengo acceso a todos los recursos necesarios
- [ ] Entiendo los próximos pasos y criterios de aceptación
- [ ] Sé a quién contactar si tengo bloqueadores

---

## 12. Firma del Handoff

### Agente Origen

**Nombre:** Backend Developer Agent
**Completado:** 2025-12-25 10:30:00 UTC
**Commit hash:** abc123def456789
**Evidence report:** `/home/api_prod/evidence-reports/user-management-backend.md`

**Declaración:**
```
Declaro que:
✅ Toda la funcionalidad implementada está testeada
✅ Todos los tests pasan localmente
✅ La documentación está actualizada
✅ Los contracts están claramente definidos
✅ No hay bugs conocidos críticos
✅ El código está listo para la siguiente fase
```

---

### Agente Destino

**Nombre:** Testing Engineer Agent
**Recibido:** 2025-12-25 11:00:00 UTC
**Status:** ✅ Aceptado / ⏸️ Pendiente / ❌ Rechazado

**Comentarios:**
```
[Agente destino completa después de revisar]

Verificaciones realizadas:
[ ] Tests ejecutados localmente
[ ] Endpoints testeados manualmente
[ ] Prerequisites verificados
[ ] Documentación revisada

Bloqueadores (si hay):
[ ] [Descripción del blocker 1]
[ ] [Descripción del blocker 2]

Próximos pasos confirmados: Sí / No
Tiempo estimado para completar fase: [X horas]
```

---
```

---

## 📝 Guía de Uso

### Flujos Comunes de Handoff

#### 1. Backend → Frontend

**Agente Origen:** Backend Developer
**Agente Destino:** Frontend Developer

**Artefactos clave:**
- API contracts (endpoints, request/response schemas)
- Base URL y credentials
- Swagger/OpenAPI docs
- Sample requests con curl
- CORS configuration

**Próximos pasos típicos:**
- Implementar llamadas a API desde frontend
- Crear componentes que consuman endpoints
- Manejo de estados de carga y errores
- Validación de formularios según contratos

---

#### 2. Frontend → Testing

**Agente Origen:** Frontend Developer
**Agente Destino:** Testing Engineer

**Artefactos clave:**
- Componentes implementados
- User flows completos
- Build artifacts (dist/)
- Development server URL
- Component props contracts

**Próximos pasos típicos:**
- Escribir component tests (Jest/React Testing Library)
- E2E tests (Playwright/Cypress)
- Visual regression tests
- Accessibility tests (axe)
- Cross-browser testing

---

#### 3. Backend → DevOps

**Agente Origen:** Backend Developer
**Agente Destino:** DevOps Engineer

**Artefactos clave:**
- Docker image
- Environment variables
- Database migrations
- Health check endpoints
- Resource requirements (CPU, memory)

**Próximos pasos típicos:**
- Configurar CI/CD pipeline
- Deploy a staging
- Setup monitoring y logging
- Configure load balancer
- SSL certificates

---

#### 4. Data Analyst → Data Detective

**Agente Origen:** Data Analyst
**Agente Destino:** Data Detective

**Artefactos clave:**
- Dataset cleaned y normalizado
- Initial visualizations
- Anomalies observadas
- Hypotheses preliminares
- Data dictionary

**Próximos pasos típicos:**
- Deep correlation analysis
- Multi-level statistical testing
- Anomaly detection algorithms
- Hypothesis validation
- Root cause analysis

---

#### 5. Testing → DevOps (para deployment)

**Agente Origen:** Testing Engineer
**Agente Destino:** DevOps Engineer

**Artefactos clave:**
- Test reports (passing ✅)
- Coverage reports (>80%)
- Performance benchmarks
- Security scan results
- Approved merge request

**Próximos pasos típicos:**
- Deploy a staging
- Smoke tests en staging
- Deploy a producción (blue/green)
- Monitor post-deployment
- Rollback plan ready

---

### Niveles de Detalle según Complejidad

**Handoff Simple (Bug fix):**
- Contexto breve (1-2 párrafos)
- Archivos modificados
- Tests de regresión
- Próximo paso (verificar en staging)

**Handoff Medio (Feature pequeño):**
- Contexto completo
- API contracts
- Tests coverage
- Configuration changes
- Próximos 2-3 pasos

**Handoff Complejo (Feature grande):**
- Todas las secciones del template
- Multiple artifacts
- Detailed contracts
- Known issues y workarounds
- Step-by-step next actions
- Rollback plan

---

### Checklist Pre-Handoff

Antes de crear handoff document:

- [ ] **Evidence report creado** (con pruebas de funcionalidad)
- [ ] **Todos los tests pasan** (unit, integration)
- [ ] **Code pushed** a branch con nombre descriptivo
- [ ] **Documentación actualizada** (README, API docs)
- [ ] **Contracts definidos** (API, data, components)
- [ ] **Configuration documentada** (env vars, dependencies)
- [ ] **Known issues documentados** (si hay)
- [ ] **Próximos pasos claros** (para agente destino)

---

## 🎯 Ejemplo Condensado: Backend → Frontend Handoff

```markdown
# Agent Handoff: Backend Developer → Frontend Developer

**Tarea:** User Authentication Feature
**Handoff ID:** UAF-2025-12-25-001
**Urgencia:** 🟡 Media

---

## Trabajo Completado

✅ POST /api/auth/login (autenticación)
✅ GET /api/auth/me (obtener usuario actual)
✅ JWT token generation
✅ Session management (30 min timeout)

---

## API Contract

```typescript
// POST /api/auth/login
interface LoginRequest {
  email: string;
  password: string;
}

interface LoginResponse {
  token: string;  // JWT, expires in 30 min
  user: {
    id: number;
    email: string;
    name?: string;
  }
}

// GET /api/auth/me
// Headers: Authorization: Bearer {token}
interface MeResponse {
  id: number;
  email: string;
  name?: string;
}
```

---

## Ejemplos de Uso

```bash
# Login
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "SecurePass123"}'

# Response (200):
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {"id": 1, "email": "test@example.com"}
}

# Get current user
curl http://localhost:8000/api/auth/me \
  -H "Authorization: Bearer eyJhbGci..."

# Response (200):
{"id": 1, "email": "test@example.com"}
```

---

## Próximos Pasos (Frontend)

1. [ ] Crear LoginForm component
   - Email + password inputs
   - Submit button
   - Error handling
   - Time: 1 hour

2. [ ] Implementar auth context
   - Store JWT in localStorage
   - Auto-refresh on app load
   - Logout functionality
   - Time: 45 min

3. [ ] Protected routes
   - Redirect to login if no token
   - Time: 30 min

---

## Prerequisites

```bash
# Backend must be running
curl http://localhost:8000/health
# ✅ {"status": "healthy"}
```

---

**Completado por:** Backend Developer
**Fecha:** 2025-12-25 10:30
**Evidence report:** `/evidence-reports/user-auth-backend.md`
```

---

**Última actualización:** 2025-12-25
**Handoffs exitosos:** TBD
**Reducción de miscommunication:** TBD (meta: -70%)
