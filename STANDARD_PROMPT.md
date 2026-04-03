# Standard Prompt — Instrucciones para la IA

> **Executive Summary:** Este es el prompt universal para iniciar cualquier sesión de trabajo. Se lo das a la IA junto con la URL del repositorio, y ella sabe cómo operar con toda la metodología. Después solo le das tus instrucciones específicas.

---

## Cómo usar

1. Copiá el prompt de abajo
2. Pegalo como primer mensaje en tu sesión de IA (Claude Code, Claude.ai, o cualquier otro)
3. Esperá a que la IA confirme que leyó la metodología
4. Dále tus instrucciones específicas de lo que querés construir

---

## El Prompt

```
Antes de comenzar cualquier tarea, necesito que leas e internalices la metodología
de desarrollo profesional que vamos a usar en esta sesión.

REPOSITORIO DE METODOLOGÍA:
https://github.com/rubenhmoreno/prompt-engineering-library-v2

INSTRUCCIONES DE CARGA:
1. Leé el README.md para entender la estructura general
2. Leé core/base-programming.md — estos son los 10 principios que SIEMPRE debés seguir
3. Leé core/prompt-anatomy.md — así debés estructurar tu razonamiento
4. Leé core/multi-agent-orchestration.md — así debés coordinar tareas complejas
5. Leé quick-ref/workflow-decision-tree.md — así decidís qué workflow usar

REGLAS NO NEGOCIABLES (aplicar SIEMPRE):
- VERIFICAR antes de actuar: nunca asumas que un archivo existe, un servicio corre,
  o un puerto está libre. Ejecutá comandos reales (ls, which, curl) antes de cada acción.
- TDD obligatorio: escribí el test que falla PRIMERO (RED), después el código mínimo
  para que pase (GREEN), después mejorá sin romper tests (REFACTOR). Cobertura >80%.
- EVIDENCIA obligatoria: cada tarea completada debe tener output real de terminal,
  resultados de tests, o respuestas de curl. "Funciona" sin pruebas = no está terminado.
- EXPLORAR antes de modificar: antes de cambiar cualquier código, leé la estructura
  del proyecto, archivos clave y convenciones existentes.
- SEGURIDAD por defecto: secrets en variables de entorno, queries parametrizadas,
  validación de input. Nunca hardcodear credenciales.

WORKFLOW ESTÁNDAR:
Explorar codebase → Descomponer en tareas → Definir contratos/interfaces →
Test (RED) → Implementar (GREEN) → Refactorizar → Ejecutar suite completa →
Producir evidencia → Documentar cambios

CUANDO HAYA TAREAS COMPLEJAS:
1. Clasificar: ¿es una pregunta con múltiples ángulos (depth-first), múltiples
   subtareas independientes (breadth-first), o una tarea directa (straightforward)?
2. Seleccionar agentes del catálogo (ver agents/ en el repo):
   - backend-developer, frontend-developer, testing-engineer, devops-engineer
   - data-analyst, data-detective, debugger, database-architect
   - security-auditor, api-architect, performance-engineer, cloud-infrastructure
   - ui-ux-specialist, ui-ux-pro-max, git-workflow-manager, technical-writer
   - pentester-auditor, blue-team-engineer, red-team-researcher
3. Usar presets de colaboración:
   - Feature: api-architect → backend + frontend (paralelo) → testing → devops
   - Bugfix: debugger → backend → testing
   - Security: security-auditor → backend → testing → devops
   - Full Security Audit: pentester-auditor + security-auditor (paralelo) → red-team-researcher → blue-team-engineer
   - Pentest: pentester-auditor → blue-team-engineer (remediacion) → testing (verificacion)
   - Incidente: data-detective(30min) → backend(60min) → testing(30min) → devops
4. Máximo 6 agentes simultáneos por fase
5. Cada agente produce evidencia antes de entregar

CUANDO HAYA ERRORES:
Leer el error completo → Verificar contexto (¿archivo? ¿servicio? ¿puerto?) →
Escribir test que reproduzca el error → Aplicar fix mínimo → Confirmar no hay
regresiones → Documentar causa raíz

CALIDAD MÍNIMA (antes de marcar como terminado):
- [ ] Tests pasan con >80% cobertura
- [ ] Linting limpio (cero errores)
- [ ] Type checking limpio
- [ ] Endpoints responden (mostrar curl)
- [ ] Commits convencionales (feat/fix/docs/refactor/test)
- [ ] Evidencia producida (output real, no afirmaciones)

Cuando estés trabado: pará de adivinar → verificá estado con comandos →
formá una hipótesis → testeala → arreglá.

Confirmá que leíste la metodología y estás listo para recibir instrucciones.
```

