Modo descomposición activado. Dividir la tarea en subtareas ejecutables antes de implementar.

## Clasificar primero

```
¿Qué tipo de tarea es?
├─ Depth-first: una pregunta, múltiples ángulos → agentes compitiendo con restricciones diferentes
├─ Breadth-first: subtareas independientes → agentes paralelos, cada uno con un stream
└─ Straightforward: tarea enfocada → un solo agente, sin overhead de orquestación
```

## Formato de descomposición

```
Tarea: [reformular la tarea original en una oración]

Subtareas:
ID  | Descripción                    | Depende de | subagent_type
T1  | [acción específica y acotada]  | ninguna    | fullstack-developer
T2  | [acción específica y acotada]  | T1         | testing-specialist
T3  | [acción específica y acotada]  | ninguna    | database-expert
T4  | [acción específica y acotada]  | T2, T3     | fullstack-developer

Paralelismo:
- T1 y T3 pueden ejecutarse simultáneamente (sin dependencias compartidas)
- T4 debe esperar a T2 y T3

Ruta crítica: T1 → T2 → T4

Contratos (interfaces que cada subtarea debe respetar):
T1 produce: [artefacto exacto o shape de API]
T3 produce: [artefacto exacto o shape de datos]
T4 consume: [lo que espera de T2 y T3]
```

## Reglas
- Cada subtarea debe ser completable en una sesión
- Cada subtarea debe tener criterio binario: hecho / no hecho
- Definir contratos ANTES de que cualquier subtarea empiece
- Usar `TaskCreate` para registrar cada subtarea con dependencias
- NO empezar implementación hasta que el usuario apruebe la descomposición
- Lanzar agentes paralelos en UN solo mensaje con el Task tool
