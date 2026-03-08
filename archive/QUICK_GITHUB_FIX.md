# Quick GitHub Fix - Error 403
## Solución al problema de autenticación

**Error encontrado:** `Permission denied` / `403 Forbidden`

**Causa:** El Personal Access Token tiene permisos insuficientes o está expirado.

---

## ✅ SOLUCIÓN RÁPIDA (5 minutos)

### Paso 1: Crear nuevo Personal Access Token

1. Ve a: **https://github.com/settings/tokens**

2. Click en **"Generate new token"** → **"Generate new token (classic)"**

3. Configuración del token:
   - **Note:** `Prompt Engineering Library - 2025`
   - **Expiration:** `90 days` (o el que prefieras)
   - **Scopes:** Selecciona estos permisos:
     - ✅ **repo** (marcar TODO el grupo "repo")
       - ✅ repo:status
       - ✅ repo_deployment
       - ✅ public_repo
       - ✅ repo:invite
       - ✅ security_events

4. Scroll down y click **"Generate token"**

5. **¡IMPORTANTE!** Copia el token INMEDIATAMENTE (solo se muestra una vez)
   - Formato: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - Guárdalo en un lugar seguro

---

### Paso 2: Configurar Git con el nuevo token

```bash
cd /home/api_prod/prompt-engineering

# Remover remote anterior
git remote remove origin

# Agregar remote con nuevo token (REEMPLAZA ghp_YOUR_TOKEN con tu token)
git remote add origin https://mcapriotti74:ghp_YOUR_TOKEN@github.com/mcapriotti74/prompt-engineering-library.git

# Verificar que está configurado
git remote -v
```

---

### Paso 3: Push al repositorio

```bash
cd /home/api_prod/prompt-engineering

# Push
git push -u origin main
```

**Output esperado:**
```
Enumerating objects: 22, done.
Counting objects: 100% (22/22), done.
Delta compression using up to X threads
Compressing objects: 100% (21/21), done.
Writing objects: 100% (22/22), XX KiB | XX MiB/s, done.
Total 22 (delta 0), reused 0 (delta 0)
To https://github.com/mcapriotti74/prompt-engineering-library.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

---

### Paso 4: Verificar en GitHub

1. Ve a: **https://github.com/mcapriotti74/prompt-engineering-library**

2. Deberías ver:
   - ✅ 22 archivos
   - ✅ README.md como página principal
   - ✅ Última actualización: hace unos segundos

---

## 🔐 ALTERNATIVA: Usar GitHub CLI

Si prefieres no manejar tokens manualmente:

```bash
# Instalar GitHub CLI (si no está instalado)
# Debian/Ubuntu:
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Login con GitHub CLI
gh auth login

# Crear y publicar repositorio
cd /home/api_prod/prompt-engineering
gh repo create prompt-engineering-library \
  --public \
  --source=. \
  --remote=origin \
  --push
```

---

## 🐛 Troubleshooting

### Error: "token has expired"
**Solución:** Crear nuevo token (Paso 1 arriba)

### Error: "repo not found"
**Solución:** Verifica que el repositorio existe en:
https://github.com/mcapriotti74/prompt-engineering-library

Si no existe, créalo en: https://github.com/new

### Error: "permission denied"
**Solución:** Verifica que el token tenga el scope `repo` completo marcado

### Error: "authentication failed"
**Solución:** Verifica el formato de la URL:
```
https://USERNAME:TOKEN@github.com/USERNAME/REPO.git
```

No debe ser:
```
https://TOKEN@github.com/USERNAME/REPO.git  ❌ MAL
```

---

## ✅ Verificación Final

Después de push exitoso:

```bash
# Ver info del repositorio
cd /home/api_prod/prompt-engineering
git remote -v
git log --oneline -1
git branch -vv

# Verificar estado
git status
```

**Output esperado:**
```
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

---

## 📝 Para Futuros Pushes

Una vez configurado correctamente, futuros cambios son simples:

```bash
cd /home/api_prod/prompt-engineering

# Hacer cambios en archivos...

# Commit
git add .
git commit -m "feat: descripción del cambio"

# Push
git push
```

---

## 🔒 Seguridad del Token

**IMPORTANTE:**

1. ✅ Nunca commitear el token al repositorio
2. ✅ Guardar el token en gestor de passwords
3. ✅ Rotar tokens periódicamente (cada 90 días)
4. ✅ Revocar tokens viejos después de crear nuevos

Si alguna vez expones el token accidentalmente:
1. Ve a: https://github.com/settings/tokens
2. Click "Revoke" en el token expuesto
3. Genera uno nuevo

---

## 📧 Resumen para Email

Token actual tiene problema: `403 Forbidden`

Solución:
1. Crear nuevo token: https://github.com/settings/tokens
   - Scope: `repo` (completo)
2. Ejecutar:
   ```bash
   cd /home/api_prod/prompt-engineering
   git remote remove origin
   git remote add origin https://mcapriotti74:ghp_NUEVO_TOKEN@github.com/mcapriotti74/prompt-engineering-library.git
   git push -u origin main
   ```

---

**Última actualización:** 2025-12-25
**Status:** Pendiente de nuevo token