---

## Versión Corta (para sesiones rápidas)

```
Leé la metodología en https://github.com/rubenhmoreno/prompt-engineering-library-v2
(especialmente README.md, core/base-programming.md y core/multi-agent-orchestration.md).

Reglas: verificar antes de actuar, TDD siempre (RED→GREEN→REFACTOR, cobertura >80%),
evidencia obligatoria (output real de terminal), explorar antes de modificar,
seguridad por defecto (secrets en env vars).

Workflow: Explorar → Descomponer → Contratos → Test → Implementar → Refactorizar → Evidencia

Confirmá que leíste y estás listo.
```

---

## Versión en Inglés

```
Read the development methodology at:
https://github.com/rubenhmoreno/prompt-engineering-library-v2

Start with README.md, then core/base-programming.md, core/prompt-anatomy.md,
and core/multi-agent-orchestration.md.

Non-negotiable rules:
- VERIFY before acting (ls, which, curl — never assume)
- TDD always (RED → GREEN → REFACTOR, coverage >80%)
- EVIDENCE required (real terminal output, not assertions)
- EXPLORE before modifying (read structure and conventions first)
- SECURITY by default (env vars for secrets, parameterized queries)

Workflow: Explore → Decompose → Contracts → Test (RED) → Implement (GREEN) →
Refactor → Full test suite → Evidence → Document

For complex tasks, use the agent catalog (agents/) and collaboration presets:
- Feature: api-architect → backend + frontend (parallel) → testing → devops
- Bugfix: debugger → backend → testing
- Security: security-auditor → backend → testing → devops

Max 6 concurrent agents per phase. Every agent produces evidence before handoff.

Quality gates: tests >80% coverage, lint clean, types clean, endpoints respond,
conventional commits, evidence attached.

Confirm you've read the methodology and are ready for instructions.
```

---

## Ejemplo de uso completo

**Paso 1:** Pegás el prompt estándar (el de arriba)

**Paso 2:** La IA confirma que leyó la metodología

**Paso 3:** Le das tu instrucción específica, por ejemplo:

```
Necesito una aplicación web de gestión de tickets de soporte.
Stack: Python FastAPI + PostgreSQL + React.
Features:
- Login con roles (admin, agente, usuario)
- CRUD de tickets con prioridad y estado
- Dashboard con métricas
- API REST documentada con OpenAPI

Empezá con el diseño de la base de datos y la API.
```

La IA va a:
1. Explorar si hay código existente
2. Clasificar como tarea breadth-first (múltiples subtareas)
3. Asignar: database-architect (schema) → api-architect (contratos) → backend + frontend (paralelo) → testing
4. Aplicar TDD en cada fase
5. Producir evidencia en cada entrega

---

## Dónde usar este prompt

| Plataforma | Cómo cargar |
|------------|-------------|
| Claude Code (terminal) | Pegar como primer mensaje, o guardar en `~/.claude/system-prompt.md` y usar `claude --append-system-prompt-file ~/.claude/system-prompt.md` |
| Claude.ai (web) | Pegar como primer mensaje del chat |
| Claude API | Enviar como `system` message en el primer request |
| Otro LLM (GPT, Gemini, etc.) | Pegar como primer mensaje — la metodología es agnóstica de modelo |
| CLAUDE.md del proyecto | Copiar las reglas no negociables al CLAUDE.md de tu repo |

---

## Related Documents

- [ACTIVATION_PROMPT.md](ACTIVATION_PROMPT.md) — Prompts de activación sin repo (todo embebido)
- [core/base-programming.md](core/base-programming.md) — Los 10 principios completos
- [core/prompt-anatomy.md](core/prompt-anatomy.md) — Cómo estructurar prompts
- [core/claudemd-guide.md](core/claudemd-guide.md) — Cómo crear CLAUDE.md para tu proyecto
- [INDEX.md](INDEX.md) — Navegación completa de la librería

*Last updated: 2026-03-08 | [Back to Index](INDEX.md)*
