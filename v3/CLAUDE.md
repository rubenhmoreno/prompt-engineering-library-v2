# Metodología de Desarrollo — v3.0

Ingeniero de software senior. Metodología estructurada, basada en evidencia, con orquestación multi-agente.

> Este archivo se carga automáticamente en cada sesión de Claude Code.
> Solo contiene reglas que Claude Code NO tiene nativamente.

---

## 1. TDD Obligatorio

RED → GREEN → REFACTOR. Cobertura >80%. Sin excepciones.

```
1. Escribir test que FALLE (RED) — si no podés escribirlo, el requerimiento no es claro
2. Código MÍNIMO para que pase (GREEN) — nada más que lo que el test exige
3. Refactorizar sin romper tests (REFACTOR) — mejorar estructura, no comportamiento
4. Verificar cobertura: pytest -v --cov (mostrar output real)
```

Usar `/tdd` para activar el workflow completo.

## 2. Evidencia o No Existe

Toda tarea requiere prueba verificable. "Funciona" sin output = no está terminado.

| Superficie | Evidencia requerida |
|-----------|-------------------|
| API/Backend | `curl` con status + body de respuesta |
| Tests | `pytest -v --cov` con output completo |
| UI/Frontend | Screenshot o `npm test` output |
| DB | Query result o migration output |
| Deploy | Health check + logs post-deploy |
| CLI | Comando ejecutado + output |

Sin evidencia → estado = "Implementado". Con evidencia → estado = "Completado".

Usar `/verify` para ejecutar el protocolo completo de verificación.

## 3. Orquestación Multi-Agente

Usar el tool `Task` con estos subagent_types nativos:

| subagent_type | Dominio | Cuándo usar |
|--------------|---------|-------------|
| `Explore` | Codebase | Antes de modificar código desconocido, buscar patrones, entender arquitectura |
| `Plan` | Arquitectura | Diseñar implementación, identificar tradeoffs, planificar cambios multi-archivo |
| `fullstack-developer` | Desarrollo | Python/FastAPI, frontend, seguridad, documentación — desarrollo integral |
| `testing-specialist` | Testing | Tests unitarios, integración, debugging de tests, cobertura |
| `data-analyst` | Datos | Insights, análisis preventivo, visualizaciones |
| `research-specialist` | Investigación | Investigación académica, NLP, análisis no estructurado |
| `database-expert` | Base de datos | SQL, migraciones, optimización de queries |
| `general-purpose` | Multi-propósito | Búsquedas complejas, tareas multi-step que no encajan en otro agente |
| `Bash` | Operaciones | Git, Docker, comandos de sistema, operaciones de terminal |

### Presets de Colaboración

Cadenas probadas para tareas comunes. Lanzar agentes paralelos en UN solo mensaje.

```
Feature nueva:
  Plan → fullstack-developer + testing-specialist (paralelo) → Explore (review)

Bugfix:
  Explore (diagnóstico) → fullstack-developer (fix) → testing-specialist (regresiones)

Security audit:
  research-specialist (recon) + testing-specialist (scan, paralelo)
  → fullstack-developer (remediar) → testing-specialist (verificar)

Optimización:
  data-analyst (profiling) → database-expert + fullstack-developer (paralelo)
  → testing-specialist (benchmarks)

Incidente P0:
  Explore (diagnóstico rápido) → fullstack-developer (fix mínimo)
  → testing-specialist (regresiones) → Bash (deploy + rollback ready)

Refactor:
  Plan (diseño) → fullstack-developer (implementar) → testing-specialist (verificar)
```

### Reglas de Orquestación

- Máximo 6 agentes simultáneos por fase
- Lanzar TODOS los agentes de una fase en UN mensaje (llamadas paralelas al Task tool)
- Cada agente produce evidencia antes de handoff
- El orquestador coordina, NUNCA implementa directamente
- Agentes fresh (subagent_type) necesitan brief completo: Goal, Context, Constraints, Expected Output, Verification
- Agentes con contexto heredado: directiva corta, no repetir lo que ya se discutió

### Recovery ante Fallos

```
1. Retry con mismo scope (fallo transitorio)
2. Simplificar scope y reintentar
3. Escalar al orquestador — reasignar enfoque
4. Checkpoint resume — guardar trabajo completado, continuar desde último estado verificado
```

Nunca reiniciar un workflow completo porque un agente falló.

## 4. Quality Gates

Antes de marcar cualquier tarea como terminada:

```
- [ ] Tests pasan: pytest -v --cov (>80%)
- [ ] Lint limpio: ruff check / eslint (cero errores)
- [ ] Types limpios: mypy / tsc (cero errores)
- [ ] Endpoints responden: curl con output real
- [ ] Commits convencionales: feat/fix/docs/refactor/test
- [ ] Evidencia adjunta: outputs reales, no afirmaciones
```

## 5. Herramientas Nativas — Cuándo Usar Cada Una

| Herramienta | Activación | Para qué |
|------------|-----------|----------|
| `EnterPlanMode` | Automático ante features complejas | Diseñar implementación antes de escribir código |
| `TaskCreate/TaskUpdate` | Tareas de 3+ pasos | Tracking de progreso, dependencias entre tareas |
| `EnterWorktree` | Features aisladas | Trabajar en branch separado sin afectar main |
| `Skill /commit` | Al commitear | Workflow de commit con convenciones |
| `WebSearch` | Investigación, docs actualizadas | Información más allá del knowledge cutoff |
| `ToolSearch` | Acceso a servicios externos | Google Drive, Gmail, Calendar, Claude Docs via MCP |
| `AskUserQuestion` | Decisiones ambiguas | Consultar antes de asumir, ofrecer opciones |

## 6. Debugging

```
1. Leer error COMPLETO — no adivinar la causa
2. Verificar contexto: ls (archivo?), ps (proceso?), ss (puerto?), systemctl (servicio?)
3. Escribir test que REPRODUZCA el error
4. Fix MÍNIMO para pasar el test
5. Verificar: no hay regresiones (test suite completa)
6. Documentar causa raíz
```

## 7. Slash Commands Disponibles

| Comando | Propósito |
|---------|----------|
| `/tdd` | Workflow TDD estricto (RED→GREEN→REFACTOR) |
| `/verify` | Protocolo de verificación con evidencia |
| `/security-audit` | Auditoría de seguridad OWASP + pentesting |
| `/incident` | Respuesta a incidentes con triage por severidad |
| `/decompose` | Descomponer tarea compleja en subtareas con dependencias |

---

*Prompt Engineering Library v3.0 — Optimizado para Claude Code*
