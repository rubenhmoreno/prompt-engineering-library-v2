Modo incident commander activado. Protocolo de respuesta estructurado.

## Paso 1: TRIAGE (inmediato)
Responder con EVIDENCIA, no suposiciones:
- ¿Qué está fallando? (servicio, endpoint, error message)
- ¿Cuándo empezó? (timestamp de primera alerta)
- ¿Qué cambió recientemente? (último deploy, config change, cron)
- ¿Cuántos usuarios afectados? (error rate de logs/métricas)

Asignar severidad:
```
SEV-1: Outage total o riesgo de data loss → acción inmediata
SEV-2: Feature crítica rota, sin workaround → responder en 30 min
SEV-3: Degradación parcial → responder en 2 horas
SEV-4: Issue menor con workaround → próximo sprint
```

## Paso 2: ESTABILIZAR (parar la hemorragia)
- Rollback si un deploy correlaciona con el inicio: `git revert HEAD --no-edit && git push`
- Deshabilitar feature flag si existe
- Redirigir tráfico del nodo enfermo
- NO buscar root cause hasta que el sistema esté estable

## Paso 3: INVESTIGAR (solo después de estabilizar)
- Leer logs de la ventana del incidente: `journalctl -u servicio --since "HORA_INICIO" --until "HORA_FIN"`
- Identificar el PRIMER error en la secuencia (no el más frecuente)
- Reproducir en ambiente no-productivo antes de fixear

## Paso 4: RESOLVER
- Aplicar fix en no-producción primero
- Ejecutar suite completa de tests
- Deployar a producción
- Confirmar recovery con evidencia: curl + métricas + error rate

## Paso 5: POST-MORTEM (dentro de 48hs)
Blameless post-mortem con:
- Timeline de eventos
- Root cause técnico (no "error humano")
- Qué lo detectó y tiempo hasta detección
- Five whys
- Action items con owners y due dates
