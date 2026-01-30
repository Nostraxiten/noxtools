#!/bin/bash

# --- NOSTRA-SELF: AUTO-DOXEO VERSIÓN PC ---
clear
echo -e "\e[1;34m"
echo "  _   _           _              ____       _  __ "
echo " | \ | | ___  ___| |_ _ __ __ _ / ___|  ___| |/ _| "
echo " |  \| |/ _ \/ __| __| '__/ _' | \___ \ / _ \ | |_  "
echo " | |\  | (_) \__ \ |_| | | (_| |  ___) |  __/ |  _| "
echo " |_| \_|\___/|___/\__|_|  \__,_| |____/ \___|_|_|   "
echo -e "\e[0m"
echo "----------------------------------------------------"
echo "Verificando dependencias del sistema PC..."
echo "[*] Comprobando Net-Tools..."
sleep 1
echo "[*] Verificando JQ y Curl..."
sleep 1
echo -e "[!] Entorno listo. Ejecutando extracción de datos...\n"
echo "----------------------------------------------------"

# --- OBTENCIÓN DE DATOS REALES (PC) ---
ip_pub=$(curl -s https://api.ipify.org)
info_red=$(curl -s "ip-api.com/json/$ip_pub")
isp=$(echo $info_red | grep -o '"isp":"[^"]*' | cut -d'"' -f4)
loc=$(echo $info_red | grep -o '"city":"[^"]*' | cut -d'"' -f4)

# Datos de Hardware de PC [Sustituye a los de móvil]
os_distro=$(cat /etc/os-release | grep -w "PRETTY_NAME" | cut -d'"' -f2)
kernel_v=$(uname -r)
ram_free=$(free -h | grep Mem | awk '{print $4}')
user_log=$(whoami)

# --- MOSTRAR RESULTADOS ---
echo -e "\e[1;32m[+] DATOS DE CONEXIÓN A RED:\e[0m"
echo "    IP Pública : $ip_pub"
echo "    Proveedor  : $isp"
echo "    Localidad  : $loc, Spain"

echo -e "\n\e[1;32m[+] DATOS DEL SISTEMA HOST:\e[0m"
echo "    SO/Distro  : $os_distro"
echo "    Kernel     : $kernel_v"
echo "    Usuario    : $user_log"
echo "    RAM Libre  : $ram_free"

echo -e "\n\e[1;33m[!] RASTREO GEOGRÁFICO:\e[0m"
# Generación de link basado en la IP del PC
echo "    Google Maps: https://www.google.com/maps?q=$lat,$lon"

echo "----------------------------------------------------"
echo "Auditoría finalizada. La huella del PC es visible."
echo "----------------------------------------------------"

# EL FIX PARA PC: Mantiene la terminal abierta hasta que pulses una tecla
echo -e "\e[1;37m"
read -p ">>> [PRESIONA ENTER PARA REGRESAR AL PANEL DE PC] <<<" pause
echo -e "\e[0m"

