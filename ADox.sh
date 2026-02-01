#!/bin/bash
# --- NOX-SYSTEM: AUTO-DOXING ULTIMATE (AUTO-INSTALLER) ---

# 1. Configuración Visual
clear
G='\e[1;32m' # Verde Hacker
R='\e[1;31m' # Rojo Alerta
C='\e[1;36m' # Cyan Info
Y='\e[1;33m' # Amarillo Aviso
W='\e[1;37m' # Blanco Texto
N='\e[0m'    # Reset

# Banner
echo -e "${G}"
echo " █████╗ ██████╗  ██████╗ ██╗  ██╗"
echo "██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝"
echo "███████║██║  ██║██║   ██║ ╚███╔╝ "
echo "██╔══██║██║  ██║██║   ██║ ██╔██╗ "
echo "██║  ██║██████╔╝╚██████╔╝██╔╝ ██╗"
echo "╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝"
echo -e "${W}    >> SYSTEM SELF-DIAGNOSTIC TOOL v2.5 <<${N}"
echo -e "${C}====================================================${N}"

# ==========================================
# 🛑 MÓDULO DE INSTALACIÓN FORZADA (AUTO-FIX)
# ==========================================
echo -e "\n${Y}[!] VERIFICANDO ARSENAL DE HERRAMIENTAS...${N}"

# Función para instalar silenciosamente si falta algo
function check_install {
    if ! command -v $1 &> /dev/null; then
        echo -e "${R}[x] Herramienta '$1' no detectada. Instalando...${N}"
        pkg install $1 -y > /dev/null 2>&1
        echo -e "${G}[v] '$1' instalada correctamente.${N}"
    else
        echo -e "${G}[v] '$1' ya está lista.${N}"
    fi
}

# Verificamos e instalamos una por una
check_install "curl"
check_install "jq"
check_install "termux-api"

echo -e "${C}[*] Dependencias cargadas. Iniciando escaneo profundo...${N}"
sleep 1
# ==========================================

# 3. EXTRACCIÓN MASIVA DE DATOS
echo -e "${G}[+] Inyectando en el Kernel...${N}"
echo -e "${G}[+] Escaneando red global...${N}"

# --- RED Y GEOLOCALIZACIÓN ---
# Usamos un user-agent para evitar bloqueos
raw_net=$(curl -s -A "Mozilla/5.0" http://ip-api.com/json/?fields=66846719)
ip=$(echo $raw_net | jq -r '.query')
city=$(echo $raw_net | jq -r '.city')
region=$(echo $raw_net | jq -r '.regionName')
country=$(echo $raw_net | jq -r '.country')
isp=$(echo $raw_net | jq -r '.isp')
as_net=$(echo $raw_net | jq -r '.as')
lat=$(echo $raw_net | jq -r '.lat')
lon=$(echo $raw_net | jq -r '.lon')
timezone=$(echo $raw_net | jq -r '.timezone')
zip=$(echo $raw_net | jq -r '.zip')
mobile_net=$(echo $raw_net | jq -r '.mobile')
proxy=$(echo $raw_net | jq -r '.proxy')

# --- HARDWARE (GETPROP & PROC) ---
model=$(getprop ro.product.model)
brand=$(getprop ro.product.brand)
device=$(getprop ro.product.device)
board=$(getprop ro.board.platform)
cpu_abi=$(getprop ro.product.cpu.abi)
hardware=$(getprop ro.hardware)
bootloader=$(getprop ro.bootloader)
fingerprint=$(getprop ro.build.fingerprint)
security_patch=$(getprop ro.build.version.security_patch)
android_ver=$(getprop ro.build.version.release)
sdk_ver=$(getprop ro.build.version.sdk)
uptime_sys=$(uptime -p)
kernel_info=$(uname -a)

# --- CPU & MEMORIA ---
cpu_proc=$(grep -m 1 'model name' /proc/cpuinfo | cut -d: -f2 | xargs)
if [ -z "$cpu_proc" ]; then cpu_proc="ARMv8 Processor (Android)"; fi
cores=$(grep -c ^processor /proc/cpuinfo)
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2/1024 " MB"}')
mem_free=$(grep MemFree /proc/meminfo | awk '{print $2/1024 " MB"}')

# --- BATERÍA (Check inteligente) ---
# Intentamos obtener batería. Si falla, es porque falta la APP de Android (no el paquete)
bat_data=$(timeout 2s termux-battery-status 2>/dev/null)
if [[ -z "$bat_data" ]]; then
    bat_info="${R}ERROR: Falta instalar la App 'Termux:API' de PlayStore${N}"
else
    bat_pct=$(echo $bat_data | jq -r '.percentage')
    bat_hlth=$(echo $bat_data | jq -r '.health')
    bat_temp=$(echo $bat_data | jq -r '.temperature')
    bat_stat=$(echo $bat_data | jq -r '.status')
    bat_info="${G}${bat_pct}% ${W}| Salud: ${G}${bat_hlth} ${W}| Temp: ${Y}${bat_temp}°C ${W}| Estado: ${C}${bat_stat}"
fi

# 4. DESPLIEGUE DE INFORMACIÓN (MODO MATRIX)
echo -e "\n${C}>> 📡 [RED E IDENTIDAD DIGITAL]${N}"
echo -e "${W}----------------------------------------"
echo -e "${W}IP Pública    : ${G}$ip"
echo -e "${W}Proveedor ISP : ${G}$isp"
echo -e "${W}Organización  : ${G}$as_net"
echo -e "${W}Ubicación     : ${G}$city, $region, $country ($zip)"
echo -e "${W}Coordenadas   : ${R}$lat, $lon"
echo -e "${W}Zona Horaria  : ${C}$timezone"
echo -e "${W}Datos Móviles : ${Y}$mobile_net"
echo -e "${W}VPN/Proxy     : ${R}$proxy"
echo -e "${W}Enlace Mapa   : ${C}http://googleusercontent.com/maps.google.com/maps?q=$lat,$lon"

echo -e "\n${C}>> 📱 [IDENTIDAD DEL DISPOSITIVO]${N}"
echo -e "${W}----------------------------------------"
echo -e "${W}Modelo Real   : ${G}$model ($device)"
echo -e "${W}Marca         : ${G}$brand"
echo -e "${W}Placa Base    : ${Y}$board"
echo -e "${W}Bootloader    : ${Y}$bootloader"
echo -e "${W}Huella Digital: ${W}${fingerprint:0:40}..."

echo -e "\n${C}>> 🤖 [SISTEMA OPERATIVO]${N}"
echo -e "${W}----------------------------------------"
echo -e "${W}Android Versión: ${G}$android_ver (SDK $sdk_ver)"
echo -e "${W}Parche Segur.  : ${R}$security_patch"
echo -e "${W}Arquitectura   : ${G}$cpu_abi"
echo -e "${W}Kernel         : ${W}${kernel_info:0:45}..."
echo -e "${W}Tiempo Activo  : ${C}$uptime_sys"

echo -e "\n${C}>> ⚡ [HARDWARE Y RECURSOS]${N}"
echo -e "${W}----------------------------------------"
echo -e "${W}Procesador     : ${G}$hardware / $cpu_proc"
echo -e "${W}Núcleos CPU    : ${G}$cores Cores"
echo -e "${W}Memoria RAM    : ${G}$mem_total ${W}(Libre: $mem_free)"
echo -e "${W}Energía        : $bat_info"

echo -e "\n${C}===================================================="
echo -e "${R} [!] ANÁLISIS FORENSE COMPLETADO - LOG DESTRUIDO"
echo -e "${C}====================================================${N}"

