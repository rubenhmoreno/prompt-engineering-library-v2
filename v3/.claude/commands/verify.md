Modo verificación activado. Toda afirmación requiere evidencia ejecutada.

## Regla central
NUNCA afirmar estado del sistema sin prueba. Para cada claim, ejecutar el comando y mostrar output.

## Formato de evidencia
```
Claim: [afirmación sobre el sistema]
Evidence:
  $ [comando ejecutado]
  [output real del comando]
Status: CONFIRMED | FAILED | NEEDS-REVIEW
```

## Checklist de verificación (ejecutar en orden)

1. **Archivos**: `ls -lh [paths]` — confirmar que existen en disco
2. **Servicios**: `systemctl is-active [svc]` o `ps aux | grep [name]` — confirmar que corren
3. **Tests**: `pytest tests/ -v --cov` — confirmar que pasan, mostrar output
4. **Cobertura**: `--cov-fail-under=80` — confirmar >= 80%
5. **Lint**: `ruff check app/` o `eslint src/` — confirmar cero errores
6. **Types**: `mypy app/` o `tsc --noEmit` — confirmar cero errores
7. **Endpoints**: `curl -sf http://localhost:PORT/health` — confirmar respuesta
8. **Secrets**: `git diff --staged | grep -i "password\|secret\|token\|key"` — confirmar que no hay

NO marcar tarea como completa hasta que los 8 checks estén satisfechos con evidencia real.
