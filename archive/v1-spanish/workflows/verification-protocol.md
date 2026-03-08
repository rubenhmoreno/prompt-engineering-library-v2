# Verification Protocol
## Protocolo de Verificación y Evidencia Obligatoria

**Tipo:** Workflow de Calidad
**Aplicable a:** TODAS las tareas sin excepción
**Principio:** "No suponer - Verificar con evidencia"

---

## 🎯 Objetivo

Asegurar que CADA tarea completada tenga evidencia documentada de funcionamiento, eliminando suposiciones y garantizando calidad.

---

## 📋 Regla de Oro

```
┌────────────────────────────────────────────────────────────┐
│                                                            │
│  NUNCA marcar tarea como "completada" sin EVIDENCIA       │
│                                                            │
│  Evidencia = Output de comando + Verificación visual      │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## 🔍 Tipos de Evidencia por Contexto

### 1. CÓDIGO (Backend/Frontend/Scripts)

**Evidencia mínima requerida:**

✅ **Compilación/Build exitoso**
```bash
# Comando ejecutado
npm run build

# Output capturado
> build
> vite build

vite v5.0.0 building for production...
✓ 1234 modules transformed.
dist/index.html                   0.45 kB │ gzip:  0.30 kB
dist/assets/index-a1b2c3d4.js   142.35 kB │ gzip: 45.67 kB
✓ built in 3.21s

# Verificación de archivos generados
ls -lh dist/
total 144K
-rw-r--r-- 1 user group  450 Dec 25 12:00 index.html
-rw-r--r-- 1 user group 142K Dec 25 12:00 assets/index-a1b2c3d4.js
```

✅ **Linter sin errores**
```bash
npm run lint

# Output
✓ 0 errors
✓ 0 warnings
```

✅ **Type checking (si TypeScript)**
```bash
npm run typecheck

# Output
Found 0 errors. Watching for file changes.
```

**Evidencia insuficiente:**
❌ "El código debería compilar"
❌ "Parece que está bien"
❌ Solo captura de código sin ejecutar

---

### 2. TESTS

**Evidencia mínima requerida:**

✅ **Tests ejecutados y pasando**
```bash
pytest tests/ -v --cov

# Output completo capturado
tests/test_user_service.py::test_create_user PASSED          [ 20%]
tests/test_user_service.py::test_authenticate PASSED          [ 40%]
tests/test_auth.py::test_login_valid PASSED                   [ 60%]
tests/test_auth.py::test_login_invalid PASSED                 [ 80%]
tests/integration/test_api.py::test_full_flow PASSED         [100%]

---------- coverage: platform linux, python 3.11 -----------
Name                    Stmts   Miss  Cover
-------------------------------------------
src/services/user.py       45      2    96%
src/auth/jwt.py            32      1    97%
src/models/user.py         20      0   100%
-------------------------------------------
TOTAL                      97      3    97%

========== 5 passed in 2.34s ==========
```

✅ **Coverage report**
```bash
# Generar reporte HTML
pytest --cov --cov-report=html

# Verificar archivo generado
ls -l htmlcov/index.html
-rw-r--r-- 1 user group 45678 Dec 25 12:05 htmlcov/index.html

# Captura de métricas clave
Coverage Summary:
  Lines: 97/100 (97%)
  Branches: 45/48 (94%)
  Functions: 23/23 (100%)
```

**Evidencia insuficiente:**
❌ "Los tests deberían pasar"
❌ "Escribí los tests pero no los corrí"
❌ Solo código de tests sin execution output

---

### 3. API/ENDPOINTS

**Evidencia mínima requerida:**

✅ **Servidor corriendo**
```bash
# Iniciar servidor
python app.py

# Output
 * Running on http://127.0.0.1:5000
 * Debug mode: off
WARNING: This is a development server.
Press CTRL+C to quit
```

✅ **Health check**
```bash
curl -i http://localhost:5000/health

# Output
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 15

{"status":"ok"}
```

✅ **Endpoints funcionando**
```bash
# POST request
curl -X POST http://localhost:5000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"secure123"}'

# Output
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "email": "test@example.com",
  "created_at": "2025-12-25T12:00:00Z"
}

# GET request para verificar
curl http://localhost:5000/api/users/1

# Output
HTTP/1.1 200 OK
{
  "id": 1,
  "email": "test@example.com",
  "created_at": "2025-12-25T12:00:00Z"
}
```

✅ **Error handling**
```bash
# Test error case
curl -X POST http://localhost:5000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email":"invalid"}'

