# TDD Workflow (Test-Driven Development)
## Desarrollo Guiado por Tests para Calidad y Confianza

**Tipo:** Workflow Metodológico
**Aplicable a:** Backend, Frontend, Data Processing
**Agentes involucrados:** Backend Developer, Frontend Developer, Testing Engineer

---

## 🎯 Objetivo

Desarrollar software de alta calidad escribiendo tests ANTES del código de implementación, asegurando cobertura completa y diseño testeable.

---

## 📋 Ciclo TDD: Red → Green → Refactor

```
┌─────────────────────────────────────────────────────┐
│                  TDD CYCLE                          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. RED (Escribir test que falla)                  │
│     ↓                                               │
│  2. GREEN (Implementar mínimo para pasar)          │
│     ↓                                               │
│  3. REFACTOR (Mejorar código manteniendo tests)    │
│     ↓                                               │
│  4. Repetir                                         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🔴 FASE 1: RED (Escribir Test que Falla)

### Objetivo:
Escribir un test específico para UNA funcionalidad antes de implementarla.

### Proceso:

**1. Definir requisito claramente**
```
Requisito: "El sistema debe poder crear un usuario con email y password"

Desglosar en casos específicos:
- ✅ Crear usuario con datos válidos → SUCCESS
- ❌ Crear usuario sin email → ERROR
- ❌ Crear usuario con email inválido → ERROR
- ❌ Crear usuario con email duplicado → ERROR
- ❌ Crear usuario con password débil → ERROR
```

**2. Escribir test para UN caso**
```python
# tests/test_user_service.py
import pytest
from services.user_service import UserService
from models.user import User

def test_create_user_with_valid_data():
    """
    GIVEN: datos válidos de usuario
    WHEN: se llama a create_user()
    THEN: debe crear el usuario y retornarlo
    """
    # Arrange
    service = UserService()
    email = "test@example.com"
    password = "SecurePass123"

    # Act
    user = service.create_user(email=email, password=password)

    # Assert
    assert user is not None
    assert user.email == email
    assert user.id is not None
    assert user.password != password  # Debe estar hasheado
    assert len(user.password) > 20  # Hash largo
```

**3. Ejecutar test (debe FALLAR)**
```bash
pytest tests/test_user_service.py::test_create_user_with_valid_data -v

# Output esperado:
# FAILED - ImportError: cannot import name 'UserService'
# ✅ CORRECTO - El test falla porque no existe la implementación
```

**4. Verificar que falla por la razón correcta**
```
✅ Falla porque falta implementación (BIEN)
❌ Falla por error de sintaxis (MAL - corregir test)
❌ Falla por import incorrecto (MAL - corregir test)
```

---

## 🟢 FASE 2: GREEN (Implementar Mínimo)

### Objetivo:
Escribir el código MÍNIMO necesario para que el test pase.

### Proceso:

**1. Crear implementación mínima**
```python
# models/user.py
from dataclasses import dataclass
from typing import Optional

@dataclass
class User:
    id: Optional[int]
    email: str
    password: str  # Hasheado


# services/user_service.py
from models.user import User
import bcrypt

class UserService:
    def __init__(self):
        self.users = []  # En memoria por ahora
        self.next_id = 1

    def create_user(self, email: str, password: str) -> User:
        # Hash password
        hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

        # Create user
        user = User(
            id=self.next_id,
            email=email,
            password=hashed.decode()
        )

        self.users.append(user)
        self.next_id += 1

        return user
```

**2. Ejecutar test (debe PASAR)**
```bash
pytest tests/test_user_service.py::test_create_user_with_valid_data -v

# Output esperado:
# PASSED ✅
```

**3. Verificar que pasa por las razones correctas**
```python
# Opcional: agregar prints temporales para verificar
def test_create_user_with_valid_data():
    service = UserService()
    user = service.create_user("test@example.com", "SecurePass123")

    print(f"User ID: {user.id}")
    print(f"User email: {user.email}")
    print(f"Password hashed: {user.password}")

    assert user is not None  # ✅
    assert user.email == "test@example.com"  # ✅
    assert user.password != "SecurePass123"  # ✅
