#!/bin/bash
# --- NOPSI v8.1: WOLF EYES (FIXED) ---
# Tool: noxtools | Dev: nostraxiten | System: Hybrid (Kali/Termux)
# Integrated: nmap, dig, whois, traceroute, dnsrecon, jq, curl

# 1. PARCHE DE COMPATIBILIDAD (FIX PARA IMAGEN 9)
# Este bloque crea el archivo que dnsrecon busca en Termux para no dar error.
if [ -d "/data/data/com.termux/files/usr" ]; then
    if [ ! -f "/data/data/com.termux/files/usr/etc/resolv.conf" ]; then
        mkdir -p /data/data/com.termux/files/usr/etc
        echo "nameserver 8.8.8.8" > /data/data/com.termux/files/usr/etc/resolv.conf
    fi
fi

# 2. CONFIGURACIÓN VISUAL
clear
G='\e[1;32m' # Green
R='\e[1;31m' # Red
C='\e[1;36m' # Cyan
Y='\e[1;33m' # Yellow
W='\e[1;37m' # White
M='\e[1;35m' # Magenta
N='\e[0m'    # Reset

# Banner
echo -e "${G}"
echo "███╗   ██╗ ██████╗ ██████╗ ███████╗██╗"
echo "████╗  ██║██╔═══██╗██╔══██╗██╔════╝██║"
echo "██╔██╗ ██║██║   ██║██████╔╝███████╗██║"
echo "██║╚██╗██║██║   ██║██╔═══╝ ╚════██║██║"
echo "██║ ╚████║╚██████╔╝██║     ███████║██║"
echo "╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝"
echo -e "${Y}    [ NOXTOOLS v8.1 - WOLF EYES FIXED ]${N}"
echo -e "${W}----------------------------------------${N}"

echo -e "${Y}[I] VERIFICANDO ARSENAL DE NOXTOOLS...${N}"

# 3. GESTOR DE DEPENDENCIAS INTELIGENTE (Mejorado para Kali/Termux)
function check_and_install {
    COMMAND_NAME=$1 
    PACKAGE_NAME=$2 
    
    if ! command -v $COMMAND_NAME &> /dev/null; then
        echo -e "${R}[x] Falta: $COMMAND_NAME. Instalando...${N}"
        if [ -d "/data/data/com.termux/files/usr" ]; then
            pkg install $PACKAGE_NAME -y > /dev/null 2>&1
        else
            if [ "$EUID" -ne 0 ]; then 
                sudo apt-get update > /dev/null 2>&1
                sudo apt-get install -y $PACKAGE_NAME > /dev/null 2>&1
            else
                apt-get update > /dev/null 2>&1
                apt-get install -y $PACKAGE_NAME > /dev/null 2>&1
            fi
        fi
    else
        echo -e "${G}[v] $COMMAND_NAME detectado.${N}"
    fi
}

function install_dnsrecon {
    if ! command -v dnsrecon &> /dev/null; then
        echo -e "${M}[!] Instalando dnsrecon (Este proceso puede tardar)...${N}"
        if [ -d "/data/data/com.termux/files/usr" ]; then
            pkg install python -y > /dev/null 2>&1
            pip install dnsrecon > /dev/null 2>&1
        else
            if [ "$EUID" -ne 0 ]; then sudo apt-get install -y dnsrecon > /dev/null 2>&1
            else apt-get install -y dnsrecon > /dev/null 2>&1; fi
        fi
    else
        echo -e "${G}[v] dnsrecon detectado.${N}"
    fi
}

# EJECUCIÓN DE INSTALACIONES
check_and_install "jq" "jq"
check_and_install "dig" "dnsutils"
check_and_install "whois" "whois"
check_and_install "nmap" "nmap"
check_and_install "curl" "curl"
check_and_install "traceroute" "traceroute"
install_dnsrecon

echo -e "${W}----------------------------------------${N}"

# 4. INPUT DEL OBJETIVO
read -p "🎯 Introduce IP o DOMINIO: " target
target_clean=$(echo $target | sed -e 's|^[^/]*//||' -e 's|/.*$||')

ip=$(dig +short $target_clean | head -n 1)
if [ -z "$ip" ]; then ip=$target_clean; fi

echo -e "\n${C}[*] OBJETIVO FIJADO: ${Y}$target_clean${C} -> ${Y}$ip${N}"

# --- MÓDULOS DE ATAQUE ---

# [1] GEOLOCALIZACIÓN
echo -e "\n${G}[1] GEOLOCALIZACIÓN E ISP${N}"
info=$(curl -s --connect-timeout 5 "http://ip-api.com/json/$ip")
if [[ "$info" == *"success"* ]]; then
    echo -e "${W} • Ubicación: $(echo $info | jq -r '.city'), $(echo $info | jq -r '.country')"
    echo -e "${W} • ISP/Org:   $(echo $info | jq -r '.isp') / $(echo $info | jq -r '.org')"
else
    echo -e "${R} • [!] Fallo al geolocalizar.${N}"
fi

# [2] WHOIS INFO
echo -e "\n${G}[2] REGISTRO WHOIS${N}"
if command -v whois &> /dev/null; then
    whois $target_clean | grep -E -i "Registrar:|Creation Date:|Updated Date:|Registry Expiry:" | head -n 5 | sed 's/^/ • /'
else
    echo -e "${R} • Herramienta 'whois' no instalada.${N}"
fi

# [3] TRACEROUTE
echo -e "\n${G}[3] RUTA DE RED (TRACEROUTE)${N}"
if command -v traceroute &> /dev/null; then
    traceroute -m 15 -w 1 $target_clean 2>/dev/null | head -n 5 
else
    echo -e "${R} • 'traceroute' no disponible.${N}"
fi

# [4] DNS RECON AVANZADO (FIXED)
echo -e "\n${G}[4] INTELIGENCIA DNS (DNSRECON)${N}"
if command -v dnsrecon &> /dev/null; then
    # Usamos 2>/dev/null para ignorar advertencias menores de Python
    dnsrecon -d $target_clean -t std 2>/dev/null | grep -E "A|MX|NS|TXT" | head -n 10 | sed 's/^/ • /'
else
    echo -e "${Y} [!] dnsrecon no disponible.${N}"
fi

# [5] ESCANEO DE SERVICIOS
echo -e "\n${G}[5] ESCANEO DE SERVICIOS (NMAP)${N}"
nmap -F -sV --version-light -n $ip | grep -E "^[0-9]" | while read -r line; do
    port=$(echo $line | awk '{print $1}')
    svc=$(echo $line | awk '{print $3}')
    echo -e "${W} --> ${Y}$port${W} | ${G}$svc${W}"
done

echo -e "\n${W}========================================${N}"
echo -e "${G}[+] OPERACIÓN COMPLETADA - NOXTOOLS${N}"
read -p ">>> ENTER PARA SALIR <<<" dummy

