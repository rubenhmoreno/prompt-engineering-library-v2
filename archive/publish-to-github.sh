#!/bin/bash
# publish-to-github.sh
# Script para publicar Prompt Engineering Library a GitHub

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Prompt Engineering Library${NC}"
echo -e "${GREEN}GitHub Publishing Script${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "README.md" ] || [ ! -f "base-programming.md" ]; then
    echo -e "${RED}Error: Este script debe ejecutarse desde /home/api_prod/prompt-engineering/${NC}"
    exit 1
fi

echo -e "${YELLOW}Paso 1: Verificar configuración de Git${NC}"
if ! git config user.name &> /dev/null; then
    read -p "Ingresa tu nombre para Git: " git_name
    git config user.name "$git_name"
fi

if ! git config user.email &> /dev/null; then
    read -p "Ingresa tu email para Git: " git_email
    git config user.email "$git_email"
fi

echo -e "${GREEN}✓ Git configurado:${NC}"
echo "  Nombre: $(git config user.name)"
echo "  Email: $(git config user.email)"
echo ""

echo -e "${YELLOW}Paso 2: Verificar estado del repositorio${NC}"
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: No es un repositorio Git. Ejecuta primero:${NC}"
    echo "  git init"
    echo "  git add -A"
    echo "  git commit -m 'Initial commit'"
    exit 1
fi

echo -e "${GREEN}✓ Repositorio Git inicializado${NC}"
git log --oneline -1
echo ""

echo -e "${YELLOW}Paso 3: Configurar GitHub Remote${NC}"
echo ""
echo "Necesitas crear un Personal Access Token en GitHub:"
echo "  1. Ve a: https://github.com/settings/tokens"
echo "  2. Click 'Generate new token (classic)'"
echo "  3. Selecciona scope: 'repo'"
echo "  4. Copia el token"
echo ""

read -p "¿Ya tienes un Personal Access Token? (y/n): " has_token

if [ "$has_token" != "y" ]; then
    echo ""
    echo -e "${YELLOW}Por favor crea el token y vuelve a ejecutar este script.${NC}"
    echo "Guarda el token en un lugar seguro (no lo commitees al repositorio)."
    exit 0
fi

read -p "Ingresa tu username de GitHub: " github_user
read -s -p "Ingresa tu Personal Access Token: " github_token
echo ""

# Formato correcto: https://USERNAME:TOKEN@github.com/USERNAME/REPO.git
REPO_URL="https://${github_user}:${github_token}@github.com/${github_user}/prompt-engineering-library.git"

# Verificar si ya existe el remote
if git remote | grep -q "^origin$"; then
    echo -e "${YELLOW}Remote 'origin' ya existe. Actualizando...${NC}"
    git remote set-url origin "$REPO_URL"
else
    echo -e "${GREEN}Agregando remote 'origin'...${NC}"
    git remote add origin "$REPO_URL"
fi

echo -e "${GREEN}✓ Remote configurado${NC}"
echo ""

echo -e "${YELLOW}Paso 4: Verificar que el repositorio existe en GitHub${NC}"
echo "Ve a: https://github.com/${github_user}/prompt-engineering-library"
echo ""
read -p "¿El repositorio ya existe en GitHub? (y/n): " repo_exists

if [ "$repo_exists" != "y" ]; then
    echo ""
    echo -e "${YELLOW}Debes crear el repositorio primero:${NC}"
    echo "  1. Ve a: https://github.com/new"
    echo "  2. Repository name: prompt-engineering-library"
    echo "  3. Public repository"
    echo "  4. NO inicialices con README, .gitignore, o license"
    echo "  5. Click 'Create repository'"
    echo ""
    read -p "Presiona Enter cuando hayas creado el repositorio..."
fi

echo -e "${YELLOW}Paso 5: Push al repositorio${NC}"
echo ""

if git push -u origin main; then
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}✓ ¡Publicación exitosa!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo "Tu repositorio está disponible en:"
    echo -e "${GREEN}https://github.com/${github_user}/prompt-engineering-library${NC}"
    echo ""
    echo "Próximos pasos recomendados:"
    echo "  1. Agregar topics al repositorio"
    echo "  2. Star tu propio repositorio"
    echo "  3. Compartir el link con otros desarrolladores"
    echo ""
    echo "Para actualizaciones futuras:"
    echo "  git add ."
    echo "  git commit -m 'feat: descripción del cambio'"
    echo "  git push"
    echo ""
else
    echo ""
    echo -e "${RED}Error al hacer push.${NC}"
    echo ""
    echo "Posibles soluciones:"
    echo "  1. Verifica que el token tenga permisos 'repo'"
    echo "  2. Verifica que el repositorio exista en GitHub"
    echo "  3. Verifica la conexión a internet"
    echo ""
    echo "Para más ayuda, consulta: GITHUB_SETUP.md"
    exit 1
fi
