# Task Decomposition Template
## Descomposición de Tareas Complejas en Subtareas Manejables

**Propósito:** Dividir requisitos complejos en subtareas específicas, asignables y verificables
**Usar cuando:** Feature grande, proyecto nuevo, múltiples componentes involucrados

---

## 📋 Template

```markdown
# Descomposición de Tarea: [NOMBRE DEL FEATURE/PROYECTO]

## 1. Requisito Original

**Descripción del usuario:**
[Copiar textualmente lo que pidió el usuario]

**Contexto:**
[Información adicional relevante]

**Criterios de aceptación (si especificados):**
- [ ] [Criterio 1]
- [ ] [Criterio 2]
- [ ] [Criterio 3]

---

## 2. Análisis de Componentes

**Componentes identificados:**

### Frontend
- [ ] [Componente UI 1]
- [ ] [Componente UI 2]
- [ ] [...]

### Backend
- [ ] [API endpoint 1]
- [ ] [API endpoint 2]
- [ ] [Servicio/lógica 1]
- [ ] [...]

### Base de Datos
- [ ] [Tabla/schema 1]
- [ ] [Migration 1]
- [ ] [...]

### Testing
- [ ] [Unit tests]
- [ ] [Integration tests]
- [ ] [E2E tests]

### DevOps/Deployment
- [ ] [Configuración 1]
- [ ] [Script 1]
- [ ] [...]

### Documentación
- [ ] [README update]
- [ ] [API docs]
- [ ] [...]

---

## 3. Mapa de Dependencias

```
graph TD
    A[Tarea A] --> C[Tarea C]
    B[Tarea B] --> C
    C --> D[Tarea D]
    C --> E[Tarea E]
    D --> F[Tarea F]
    E --> F
```

**Descripción de dependencias:**
- Tarea C depende de A y B (esperar a que ambas terminen)
- Tareas A y B pueden ejecutarse en paralelo
- Tarea F requiere D y E completadas

---

## 4. Subtareas Detalladas

### GRUPO 1: Fundación (Pueden ejecutarse en paralelo)

#### Subtarea 1.1: [Nombre]
**Agente:** [Backend Developer / Frontend Developer / etc.]
**Tiempo estimado:** [X horas]
**Dependencias:** Ninguna

**Descripción:**
[Qué debe hacerse específicamente]

**Input:**
[Qué información/archivos necesita]

**Output esperado:**
[Qué debe producir - archivos, código, documentación]

**Criterios de completitud:**
- [ ] [Criterio verificable 1]
- [ ] [Criterio verificable 2]
- [ ] [Tests pasan]
- [ ] [Documentado]

**Evidencia requerida:**
- [ ] Output de comando X
- [ ] Screenshot de Y
- [ ] Test coverage >80%

---

#### Subtarea 1.2: [Nombre]
**Agente:** [...]
**Tiempo estimado:** [X horas]
**Dependencias:** Ninguna

[... misma estructura]

---

### GRUPO 2: Core Features (Depende de GRUPO 1)

#### Subtarea 2.1: [Nombre]
**Agente:** [...]
**Tiempo estimado:** [X horas]
**Dependencias:** Subtarea 1.1, 1.2

[... misma estructura]

---

### GRUPO 3: Integration & Testing (Depende de GRUPO 2)

[... continuar]

---

### GRUPO 4: Deployment (Depende de GRUPO 3)

[... continuar]

---

## 5. Contratos de Interfaz

**Definir interfaces ANTES de desarrollo paralelo:**

### API Contract: [Nombre del endpoint]
```yaml
POST /api/resource
  Request:
    - field1: type (required/optional)
    - field2: type (required/optional)
  Response:
    - 200 OK: { schema }
    - 400 Bad Request: { error }
    - 401 Unauthorized: { error }
```

### Data Contract: [Nombre de la estructura]
```typescript
interface DataStructure {
  id: number;
  name: string;
  created_at: Date;
}
```

### Component Props Contract:
```typescript
interface ComponentProps {
  data: DataStructure[];
  onSelect: (id: number) => void;
  loading?: boolean;
}
```

---

## 6. Estrategia de Ejecución

**Orden recomendado:**

```
Día 1:
  └─ GRUPO 1 (paralelo) - Fundación
     Agentes: Backend, Frontend, DevOps
     Duración: 4 horas
     Sincronización: Al final del día

Día 2:
  └─ GRUPO 2 (paralelo) - Core Features
     Agentes: Backend, Frontend
     Duración: 6 horas
     Sincronización: Al final del día

Día 3:
  └─ GRUPO 3 (paralelo) - Testing
     Agentes: Testing, Backend (fixes)
     Duración: 4 horas

  └─ GRUPO 4 (secuencial) - Deploy
     Agente: DevOps
     Duración: 2 horas
