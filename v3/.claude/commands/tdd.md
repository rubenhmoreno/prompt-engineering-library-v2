Modo TDD activado. Seguir este ciclo estrictamente para la tarea actual.

## RED — Test que falla
- Escribir UN test que describa el comportamiento esperado.
- Ejecutar y confirmar que falla con el error esperado (implementación faltante, NO error de sintaxis).
- NO escribir código de implementación en esta fase.

## GREEN — Código mínimo
- Escribir el código MÍNIMO para que el test pase.
- Ejecutar suite completa: confirmar que el nuevo test pasa y no hay regresiones.
- NO refactorizar en esta fase.

## REFACTOR — Mejorar sin romper
- Mejorar estructura, nombres, duplicación — sin cambiar comportamiento.
- Ejecutar suite completa después de CADA cambio individual.
- Parar cuando todos los tests pasen y el código sea claro.

## VERIFY — Cobertura
- Ejecutar: `pytest tests/ -v --cov=app --cov-report=term-missing`
- Cobertura >= 80% en módulos modificados.
- Si está por debajo, volver a RED con un test para la rama no cubierta.

## Reglas inquebrantables
- NUNCA saltear RED. Si no podés escribir un test que falle, el requerimiento no es claro — preguntar.
- NUNCA escribir más implementación de la que el test actual exige.
- NUNCA mergear un commit donde cayó la cobertura.
