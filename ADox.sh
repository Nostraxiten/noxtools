#!/bin/bash
# --- Nostra-Self: AUTO-DOXEO REAL ---
clear
echo -e "\e[1;35m"
echo "  _   _           _             ____       _  __ "
echo " | \ | | ___  ___| |_ _ __ __ _/ ___|  ___| |/ _| "
echo " |  \| |/ _ \/ __| __| '__/ _' \___ \ / _ \ | |_  "
echo " | |\  | (_) \__ \ |_| | | (_| |___) |  __/ |  _| "
echo " |_| \_|\___/|___/\__|_|  \__,_|____/ \___|_|_|   "
echo -e "\e[0m"
echo "---------------------------------------------------"
echo "Verificando dependencias..."

# Instalación silenciosa de dependencias
pkg install termux-api jq curl -y > /dev/null 2>&1

echo "[!] Todo listo. Iniciando Auto-Doxeo real..."
echo "---------------------------------------------------"

# --- EXTRACCIÓN DE DATOS REALES ---

# 1. Obtención de IP y Red
ip_pub=$(curl -s https://api.ipify.org)
info_red=$(curl -s "http://ip-api.com/json/$ip_pub")
isp=$(echo $info_red | jq -r '.isp')
loc=$(echo $info_red | jq -r '.city')
lat=$(echo $info_red | jq -r '.lat')
lon=$(echo $info_red | jq -r '.lon')

# 2. Datos del Dispositivo Reales (Requiere App Termux:API)
modelo=$(getprop ro.product.model)
android_v=$(getprop ro.build.version.release)

# Captura real de batería usando jq para procesar el JSON de termux-battery-status
bateria_json=$(termux-battery-status 2>/dev/null)
if [ -z "$bateria_json" ]; then
    bateria="Error (Instala Termux:API App)"
else
    bateria=$(echo $bateria_json | jq -r '.percentage')"%"
fi

# --- MOSTRAR RESULTADOS ---
echo -e "\e[1;32m[+] DATOS DE CONEXIÓN:\e[0m"
echo "    IP Pública : $ip_pub"
echo "    Proveedor  : $isp"
echo "    Ubicación  : $loc, Spain"

echo -e "\n\e[1;32m[+] DATOS DEL DISPOSITIVO:\e[0m"
echo "    Móvil      : $modelo"
echo "    Android v. : $android_v"
echo "    Batería    : $bateria"

echo -e "\n\e[1;33m[!] TU UBICACIÓN EN EL MAPA:\e[0m"
echo "    https://www.google.com/maps/place/$lat,$lon"

echo "---------------------------------------------------"
echo "Escaneo finalizado. Tu privacidad está expuesta."
echo "---------------------------------------------------"

echo -e "\e[1;37m"
read -p ">>> [PRESIONA ENTER PARA VOLVER AL PANEL] <<<" pause
echo -e "\e[0m"
either