```

**4. NO optimizar todavía**
```
✅ Código funciona y test pasa
⏸️ NO refactorizar ahora
⏸️ NO agregar features extra
⏸️ Esperar a fase REFACTOR
```

---

## 🔵 FASE 3: REFACTOR (Mejorar Código)

### Objetivo:
Mejorar el código SIN romper los tests existentes.

### Proceso:

**1. Identificar code smells**
```python
# Code smells en implementación actual:
# ❌ Almacenamiento en memoria (no persiste)
# ❌ No valida email
# ❌ No valida password strength
# ❌ No maneja duplicados
# ❌ No hay separación de responsabilidades
```

**2. Refactorizar paso a paso**

**Refactor 1: Extraer validación**
```python
# validators/user_validator.py
import re

class UserValidator:
    EMAIL_REGEX = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

    @staticmethod
    def validate_email(email: str) -> bool:
        return re.match(UserValidator.EMAIL_REGEX, email) is not None

    @staticmethod
    def validate_password(password: str) -> tuple[bool, str]:
        if len(password) < 8:
            return False, "Password must be at least 8 characters"
        if not re.search(r'[A-Z]', password):
            return False, "Password must contain uppercase letter"
        if not re.search(r'[0-9]', password):
            return False, "Password must contain number"
        return True, ""


# services/user_service.py (refactorizado)
from models.user import User
from validators.user_validator import UserValidator
import bcrypt

class UserService:
    def __init__(self):
        self.users = []
        self.next_id = 1
        self.validator = UserValidator()

    def create_user(self, email: str, password: str) -> User:
        # Validar email
        if not self.validator.validate_email(email):
            raise ValueError("Invalid email format")

        # Validar password
        is_valid, error = self.validator.validate_password(password)
        if not is_valid:
            raise ValueError(error)

        # Hash password
        hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

        # Create user
        user = User(
            id=self.next_id,
            email=email,
            password=hashed.decode()
        )

        self.users.append(user)
        self.next_id += 1

        return user
```

**3. Ejecutar tests después de CADA refactor**
```bash
pytest tests/test_user_service.py -v

# Debe seguir pasando:
# PASSED ✅

# Si falla después de refactor:
# ❌ Revertir cambios
# ❌ Revisar qué se rompió
# ✅ Arreglar y volver a ejecutar
```

**4. Agregar más tests para casos edge**
```python
def test_create_user_with_invalid_email():
    service = UserService()

    with pytest.raises(ValueError, match="Invalid email"):
        service.create_user("invalid-email", "SecurePass123")

def test_create_user_with_weak_password():
    service = UserService()

    with pytest.raises(ValueError, match="must be at least 8 characters"):
        service.create_user("test@example.com", "weak")

def test_create_user_with_no_uppercase():
    service = UserService()

    with pytest.raises(ValueError, match="must contain uppercase"):
        service.create_user("test@example.com", "lowercase123")
```

**5. Ejecutar suite completa**
```bash
pytest tests/test_user_service.py -v --cov=services

# Output esperado:
# test_create_user_with_valid_data PASSED
# test_create_user_with_invalid_email PASSED
# test_create_user_with_weak_password PASSED
# test_create_user_with_no_uppercase PASSED
#
# Coverage: 95%
```

---

## 🔄 FASE 4: REPETIR (Siguiente Feature)

### Volver a RED para siguiente funcionalidad

**Siguiente requisito:** "El sistema debe poder autenticar un usuario"

**1. RED: Escribir test**
```python
def test_authenticate_user_with_valid_credentials():
    # Arrange
    service = UserService()
    email = "test@example.com"
    password = "SecurePass123"

    # Crear usuario primero
    service.create_user(email, password)

    # Act
    authenticated_user = service.authenticate(email, password)

    # Assert
    assert authenticated_user is not None
    assert authenticated_user.email == email
```

**2. Ejecutar (debe fallar)**
```bash
pytest tests/test_user_service.py::test_authenticate_user_with_valid_credentials -v

# FAILED - AttributeError: 'UserService' has no attribute 'authenticate'
# ✅ Correcto
```

**3. GREEN: Implementar**
```python
class UserService:
    # ... existing code ...

    def authenticate(self, email: str, password: str) -> Optional[User]:
        # Buscar usuario
        user = next((u for u in self.users if u.email == email), None)
        if not user:
            return None

        # Verificar password
        if bcrypt.checkpw(password.encode(), user.password.encode()):
            return user

        return None
