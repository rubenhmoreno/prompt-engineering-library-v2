# Agentes — Referencia Rápida

Guía de decisión para seleccionar el agente correcto en cada situación.

---

## Árbol de Decisión

```
¿Qué necesitás hacer?
│
├─ Entender código existente ──────────────── Explore
├─ Planificar implementación ──────────────── Plan
├─ Desarrollar feature (backend/frontend) ─── fullstack-developer
├─ Escribir o debuggear tests ─────────────── testing-specialist
├─ Analizar datos o métricas ──────────────── data-analyst
├─ Investigar tema técnico/académico ──────── research-specialist
├─ Optimizar queries o diseñar schema ─────── database-expert
├─ Ejecutar comandos de sistema ───────────── Bash
├─ Auditar seguridad ──────────────────────── research-specialist + testing-specialist
├─ Tarea multi-step genérica ──────────────── general-purpose
└─ No estoy seguro ───────────────────────── general-purpose
```

## Tabla Completa

| subagent_type | Especialidad | Tools | Output esperado |
|--------------|-------------|-------|----------------|
| `Explore` | Exploración de codebase, búsqueda de patrones, entender arquitectura | Read, Grep, Glob | Mapa de estructura, archivos relevantes, convenciones |
| `Plan` | Diseño de implementación, tradeoffs, planes multi-archivo | Read, Grep, Glob | Plan paso a paso, archivos críticos, riesgos |
| `fullstack-developer` | Python/FastAPI, frontend, seguridad, documentación | Read, Write, Edit, Bash, Grep, Glob, LS | Código implementado, endpoints, componentes |
| `testing-specialist` | Tests unitarios/integración, debugging, cobertura | Read, Write, Bash, Grep, Glob | Suite de tests, coverage report |
| `data-analyst` | Insights, análisis preventivo, visualización | Read, Write, Edit, Bash, Grep, Glob | Análisis, gráficos, recomendaciones |
| `research-specialist` | Investigación, NLP, análisis no estructurado | Read, Write, WebFetch, WebSearch, Grep, Glob | Informe de investigación, hallazgos |
| `database-expert` | SQL, migraciones, optimización de queries | Read, Write, Bash, Grep | Queries optimizadas, esquemas, migraciones |
| `general-purpose` | Búsquedas complejas, tareas multi-step | Todos | Variable según tarea |
| `Bash` | Git, Docker, comandos de sistema | Bash | Output de terminal |

## Mapeo de Agentes Legacy → Nativos

La librería v2 definía 19 agentes especializados. En Claude Code v3, se mapean así:

| Agente v2 | subagent_type v3 | Notas |
|-----------|-----------------|-------|
| backend-developer | `fullstack-developer` | Desarrollo integral |
| frontend-developer | `fullstack-developer` | Mismo agente cubre ambos |
| api-architect | `Plan` | Diseño de contratos y OpenAPI |
| database-architect | `database-expert` | Mapeo directo |
| testing-engineer | `testing-specialist` | Mapeo directo |
| devops-engineer | `Bash` + `fullstack-developer` | Infra como código + scripts |
| debugger | `Explore` + `testing-specialist` | Diagnóstico + reproducción |
| data-analyst | `data-analyst` | Mapeo directo |
| data-detective | `data-analyst` + `Explore` | Análisis forense de datos |
| ui-ux-specialist | `fullstack-developer` | Con instrucciones de UX |
| ui-ux-pro-max | `fullstack-developer` | Con instrucciones de diseño avanzado |
| security-auditor | `research-specialist` | Con scope OWASP/CWE |
| pentester-auditor | `research-specialist` + `Bash` | Recon + scanning |
| blue-team-engineer | `fullstack-developer` | Hardening + políticas |
| red-team-researcher | `research-specialist` | Threat intelligence + ATT&CK |
| performance-engineer | `data-analyst` + `database-expert` | Profiling + optimización |
| cloud-infrastructure | `Bash` + `fullstack-developer` | Terraform/Pulumi + IaC |
| git-workflow-manager | `Bash` | Git operations directas |
| technical-writer | `research-specialist` | Documentación técnica |

## Prompting por Tipo de Agente

### Agentes con contexto (heredan conversación)
```
Prompt corto y directivo. No repetir contexto.
Ejemplo: "Buscá todos los usos de authenticate_user() en app/.
Reportá como tabla: archivo, línea, si maneja AuthError."
```

### Agentes fresh (subagent_type — sin contexto)
```
Brief completo con 5 secciones:
1. Goal: qué debe lograr (1-2 oraciones)
2. Context: archivos, stack, estructura relevante
3. Constraints: qué NO tocar, límites de scope
4. Expected Output: formato exacto del resultado
5. Verification: comando para verificar el trabajo
```

---

*Prompt Engineering Library v3.0 — Referencia de Agentes*
