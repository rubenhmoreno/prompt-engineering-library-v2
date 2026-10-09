Modo auditoría de seguridad activado. Seguir las 5 fases en orden.

## Fase 1: RECONOCIMIENTO
- Mapear superficie de ataque: endpoints, puertos, servicios expuestos
- Identificar stack tecnológico y versiones
- Revisar configuración de acceso y autenticación
- Output: tabla de superficie con [componente, puerto, autenticación, exposición]

## Fase 2: ANÁLISIS DE VULNERABILIDADES
Evaluar contra OWASP Top 10 (2021):

| # | Check | Comando/Acción |
|---|-------|---------------|
| A01 | Broken Access Control | ¿Auth check antes de cada operación sensible? ¿IDOR posible? |
| A02 | Cryptographic Failures | ¿Passwords con bcrypt/argon2? ¿TLS en tránsito? ¿Datos sensibles cifrados? |
| A03 | Injection | ¿Queries parametrizadas? ¿Input sanitizado? ¿Output encoded? |
| A04 | Insecure Design | ¿Rate limiting en auth? ¿Threat model documentado? |
| A05 | Security Misconfiguration | ¿Default creds cambiadas? ¿Stack traces ocultos en prod? |
| A06 | Vulnerable Components | `pip audit` / `npm audit` / `cargo audit` |
| A07 | Auth Failures | ¿Sessions invalidadas en logout? ¿MFA disponible? ¿Brute-force protection? |
| A08 | Integrity Failures | ¿Lockfiles commiteados? ¿CI/CD con acceso restringido? |
| A09 | Logging Failures | ¿Auth failures loggeados? ¿Logs inmutables? |
| A10 | SSRF | ¿User input en HTTP requests salientes? ¿Allowlist de URLs? |

## Fase 3: CLASIFICACIÓN
Para cada hallazgo:
- CVSS score (0-10)
- CWE ID correspondiente
- Severidad: CRITICAL / HIGH / MEDIUM / LOW / INFO
- Sin evidencia concreta → marcar como [THEORETICAL]

## Fase 4: REMEDIACIÓN
- Quick wins (implementar inmediatamente)
- Plan de hardening (próxima iteración)
- Cambios de arquitectura (planificar con `EnterPlanMode`)

## Fase 5: REPORTE
Tabla de hallazgos:
```
| # | Hallazgo | OWASP | CVSS | CWE | Estado | Evidencia | Remediación |
```

Reglas: scope autorizado requerido | sin evidencia = [THEORETICAL] | siempre CVSS + CWE
