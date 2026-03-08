# Multi-Agent Orchestration Prompt
## Ejecución Paralela y Coordinación de Agentes Especializados

**Tipo:** Core Workflow Prompt
**Prioridad:** ALTA
**Basado en:** Anthropic Best Practices + Advanced DevOps Techniques

---

## 🎯 Objetivo

Maximizar eficiencia dividiendo tareas complejas en subtareas especializadas ejecutadas por agentes dedicados en paralelo.

---

## 📋 Principios Fundamentales

### 1. **Un Agente = Una Responsabilidad**
Cada agente debe tener:
- ✅ Propósito único y bien definido
- ✅ Herramientas específicas para su tarea
- ✅ Contexto aislado (no contaminar conversación principal)
- ✅ Criterios claros de éxito/fallo

### 2. **Paralelización Máxima**
- ✅ Identificar tareas independientes
- ✅ Ejecutar agentes simultáneamente cuando sea posible
- ✅ Solo secuencializar cuando haya dependencias
- ❌ Nunca ejecutar secuencialmente si puede ser paralelo

### 3. **Handoffs Documentados**
- ✅ Pasar contexto explícito entre agentes
- ✅ Documentar qué hizo cada agente
- ✅ Verificar output antes del siguiente agente
- ❌ Nunca asumir que agente siguiente "sabrá" qué hacer

---

## 🤖 Agentes Disponibles

### Backend Developer
**Propósito:** Lógica de servidor, APIs, bases de datos
**Herramientas:** Read, Write, Edit, Bash (server commands), Grep
**Output:** Código backend funcional + tests unitarios
**Verificación:** Tests pasan + API responde correctamente

### Frontend Developer
**Propósito:** UI, UX, componentes visuales
**Herramientas:** Read, Write, Edit, WebFetch (docs), Bash (npm/build)
**Output:** Componentes UI + estilos + tests frontend
**Verificación:** Build exitoso + UI renderiza + tests pasan

### Testing Engineer
**Propósito:** QA, tests E2E, integración, seguridad
**Herramientas:** Bash (test runners), Read (test files), Write (nuevos tests)
**Output:** Suite de tests completa + reporte de cobertura
**Verificación:** Todos los tests pasan + cobertura >80%

### DevOps Engineer
**Propósito:** Deployment, CI/CD, infraestructura, monitoreo
**Herramientas:** Bash (docker, systemctl, etc.), Read (configs), Write (scripts)
**Output:** Scripts de deployment + configuración + documentación
**Verificación:** Deploy exitoso + servicios running + healthchecks pasan

### Data Analyst
**Propósito:** Análisis de datos, visualizaciones, reportes
**Herramientas:** Read (data files), Bash (Python/R), Write (notebooks/reports)
**Output:** Análisis completo + visualizaciones + insights
**Verificación:** Resultados reproducibles + gráficos generados

### UI/UX Specialist
**Propósito:** Diseño, accesibilidad, experiencia de usuario
**Herramientas:** Read (designs), Write (specs), WebFetch (design systems)
**Output:** Especificaciones de diseño + guidelines + mockups
**Verificación:** Cumple WCAG + responsive + consistente

---

## 🔄 Workflow Multi-Agente

### Template de Orquestación:

```markdown
# [NOMBRE DEL PROYECTO/FEATURE]

## Objetivo General:
[Descripción clara del objetivo final]

## Descomposición de Tareas:

### Agente 1: [TIPO] - [NOMBRE_TAREA]
**Responsabilidad:** [Qué debe hacer]
**Input:** [Qué información necesita]
**Output esperado:** [Qué debe producir]
**Criterios de éxito:** [Cómo verificar que funcionó]
**Dependencias:** [Ninguna | Requiere output de Agente X]

### Agente 2: [TIPO] - [NOMBRE_TAREA]
**Responsabilidad:** [Qué debe hacer]
**Input:** [Qué información necesita]
**Output esperado:** [Qué debe producir]
**Criterios de éxito:** [Cómo verificar que funcionó]
**Dependencias:** [Ninguna | Requiere output de Agente X]

### Agente 3: [TIPO] - [NOMBRE_TAREA]
**Responsabilidad:** [Qué debe hacer]
**Input:** [Qué información necesita]
**Output esperado:** [Qué debe producir]
**Criterios de éxito:** [Cómo verificar que funcionó]
**Dependencias:** [Ninguna | Requiere output de Agente X]

## Orden de Ejecución:

**Paralelo (Fase 1):**
- Agente 1 + Agente 2 (sin dependencias entre sí)

**Secuencial (Fase 2):**
- Agente 3 (requiere output de Agente 1 y 2)

## Verificación Final:
[Cómo verificar que todo funcionó integrado]
```

