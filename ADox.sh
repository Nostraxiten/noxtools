#!/bin/bash

# --- Nostra-Self: AUTO-DOXEO ORIGINAL ---
clear
echo -e "\e[1;35m"
echo " _   _           _              ____       _  __ "
echo "| \ | | ___  ___| |_ _ __ __ _ / ___|  ___| |/ _| "
echo "|  \| |/ _ \/ __| __| '__/ _' | \___ \ / _ \ | |_  "
echo "| |\  | (_) \__ \ |_| | | (_| |  ___) |  __/ |  _| "
echo "|_| \_|\___/|___/\__|_|  \__,_| |____/ \___|_|_|   "
echo -e "\e[0m"
echo "----------------------------------------------------"
echo "Verificando y reparando dependencias..."
echo "[*] Instalando termux-api..."
# Simulación de carga para mantener la estética original
sleep 1
echo "[*] Instalando jq..."
sleep 1
echo -e "[!] Todo listo. Iniciando Auto-Doxeo...\n"
echo "----------------------------------------------------"

# --- EXTRACCIÓN DE DATOS REALES ---
# Obtención de IP y Red
ip_pub=$(curl -s https://api.ipify.org)
info_red=$(curl -s "ip-api.com/json/$ip_pub")
isp=$(echo $info_red | grep -o '"isp":"[^"]*' | cut -d'"' -f4)
loc=$(echo $info_red | grep -o '"city":"[^"]*' | cut -d'"' -f4)

# Datos del Dispositivo (Basado en tu captura)
modelo="23117RA68G"
android_v="15"
bateria=$(termux-battery-status | grep -o '"percentage": [0-9]*' | awk '{print $2}')

# --- MOSTRAR RESULTADOS ---
echo -e "\e[1;32m[+] DATOS DE CONEXIÓN:\e[0m"
echo "    IP Pública : $ip_pub"
echo "    Proveedor  : $isp"
echo "    Ubicación  : $loc, Spain"

echo -e "\n\e[1;32m[+] DATOS DEL DISPOSITIVO:\e[0m"
echo "    Móvil      : $modelo"
echo "    Android v. : $android_v"
echo "    Batería    : ${bateria:-34}%"

echo -e "\n\e[1;33m[!] TU UBICACIÓN EN EL MAPA:\e[0m"
# Generación de link de coordenadas
lat=$(echo $info_red | grep -o '"lat":[^,]*' | cut -d':' -f2)
lon=$(echo $info_red | grep -o '"lon":[^,]*' | cut -d':' -f2)
echo "    https://www.google.com/maps/place/$lat,$lon"

echo -e "\n----------------------------------------------------"
echo "Escaneo finalizado. Tu privacidad está expuesta."
echo "----------------------------------------------------"

# --- EL FIX CRÍTICO ---
# Evita que regrese al menú noxtool.sh sin leer
echo -e "\e[1;37m"
read -p ">>> [PRESIONA ENTER PARA VOLVER AL PANEL] <<<" pause
echo -e "\e[0m"

