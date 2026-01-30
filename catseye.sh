#!/bin/bash

# --- CAT'S EYE: VERSIÓN PROFESIONAL ARREGLADA ---
clear
echo -e "\e[33m"
echo "   ____      _   '      _____            "
echo "  / ___|__ _| |_ ___  | ____|   _  ___  "
echo " | |   / _' | __/ __| |  _| | | | |/ _ \ "
echo " | |__| (_| | |_\__ \ | |___| |_| |  __/ "
echo "  \____\__,_|\__|___/ |______\__, |\___| "
echo "                             |___/       "
echo -e "\e[0m"

if [ -z "$1" ]; then
    read -p "Introduce el Username> " user
else
    user=$1
fi

echo -e "\n\e[34m[*] Escaneando perfiles reales para: $user...\e[0m\n"

check_site() {
    # Usamos un agente de navegador muy común para evitar bloqueos en 4G+
    agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    
    # Obtenemos solo el código de estado y el contenido base
    status=$(curl -s -L -o /dev/null -k -A "$agent" -w "%{http_code}" "$1$user")
    
    if [ "$status" == "200" ]; then
        # Verificamos contenido solo en sitios problemáticos como Instagram o TikTok
        case $2 in
            "Instagram")
                # Instagram redirige a login si no existe. Verificamos la URL final.
                final_url=$(curl -s -L -o /dev/null -k -A "$agent" -w "%{url_effective}" "$1$user")
                if [[ "$final_url" == *"login"* ]]; then
                    echo -e "\e[31m[-] [NADA]   $2\e[0m"
                else
                    echo -e "\e[32m[+] [EXISTE] $2: $1$user\e[0m"
                fi
                ;;
            *)
                # Para el resto, si es 200, es que existe
                echo -e "\e[32m[+] [EXISTE] $2: $1$user\e[0m"
                ;;
        esac
    elif [ "$status" == "404" ]; then
        echo -e "\e[31m[-] [NADA]   $2\e[0m"
    else
        echo -e "\e[33m[?] [BLOQUEO] $2 (Cod: $status)\e[0m"
    fi
}

# --- LISTA OPTIMIZADA ---
check_site "https://www.instagram.com/" "Instagram"
check_site "https://www.tiktok.com/@" "TikTok"
check_site "https://x.com/" "X (Twitter)"
check_site "https://www.facebook.com/" "Facebook"
check_site "https://www.github.com/" "GitHub"
check_site "https://www.youtube.com/@" "YouTube"
check_site "https://www.twitch.tv/" "Twitch"
check_site "https://www.roblox.com/user.aspx?username=" "Roblox"

echo -e "\n------------------------------------------------"
echo " Búsqueda finalizada."