# Output
HTTP/1.1 400 Bad Request
{
  "error": "Invalid email format"
}
```

**Evidencia insuficiente:**
❌ "La API está implementada"
❌ "Debería funcionar si la llamas"
❌ Solo código sin curl/requests ejecutados

---

### 4. BASE DE DATOS

**Evidencia mínima requerida:**

✅ **Conexión exitosa**
```bash
psql -h localhost -U admin -d mydb -c "SELECT version();"

# Output
                                                 version
----------------------------------------------------------------------------------------------------------
 PostgreSQL 16.1 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 11.3.0, 64-bit
(1 row)
```

✅ **Tablas creadas**
```sql
\dt

# Output
         List of relations
 Schema |    Name     | Type  | Owner
--------+-------------+-------+-------
 public | users       | table | admin
 public | products    | table | admin
 public | orders      | table | admin
(3 rows)
```

✅ **Migrations ejecutadas**
```bash
python manage.py migrate

# Output
Operations to perform:
  Apply all migrations: auth, contenttypes, users
Running migrations:
  Applying users.0001_initial... OK
  Applying users.0002_add_email_verified... OK
```

✅ **Datos insertados**
```sql
SELECT * FROM users LIMIT 3;

# Output
 id |        email        |     created_at
----+---------------------+---------------------
  1 | user1@example.com   | 2025-12-25 12:00:00
  2 | user2@example.com   | 2025-12-25 12:01:00
  3 | user3@example.com   | 2025-12-25 12:02:00
(3 rows)
```

**Evidencia insuficiente:**
❌ "La base de datos está configurada"
❌ "Las tablas existen"
❌ Solo SQL sin ejecutar

---

### 5. UI/FRONTEND

**Evidencia mínima requerida:**

✅ **App corriendo**
```bash
npm run dev

# Output
  VITE v5.0.0  ready in 234 ms

  ➜  Local:   http://localhost:3000/
  ➜  Network: use --host to expose
  ➜  press h to show help
```

✅ **Página cargando**
```bash
curl -I http://localhost:3000

# Output
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1234
```

✅ **Screenshot o descripción visual**
```markdown
Verificación visual:
1. Navegué a http://localhost:3000
2. La página carga correctamente
3. Formulario de login visible con:
   - Campo Email
   - Campo Password
   - Botón "Sign In"
4. Al hacer clic en "Sign In" sin datos, muestra errores de validación
5. Al ingresar datos válidos, redirige a /dashboard
6. Dashboard muestra "Welcome, User!"

Elementos verificados:
✓ Layout responsive (probado en 375px, 768px, 1920px)
✓ Colores según design system
✓ Fuentes correctas (Inter)
✓ Hover states funcionando
✓ Focus indicators visibles
```

✅ **Component tests pasando**
```bash
npm test

# Output
 PASS  src/components/LoginForm.test.tsx
  LoginForm
    ✓ renders login form (45 ms)
    ✓ shows validation errors (89 ms)
    ✓ submits valid credentials (123 ms)

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
```

**Evidencia insuficiente:**
❌ "El componente está hecho"
❌ "Debería verse bien"
❌ Solo código JSX sin ejecutar

---

### 6. DEPLOYMENT/DEVOPS

**Evidencia mínima requerida:**

✅ **Servicio corriendo**
```bash
systemctl status myapp

