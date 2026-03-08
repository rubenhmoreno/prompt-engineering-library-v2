# Solución - Token de GitHub Fine-Grained
## El token actual necesita configuración adicional

**Problema identificado:** Tu token `github_pat_11AWMI...` es un **Fine-grained personal access token** que requiere configuración específica de repositorio.

---

## ✅ SOLUCIÓN 1: Editar el token actual (Más rápido)

### Paso 1: Ir a configuración de tokens fine-grained

Abre: **https://github.com/settings/tokens?type=beta**

### Paso 2: Encontrar y editar tu token

Busca el token que empieza con `github_pat_11AWMI2NA0OLxgvF2CvQhq...`

Click en el nombre del token para editarlo.

### Paso 3: Configurar acceso al repositorio

En la sección **"Repository access"**:

- Opción A (Recomendado para este caso):
  - Selecciona: **"Only select repositories"**
  - Click en "Select repositories"
  - Busca y selecciona: `prompt-engineering-library`

- Opción B (Más permisivo):
  - Selecciona: **"All repositories"**

### Paso 4: Configurar permisos

En la sección **"Permissions"** → **"Repository permissions"**:

Configura los siguientes permisos:

- **Contents**: `Read and write` ✅ (CRÍTICO - Este es el que falta)
- **Metadata**: `Read-only` (ya debe estar)
- **Pull requests**: `Read and write` (opcional)
- **Issues**: `Read and write` (opcional)

### Paso 5: Guardar cambios

Scroll down y click **"Update token"** o **"Save changes"**

### Paso 6: Hacer push

```bash
cd /home/api_prod/prompt-engineering

# El remote ya está configurado, solo hacer push
git push -u origin main
```

**Deberías ver:**
```
Enumerating objects: 22, done.
Counting objects: 100% (22/22), done.
...
To https://github.com/mcapriotti74/prompt-engineering-library.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

---

## ✅ SOLUCIÓN 2: Crear nuevo Classic Token (Alternativa)

Si prefieres usar un Classic Personal Access Token (más simple):

### Paso 1: Crear nuevo token Classic

Abre: **https://github.com/settings/tokens/new**

### Paso 2: Configurar

- **Note**: `Prompt Engineering Library - Classic`
- **Expiration**: `90 days` (o el que prefieras)
- **Scopes**: Marca **SOLO**:
  - ✅ **repo** (marca la casilla principal, todas las sub-opciones se marcarán automáticamente)

### Paso 3: Generar

Click **"Generate token"**

**¡COPIA EL TOKEN INMEDIATAMENTE!** (Formato: `ghp_xxxxxxxxxxxx...`)

### Paso 4: Configurar Git con nuevo token

```bash
cd /home/api_prod/prompt-engineering

# Remover remote anterior
git remote remove origin

# Agregar con NUEVO token (reemplaza ghp_XXX con tu token)
git remote add origin https://mcapriotti74:ghp_NUEVO_TOKEN_AQUI@github.com/mcapriotti74/prompt-engineering-library.git

# Push
git push -u origin main
```

---

## 🔍 Verificar que funcionó

Después del push exitoso:

1. Ve a: **https://github.com/mcapriotti74/prompt-engineering-library**

2. Deberías ver:
   - ✅ 22 archivos
   - ✅ README.md como página principal con badges
   - ✅ Carpetas: agents/, core/, workflows/, templates/, examples/
   - ✅ Commit message: "feat: Initial commit - Prompt Engineering Library v1.0.0"

---

## 📊 Diferencias entre tipos de tokens

### Fine-grained PAT (github_pat_XXX)
- ✅ Más seguro (permisos granulares por repo)
- ✅ Puede expirar automáticamente
- ❌ Requiere configurar cada repositorio individualmente
- ❌ Más complejo de configurar

### Classic PAT (ghp_XXX)
- ✅ Más simple (un solo scope `repo`)
- ✅ Funciona con todos los repositorios
- ❌ Menos granular (todo o nada)

---

## ⚡ Comando rápido de verificación

Después de configurar el token:

```bash
# Verificar que el token tiene permisos
curl -s -H "Authorization: token TU_TOKEN" \
  https://api.github.com/repos/mcapriotti74/prompt-engineering-library \
  | grep -A 5 '"permissions"'

# Debería mostrar:
# "permissions": {
#   "admin": true,
#   "maintain": true,
#   "push": true,  ← ESTE ES EL IMPORTANTE
#   ...
# }
```

---

## 🚨 Troubleshooting

### Error persiste después de editar token

**Solución:** Los cambios en tokens fine-grained pueden tardar 1-2 minutos en propagarse. Espera un momento y vuelve a intentar.

### No encuentro el token en la lista

**Solución:**
- Fine-grained: https://github.com/settings/tokens?type=beta
- Classic: https://github.com/settings/tokens

### Token expiró

**Solución:** Los tokens fine-grained pueden tener expiración muy corta (7 días por defecto). Crea uno nuevo con expiración más larga.

---

## ✅ Checklist Final

Antes de considerar resuelto:

- [ ] Token configurado correctamente (fine-grained O classic)
- [ ] Permiso "Contents: Read and write" activado (fine-grained)
  O scope "repo" marcado (classic)
- [ ] Repository access configurado para "prompt-engineering-library"
- [ ] Remote de git configurado con token correcto
- [ ] `git push -u origin main` ejecutado exitosamente
- [ ] Repositorio visible en https://github.com/mcapriotti74/prompt-engineering-library

---

## 📧 Resumen para recordar

**Problema:** Token fine-grained sin permiso "Contents: Read and write"

**Solución rápida:**
1. https://github.com/settings/tokens?type=beta
2. Editar token
3. Repository access → Select "prompt-engineering-library"
4. Repository permissions → Contents: "Read and write"
5. Save changes
6. `git push -u origin main`

**Solución alternativa:**
1. Crear Classic token: https://github.com/settings/tokens/new
2. Scope: `repo`
3. Generar y copiar token (ghp_XXX)
4. Ejecutar:
   ```bash
   git remote set-url origin https://mcapriotti74:ghp_XXX@github.com/mcapriotti74/prompt-engineering-library.git
   git push -u origin main
   ```

---

**Última actualización:** 2025-12-25
**Status:** Esperando configuración de token
