# Prompt Engineering Library para Claude Code

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/mcapriotti74/prompt-engineering-library/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Documentation](https://img.shields.io/badge/docs-complete-success.svg)](README.md)
[![Quality Score](https://img.shields.io/badge/quality-9.86%2F10-success.svg)](REVIEW.md)

## Sistema de Prompts Multi-Agente con Testing y Verificación

**Creado:** 2025-12-25
**Versión:** 1.0.0
**Propósito:** Librería modular de prompts especializados para desarrollo profesional con Claude Code
**Repositorio:** https://github.com/mcapriotti74/prompt-engineering-library

---

## 📁 Estructura del Proyecto

```
prompt-engineering/
├── README.md                          # Este archivo
├── core/
│   ├── base-programming.md            # Prompt base para programación
│   ├── error-prevention.md            # Prevención de errores (anti-suposiciones)
│   └── multi-agent-orchestration.md   # Orquestación de agentes
├── agents/
│   ├── backend-developer.md           # Agente especializado backend
│   ├── frontend-developer.md          # Agente especializado frontend
│   ├── testing-engineer.md            # Agente de testing y QA
│   ├── devops-engineer.md             # Agente DevOps/deployment
│   ├── data-analyst.md                # Agente análisis de datos
│   └── ui-ux-specialist.md            # Agente UI/UX
├── workflows/
│   ├── tdd-workflow.md                # Test-Driven Development
│   ├── parallel-development.md        # Desarrollo paralelo multi-agente
│   └── verification-protocol.md       # Protocolo de verificación y evidencia
├── templates/
│   ├── task-decomposition.md          # Template descomposición de tareas
│   ├── evidence-report.md             # Template reporte de evidencia
│   └── agent-handoff.md               # Template handoff entre agentes
└── examples/
    ├── case-study-vox-client.md       # Caso de estudio: VOX Client
    └── best-practices-learned.md      # Lecciones aprendidas
```

---

## 🎯 Objetivos

1. **Eliminar suposiciones**: Verificar antes de ejecutar
2. **Testing planificado**: TDD y verificación continua
3. **Multi-agente eficiente**: Paralelización de tareas especializadas
4. **Evidencia documental**: Cada cambio con prueba de funcionamiento
5. **Reproducibilidad**: Workflows repetibles y auditables

---

## 🚀 Inicio Rápido

### Para usar un agente específico:

```bash
# En Claude Code:
/task "Usa el agente backend-developer para implementar API REST"
```

### Para workflow multi-agente:

```bash
# En Claude Code:
/task "Usa parallel-development workflow:
  - Agente 1 (backend): API endpoints
  - Agente 2 (frontend): UI components
  - Agente 3 (testing): Unit tests
  Ejecutar en paralelo"
```

---

## 📚 Principios Fundamentales

### 1. **NO SUPONER - VERIFICAR**
- ✅ Ejecutar `ls`, `file`, `grep` antes de asumir
- ✅ Leer código existente antes de modificar
- ✅ Verificar encoding y line endings
- ❌ Nunca asumir rutas de archivos
- ❌ Nunca asumir estructura sin verificar

### 2. **TESTING FIRST**
- ✅ Escribir tests antes de implementar (TDD)
- ✅ Verificar con ejecución real (no solo linting)
- ✅ Documentar resultados de tests
- ❌ Nunca marcar completado sin evidencia
- ❌ Nunca "asumir que funciona"

### 3. **MULTI-AGENTE ESPECIALIZADO**
- ✅ Un agente = una responsabilidad clara
- ✅ Ejecución paralela cuando sea posible
- ✅ Handoffs documentados entre agentes
- ❌ Nunca mezclar responsabilidades
- ❌ Nunca ejecutar secuencialmente si puede ser paralelo

### 4. **EVIDENCIA OBLIGATORIA**
- ✅ Capturar output de comandos
- ✅ Screenshots de UI cuando aplique
- ✅ Logs de tests pasando
- ✅ Diff de cambios relevantes
- ❌ Nunca reportar sin prueba

---

## 🔧 Configuración Inicial

### Instalar comandos en tu proyecto:

```bash
# Copiar templates a tu proyecto
cp -r prompt-engineering/.claude/commands /tu-proyecto/.claude/

# Hacer disponibles los agentes
git add .claude/
git commit -m "Add prompt engineering agents"
```

### Estructura recomendada en tu proyecto:

```
tu-proyecto/
├── .claude/
│   ├── commands/
│   │   ├── backend.md      # /backend
│   │   ├── frontend.md     # /frontend
│   │   ├── test.md         # /test
│   │   └── verify.md       # /verify
│   └── CLAUDE.md           # Configuración del proyecto
```

---

## 📖 Guías de Uso

### Caso 1: Desarrollo de Feature Completa

```markdown
Prompt inicial:
"Implementar sistema de autenticación JWT usando multi-agente workflow:

Agente 1 (backend-developer):
- Crear endpoints /login, /register, /verify
- Usar bcrypt para passwords
- Generar JWT tokens
- Tests unitarios con pytest

Agente 2 (frontend-developer):
- Formularios login/register en React
- Manejo de tokens en localStorage
- Protected routes
- Tests con React Testing Library

Agente 3 (testing-engineer):
- Tests de integración E2E
- Casos de error (401, 403, 500)
- Performance tests
- Security audit

Ejecutar agentes en paralelo. Reportar evidencia de cada agente."
```

### Caso 2: Debugging con Evidencia

```markdown
"Usar verification-protocol para debug:

1. Reproducir el error (capturar stacktrace)
2. Identificar root cause (no suponer)
3. Proponer fix con test que falla
4. Implementar fix
5. Verificar test pasa
6. Reportar evidencia completa"
```

---

## 🎓 Mejores Prácticas Aprendidas

### De la experiencia VOX Client v2.0.21:

#### ❌ **Errores cometidos:**
1. Crear múltiples versiones (a, b, c, d, e, f, g) sin verificar
2. Asumir encoding UTF-8 funciona en PowerShell Windows
3. Asumir rutas relativas sin verificar estructura
4. No probar sintaxis antes de empaquetar
5. No documentar cambios entre versiones

#### ✅ **Soluciones aplicadas:**
1. **Verificación pre-empaquetado:** `file`, `grep`, estructura manual
2. **Testing de encoding:** Convertir a ASCII + CRLF para Windows
3. **Verificación de rutas:** `Test-Path` con fallback
4. **Versionado semántico:** Letra = tipo de cambio (a=docs, b=permisos, c=syntax, etc.)
5. **CHANGELOG.txt:** Documentar cada cambio

---

## 📊 Métricas de Éxito

### KPIs para evaluar efectividad:

- **Tasa de éxito primer intento:** >80% (vs ~30% sin prompts)
- **Versiones desperdiciadas:** <3 por feature
- **Tests automáticos:** 100% de features con tests
- **Tiempo de debugging:** <20% del tiempo total
- **Evidencia documental:** 100% de tasks completadas

---

## 🌐 Ecosistema

Esta librería es el **CORE** de un ecosistema modular más amplio:

### 📚 prompt-engineering-library (este repo)
**Propósito:** Principios fundamentales, genéricos y estables
**Contenido:**
- Principios universales (TDD, verificación, multi-agente)
- Workflows agnósticos de tecnología
- Agentes base (backend, frontend, testing, etc.)
- Templates de comunicación

**Actualización:** Estable (v1.0 objetivo: 6-12 meses sin cambios)
**Filosofía:** Generic, technology-agnostic, long-lasting

### 🛠️ prompt-engineering-tools (futuro)
**Propósito:** Catálogo de herramientas específicas
**Contenido:**
- Comparaciones de librerías (matplotlib vs plotly vs seaborn)
- Stacks recomendados por caso de uso
- Mejores prácticas por tecnología
- Tool-specific patterns

**Actualización:** Frecuente (mensual)
**Filosofía:** Specific, tool-focused, rapidly-updated

### 📖 prompt-engineering-recipes (futuro)
**Propósito:** Casos de uso completos end-to-end
**Contenido:**
- Recetas por proyecto tipo (e-commerce, data pipeline, etc.)
- Combinación workflow + tools + código ejemplo
- Arquitecturas de referencia
- Troubleshooting guides

**Actualización:** Por demanda
**Filosofía:** Practical, example-driven, production-ready

---

## 🔄 Roadmap

### v1.0 - Core Library (✅ COMPLETADO)
- [x] Estructura base del proyecto
- [x] Principios core (error-prevention, multi-agent-orchestration)
- [x] 7 agentes especializados
- [x] 3 workflows principales (TDD, parallel-development, verification)
- [x] 3 templates (task-decomposition, evidence-report, handoff)
- [x] 2 casos de estudio (VOX Client, best-practices)
- [x] Documentación completa (README, REVIEW, CHANGELOG)
- [x] GitHub publication
- [x] Contribution guidelines
- [x] MIT License

### v1.1 - Community & Automation (Próximo)
- [ ] GitHub Actions CI/CD workflows
- [ ] Issue and PR templates
- [ ] Automated markdown linting
- [ ] Link validation
- [ ] Contributors recognition system

### v1.2 - Expansion (Futuro)
- [ ] Multi-language translations (English, Portuguese)
- [ ] Additional case studies from community
- [ ] Enhanced verification commands library
- [ ] Video tutorials and walkthroughs

### v2.0 - Ecosystem (Largo plazo)
- [ ] Launch prompt-engineering-tools repository
- [ ] Launch prompt-engineering-recipes repository
- [ ] Cross-repository integration
- [ ] Unified search and navigation

---

## 🤝 Contribución

¡Las contribuciones son bienvenidas! Este proyecto se beneficia de la experiencia de la comunidad.

**Por favor lee:** [CONTRIBUTING.md](CONTRIBUTING.md)

### Quick Start para Contribuir

```bash
# Fork el repositorio en GitHub
git clone https://github.com/YOUR_USERNAME/prompt-engineering-library.git
cd prompt-engineering-library

# Crear rama para tu feature
git checkout -b feature/your-feature-name

# Hacer cambios...

# Commit siguiendo Conventional Commits
git commit -m "feat(agents): Add security-audit-agent"

# Push y crear PR
git push origin feature/your-feature-name
```

### Áreas que Necesitan Ayuda

- 📝 Traducciones a otros idiomas
- 📖 Casos de estudio de proyectos reales
- 🔍 Comandos de verificación adicionales
- 🎨 Ejemplos con diferentes tech stacks
- 🐛 Reporte de bugs o documentación poco clara

---

## 📝 Licencia

MIT License - Ver [LICENSE](LICENSE) para detalles

**Resumen:**
- ✅ Uso comercial permitido
- ✅ Modificación permitida
- ✅ Distribución permitida
- ✅ Uso privado permitido
- ⚠️ Sin garantía
- ⚠️ Sin responsabilidad del autor

---

## 📧 Contacto y Soporte

**Mantenedor Principal:** Marcos Capriotti ([@mcapriotti74](https://github.com/mcapriotti74))
**Email:** mc@itecnis.com / mcaprio@gmail.com
**Repositorio:** https://github.com/mcapriotti74/prompt-engineering-library
**Issues:** https://github.com/mcapriotti74/prompt-engineering-library/issues

### Cómo Obtener Ayuda

1. **Documentación:** Revisa README.md y archivos en `/core`, `/workflows`, `/agents`
2. **Ejemplos:** Consulta `/examples` para casos de uso reales
3. **Issues:** Busca en issues cerrados, puede estar respondido
4. **Nueva pregunta:** Abre un issue con label `question`
5. **Email:** Para consultas privadas o colaboraciones

---

## 🙏 Agradecimientos

Este proyecto nació de las lecciones aprendidas en proyectos reales, incluyendo:
- VOX Client v2.0.21 (caso de estudio de errores y soluciones)
- Experiencias con Claude Code en entornos de producción
- Feedback de desarrolladores usando multi-agente workflows

**Inspiración:**
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- Test-Driven Development principles
- Evidence-based software engineering

---

## 📊 Estadísticas del Proyecto

**Última actualización:** 2025-12-25
**Versión:** 1.0.0
**Archivos:** 24 (22 de librería + 2 documentación)
**Líneas de código/docs:** ~14,500
**Agentes:** 7 especializados
**Workflows:** 3 completos
**Templates:** 3 reutilizables
**Casos de estudio:** 2 documentados
**Calidad:** 9.86/10 (5-layer review)
**Licencia:** MIT
**Estado:** ✅ Producción estable

---

**⭐ Si este proyecto te resulta útil, considera darle una estrella en GitHub!**
