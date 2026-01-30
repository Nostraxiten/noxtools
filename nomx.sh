#!/bin/bash

# --- NOXGHOST: EMAIL DEEP SCANNER ---
clear
echo -e "\e[31m"
echo "  _   _             ____ _               _    "
echo " | \ | | _____  __ / ___| |__   ___  ___| |_  "
echo " |  \| |/ _ \ \/ /| |  _| '_ \ / _ \/ __| __| "
echo " | |\  | (_) >  < | |_| | | | | (_) \__ \ |_  "
echo " |_| \_|\___/_/\_\ \____|_| |_|\___/|___/\__| "
echo -e "          \e[1;37m[ EL OJO QUE TODO LO VE ]\e[0m"
echo "--------------------------------------------------------"

read -p " Introduce el email a investigar: " email
dom=$(echo $email | cut -d'@' -f2)

echo -e "\n\e[33m[*] Iniciando extracción masiva para: $email...\e[0m"
echo "--------------------------------------------------------"

# 1. ANÁLISIS DE INFRAESTRUCTURA (DNS/MX)
echo -e "\e[1;36m[ 1. HUELLA TÉCNICA ]\e[0m"
mx=$(host -t mx $dom 2>/dev/null | head -n 1)
ip=$(host -t a $dom 2>/dev/null | head -n 1 | awk '{print $4}')
echo -e " > Servidor MX: \e[32m${mx:-No detectado}\e[0m"
echo -e " > IP de Dominio: \e[32m${ip:-Desconocida}\e[0m"

# 2. DEDUCCIÓN DE ECOSISTEMA Y DISPOSITIVO
echo -e "\n\e[1;36m[ 2. ECOSISTEMA PROBABLE ]\e[0m"
case $dom in
    *gmail.com) echo " > Dispositivo: Android / Google Pixel (Prob. 85%)" ;;
    *icloud.com|*me.com) echo " > Dispositivo: iPhone / iPad (Prob. 98%)" ;;
    *outlook.com|*hotmail.*) echo " > Dispositivo: Windows / PC / Surface" ;;
    *) echo " > Dispositivo: Profesional / Corporativo" ;;
esac

# 3. RASTREO DE FUGAS (DATA LEAKS)
echo -e "\n\e[1;36m[ 3. VULNERABILIDADES (OSINT) ]\e[0m"
echo " > Verificar filtraciones: https://haveibeenpwned.com/unifiedsearch/$email"
echo " > Rastro en Redes: https://www.google.com/search?q=\"$email\""

# 4. VERIFICACIÓN DE IDENTIDAD (API SIMULATION)
echo -e "\n\e[1;36m[ 4. SERVICIOS VINCULADOS ]\e[0m"
# Intentamos ver si el dominio tiene servicios de alta disponibilidad
check_gravatar=$(curl -s -o /dev/null -w "%{http_code}" "https://www.gravatar.com/avatar/$(echo -n $email | tr '[:upper:]' '[:lower:]' | md5sum | cut -d' ' -f1)")
if [ "$check_gravatar" == "200" ]; then
    echo -e " > Foto de Perfil: \e[32mDETECTADA (Gravatar)\e[0m"
else
    echo -e " > Foto de Perfil: \e[31mNo encontrada\e[0m"
fi

echo "--------------------------------------------------------"
read -p "Presiona Enter para cerrar NoxGhost..."

