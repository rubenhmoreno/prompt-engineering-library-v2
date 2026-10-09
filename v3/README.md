# Prompt Engineering Library v3.0

Metodología de desarrollo optimizada para Claude Code. 7 archivos en lugar de 73.

## Estructura

```
CLAUDE.md                          ← Core (se carga automáticamente)
AGENTS.md                          ← Referencia de agentes y mapeo
.claude/commands/
  tdd.md                           ← /tdd — Test-Driven Development
  verify.md                        ← /verify — Verificación con evidencia
  security-audit.md                ← /security-audit — Auditoría OWASP
  incident.md                      ← /incident — Respuesta a incidentes
  decompose.md                     ← /decompose — Descomposición de tareas
```

## Instalación

### Opción A: Proyecto existente (copiar archivos)

```bash
# Copiar CLAUDE.md a la raíz de tu proyecto
cp CLAUDE.md /ruta/a/tu/proyecto/

# Copiar slash commands
cp -r .claude/ /ruta/a/tu/proyecto/.claude/
```

### Opción B: Global (para todas las sesiones)

```bash
# System prompt global
cp CLAUDE.md ~/.claude/CLAUDE.md

# Slash commands globales (disponibles en todos los proyectos)
mkdir -p ~/.claude/commands
cp .claude/commands/*.md ~/.claude/commands/
```

### Opción C: Con prompt caching (90% reducción de costos)

```bash
claude --append-system-prompt-file CLAUDE.md
```

## Uso

```bash
# Sesión normal — CLAUDE.md se carga automáticamente
claude

# Activar TDD
/tdd

# Verificar trabajo completado
/verify

# Auditoría de seguridad
/security-audit

# Responder a un incidente
/incident

# Descomponer tarea compleja
/decompose
```

## Principios de diseño

### Por qué 7 archivos y no 73

1. **Claude Code ya sabe** — El 60% del contenido de v2 (read before modify, no time estimates, parallel tools, no over-engineering, security defaults) ya está en el system prompt nativo de Claude Code. Repetirlo desperdicia tokens y genera ruido.

2. **Subagents nativos** — Los 19 agentes de v2 se mapean a 9 subagent_types reales de Claude Code. No necesitás definir un "backend-developer" cuando `fullstack-developer` ya existe como agente nativo con tools reales.

3. **Herramientas nativas** — `EnterPlanMode` reemplaza la fase P de RIPER. `TaskCreate` reemplaza la descomposición manual. `EnterWorktree` reemplaza la gestión manual de worktrees.

4. **Solo valor agregado** — Cada línea en CLAUDE.md existe porque Claude Code NO la tiene nativamente: TDD obligatorio, evidencia verificable, presets de orquestación, quality gates.

### Qué se eliminó y por qué

| Eliminado | Razón |
|-----------|-------|
| 10 principios de base-programming | 7 de 10 ya están en Claude Code nativo |
| coding-discipline (10 reglas) | Todas están en el system prompt de Claude Code |
| prompt-anatomy (10 componentes) | Aplica a prompting general, no a Claude Code |
| error-prevention (7 categorías) | Cubierto por debugging + verify |
| real-validation (8 reglas) | Condensado en sección de evidencia |
| 19 archivos de agentes | Mapeados a 9 subagent_types en AGENTS.md |
| 12 archivos de workflows | Condensados en 5 slash commands |
| Templates (3 archivos) | Integrados en /decompose y /verify |
| Examples (2 archivos) | Referencia histórica, no operacional |
| Quick-ref (6 archivos) | Condensados en AGENTS.md |
| RIPER workflow | Plan mode nativo + /decompose |
| session-memory, dream-consolidation | Claude Code maneja contexto automáticamente |
| explore-first | `Explore` subagent es nativo |

### Herramientas nativas que se integran

| Herramienta | Reemplaza en v2 |
|------------|----------------|
| `EnterPlanMode` | RIPER fase P (Plan) |
| `TaskCreate/TaskUpdate` | templates/task-decomposition.md |
| `EnterWorktree` | workflows/parallel-development.md (worktrees) |
| `Skill /commit` | agents/git-workflow-manager.md |
| `WebSearch` | Investigación manual |
| `ToolSearch` | Acceso a Google Drive, Gmail, Calendar, Claude Docs |
| `AskUserQuestion` | Clarificación manual |
| `Task` con subagent_types | Los 19 agentes custom |

## Migración desde v2

Si venís de la v2, la transición es directa:

1. Reemplazá tu `ACTIVATION_PROMPT` o `STANDARD_PROMPT` por `CLAUDE.md`
2. Copiá los archivos de `.claude/commands/` a tu proyecto
3. Los 19 agentes se usan ahora a través del Task tool con los subagent_types listados en `AGENTS.md`
4. `/tdd`, `/verify`, `/security-audit`, `/incident`, `/decompose` reemplazan los workflows individuales
5. `EnterPlanMode` reemplaza RIPER. `TaskCreate` reemplaza task-decomposition manual

## Compatibilidad

- **Claude Code CLI**: Soporte completo
- **Claude.ai web**: Pegar CLAUDE.md como primer mensaje (sin slash commands)
- **Otros modelos**: No soportado en v3 (usar v2 para modelo-agnóstico)
