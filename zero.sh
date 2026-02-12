#!/bin/bash
# ==========================================
# noxtools - MOD: ZERO.SH (The Investigator)
# ==========================================

# Definición de colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AZUL='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
AMARILLO='\033[1;33m'
RESET='\033[0m'

# Limpiar pantalla y mostrar Logo
clear
echo -e "${MAGENTA}"
echo "  ███████╗███████╗██████╗  ██████╗ "
echo "  ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗"
echo "    ███╔╝ █████╗  ██████╔╝██║   ██║"
echo "   ███╔╝  ██╔══╝  ██╔══██╗██║   ██║"
echo "  ███████╗███████╗██║  ██║╚██████╔╝"
echo "  ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ "
echo -e "         [ NOXTOOLS v1.0 ]${RESET}"
echo -e "${AMARILLO}------------------------------------------${RESET}"

# Pedir la IP al usuario
echo -ne "${CYAN}[?] Introduce la IP de la víctima: ${RESET}"
read IP

# Validar si se introdujo algo
if [ -z "$IP" ]; then
  echo -e "${ROJO}[!] No has puesto ninguna IP. Abortando.${RESET}"
  exit 1
fi

echo -e "\n${AMARILLO}[*] Iniciando protocolos de rastreo...${RESET}"
sleep 1

# 1. Whois (Datos Legales)
echo -e "\n${AZUL}>> BUSCANDO EN BASE DE DATOS WHOIS...${RESET}"
echo "------------------------------------------"
whois $IP | grep -Ei "netname|descr|country|role|address" | sed 's/^/  /'
echo "------------------------------------------"

# 2. IP-API (Geolocalización)
echo -e "\n${VERDE}>> RASTREANDO UBICACIÓN FÍSICA...${RESET}"
echo "------------------------------------------"
# Usamos curl con el formato JSON ordenado
RESULT=$(curl -s "ip-api.com/json/$IP?fields=status,message,country,regionName,city,zip,lat,lon,isp,as,mobile,proxy,query")

# Mostrar datos clave
echo "$RESULT" | json_pp 2>/dev/null || echo "$RESULT"

# 3. Extra: Generar Link de Mapa
LAT=$(echo "$RESULT" | grep -oP '"lat":\s*\K-?\d+\.\d+')
LON=$(echo "$RESULT" | grep -oP '"lon":\s*\K-?\d+\.\d+')

if [ ! -z "$LAT" ]; then
  echo -e "\n${AMARILLO}[+] LINK A GOOGLE MAPS:${RESET}"
  echo -e "  https://www.google.com/maps?q=$LAT,$LON"
fi

echo -e "\n${MAGENTA}------------------------------------------"
echo -e "[+] Análisis finalizado, nostraxiten."
echo -e "------------------------------------------${RESET}"
