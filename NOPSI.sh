#!/bin/bash
# --- NOPSI v6.0: AGGRESSIVE INTEL & FINGERPRINTING ---
# Tool: noxtools | Dev: nostraxiten | Auto-Installer: Enabled

# 1. Configuración Visual y Auto-Instalación
clear
G='\e[1;32m'
R='\e[1;31m'
C='\e[1;36m'
Y='\e[1;33m'
W='\e[1;37m'
N='\e[0m'

echo -e "${Y}[!] VERIFICANDO ARSENAL DE NOXTOOLS...${N}"

# Función de instalación automática
function check_and_install {
    if ! command -v $1 &> /dev/null; then
        echo -e "${R}[x] $1 no encontrado. Instalando ahora...${N}"
        pkg install $1 -y > /dev/null 2>&1
    fi
}

# Lista de dependencias necesarias
check_and_install "jq"
check_and_install "dnsutils"
check_and_install "nmap"
check_and_install "curl"

clear
echo -e "${G}"
echo "███╗   ██╗ ██████╗ ██████╗ ███████╗██╗"
echo "████╗  ██║██╔═══██╗██╔══██╗██╔════╝██║"
echo "██╔██╗ ██║██║   ██║██████╔╝███████╗██║"
echo "██║╚██╗██║██║   ██║██╔═══╝ ╚════██║██║"
echo "██║ ╚████║╚██████╔╝██║     ███████║██║"
echo "╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝"
echo -e "${Y}      [ EL OJO DE ODÍN - ESCANEO TOTAL ]${N}"
echo -e "${W}----------------------------------------------------"

read -p "🎯 Introduce la IP o URL: " target

# 2. Procesamiento del objetivo
if [[ $target == http* ]]; then
    target_clean=$(echo $target | sed -e 's|^[^/]*//||' -e 's|/.*$||')
else
    target_clean=$target
fi

ip=$(host $target_clean 2>/dev/null | grep "has address" | awk '{print $4}' | head -n 1)
if [ -z "$ip" ]; then ip=$target_clean; fi

echo -e "\n${C}[*] Iniciando Auditoría Profunda sobre: ${Y}$target_clean ($ip)${N}"
echo -e "${W}----------------------------------------------------"

# --- MÓDULOS DE INTELIGENCIA ---

# 1. GEOLOCALIZACIÓN
echo -e "${G}[1] GEOPOSICIONAMIENTO E ISP${N}"
info=$(curl -s "http://ip-api.com/json/$ip")
echo -e "${W} • IP: $(echo $info | jq -r '.query')"
echo -e "${W} • ISP: $(echo $info | jq -r '.isp')"
echo -e "${W} • Org: $(echo $info | jq -r '.as')"
echo -e "${W} • Ubicación: $(echo $info | jq -r '.city'), $(echo $info | jq -r '.country')"
echo -e "${W} • Proxy/VPN: $(echo $info | jq -r '.proxy')"

# 2. FINGERPRINTING WEB
echo -e "\n${G}[2] FINGERPRINTING DE SERVIDOR WEB${N}"
headers=$(curl -s -I --connect-timeout 5 http://$target_clean)
if [ ! -z "$headers" ]; then
    server=$(echo "$headers" | grep -i "server:" | cut -d' ' -f2-)
    echo -e "${W} • Servidor: ${C}${server:-Oculto/WAF}"
    if curl -s "http://$target_clean/wp-login.php" | grep -q "wordpress"; then
        echo -e "${Y} • [!] CMS Detectado: WordPress${N}"
    fi
else
    echo -e "${R} • Error: No se detecta servidor web activo.${N}"
fi

# 3. DNS INTEL
echo -e "\n${G}[3] REGISTROS DNS${N}"
echo -ne "${W} • MX: " && dig +short MX $target_clean | tr '\n' ' ' || echo "N/A"
echo -ne "\n${W} • TXT: " && dig +short TXT $target_clean | head -n 1

# 4. ESCANEO DE SERVICIOS (NMAP)
echo -e "\n${G}[4] ESCANEO DE SERVICIOS (NMAP)${N}"
nmap -T4 -F -sV $ip | grep "open" | while read -r line; do
    port=$(echo $line | awk '{print $1}')
    service=$(echo $line | awk '{print $3}')
    echo -e "${W}  --> Puerto ${Y}$port ${W}| Servicio: ${G}$service"
done

echo -e "\n${W}----------------------------------------------------"
echo -e "${G}[+] Reporte completado para nostraxiten.${N}"
read -p ">>> [PRESIONA ENTER PARA FINALIZAR] <<<" dummy

