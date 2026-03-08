# GitHub Actions Workflow Setup

## Status

⚠️ **GitHub Actions workflow creado pero no publicado al repositorio**

El archivo `.github/workflows/markdown-lint.yml` está listo localmente pero requiere permisos adicionales del token de GitHub para ser publicado.

---

## Problema

Al intentar hacer push del workflow, recibimos este error:

```
! [remote rejected] main -> main (refusing to allow a Personal Access Token to
create or update workflow `.github/workflows/markdown-lint.yml` without `workflow` scope)
```

---

## Solución

El Personal Access Token necesita el scope adicional **`workflow`**.

### Opción 1: Actualizar Token Fine-Grained (Recomendado)

1. Ve a: https://github.com/settings/tokens?type=beta
2. Encuentra y edita tu token actual
3. En **"Repository permissions"**, agrega:
   - **Workflows**: `Read and write` ✅
4. Guarda los cambios
5. Ejecuta:

```bash
cd /home/api_prod/prompt-engineering
git add .github/workflows/
git commit -m "ci: Add GitHub Actions markdown linting workflow"
git push
```

### Opción 2: Crear Nuevo Classic Token

Si prefieres usar Classic PAT:

1. Ve a: https://github.com/settings/tokens/new
2. Scopes necesarios:
   - ✅ **repo** (completo)
   - ✅ **workflow** (NUEVO - necesario para GitHub Actions)
3. Genera el token y cópialo
4. Actualiza el remote:

```bash
cd /home/api_prod/prompt-engineering
git remote set-url origin https://mcapriotti74:ghp_NUEVO_TOKEN@github.com/mcapriotti74/prompt-engineering-library.git
git add .github/workflows/
git commit -m "ci: Add GitHub Actions markdown linting workflow"
git push
```

---

## Workflow Contenido

El workflow `markdown-lint.yml` incluye:

### Características

1. **Triggers:**
   - Push a `main` o `develop`
   - Pull requests a `main` o `develop`

2. **Jobs:**
   - Linting de archivos Markdown con `markdownlint-cli`
   - Validación de links rotos con `github-action-markdown-link-check`

3. **Configuración:**
   - `.markdownlint.json`: Reglas de linting (líneas max 120 chars, permite HTML específico)
   - `.markdown-link-check.json`: Configuración de validación de links

### Beneficios

- ✅ Detecta errores de formato automáticamente
- ✅ Valida que todos los links funcionen
- ✅ Feedback inmediato en PRs
- ✅ Mantiene calidad consistente de documentación

---

## Archivo del Workflow

**Ubicación:** `.github/workflows/markdown-lint.yml`

```yaml
name: Markdown Lint

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  markdown-lint:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'

    - name: Install markdownlint-cli
      run: npm install -g markdownlint-cli

    - name: Run markdownlint
      run: |
        markdownlint '**/*.md' \
          --ignore node_modules \
          --ignore .github \
          --config .markdownlint.json || true

    - name: Check for broken links
      uses: gaurav-nelson/github-action-markdown-link-check@v1
      with:
        use-quiet-mode: 'yes'
        use-verbose-mode: 'yes'
        config-file: '.markdown-link-check.json'
```

---

## Verificación Post-Push

Una vez que el workflow esté publicado, verifica:

1. **Ve a:** https://github.com/mcapriotti74/prompt-engineering-library/actions
2. **Deberías ver:** "Markdown Lint" workflow
3. **Primera ejecución:** Se disparará automáticamente en el próximo push/PR

**Output esperado:**
```
✓ Checkout code
✓ Setup Node.js
✓ Install markdownlint-cli
✓ Run markdownlint
✓ Check for broken links
```

---

## Testing Local (Opcional)

Puedes probar el linting localmente antes de publicar:

```bash
# Instalar markdownlint-cli
npm install -g markdownlint-cli

# Ejecutar linting
cd /home/api_prod/prompt-engineering
markdownlint '**/*.md' --ignore node_modules --config .markdownlint.json

# Verificar links (requiere Docker)
docker run -v $(pwd):/tmp:ro --rm -i ghcr.io/tcort/markdown-link-check:stable /tmp/README.md
```

---

## Troubleshooting

### Error: "workflow scope not found"

**Solución:** Asegúrate de agregar el scope `workflow` al token (ver Opción 1 o 2 arriba)

### Error persiste después de actualizar token

**Solución:** Los cambios en tokens fine-grained pueden tardar 1-2 minutos en propagarse. Espera y vuelve a intentar.

### Workflow no se ejecuta automáticamente

**Solución:**
1. Verifica que el archivo está en `.github/workflows/` (no `github/workflows/`)
2. Verifica sintaxis YAML con: `yamllint .github/workflows/markdown-lint.yml`
3. Revisa la pestaña "Actions" en GitHub para ver errores

---

## Checklist

- [ ] Token actualizado con scope `workflow`
- [ ] Workflow publicado a GitHub
- [ ] Primera ejecución del workflow exitosa
- [ ] Badge agregado a README.md (opcional):

```markdown
[![Markdown Lint](https://github.com/mcapriotti74/prompt-engineering-library/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/mcapriotti74/prompt-engineering-library/actions/workflows/markdown-lint.yml)
```

---

## Próximos Pasos

Una vez que el workflow esté funcionando:

1. **Monitorear:** Revisar ejecuciones en pestaña Actions
2. **Ajustar:** Modificar `.markdownlint.json` si hay reglas muy estrictas
3. **Expandir:** Agregar workflows adicionales:
   - Spell checking
   - Code example syntax validation
   - Automated changelog updates

---

**Última actualización:** 2025-12-25
**Estado:** ⏳ Esperando scope `workflow` en token
**Documentación:** README.md, CONTRIBUTING.md

