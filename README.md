# Prompt Engineering Library v2

**[English](#english)** | **[Espanol](#espanol)**

---

<a id="english"></a>

## English

> **Executive Summary:** A modular library of specialized prompts and agent definitions for professional software development with AI. It enforces four non-negotiable principles — verify before acting, test-driven development, multi-agent specialization, and evidence-based reporting — so that every AI session produces reliable, auditable results.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [INDEX.md](INDEX.md), [CONTRIBUTING.md](CONTRIBUTING.md) |

---

### How to Use This Library

**Copy the prompt below and paste it as the first message in any AI session** (Claude Code, Claude.ai, ChatGPT, Gemini, or any LLM). Then give it your specific task.

#### Standard Prompt (copy and paste)

```
Read the professional development methodology at:
https://github.com/rubenhmoreno/prompt-engineering-library-v2

Read these files in order:
1. README.md — general structure and principles
2. core/base-programming.md — 10 non-negotiable principles
3. core/prompt-anatomy.md — how to structure your reasoning
4. core/multi-agent-orchestration.md — how to coordinate complex tasks

NON-NEGOTIABLE RULES (apply ALWAYS):
- VERIFY before acting: never assume files exist, services are running, or ports
  are free. Run actual commands (ls, which, curl) before every action.
- TDD mandatory: write the failing test FIRST (RED), then minimum code to pass
  (GREEN), then improve without breaking tests (REFACTOR). Coverage >80%.
- EVIDENCE mandatory: every completed task must have real terminal output, test
  results, or curl responses. "It works" without proof = not done.
- EXPLORE before modifying: before changing any code, read the project structure,
  key files, and existing conventions.
- SECURITY by default: secrets in env vars, parameterized queries, input
  validation. Never hardcode credentials.

STANDARD WORKFLOW:
Explore codebase → Decompose into tasks → Define contracts/interfaces →
Test (RED) → Implement (GREEN) → Refactor → Run full test suite →
Produce evidence → Document changes

FOR COMPLEX TASKS:
1. Classify: one question with multiple angles (depth-first), multiple independent
   subtasks (breadth-first), or single focused task (straightforward)?
2. Select agents from the catalog (see agents/ in the repo):
   backend-developer, frontend-developer, testing-engineer, devops-engineer,
   data-analyst, data-detective, debugger, database-architect,
   security-auditor, api-architect, performance-engineer, cloud-infrastructure,
   ui-ux-specialist, ui-ux-pro-max, git-workflow-manager, technical-writer
3. Use collaboration presets:
   - Feature: api-architect → backend + frontend (parallel) → testing → devops
   - Bugfix: debugger → backend → testing
   - Security: security-auditor → backend → testing → devops
   - Incident: data-detective(30m) → backend(60m) → testing(30m) → devops
4. Max 6 simultaneous agents per phase
5. Each agent produces evidence before handoff

WHEN ERRORS OCCUR:
Read the full error → Verify context (file? service? port?) →
Write a test that reproduces the error → Apply minimum fix →
Confirm no regressions → Document root cause

QUALITY GATES (before marking done):
- [ ] Tests pass with >80% coverage
- [ ] Linting clean (zero errors)
- [ ] Type checking clean
- [ ] Endpoints respond (show curl output)
- [ ] Conventional commits (feat/fix/docs/refactor/test)
- [ ] Evidence produced (real output, not assertions)

When stuck: stop guessing → verify state with commands → form hypothesis →
test it → fix.

Confirm you have read the methodology and are ready for instructions.
```

#### Short Version (for quick sessions)

```
Read the methodology at https://github.com/rubenhmoreno/prompt-engineering-library-v2
(especially README.md, core/base-programming.md and core/multi-agent-orchestration.md).

Rules: verify before acting, TDD always (RED→GREEN→REFACTOR, coverage >80%),
mandatory evidence (real terminal output), explore before modifying,
security by default (secrets in env vars).

Workflow: Explore → Decompose → Contracts → Test → Implement → Refactor → Evidence

Confirm you have read it and are ready.
```

#### Usage Example

**Step 1:** Paste the prompt above

**Step 2:** The AI confirms it read the methodology

**Step 3:** Give your specific instruction:
```
I need a support ticket management web app.
Stack: Python FastAPI + PostgreSQL + React.
Features:
- Login with roles (admin, agent, user)
- Ticket CRUD with priority and status
- Dashboard with metrics
- REST API documented with OpenAPI

Start with the database design and the API.
```

The AI will automatically:
1. Explore if there is existing code
2. Classify as breadth-first (multiple subtasks)
3. Assign: database-architect → api-architect → backend + frontend (parallel) → testing
4. Apply TDD at each phase
5. Produce evidence at every delivery

---

### Quick Reference Card

| Want to... | Go to |
|------------|-------|
| Bootstrap any AI session with this methodology | Copy the prompt above |
| Activate without repo URL (self-contained) | [ACTIVATION_PROMPT.md](ACTIVATION_PROMPT.md) (3 variants) |
| Use a specialist agent | See Agent Roster below, then open `agents/<name>.md` |
| Run tasks in parallel | [core/multi-agent-orchestration.md](core/multi-agent-orchestration.md) |
| Prevent common errors | [core/error-prevention.md](core/error-prevention.md) |
| Validate completed work | [core/real-validation.md](core/real-validation.md) |
| Improve prompt quality | [core/prompting-techniques.md](core/prompting-techniques.md) |
| Deploy (non-technical) | [workflows/simple-deployment.md](workflows/simple-deployment.md) |
| Check usability (non-technical) | [quick-ref/ux-checklist.md](quick-ref/ux-checklist.md) |
| Navigate everything | [INDEX.md](INDEX.md) |

---

### What This Library Is

The library provides ready-to-use prompts that configure AI sessions with professional-grade discipline. Instead of ad-hoc instructions, you load a proven prompt and immediately get a session that verifies before acting, writes tests first, delegates to the right specialist, and refuses to mark anything done without real evidence.

It ships with 16 specialist agents, 7 workflows, 3 templates, and 9 core documents. All content is technology-agnostic and designed to remain stable over time.

### Agent Roster

| Agent | Domain | When to Use |
|-------|--------|-------------|
| `backend-developer` | APIs, databases, business logic, server-side Python/Node | Building endpoints, services, migrations |
| `frontend-developer` | React/Vue/JS components, CSS, build tooling | UI features, component libraries, accessibility |
| `testing-engineer` | Unit, integration, E2E, performance, security tests | QA passes, coverage gaps, regression suites |
| `devops-engineer` | Docker, CI/CD, deployment scripts, infrastructure-as-code | Deploy pipelines, container config, monitoring |
| `data-analyst` | Data exploration, visualizations, reports, notebooks | Analysis tasks, dashboards, data cleaning |
| `data-detective` | Root-cause analysis, anomaly detection, log forensics | Debugging data issues, unexpected behavior |
| `ui-ux-specialist` | Design systems, WCAG accessibility, UX specifications | Design review, accessibility audits, mockups |
| `security-auditor` | Threat modeling, OWASP, CVE scanning, auth review | Pre-release security pass, dependency audit |
| `api-architect` | API design, contracts, versioning, OpenAPI specs | API design phase, breaking-change review |
| `performance-engineer` | Profiling, benchmarking, caching, query optimization | Latency issues, load testing, bottleneck analysis |
| `cloud-infrastructure` | AWS/GCP/Azure, IaC (Terraform/Pulumi), cost optimization | Cloud provisioning, scaling, cost review |
| `debugger` | Runtime errors, stack traces, systematic debugging | Crashes, intermittent failures, error diagnosis |
| `git-workflow-manager` | Branch strategy, commits, PRs, conflict resolution | Git workflow setup, release management |
| `database-architect` | Schema design, migrations, query optimization, indexing | Database design, slow queries, scaling |
| `technical-writer` | API docs, ADRs, runbooks, changelogs | Post-implementation documentation |
| `ui-ux-pro-max` | Industry-specific design, visual styles, navigation, animation, mobile UI | New product design, style selection, landing pages, chart selection |

### Architecture

```
prompt-engineering-library-v2/
|
+-- STANDARD_PROMPT.md              <- Universal prompt (repo URL + methodology)
+-- ACTIVATION_PROMPT.md            <- Self-contained prompts (3 variants)
|
+-- CORE (start here every session)
|   +-- core/base-programming.md          <- Master prompt: 10 principles + workflows
|   +-- core/error-prevention.md          <- Verification protocol: 7 categories
|   +-- core/multi-agent-orchestration.md <- Parallel execution framework
|   +-- core/prompting-techniques.md      <- CoT, Few-Shot, ReAct techniques
|   +-- core/real-validation.md           <- Evidence rules: no fake "done"
|   +-- core/prompt-anatomy.md            <- 10-component prompt structure
|   +-- core/agentic-safety.md            <- Scope, blocklists, checkpoints
|   +-- core/hooks-guide.md               <- Claude Code lifecycle hooks
|   +-- core/claudemd-guide.md            <- CLAUDE.md creation guide
|
+-- AGENTS (load when you need a specialist)
|   +-- 16 specialized agents (see roster above)
|
+-- WORKFLOWS (orchestrate multi-step processes)
|   +-- workflows/tdd-workflow.md
|   +-- workflows/parallel-development.md
|   +-- workflows/simple-deployment.md    <- Non-technical deploy guide
|   +-- workflows/verification-protocol.md
|   +-- workflows/explore-first.md        <- Codebase investigation protocol
|   +-- workflows/riper-workflow.md       <- Research/Innovate/Plan/Execute/Review
|   +-- workflows/incident-response.md    <- P0-P3 time-boxed incident handling
|   +-- workflows/session-memory.md       <- Cross-session continuity patterns
|
+-- TEMPLATES (reusable communication formats)
|   +-- templates/task-decomposition.md
|   +-- templates/evidence-report.md
|   +-- templates/agent-handoff.md
|
+-- QUICK REFERENCES (one-screen lookups)
|   +-- quick-ref/all-agents-cheatsheet.md
|   +-- quick-ref/workflow-decision-tree.md
|   +-- quick-ref/command-reference.md
|   +-- quick-ref/template-selector.md
|   +-- quick-ref/ux-checklist.md         <- Non-technical usability review
|   +-- quick-ref/slash-commands.md       <- 6 ready-to-use /command definitions
|
+-- EXAMPLES
    +-- examples/case-study-vox-client.md
    +-- examples/best-practices-learned.md
```

Data flows top-down: the **core** layer establishes invariants for every session. **Agents** operate within those invariants with specialized tools. **Workflows** coordinate multiple agents. **Templates** standardize communication between agents and to the user.

### Four Fundamental Principles

**1. VERIFY, DON'T ASSUME**

Never assume a file exists, a command is installed, a service is running, or a port is free. Verify with actual commands before acting.

```bash
ls -lh /path/to/file          # Does it exist?
command -v python3            # Is it installed?
systemctl status myservice    # Is it running?
```

**2. TEST-DRIVEN DEVELOPMENT**

Write the failing test first (RED), then write the minimum code to make it pass (GREEN), then improve without breaking the test (REFACTOR). Minimum coverage: 80%.

```python
# RED: write the test first
def test_user_password_is_hashed():
    user = UserService().create("a@b.com", "Secret123")
    assert user.password != "Secret123"

# GREEN: minimal implementation
# REFACTOR: improve structure, keep tests passing
```

**3. MULTI-AGENT SPECIALIZATION**

One agent, one responsibility. Identify independent tasks and run those agents in parallel. Only serialize when there is a real data dependency.

```
Phase 1 (parallel):  backend-developer  +  frontend-developer
Phase 2 (serial):    testing-engineer   (needs Phase 1 output)
```

**4. EVIDENCE-BASED REPORTING**

"Completed" means nothing without proof. Every claim must be backed by terminal output, test results, or curl responses.

```bash
$ pytest tests/ -v --cov=app
15 passed, coverage: 94%

$ curl http://localhost:8000/health
{"status": "healthy", "version": "2.1.0"}
```

---

### Where to Use the Standard Prompt

| Platform | How to load |
|----------|-------------|
| Claude Code (terminal) | Paste as first message, or save to `~/.claude/system-prompt.md` and run `claude --append-system-prompt-file ~/.claude/system-prompt.md` |
| Claude.ai (web) | Paste as first message in the chat |
| Claude API | Send as `system` message in the first request |
| Other LLMs (GPT, Gemini, etc.) | Paste as first message — the methodology is model-agnostic |
| Project CLAUDE.md | Copy the non-negotiable rules to your repo's CLAUDE.md |

---

### Related Documents

- [INDEX.md](INDEX.md) — Full navigation by role, task, and situation
- [STANDARD_PROMPT.md](STANDARD_PROMPT.md) — Full prompt document with all variants
- [ACTIVATION_PROMPT.md](ACTIVATION_PROMPT.md) — Self-contained prompts (no repo URL needed)
- [core/base-programming.md](core/base-programming.md) — Master session prompt
- [core/prompting-techniques.md](core/prompting-techniques.md) — CoT, Few-Shot, ReAct and more
- [core/real-validation.md](core/real-validation.md) — Evidence standards
- [CONTRIBUTING.md](CONTRIBUTING.md) — How to contribute
- [LICENSE](LICENSE) — MIT License

---

<a id="espanol"></a>

## Espanol

> **Resumen Ejecutivo:** Una libreria modular de prompts especializados y definiciones de agentes para desarrollo profesional de software con IA. Aplica cuatro principios innegociables: verificar antes de actuar, desarrollo guiado por tests, especializacion multi-agente, y reportes basados en evidencia, para que cada sesion de IA produzca resultados confiables y auditables.

---

### Como usar esta libreria

**Copia el prompt de abajo y pegalo como primer mensaje en cualquier sesion de IA** (Claude Code, Claude.ai, ChatGPT, Gemini, o cualquier LLM). Despues dale tu tarea especifica.

#### Prompt Estandar (copiar y pegar)

```
Lee la metodologia de desarrollo profesional en:
https://github.com/rubenhmoreno/prompt-engineering-library-v2

Lee estos archivos en orden:
1. README.md — estructura general y principios
2. core/base-programming.md — 10 principios innegociables
3. core/prompt-anatomy.md — como estructurar tu razonamiento
4. core/multi-agent-orchestration.md — como coordinar tareas complejas

REGLAS NO NEGOCIABLES (aplicar SIEMPRE):
- VERIFICAR antes de actuar: nunca asumas que un archivo existe, un servicio
  corre, o un puerto esta libre. Ejecuta comandos reales (ls, which, curl)
  antes de cada accion.
- TDD obligatorio: escribe el test que falla PRIMERO (ROJO), despues el codigo
  minimo para que pase (VERDE), despues mejora sin romper tests (REFACTORIZAR).
  Cobertura >80%.
- EVIDENCIA obligatoria: cada tarea completada debe tener output real de terminal,
  resultados de tests, o respuestas de curl. "Funciona" sin pruebas = no terminado.
- EXPLORAR antes de modificar: antes de cambiar cualquier codigo, lee la estructura
  del proyecto, archivos clave y convenciones existentes.
- SEGURIDAD por defecto: secrets en variables de entorno, queries parametrizadas,
  validacion de input. Nunca hardcodear credenciales.

WORKFLOW ESTANDAR:
Explorar codebase → Descomponer en tareas → Definir contratos/interfaces →
Test (ROJO) → Implementar (VERDE) → Refactorizar → Ejecutar suite completa →
Producir evidencia → Documentar cambios

PARA TAREAS COMPLEJAS:
1. Clasificar: ¿es una pregunta con multiples angulos (depth-first), multiples
   subtareas independientes (breadth-first), o una tarea directa (straightforward)?
2. Seleccionar agentes del catalogo (ver agents/ en el repo):
   backend-developer, frontend-developer, testing-engineer, devops-engineer,
   data-analyst, data-detective, debugger, database-architect,
   security-auditor, api-architect, performance-engineer, cloud-infrastructure,
   ui-ux-specialist, ui-ux-pro-max, git-workflow-manager, technical-writer
3. Usar presets de colaboracion:
   - Feature: api-architect → backend + frontend (paralelo) → testing → devops
   - Bugfix: debugger → backend → testing
   - Security: security-auditor → backend → testing → devops
   - Incidente: data-detective(30min) → backend(60min) → testing(30min) → devops
4. Maximo 6 agentes simultaneos por fase
5. Cada agente produce evidencia antes de entregar

CUANDO HAYA ERRORES:
Leer el error completo → Verificar contexto (¿archivo? ¿servicio? ¿puerto?) →
Escribir test que reproduzca el error → Aplicar fix minimo →
Confirmar no hay regresiones → Documentar causa raiz

CALIDAD MINIMA (antes de marcar como terminado):
- [ ] Tests pasan con >80% cobertura
- [ ] Linting limpio (cero errores)
- [ ] Type checking limpio
- [ ] Endpoints responden (mostrar curl)
- [ ] Commits convencionales (feat/fix/docs/refactor/test)
- [ ] Evidencia producida (output real, no afirmaciones)

Cuando estes trabado: para de adivinar → verifica estado con comandos →
forma una hipotesis → testeala → arregla.

Confirma que leiste la metodologia y estas listo para recibir instrucciones.
```

#### Version Corta (para sesiones rapidas)

```
Lee la metodologia en https://github.com/rubenhmoreno/prompt-engineering-library-v2
(especialmente README.md, core/base-programming.md y core/multi-agent-orchestration.md).

Reglas: verificar antes de actuar, TDD siempre (ROJO→VERDE→REFACTORIZAR, cobertura >80%),
evidencia obligatoria (output real de terminal), explorar antes de modificar,
seguridad por defecto (secrets en env vars).

Workflow: Explorar → Descomponer → Contratos → Test → Implementar → Refactorizar → Evidencia

Confirma que leiste y estas listo.
```

#### Ejemplo de uso

**Paso 1:** Pegas el prompt de arriba

**Paso 2:** La IA confirma que leyo la metodologia

**Paso 3:** Le das tu instruccion especifica:
```
Necesito una aplicacion web de gestion de tickets de soporte.
Stack: Python FastAPI + PostgreSQL + React.
Features:
- Login con roles (admin, agente, usuario)
- CRUD de tickets con prioridad y estado
- Dashboard con metricas
- API REST documentada con OpenAPI

Empeza con el diseno de la base de datos y la API.
```

La IA va a automaticamente:
1. Explorar si hay codigo existente
2. Clasificar como breadth-first (multiples subtareas)
3. Asignar: database-architect → api-architect → backend + frontend (paralelo) → testing
4. Aplicar TDD en cada fase
5. Producir evidencia en cada entrega

---

### Referencia Rapida

| Quiero... | Ir a |
|-----------|------|
| Iniciar cualquier sesion de IA con esta metodologia | Copiar el prompt de arriba |
| Activar sin URL del repo (autocontenido) | [ACTIVATION_PROMPT.md](ACTIVATION_PROMPT.md) (3 variantes) |
| Usar un agente especialista | Ver el catalogo de agentes abajo, luego abrir `agents/<nombre>.md` |
| Ejecutar tareas en paralelo | [core/multi-agent-orchestration.md](core/multi-agent-orchestration.md) |
| Prevenir errores comunes | [core/error-prevention.md](core/error-prevention.md) |
| Validar trabajo completado | [core/real-validation.md](core/real-validation.md) |
| Mejorar la calidad de los prompts | [core/prompting-techniques.md](core/prompting-techniques.md) |
| Hacer deploy (no tecnico) | [workflows/simple-deployment.md](workflows/simple-deployment.md) |
| Revisar usabilidad (no tecnico) | [quick-ref/ux-checklist.md](quick-ref/ux-checklist.md) |
| Navegar todo | [INDEX.md](INDEX.md) |

---

### Catalogo de Agentes

| Agente | Dominio | Cuando Usarlo |
|--------|---------|---------------|
| `backend-developer` | APIs, bases de datos, logica de negocio, Python/Node server-side | Construir endpoints, servicios, migraciones |
| `frontend-developer` | Componentes React/Vue/JS, CSS, herramientas de build | Features de UI, librerias de componentes, accesibilidad |
| `testing-engineer` | Tests unitarios, integracion, E2E, performance, seguridad | QA, gaps de cobertura, suites de regresion |
| `devops-engineer` | Docker, CI/CD, scripts de deploy, infraestructura como codigo | Pipelines de deploy, configuracion de containers, monitoreo |
| `data-analyst` | Exploracion de datos, visualizaciones, reportes, notebooks | Tareas de analisis, dashboards, limpieza de datos |
| `data-detective` | Analisis de causa raiz, deteccion de anomalias, forensia de logs | Debugging de problemas de datos, comportamiento inesperado |
| `ui-ux-specialist` | Sistemas de diseno, accesibilidad WCAG, especificaciones UX | Review de diseno, auditorias de accesibilidad, mockups |
| `security-auditor` | Modelado de amenazas, OWASP, escaneo CVE, review de auth | Revision de seguridad pre-release, auditoria de dependencias |
| `api-architect` | Diseno de APIs, contratos, versionado, specs OpenAPI | Fase de diseno de API, review de breaking changes |
| `performance-engineer` | Profiling, benchmarking, caching, optimizacion de queries | Problemas de latencia, load testing, analisis de cuellos de botella |
| `cloud-infrastructure` | AWS/GCP/Azure, IaC (Terraform/Pulumi), optimizacion de costos | Aprovisionamiento cloud, escalado, review de costos |
| `debugger` | Errores de runtime, stack traces, debugging sistematico | Crashes, fallos intermitentes, diagnostico de errores |
| `git-workflow-manager` | Estrategia de branches, commits, PRs, resolucion de conflictos | Setup de workflow git, gestion de releases |
| `database-architect` | Diseno de schemas, migraciones, optimizacion de queries, indices | Diseno de base de datos, queries lentas, escalado |
| `technical-writer` | Docs de API, ADRs, runbooks, changelogs | Documentacion post-implementacion |
| `ui-ux-pro-max` | Diseno por industria, estilos visuales, navegacion, animacion, UI mobile | Diseno de productos nuevos, seleccion de estilo, landing pages |

### Cuatro Principios Fundamentales

**1. VERIFICAR, NO SUPONER**

Nunca asumas que un archivo existe, un comando esta instalado, un servicio esta corriendo, o un puerto esta libre. Verifica con comandos reales antes de actuar.

**2. DESARROLLO GUIADO POR TESTS (TDD)**

Escribe el test que falla primero (ROJO), luego escribe el codigo minimo para que pase (VERDE), luego mejora sin romper el test (REFACTORIZAR). Cobertura minima: 80%.

**3. ESPECIALIZACION MULTI-AGENTE**

Un agente, una responsabilidad. Identifica tareas independientes y ejecuta esos agentes en paralelo. Solo serializa cuando hay una dependencia real de datos.

**4. REPORTES BASADOS EN EVIDENCIA**

"Completado" no significa nada sin pruebas. Cada afirmacion debe estar respaldada por output de terminal, resultados de tests, o respuestas de curl.

---

### Donde usar el prompt estandar

| Plataforma | Como cargar |
|------------|-------------|
| Claude Code (terminal) | Pegar como primer mensaje, o guardar en `~/.claude/system-prompt.md` y usar `claude --append-system-prompt-file ~/.claude/system-prompt.md` |
| Claude.ai (web) | Pegar como primer mensaje del chat |
| Claude API | Enviar como mensaje `system` en el primer request |
| Otro LLM (GPT, Gemini, etc.) | Pegar como primer mensaje — la metodologia es agnostica de modelo |
| CLAUDE.md del proyecto | Copiar las reglas no negociables al CLAUDE.md de tu repo |

---

### Documentos Relacionados

- [INDEX.md](INDEX.md) — Navegacion completa por rol, tarea y situacion
- [STANDARD_PROMPT.md](STANDARD_PROMPT.md) — Documento completo del prompt con todas las variantes
- [ACTIVATION_PROMPT.md](ACTIVATION_PROMPT.md) — Prompts autocontenidos (sin URL del repo)
- [core/base-programming.md](core/base-programming.md) — Prompt maestro de sesion
- [core/prompting-techniques.md](core/prompting-techniques.md) — CoT, Few-Shot, ReAct y mas
- [core/real-validation.md](core/real-validation.md) — Estandares de evidencia
- [CONTRIBUTING.md](CONTRIBUTING.md) — Como contribuir
- [LICENSE](LICENSE) — Licencia MIT

---

*Last updated / Ultima actualizacion: 2026-03-08 | Version 2.1.0 | MIT License*