---

## 📝 Ejemplo Práctico: Sistema de Autenticación JWT

```markdown
# Implementación de Autenticación JWT

## Objetivo General:
Sistema completo de autenticación con JWT, incluyendo backend, frontend y tests

## Descomposición de Tareas:

### Agente 1: Backend Developer - API de Autenticación
**Responsabilidad:**
- Crear endpoints /api/auth/register, /api/auth/login, /api/auth/verify
- Implementar hashing de passwords con bcrypt
- Generar y validar JWT tokens
- Middleware de autenticación

**Input:**
- Especificación de API (endpoints, payloads, responses)
- Esquema de base de datos (tabla users)

**Output esperado:**
```python
# /api/auth/register
POST /api/auth/register
Body: { "email": "user@example.com", "password": "pass123" }
Response: { "token": "jwt_token", "user": {...} }

# /api/auth/login
POST /api/auth/login
Body: { "email": "user@example.com", "password": "pass123" }
Response: { "token": "jwt_token", "user": {...} }

# /api/auth/verify
GET /api/auth/verify
Header: Authorization: Bearer jwt_token
Response: { "valid": true, "user": {...} }

# Middleware
@require_auth decorator para proteger rutas

# Tests unitarios
test_register_new_user()
test_login_valid_credentials()
test_login_invalid_credentials()
test_verify_valid_token()
test_verify_invalid_token()
```

**Criterios de éxito:**
- ✅ Todos los endpoints responden correctamente
- ✅ Tests unitarios pasan (pytest -v)
- ✅ Passwords hasheados correctamente
- ✅ JWT tokens válidos por 24h

**Dependencias:** Ninguna (puede ejecutar en paralelo)

---

### Agente 2: Frontend Developer - UI de Autenticación
**Responsabilidad:**
- Formularios de Login y Register en React
- Manejo de JWT tokens en localStorage
- Protected routes (redirect si no autenticado)
- Indicadores de loading y errores

**Input:**
- Especificación de API (ya definida por Backend)
- Design mockups (opcional)

**Output esperado:**
```jsx
// Componentes:
<LoginForm />        // Formulario con email/password
<RegisterForm />     // Formulario con email/password/confirm
<ProtectedRoute />   // HOC para rutas protegidas
<AuthContext />      // Context para estado global de auth

// Funciones:
login(email, password)     → POST /api/auth/login → guarda token
register(email, password)  → POST /api/auth/register → guarda token
logout()                   → Limpia localStorage
isAuthenticated()          → Verifica token válido

// Tests:
<LoginForm /> renders correctly
login() calls API and saves token
logout() clears localStorage
<ProtectedRoute /> redirects when not authenticated
```

**Criterios de éxito:**
- ✅ Build exitoso (npm run build)
- ✅ UI renderiza sin errores
- ✅ Tests pasan (npm test)
- ✅ Tokens se guardan/leen correctamente

**Dependencias:** Ninguna (puede ejecutar en paralelo con Agente 1)

---

### Agente 3: Testing Engineer - Tests de Integración E2E
**Responsabilidad:**
- Tests E2E del flujo completo de autenticación
- Tests de seguridad (SQL injection, XSS, CSRF)
- Tests de performance (tiempo de respuesta)
- Reporte de cobertura

**Input:**
- Backend funcionando (output Agente 1)
- Frontend funcionando (output Agente 2)

**Output esperado:**
```python
# Tests E2E con Playwright/Selenium:
test_register_login_flow()
  1. Abrir /register
  2. Llenar formulario
  3. Submit
  4. Verificar redirect a /dashboard
  5. Verificar token en localStorage

test_protected_route_without_auth()
  1. Ir a /dashboard sin token
  2. Verificar redirect a /login

test_logout_flow()
  1. Login
  2. Click logout
  3. Verificar token eliminado
  4. Verificar redirect a /login

# Tests de seguridad:
test_sql_injection_register()
test_xss_in_email_field()
test_brute_force_protection()
test_token_expiration()