```

**Tiempo total estimado:** [X días / Y horas]
**Puntos de sincronización:** [Final de cada grupo]

---

## 7. Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|-----------|
| [Riesgo 1] | Alta/Media/Baja | Alto/Medio/Bajo | [Estrategia de mitigación] |
| [Riesgo 2] | ... | ... | ... |

---

## 8. Definición de "Done"

Una subtarea está completada cuando:
- [ ] Código implementado y commiteado
- [ ] Tests escritos y pasando (coverage >80%)
- [ ] Code review aprobado (si aplica)
- [ ] Documentación actualizada
- [ ] Evidencia documentada (según Verification Protocol)
- [ ] Integración verificada (si depende de otras tareas)
- [ ] No rompe funcionalidad existente (regression tests)

El feature completo está "Done" cuando:
- [ ] TODAS las subtareas completadas
- [ ] Tests E2E pasando
- [ ] Performance aceptable
- [ ] Seguridad revisada
- [ ] Accesibilidad verificada (si UI)
- [ ] Deployado a staging
- [ ] Aprobado por stakeholder
- [ ] Documentación de usuario creada

---

## 9. Checklist Pre-Ejecución

Antes de comenzar desarrollo:
- [ ] Todas las subtareas identificadas
- [ ] Dependencias mapeadas
- [ ] Agentes asignados
- [ ] Contratos de interfaz definidos
- [ ] Riesgos identificados
- [ ] Tiempo estimado por subtarea
- [ ] Puntos de sincronización establecidos
- [ ] Criterios de "Done" claros

---

## 10. Tracking

| Subtarea | Agente | Estado | Inicio | Fin | Evidencia |
|----------|--------|--------|--------|-----|-----------|
| 1.1 | Backend | Pending | - | - | - |
| 1.2 | Frontend | Pending | - | - | - |
| 2.1 | Backend | Pending | - | - | - |
| ... | ... | ... | ... | ... | ... |

**Estados:** Pending → In Progress → Review → Done

---
```

---

## 📝 Ejemplo Completo: E-commerce Cart Feature

```markdown
# Descomposición de Tarea: Sistema de Carrito de Compras

## 1. Requisito Original

**Descripción del usuario:**
"Necesito implementar un carrito de compras donde los usuarios puedan agregar productos, ver el total, modificar cantidades y proceder al checkout"

**Contexto:**
- Ya existe catálogo de productos
- Ya existe sistema de autenticación
- Integración con Stripe para pagos

**Criterios de aceptación:**
- [ ] Usuario puede agregar producto al carrito
- [ ] Usuario puede ver items en el carrito
- [ ] Usuario puede modificar cantidades
- [ ] Usuario puede eliminar items
- [ ] Se calcula total automáticamente
- [ ] Puede proceder a checkout
- [ ] Carrito persiste entre sesiones

---

## 2. Análisis de Componentes

### Frontend
- [ ] CartIcon component (navbar)
- [ ] CartDrawer component (panel lateral)
- [ ] CartItem component (item individual)
- [ ] CartSummary component (total, taxes, shipping)
- [ ] AddToCartButton component
- [ ] QuantitySelector component

### Backend
- [ ] POST /api/cart/items - Agregar item
- [ ] GET /api/cart - Obtener carrito
- [ ] PUT /api/cart/items/:id - Actualizar cantidad
- [ ] DELETE /api/cart/items/:id - Eliminar item
- [ ] GET /api/cart/summary - Calcular totales
- [ ] CartService (lógica de negocio)

### Base de Datos
- [ ] Tabla cart_items (id, user_id, product_id, quantity, created_at)
- [ ] Migration para crear tabla
- [ ] Índices (user_id, product_id)

### Testing
- [ ] Unit tests: CartService
- [ ] Integration tests: Cart API endpoints
- [ ] Component tests: CartDrawer, CartItem
- [ ] E2E test: Flujo completo de agregar → modificar → checkout

### DevOps
- [ ] Actualizar docker-compose con variables de entorno
- [ ] CI/CD: agregar tests de cart

### Documentación
- [ ] API docs: endpoints de cart
- [ ] README: cómo usar el carrito

---

## 3. Mapa de Dependencias

```
graph TD
    A[DB Schema] --> B[Backend API]
    A --> C[Backend Tests]
    D[Design System] --> E[Frontend Components]
    B --> E
    E --> F[Component Tests]
    B --> G[Integration Tests]
    F --> H[E2E Tests]
    G --> H
    H --> I[Deploy]
```

---

## 4. Subtareas Detalladas

### GRUPO 1: Fundación

#### Subtarea 1.1: DB Schema & Migration
**Agente:** Backend Developer
**Tiempo estimado:** 1 hora
**Dependencias:** Ninguna

**Descripción:**
Crear tabla cart_items y migration

**Input:**
- Esquema de DB existente (users, products)

**Output esperado:**
```sql
CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);
CREATE INDEX idx_cart_user ON cart_items(user_id);
```

**Criterios de completitud:**
- [ ] Migration creada
- [ ] Migration ejecutada en dev
- [ ] Tabla existe con índices
- [ ] Constraints funcionando

**Evidencia requerida:**
```bash
\dt cart_items
\d cart_items
SELECT * FROM cart_items LIMIT 1;
```

---

#### Subtarea 1.2: Design CartDrawer UI
**Agente:** UI/UX Specialist
**Tiempo estimado:** 1.5 horas
**Dependencias:** Ninguna

**Descripción:**
Especificar diseño del CartDrawer (panel lateral)

**Output esperado:**
```markdown
# CartDrawer Specification

