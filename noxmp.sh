#!/bin/bash

# --- NOXMAP v2.0: INFRA & GEO INTEL (TERMUX) ---
clear
echo -e "\e[1;31m"
echo "  _  _  _____  __  __  __  ____ "
echo " | \| |/ _ \ \/ / |  \/  |/  _ \ "
echo " | . ' | (_) >  <  | |\/| |  __/ "
echo " |_|\_|\___/_/\_\ |_|  |_|_|    "
echo -e "   \e[1;37m[ GEO-INFRAESTRUCTURA Y DNS ]\e[0m"
echo "--------------------------------------------------------"

read -p " URL/Dominio: " target

# 1. LIMPIEZA DE HOST
host=$(echo $target | sed -e 's|^[^/]*//||' -e 's|/.*$||')
echo -e "\n\e[1;34m[*] Objetivo:\e[0m $host"

# 2. RESOLUCIÓN DE IP
ip=$(dig +short $host | tail -n1)
if [ -z "$ip" ]; then
    echo -e "\e[1;31m[!] No se pudo resolver la IP.\e[0m"
    exit 1
fi

# 3. GEOLOCALIZACIÓN (País, Ciudad, ISP)
geo=$(curl -s "http://ip-api.com/json/$ip")
pais=$(echo $geo | grep -o '"country":"[^"]*' | cut -d'"' -f4)
ciudad=$(echo $geo | grep -o '"city":"[^"]*' | cut -d'"' -f4)
isp=$(echo $geo | grep -o '"isp":"[^"]*' | cut -d'"' -f4)

echo -e "\e[1;32m[+] UBICACIÓN FÍSICA:\e[0m"
echo "    > IP: $ip"
echo "    > País: $pais"
echo "    > Ciudad: $ciudad"
echo "    > Proveedor (ISP): $isp"

# 4. MÁQUINA Y ÚLTIMA ACTUALIZACIÓN (HTTP Headers)
echo -e "\n\e[1;32m[+] INFO DEL SERVIDOR Y WEB:\e[0m"
headers=$(curl -Is "https://$host" --connect-timeout 5 || curl -Is "http://$host" --connect-timeout 5)
server=$(echo "$headers" | grep -i "server" | cut -d':' -f2 | xargs)
last_mod=$(echo "$headers" | grep -i "last-modified" | cut -d':' -f2- | xargs)
cache=$(echo "$headers" | grep -i "x-cache" | cut -d':' -f2- | xargs)

echo "    > Máquina: ${server:-Protegida/Desconocida}"
echo "    > Última mod. web: ${last_mod:-No declarada (Dinámica)}"
echo "    > Estado Cache: ${cache:-N/A}"

# 5. ANÁLISIS DNS (Nameservers y SOA)
echo -e "\n\e[1;36m[+] CONFIGURACIÓN DNS:\e[0m"
echo "    > Servidores de Nombre (NS):"
dig +short NS $host | sed 's/^/      - /'

# Extraer el serial del registro SOA (indica actualizaciones técnicas del dominio)
soa=$(dig +short SOA $host | awk '{print $3}')
echo "    > Serial de zona (SOA): ${soa:-Desconocido}"

# 6. INFRAESTRUCTURA ENLAZADA
echo -e "\n\e[1;36m[+] IPS VINCULADAS:\e[0m"
dig +short A $host | grep -v "$ip" | sed 's/^/    - /'

echo "--------------------------------------------------------"
echo -e "\e[1;37m"
read -p ">>> [PRESIONA ENTER PARA VOLVER AL PANEL] <<<" dummy

