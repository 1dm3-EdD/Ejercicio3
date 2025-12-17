#!/bin/bash

# Colores para el output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "---------------------------------------------------"
echo "Iniciando Autocorrección del Ejercicio 3"
echo "---------------------------------------------------"

ERRORES=0

# --- 1. Comprobar archivo inicializando.txt y su contenido ---
if [ -f "inicializando.txt" ]; then
    CONTENT=$(cat inicializando.txt)
    if [[ "$CONTENT" == *"inicializando"* ]]; then
        echo -e "${GREEN}✅ Archivo 'inicializando.txt' correcto.${NC}"
    else
        echo -e "${RED}❌ 'inicializando.txt' existe pero no contiene el texto 'inicializando'.${NC}"
        ERRORES=$((ERRORES+1))
    fi
else
    echo -e "${RED}❌ No se encuentra el archivo 'inicializando.txt'.${NC}"
    ERRORES=$((ERRORES+1))
fi

# --- 2. Comprobar existencia del README (md o txt) ---
if [ -f "README.md" ] || [ -f "README.txt" ]; then
    echo -e "${GREEN}✅ Archivo README encontrado.${NC}"
else
    echo -e "${RED}❌ No se encuentra el archivo README (con extensión .md o .txt).${NC}"
    ERRORES=$((ERRORES+1))
fi

# --- 3. Comprobar el mensaje del commit específico ---
# Buscamos en el log si existe algún commit con ese mensaje exacto
if git log --pretty=format:%s | grep -Fq "Creando README.md"; then
    echo -e "${GREEN}✅ Commit con mensaje 'Creando README.md' encontrado.${NC}"
else
    echo -e "${RED}❌ No se encontró ningún commit con el mensaje exacto 'Creando README.md'.${NC}"
    echo "   (Mensajes encontrados:)"
    git log --pretty=format:"   - %s" -n 5
    ERRORES=$((ERRORES+1))
fi

# --- 4. Comprobar archivo de comandos ---
# Buscamos si hay algún archivo de texto aparte de los obligatorios
# Excluimos inicializando.txt, README.md, y scripts de corrección
FOUND_HISTORY=$(find . -maxdepth 1 -type f -name "*.txt" ! -name "inicializando.txt" | head -n 1)

if [ -n "$FOUND_HISTORY" ]; then
    echo -e "${GREEN}✅ Archivo de historial de comandos encontrado: $FOUND_HISTORY${NC}"
else
    echo -e "${RED}❌ No se encontró el archivo de texto plano con los comandos.${NC}"
    ERRORES=$((ERRORES+1))
fi

# --- NOTA SOBRE EL COLABORADOR ---
echo -e "\n⚠️  NOTA: La comprobación de 'Compartir con galonso1014' no se puede automatizar"
echo "    de forma segura en este script sin exponer tokens de administrador."
echo "    Como usas GitHub Classroom, tú ya tienes acceso al repo."

echo "---------------------------------------------------"
if [ $ERRORES -eq 0 ]; then
    echo -e "${GREEN}🎉 EJERCICIO COMPLETADO CON ÉXITO 🎉${NC}"
    exit 0
else
    echo -e "${RED}⛔ Se encontraron $ERRORES errores. Revisa el log de arriba.${NC}"
    exit 1
fi