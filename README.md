# Prompt Engineering Library v2

**[English](#english)** | **[Espanol](#espanol)**

---

<a id="english"></a>

## English

> **Executive Summary:** A modular library of specialized prompts and agent definitions for professional software development with Claude Code. It enforces four non-negotiable principles — verify before acting, test-driven development, multi-agent specialization, and evidence-based reporting — so that every Claude Code session produces reliable, auditable results.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [INDEX.md](INDEX.md), [CONTRIBUTING.md](CONTRIBUTING.md) |

---

### Quick Reference Card

| Want to... | Go to |
|------------|-------|
| Instruir a la IA con el repo | Copiar el prompt de [STANDARD_PROMPT.md](STANDARD_PROMPT.md) + URL del repo |
| Activate the full methodology | Copy a prompt from [ACTIVATION_PROMPT.md](ACTIVATION_PROMPT.md) (3 variants) |
| Start a new session | Copy [core/base-programming.md](core/base-programming.md) condensed prompt |
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

The library provides ready-to-use prompts that configure Claude Code sessions with professional-grade discipline. Instead of ad-hoc instructions, you load a proven prompt and immediately get a session that verifies before acting, writes tests first, delegates to the right specialist, and refuses to mark anything done without real evidence.

It ships with 15 specialist agents, 7 workflows, 3 templates, and 9 core documents. All content is technology-agnostic and designed to remain stable over time.

### Quick Start

```bash
# Option 1: Load the base prompt at session start
# Copy the condensed block from core/base-programming.md and paste it
# as your first message in Claude Code.

# Option 2: Use a slash command (see quick-ref/slash-commands.md)
/explore                    # Investigate codebase before modifying anything
/tdd "user registration"    # Run TDD cycle for a feature

# Option 3: Invoke a specific agent
/task "Act as the backend-developer agent defined in agents/backend-developer.md.
Implement a REST endpoint for user registration with TDD."

# Option 4: Run a multi-agent workflow
/task "Use multi-agent-orchestration workflow:
  - Agent 1 (backend-developer): POST /api/auth/register endpoint + unit tests
  - Agent 2 (frontend-developer): RegisterForm component + component tests
  - Agent 3 (testing-engineer): E2E test for full registration flow
  Run Agent 1 and Agent 2 in parallel. Run Agent 3 after both complete.
  Each agent must produce evidence before handoff."
```

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

### Architecture

```
prompt-engineering-library-v2/
|
+-- CORE (start here every session)
|   +-- core/base-programming.md          <- Master prompt: 10 principles + workflows
|   +-- core/error-prevention.md          <- Verification protocol: 7 categories
|   +-- core/multi-agent-orchestration.md <- Parallel execution framework
|   +-- core/prompting-techniques.md      <- CoT, Few-Shot, ReAct techniques
|   +-- core/real-validation.md           <- Evidence rules: no fake "done"
|   +-- core/prompt-anatomy.md            <- 10-component prompt structure  [NEW]
|   +-- core/agentic-safety.md            <- Scope, blocklists, checkpoints  [NEW]
|   +-- core/hooks-guide.md               <- Claude Code lifecycle hooks  [NEW]
|   +-- core/claudemd-guide.md            <- CLAUDE.md creation guide  [NEW]
|
+-- AGENTS (load when you need a specialist)
|   +-- 15 specialized agents (see roster above)
|
+-- WORKFLOWS (orchestrate multi-step processes)
|   +-- workflows/tdd-workflow.md
|   +-- workflows/parallel-development.md
|   +-- workflows/simple-deployment.md    <- Non-technical deploy guide
|   +-- workflows/verification-protocol.md
|   +-- workflows/explore-first.md        <- Codebase investigation protocol  [NEW]
|   +-- workflows/riper-workflow.md       <- Research/Innovate/Plan/Execute/Review  [NEW]
|   +-- workflows/incident-response.md    <- P0-P3 time-boxed incident handling  [NEW]
|   +-- workflows/session-memory.md       <- Cross-session continuity patterns  [NEW]
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
|   +-- quick-ref/slash-commands.md       <- 6 ready-to-use /command definitions  [NEW]
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
{"status": "healthy", "version": "2.0.0"}
```

---

### Related Documents

- [INDEX.md](INDEX.md) — Full navigation by role, task, and situation
- [core/base-programming.md](core/base-programming.md) — Master session prompt
- [core/prompting-techniques.md](core/prompting-techniques.md) — CoT, Few-Shot, ReAct and more
- [core/real-validation.md](core/real-validation.md) — Evidence standards
- [CONTRIBUTING.md](CONTRIBUTING.md) — How to contribute
- [LICENSE](LICENSE) — MIT License

---

<a id="espanol"></a>

## Espanol

> **Resumen Ejecutivo:** Una libreria modular de prompts especializados y definiciones de agentes para desarrollo profesional de software con Claude Code. Aplica cuatro principios innegociables: verificar antes de actuar, desarrollo guiado por tests, especializacion multi-agente, y reportes basados en evidencia, para que cada sesion de Claude Code produzca resultados confiables y auditables.

---

### Referencia Rapida

| Quiero... | Ir a |
|-----------|------|
| Instruir a la IA con el repo | Copiar el prompt de [STANDARD_PROMPT.md](STANDARD_PROMPT.md) + URL del repo |
| Activar toda la metodologia | Copiar un prompt de [ACTIVATION_PROMPT.md](ACTIVATION_PROMPT.md) (3 variantes) |
| Iniciar una nueva sesion | Copiar el prompt condensado de [core/base-programming.md](core/base-programming.md) |
| Usar un agente especialista | Ver la tabla de agentes abajo, luego abrir `agents/<nombre>.md` |
| Ejecutar tareas en paralelo | [core/multi-agent-orchestration.md](core/multi-agent-orchestration.md) |
| Prevenir errores comunes | [core/error-prevention.md](core/error-prevention.md) |
| Validar trabajo completado | [core/real-validation.md](core/real-validation.md) |
| Mejorar la calidad de los prompts | [core/prompting-techniques.md](core/prompting-techniques.md) |
| Hacer deploy (no tecnico) | [workflows/simple-deployment.md](workflows/simple-deployment.md) |
| Revisar usabilidad (no tecnico) | [quick-ref/ux-checklist.md](quick-ref/ux-checklist.md) |
| Navegar todo | [INDEX.md](INDEX.md) |

---

### Que es esta libreria

La libreria provee prompts listos para usar que configuran sesiones de Claude Code con disciplina profesional. En lugar de instrucciones improvisadas, cargas un prompt probado y obtienes inmediatamente una sesion que verifica antes de actuar, escribe tests primero, delega al especialista correcto, y se rehusa a marcar algo como terminado sin evidencia real.

Incluye 15 agentes especialistas, 7 workflows, 3 templates y 9 documentos core. Todo el contenido es agnostico de tecnologia y esta disenado para mantenerse estable en el tiempo.

### Inicio Rapido

```bash
# Opcion 1: Cargar el prompt base al inicio de la sesion
# Copia el bloque condensado de core/base-programming.md y pegalo
# como tu primer mensaje en Claude Code.

# Opcion 2: Usar un slash command (ver quick-ref/slash-commands.md)
/explore                    # Investigar el codebase antes de modificar
/tdd "registro de usuarios" # Ejecutar ciclo TDD para un feature

# Opcion 4: Invocar un agente especifico
/task "Actua como el agente backend-developer definido en agents/backend-developer.md.
Implementa un endpoint REST para registro de usuarios con TDD."

# Opcion 5: Ejecutar un workflow multi-agente
/task "Usa el workflow multi-agent-orchestration:
  - Agente 1 (backend-developer): endpoint POST /api/auth/register + tests unitarios
  - Agente 2 (frontend-developer): componente RegisterForm + tests de componente
  - Agente 3 (testing-engineer): test E2E del flujo completo de registro
  Ejecutar Agente 1 y Agente 2 en paralelo. Ejecutar Agente 3 despues de que ambos terminen.
  Cada agente debe producir evidencia antes del handoff."
```

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

### Documentos Relacionados

- [INDEX.md](INDEX.md) — Navegacion completa por rol, tarea y situacion
- [core/base-programming.md](core/base-programming.md) — Prompt maestro de sesion
- [core/prompting-techniques.md](core/prompting-techniques.md) — CoT, Few-Shot, ReAct y mas
- [core/real-validation.md](core/real-validation.md) — Estandares de evidencia
- [CONTRIBUTING.md](CONTRIBUTING.md) — Como contribuir
- [LICENSE](LICENSE) — Licencia MIT

---

*Last updated / Ultima actualizacion: 2026-03-08 | Version 2.1.0 | MIT License*