```

**4. REFACTOR: Mejorar**
```python
# Extraer a repository
class UserRepository:
    def __init__(self):
        self.users = []

    def save(self, user: User):
        self.users.append(user)

    def find_by_email(self, email: str) -> Optional[User]:
        return next((u for u in self.users if u.email == email), None)


# Service más limpio
class UserService:
    def __init__(self, repository: UserRepository):
        self.repository = repository
        self.validator = UserValidator()
        self.next_id = 1

    def create_user(self, email: str, password: str) -> User:
        # Validaciones...
        user = User(...)
        self.repository.save(user)
        return user

    def authenticate(self, email: str, password: str) -> Optional[User]:
        user = self.repository.find_by_email(email)
        if user and bcrypt.checkpw(password.encode(), user.password.encode()):
            return user
        return None
```

---

## 📊 Checklist TDD

Antes de marcar feature como completa:

- [ ] **RED**: Test escrito y falla por razón correcta
- [ ] **GREEN**: Implementación mínima hace pasar el test
- [ ] **REFACTOR**: Código mejorado sin romper tests
- [ ] **Coverage**: >80% de cobertura
- [ ] **Edge cases**: Casos borde cubiertos
- [ ] **Documentation**: Docstrings en funciones
- [ ] **Commits**: Commits atómicos (1 commit por ciclo RED-GREEN-REFACTOR)

---

## 🎯 Ejemplo Completo: Feature de Inicio a Fin

**Feature:** Sistema de gestión de tareas (TODO list)

### Iteración 1: Crear tarea

**RED:**
```python
def test_create_task():
    service = TaskService()
    task = service.create_task(title="Buy milk")
    assert task.id is not None
    assert task.title == "Buy milk"
    assert task.completed is False
```

**GREEN:**
```python
class TaskService:
    def __init__(self):
        self.tasks = []
        self.next_id = 1

    def create_task(self, title: str) -> Task:
        task = Task(id=self.next_id, title=title, completed=False)
        self.tasks.append(task)
        self.next_id += 1
        return task
```

**REFACTOR:**
```python
# Extraer validación
if not title or len(title.strip()) == 0:
    raise ValueError("Title cannot be empty")
```

### Iteración 2: Completar tarea

**RED:**
```python
def test_complete_task():
    service = TaskService()
    task = service.create_task("Buy milk")

    service.complete_task(task.id)

    updated_task = service.get_task(task.id)
    assert updated_task.completed is True
```

**GREEN:**
```python
def complete_task(self, task_id: int):
    task = next((t for t in self.tasks if t.id == task_id), None)
    if task:
        task.completed = True

def get_task(self, task_id: int) -> Optional[Task]:
    return next((t for t in self.tasks if t.id == task_id), None)
```

**REFACTOR:**
```python
# Extraer a repository
# Agregar error handling
def complete_task(self, task_id: int):
    task = self.repository.find_by_id(task_id)
    if not task:
        raise TaskNotFoundError(f"Task {task_id} not found")
    task.completed = True
    self.repository.update(task)
```

### Iteración 3: Listar tareas pendientes

**RED → GREEN → REFACTOR** (continuar ciclo...)

---

## 💡 Beneficios de TDD

1. **Confianza:** Cada cambio validado por tests
2. **Diseño:** Código naturalmente testeable
3. **Documentación:** Tests como especificación
4. **Refactoring seguro:** Detectar regresiones inmediatamente
5. **Debugging reducido:** Errores detectados temprano
6. **Coverage alto:** >80% automáticamente

---

## ⚠️ Antipatrones a Evitar

❌ **Escribir todos los tests primero**
   → Escribir 1 test a la vez

❌ **Implementar más de lo necesario en GREEN**
   → Solo lo mínimo para pasar el test

❌ **Refactorizar sin tests que pasen**
   → Asegurar GREEN antes de REFACTOR

❌ **Tests que testean implementación**
   → Testear comportamiento, no detalles internos

❌ **Tests dependientes entre sí**
   → Cada test debe ser independiente

❌ **Saltarse el ciclo**
   → Respetar RED → GREEN → REFACTOR

---

## 📚 Referencias

- **Kent Beck - TDD by Example**
- **Martin Fowler - Refactoring**
- **Uncle Bob - Clean Code**

---

**Última actualización:** 2025-12-25
**Tasa de bugs en producción:** -70% con TDD
**Coverage promedio:** 85%+
