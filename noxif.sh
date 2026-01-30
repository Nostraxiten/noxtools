#!/bin/bash

# --- NOXSNIFF v1.0: RASTREADOR DE REDIRECCIONES ---
clear
echo -e "\e[1;33m"
echo "  _  _  _____  __  ____  _  _  ____  ____ "
echo " | \| |/ _ \ \/ / / ___|| \| ||  _ ||  _ |"
echo " | . ' | (_) >  <  \___ \| .  ||  _|||  _||"
echo " |_|\_|\___/_/\_\ |____/|_|\_||_|   |_|   "
echo -e "      \e[1;37m[ DETECTOR DE SALTOS Y REDIRECTS ]\e[0m"
echo "--------------------------------------------------------"

read -p " Introduce la URL a investigar: " url

echo -e "\n\e[1;34m[*] Iniciando rastreo de cadena de saltos...\e[0m"
echo "--------------------------------------------------------"

# Comando clave: -L sigue redirecciones, -s silencioso, -I solo cabeceras
# Extraemos el código HTTP (301, 302, 200) y la URL de destino
curl -Ls -o /dev/null -D - "$url" | grep -E "HTTP/|Location:|server:|x-powered-by:" | while read -r line; do
    if [[ $line == HTTP/* ]]; then
        status=$(echo $line | awk '{print $2}')
        case $status in
            200) color="\e[1;32m";; # OK
            301|302) color="\e[1;33m";; # Redirección
            404|403) color="\e[1;31m";; # Error/Bloqueo
            *) color="\e[1;37m";;
        esac
        echo -e "\n${color}[Status $status]\e[0m"
    elif [[ $line == Location:* ]]; then
        echo -e "  \e[1;36m>> Redirigiendo a:\e[0m $(echo $line | cut -d' ' -f2)"
    elif [[ $line == server:* ]]; then
        echo -e "  \e[1;37m   Servidor:\e[0m $(echo $line | cut -d' ' -f2-)"
    fi
done

echo -e "\n--------------------------------------------------------"
echo -e "\e[1;32m[+] Análisis finalizado.\e[0m"
echo " Si el 'Status' final es 200, esa es la página de destino real."
echo "--------------------------------------------------------"

read -p ">>> [ENTER PARA VOLVER A NOSTRAXZ] <<<" pause