Layout:
- Slide from right
- Width: 400px (desktop), 100% (mobile)
- Header: "Your Cart" + Close button
- Body: List of CartItems (scrollable)
- Footer: CartSummary + "Checkout" button

States:
- Empty: "Your cart is empty" message
- Loading: Skeleton loaders
- Error: Error message + Retry button
- Filled: Show items

Animations:
- Slide in: 200ms ease-out
- Item add: fade + slide 150ms
```

---

### GRUPO 2: Core Features (Depende de GRUPO 1)

#### Subtarea 2.1: Backend Cart API
**Agente:** Backend Developer
**Tiempo estimado:** 3 horas
**Dependencias:** 1.1 (DB Schema)

**Descripción:**
Implementar endpoints de cart

**Output esperado:**
```python
# Endpoints implementados:
POST   /api/cart/items
GET    /api/cart
PUT    /api/cart/items/:id
DELETE /api/cart/items/:id

# + CartService con lógica
# + Unit tests (coverage >80%)
```

**Criterios de completitud:**
- [ ] 4 endpoints funcionando
- [ ] Validación de inputs
- [ ] Error handling
- [ ] Tests unitarios pasan
- [ ] Documentación API

**Evidencia requerida:**
```bash
curl -X POST http://localhost:8000/api/cart/items ...
pytest tests/test_cart_service.py -v --cov
```

---

#### Subtarea 2.2: Frontend Cart Components
**Agente:** Frontend Developer
**Tiempo estimado:** 4 horas
**Dependencias:** 1.2 (Design), 2.1 (API - puede usar mocks)

**Descripción:**
Implementar componentes de carrito

**Output esperado:**
```typescript
// Componentes implementados:
- CartIcon.tsx (navbar)
- CartDrawer.tsx (panel)
- CartItem.tsx (item)
- CartSummary.tsx (totales)
- AddToCartButton.tsx

// + Custom hook: useCart()
// + Component tests
```

**Criterios de completitud:**
- [ ] 5 componentes implementados
- [ ] TypeScript sin errores
- [ ] Responsive (mobile + desktop)
- [ ] Accesibilidad (ARIA labels)
- [ ] Tests de componentes pasan

---

### GRUPO 3: Integration & Testing

#### Subtarea 3.1: E2E Test - Cart Flow
**Agente:** Testing Engineer
**Tiempo estimado:** 2 horas
**Dependencias:** 2.1, 2.2

**Descripción:**
Test del flujo completo de carrito

**Output esperado:**
```typescript
test('complete cart flow', async ({ page }) => {
  // 1. Login
  // 2. Browse products
  // 3. Add to cart
  // 4. Open cart drawer
  // 5. Modify quantity
  // 6. Remove item
  // 7. Proceed to checkout
});
```

---

### GRUPO 4: Deploy

#### Subtarea 4.1: Deploy to Staging
**Agente:** DevOps Engineer
**Tiempo estimado:** 1 hora
**Dependencias:** Todo GRUPO 3

---

## 5. Contratos de Interfaz

### API Contract:

```typescript
POST /api/cart/items
  Request: {
    product_id: number;
    quantity: number; // default 1
  }
  Response: {
    id: number;
    user_id: number;
    product_id: number;
    quantity: number;
    product: {
      name: string;
      price: number;
      image_url: string;
    }
  }

GET /api/cart
  Response: {
    items: CartItem[];
    subtotal: number;
    tax: number;
    total: number;
  }
```

---

## 6. Estrategia de Ejecución

**Día 1:**
- GRUPO 1 (paralelo): DB Schema + Design (2.5h)
- GRUPO 2 start: Backend API (3h)

**Día 2:**
- GRUPO 2 (paralelo): Frontend Components (4h)
- GRUPO 3: Integration tests (2h)

**Día 3:**
- GRUPO 3: E2E tests (2h)
- GRUPO 4: Deploy (1h)

**Tiempo total:** 14.5 horas (~2 días)

---

## 7. Definición de "Done"

Feature completo cuando:
- [ ] Todas las 8 subtareas completadas
- [ ] Tests E2E pasando (flujo completo funciona)
- [ ] Performance <500ms para add to cart
- [ ] Accesibilidad AA compliant
- [ ] Responsive (mobile + tablet + desktop)
- [ ] Deployado a staging
- [ ] API documentada en Swagger
```

---

## 🎯 Cuándo Usar Este Template

✅ **Usar cuando:**
- Feature grande (>1 día de trabajo)
- Múltiples agentes involucrados
- Componentes con dependencias complejas
- Proyecto nuevo desde cero

❌ **No usar cuando:**
- Bug fix simple
- Tarea única y directa
- Solo 1 agente involucrado
- Feature muy pequeña (<2 horas)

---

**Última actualización:** 2025-12-25
