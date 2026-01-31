#!/bin/bash
# --- Nostra-Self: AUTO-DOXEO (Versión Auto-Instalable) ---

# --- SECCIÓN DE INSTALACIÓN OBLIGATORIA ---
echo -e "\e[1;33m[*] Verificando y forzando instalación de requisitos...\e[0m"
pkg update -y && pkg upgrade -y
pkg install jq curl termux-api -y > /dev/null 2>&1

clear
echo -e "\e[1;35m"
echo "  _   _           _             ____       _  __ "
echo " | \ | | ___  ___| |_ _ __ __ _/ ___|  ___| |/ _| "
echo " |  \| |/ _ \/ __| __| '__/ _' \___ \ / _ \ | |_  "
echo " | |\  | (_) \__ \ |_| | | (_| |___) |  __/ |  _| "
echo " |_| \_|\___/|___/\__|_|  \__,_|____/ \___|_|_|   "
echo -e "\e[0m"
echo "---------------------------------------------------"

# --- OBTENCIÓN DE DATOS REALES ---

# 1. Datos de Red (Geolocalización por IP)
echo -e "[*] Rastreando conexión..."
info_red=$(curl -s http://ip-api.com/json/)
ip_pub=$(echo $info_red | jq -r '.query')
isp=$(echo $info_red | jq -r '.isp')
ciudad=$(echo $info_red | jq -r '.city')
pais=$(echo $info_red | jq -r '.country')

# 2. Datos de Hardware del Sistema
modelo=$(getprop ro.product.model)
android_v=$(getprop ro.build.version.release)

# 3. Datos de Batería Real (Requiere la App Termux:API instalada en Android)
bateria_raw=$(termux-battery-status 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$bateria_raw" ]; then
    bateria="Error: Instala la App 'Termux:API' de la Play Store"
else
    bateria=$(echo $bateria_raw | jq -r '.percentage')"%"
    estado_bat=$(echo $bateria_raw | jq -r '.status')
fi

# --- INTERFAZ FINAL ---
echo -e "\e[1;32m[+] INFORMACIÓN DE RED:\e[0m"
echo "    IP Pública : $ip_pub"
echo "    Proveedor  : $isp"
echo "    Ubicación  : $ciudad, $pais"

echo -e "\n\e[1;32m[+] INFORMACIÓN DEL TELÉFONO:\e[0m"
echo "    Modelo     : $modelo"
echo "    Android    : Versión $android_v"
echo "    Batería    : $bateria ($estado_bat)"

echo -e "\n\e[1;31m[!] MAPA DE PRECISIÓN:\e[0m"
echo "    https://www.google.com/maps?q=$(echo $info_red | jq -r '.lat'),$(echo $info_red | jq -r '.lon')"
echo -e "\e[0m---------------------------------------------------"
read -p ">>> [PRESIONA ENTER PARA VOLVER AL REPO] <<<" pause