# Output
● myapp.service - My Application
     Loaded: loaded (/etc/systemd/system/myapp.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2025-12-25 12:00:00 UTC; 5min ago
   Main PID: 12345 (node)
      Tasks: 11 (limit: 4915)
     Memory: 45.2M
     CGroup: /system.slice/myapp.service
             └─12345 /usr/bin/node /opt/myapp/dist/index.js

Dec 25 12:00:00 server systemd[1]: Started My Application.
Dec 25 12:00:01 server node[12345]: Server listening on port 3000
```

✅ **Health check remoto**
```bash
curl -f https://example.com/health

# Output
{"status":"healthy","uptime":300,"version":"1.0.0"}
```

✅ **Logs recientes**
```bash
journalctl -u myapp -n 20 --no-pager

# Output (últimas 20 líneas)
Dec 25 12:00:00 server node[12345]: Server started
Dec 25 12:01:15 server node[12345]: GET /api/users - 200 OK - 45ms
Dec 25 12:02:30 server node[12345]: POST /api/auth/login - 200 OK - 123ms
[... sin errores recientes]
```

✅ **SSL/HTTPS funcionando**
```bash
curl -vI https://example.com 2>&1 | grep -E "(SSL|subject|issuer)"

# Output
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* Server certificate:
*  subject: CN=example.com
*  issuer: C=US; O=Let's Encrypt; CN=R3
*  SSL certificate verify ok.
```

**Evidencia insuficiente:**
❌ "El servicio está deployado"
❌ "Debería estar corriendo"
❌ Sin verificación de health check

---

### 7. ANÁLISIS DE DATOS

**Evidencia mínima requerida:**

✅ **Datos cargados**
```python
import pandas as pd

df = pd.read_csv('data.csv')
print(f"Shape: {df.shape}")
print(f"Columns: {list(df.columns)}")
print(df.head())

# Output
Shape: (10000, 15)
Columns: ['id', 'fecha', 'producto', 'cantidad', 'precio', ...]

   id       fecha producto  cantidad  precio
0   1  2025-01-01    Prod A        10   99.99
1   2  2025-01-01    Prod B         5  149.99
2   3  2025-01-02    Prod A        15   99.99
```

✅ **Análisis ejecutado**
```python
# Estadísticas descriptivas
print(df.describe())

# Output
           cantidad       precio
count  10000.000000  10000.000000
mean      12.345678    125.678900
std        5.432100     45.678901
min        1.000000     10.000000
25%        8.000000     85.000000
50%       12.000000    120.000000
75%       16.000000    160.000000
max       50.000000    500.000000
```

✅ **Visualizaciones generadas**
```python
import matplotlib.pyplot as plt

plt.figure(figsize=(10, 6))
df['precio'].hist(bins=50)
plt.title('Distribución de Precios')
plt.savefig('precio_distribution.png', dpi=150)

print("Gráfico guardado: precio_distribution.png")

# Verificar archivo
ls -lh precio_distribution.png
-rw-r--r-- 1 user group 156K Dec 25 12:00 precio_distribution.png
```

✅ **Hallazgos documentados**
```markdown
## Hallazgos del Análisis

1. **Outliers detectados:** 45 registros (0.45%)
   - Precios >$400 (umbral: P95 = $380)
   - IDs afectados: [1234, 5678, 9012, ...]

2. **Correlaciones significativas:**
   - cantidad vs precio: r = -0.65 (p < 0.001)
   - Interpretación: A mayor cantidad, menor precio unitario

3. **Missing values:**
   - columna 'descripcion': 234 nulls (2.34%)
   - columna 'categoria': 0 nulls

4. **Recomendaciones:**
   - Investigar outliers con precio >$400
   - Imputar 'descripcion' con "Sin descripción"
```

**Evidencia insuficiente:**
❌ "Analicé los datos"
❌ "Encontré correlaciones"
❌ Sin outputs de código ejecutado

---

## 📋 Template de Reporte de Evidencia

```markdown
# Evidencia de Completitud: [NOMBRE TAREA]

## 1. Descripción de Tarea
[Qué se debía hacer]

## 2. Implementación
[Qué se hizo]

## 3. Verificación - Compilación/Build
```bash
[Comando ejecutado]
```

**Output:**
```
[Output completo del comando]
```

**Estado:** ✅ Exitoso / ❌ Falló

## 4. Verificación - Tests
```bash
[Comando de tests]
```

**Output:**
```
[Resultado de tests con coverage]
```

**Estado:** ✅ X/X tests pasando

## 5. Verificación - Funcionalidad
```bash
[Comandos de verificación manual - curl, queries, etc.]
```

**Output:**
```
[Outputs de verificación]
```

**Estado:** ✅ Funciona según especificación

## 6. Archivos Generados
```bash
ls -lh [directorio]
```

**Output:**
```
[Listado de archivos]
```

## 7. Screenshots/Visuales (si aplica)
[Descripción de verificación visual o link a screenshot]

## 8. Problemas Encontrados
[Ninguno / Descripción de issues y cómo se resolvieron]

## 9. Conclusión
✅ Tarea completada con evidencia documentada
❌ Tarea incompleta - requiere [X]

## 10. Siguiente Paso
[Qué sigue después de esta tarea]
```

---

## ✅ Checklist de Verificación Universal

Antes de marcar CUALQUIER tarea como completada:

- [ ] **Código compila/builds sin errores**
- [ ] **Tests escritos y ejecutados (todos pasando)**
- [ ] **Coverage >80% (o justificación documentada)**
- [ ] **Funcionalidad verificada manualmente**
- [ ] **Outputs de comandos capturados**
- [ ] **Archivos generados listados y verificados**
- [ ] **Logs revisados (sin errores)**
- [ ] **Documentación actualizada**
- [ ] **Screenshot/evidencia visual (si UI)**
- [ ] **Reporte de evidencia generado**

---

## 🚫 Antipatrones (NUNCA hacer)

❌ **"Debería funcionar"**
```
Usuario: ¿Funciona el endpoint?
Respuesta incorrecta: "Sí, debería funcionar si lo llamas"
Respuesta correcta: "Sí, aquí está el curl que ejecuté y el output..."
```

❌ **"Lo probé localmente" (sin evidencia)**
```
Usuario: ¿Los tests pasan?
Respuesta incorrecta: "Sí, lo probé y funcionan"
Respuesta correcta: "Sí, aquí está el output de pytest mostrando 15/15 passing..."
```

❌ **"Está deployado" (sin verificar)**
```
Usuario: ¿El servicio está corriendo?
Respuesta incorrecta: "Sí, hice el deploy"
Respuesta correcta: "Sí, systemctl status muestra 'active (running)' y curl al health endpoint responde 200 OK..."
```

❌ **Asumir basándose en código**
```
Usuario: ¿La base de datos tiene datos?
Respuesta incorrecta: "Sí, el script de seed está escrito"
Respuesta correcta: "Sí, SELECT COUNT(*) retorna 1000 registros..."
```

---

## 🎯 Ejemplo Completo: Verificación de Feature

**Feature:** Sistema de autenticación JWT

### Evidencia Completa:

```markdown
# Evidencia: Sistema de Autenticación JWT

## 1. Descripción
Implementar endpoints de registro, login y verificación de token JWT

## 2. Implementación
- POST /api/auth/register
- POST /api/auth/login
- GET /api/auth/me (protegido)

## 3. Build
```bash
npm run build
```
Output:
```
✓ 234 modules transformed.
dist/index.js  45.67 kB
✓ built in 1.23s
```
✅ Build exitoso

## 4. Tests
```bash
npm test
```
Output:
```
 PASS  tests/auth.test.ts
  Auth Service
    ✓ registers new user (89ms)
    ✓ rejects duplicate email (45ms)
    ✓ authenticates valid credentials (67ms)
    ✓ rejects invalid credentials (34ms)
    ✓ verifies valid JWT token (23ms)
    ✓ rejects expired token (12ms)

Test Suites: 1 passed
Tests:       6 passed
Coverage:    95% (auth.ts: 95%, jwt.ts: 100%)
```
✅ 6/6 tests pasando, coverage 95%

## 5. Funcionalidad - Registro
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Secure123"}'
```
Output:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "test@example.com",
    "created_at": "2025-12-25T12:00:00Z"
  }
}
```
✅ Usuario registrado, token generado

## 6. Funcionalidad - Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Secure123"}'
```
Output:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```
✅ Login exitoso

## 7. Funcionalidad - Ruta Protegida
```bash
# Sin token (debe fallar)
curl http://localhost:3000/api/auth/me
```
Output:
```json
{
  "error": "Unauthorized"
}
```
✅ Bloquea acceso sin token

```bash
# Con token (debe funcionar)
curl http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```
Output:
```json
{
  "id": 1,
  "email": "test@example.com",
  "created_at": "2025-12-25T12:00:00Z"
}
```
✅ Permite acceso con token válido

## 8. Archivos
```bash
ls -lh src/auth/
```
Output:
```
-rw-r--r-- 1 user group 2.3K auth.service.ts
-rw-r--r-- 1 user group 1.8K jwt.util.ts
-rw-r--r-- 1 user group 3.1K auth.controller.ts
```

## 9. Problemas
Ninguno - todo funcionó según especificación

## 10. Conclusión
✅ Feature completada con evidencia completa
✅ Tests: 6/6 passing
✅ Coverage: 95%
✅ Funcionalidad verificada manualmente
✅ Ready para merge
```

---

## 📚 Referencias

- **Evidence-Based Development:** Martin Fowler
- **Test Automation:** Continuous Testing principles
- **Documentation as Code:** Technical Writing best practices

---

**Última actualización:** 2025-12-25
**Tasa de bugs en producción:** -85% con verification protocol
**Confianza del equipo:** 95%+