# Performance:
test_login_response_time() → < 200ms
test_concurrent_logins() → 100 usuarios simultáneos
```

**Criterios de éxito:**
- ✅ Todos los tests E2E pasan
- ✅ No vulnerabilidades de seguridad
- ✅ Performance dentro de SLAs
- ✅ Cobertura >85%

**Dependencias:** Requiere Agente 1 Y Agente 2 completados

---

## Orden de Ejecución:

**Fase 1 - Paralelo:**
```
┌─────────────────┐        ┌─────────────────┐
│   Agente 1      │        │   Agente 2      │
│   Backend       │        │   Frontend      │
│   (30 min)      │        │   (30 min)      │
└─────────────────┘        └─────────────────┘
        │                          │
        └──────────┬───────────────┘
                   ↓
```

**Fase 2 - Secuencial:**
```
         ┌─────────────────┐
         │   Agente 3      │
         │   Testing       │
         │   (20 min)      │
         └─────────────────┘
```

**Tiempo total:** 50 min (vs 80 min secuencial) → 37.5% más rápido

---

## Verificación Final:
```bash
# 1. Backend tests
cd backend && pytest -v
# ✓ 15 tests passed

# 2. Frontend tests
cd frontend && npm test
# ✓ 12 tests passed

# 3. E2E tests
npm run test:e2e
# ✓ 8 tests passed

# 4. Integración manual
curl -X POST http://localhost:8000/api/auth/register \
  -d '{"email":"test@example.com","password":"test123"}'
# ✓ {"token":"eyJ...", "user":{...}}

# 5. UI funcional
open http://localhost:3000/login
# ✓ Formulario visible, login funciona
```

**✅ SISTEMA COMPLETO FUNCIONANDO**
```

---

## 🎯 Comandos para Claude Code

### Iniciar workflow multi-agente:

```
Usa multi-agent-orchestration para implementar [FEATURE]:

Agente 1 (backend-developer): [descripción tarea]
Agente 2 (frontend-developer): [descripción tarea]
Agente 3 (testing-engineer): [descripción tarea]

Ejecutar Agente 1 y 2 en PARALELO.
Ejecutar Agente 3 después de 1 y 2 completados.

Reportar evidencia de cada agente antes de continuar.
```

### Verificar estado de agentes:

```
/status agents
```

### Handoff entre agentes:

```
Agente [TIPO] completado.

Output producido:
- [Archivo 1]: [descripción]
- [Archivo 2]: [descripción]

Evidencia de éxito:
[captura de comandos ejecutados]

Pasar a Agente [TIPO_SIGUIENTE] con este contexto:
[información necesaria para siguiente agente]
```

---

## 📊 Métricas de Éxito

| Métrica | Objetivo | Medición |
|---------|----------|----------|
| Reducción de tiempo | >30% vs secuencial | Tiempo total de ejecución |
| Tasa de éxito 1er intento | >80% | Tasks completadas sin retrabajar |
| Cobertura de tests | >85% | Coverage report |
| Errores de integración | <5% | Fallos en handoffs |

---

## ⚠️ Antipatrones a Evitar

❌ **Agente todoterreno**: Un agente haciendo backend + frontend + tests
   → Dividir en agentes especializados

❌ **Ejecución secuencial innecesaria**: Esperar Agente 1 → 2 → 3 cuando 1 y 2 son independientes
   → Ejecutar 1 y 2 en paralelo

❌ **Handoff implícito**: "El siguiente agente sabrá qué hacer"
   → Documentar explícitamente qué se pasa y por qué

❌ **Sin verificación intermedia**: Pasar output sin verificar
   → Cada agente reporta evidencia antes de handoff

❌ **Contexto contaminado**: Usar misma conversación para todo
   → Cada agente en su propio contexto aislado

---

## 📚 Referencias

- **Anthropic Best Practices:** https://www.anthropic.com/engineering/claude-code-best-practices
- **Subagents Documentation:** https://code.claude.com/docs/en/sub-agents
- **Advanced Multi-Agent DevOps:** Salwan Mohamed, Medium (2025)
- **Parallel Development with git worktrees:** Claude Code Best Practices

---

## 🔄 Template Rápido

```markdown
# [PROYECTO]

## Agentes:
1. [TIPO] - [TAREA] (paralelo)
2. [TIPO] - [TAREA] (paralelo)
3. [TIPO] - [TAREA] (después de 1+2)

## Ejecución:
Fase 1: 1 + 2 paralelo
Fase 2: 3 secuencial

## Verificación:
[Comandos para verificar todo funciona]
```

---

**Última actualización:** 2025-12-25
**Casos de éxito:** JWT Auth System, Microservices Deployment, Data Pipeline
**Reducción de tiempo:** 30-40% promedio
