#!/bin/bash

# --- NOPSI v5.0: AGGRESSIVE INTEL & FINGERPRINTING ---
clear
echo -e "\e[33m"
echo "  _   _  ____  _____   _____ _____ "
echo " | \ | |/ __ \|  __ \ / ____|_   _|"
echo " |  \| | |  | | |__) | (___   | |  "
echo " | . ' | |  | |  ___/ \___ \  | |  "
echo " | |\  | |__| | |     ____) |_| |_ "
echo " |_| \_|\____/|_|    |_____/|_____|"
echo -e "       \e[1;37m[ EL OJO DE ODÍN - ESCANEO TOTAL ]\e[0m"
echo "--------------------------------------------------------"

read -p " Introduce la IP o URL: " target

# Conversión de URL a IP
ip=$(host $target 2>/dev/null | grep "has address" | awk '{print $4}' | head -n 1)
[ -z "$ip" ] && ip=$target

echo -e "\n\e[34m[*] Iniciando Auditoría Profunda sobre: $ip...\e[0m"
echo "--------------------------------------------------------"

# 1. GEOLOCALIZACIÓN E ISP
info=$(curl -s "ip-api.com/json/$ip")
echo -e "\e[1;36m[ GEOPOSICIONAMIENTO ]\e[0m"
echo " > ISP: $(echo $info | grep -o '"isp":"[^"]*' | cut -d'"' -f4)"
echo " > Ciudad/País: $(echo $info | grep -o '"city":"[^"]*' | cut -d'"' -f4), $(echo $info | grep -o '"country":"[^"]*' | cut -d'"' -f4)"

# 2. DNS E INFORMACIÓN DE DOMINIO (DIG)
echo -e "\n\e[1;36m[ REGISTROS DNS (DIG) ]\e[0m"
dig +short MX $target > /tmp/mx_rec
if [ -s /tmp/mx_rec ]; then
    echo -e " > Servidores de Correo (MX):"
    cat /tmp/mx_rec | sed 's/^/   - /'
else
    echo " > No se detectaron registros de correo públicos."
fi

# 3. ESCANEO AGRESIVO DE NMAP
echo -e "\n\e[1;36m[ ESCANEO DE SERVICIOS Y VERSIONES ]\e[0m"
echo -e "\e[31m[!] Esto puede tardar 1-2 minutos. No cierres la terminal...\e[0m"
echo "--------------------------------------------------------"

# -A: Agresivo, -T4: Velocidad, -Pn: Saltar descubrimiento de host si hay firewall
nmap -A -T4 -Pn $ip

echo "--------------------------------------------------------"
echo -e "\e[32m[+] Reporte de inteligencia finalizado.\e[0m"
echo -e "\e[1;37m"
read -p ">>> [PRESIONA ENTER PARA VOLVER AL MENÚ NOSTRAX] <<<" dummy
echo -e "\e[0m"

