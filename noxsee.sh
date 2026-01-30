#!/bin/bash

# --- NOX SEES YOU: OSINT & PHONE INTELLIGENCE ---
clear
echo -e "\e[31m"
echo "  _   _                 ____                            "
echo " | \ | | _____  __  ___/ ___|  ___  ___  ___  _   _    "
echo " |  \| |/ _ \ \/ / / __\___ \ / _ \/ _ \/ __|| | | |   "
echo " | |\  | (_) >  <  \__ \___) |  __/  __/\__ \| |_| |   "
echo " |_| \_|\___/_/\_\ |___/____/ \___|\___||___/ \__,_|   "
echo -e "          \e[1;37m[ NOX SEES YOU - THE EYE IS OPEN ]\e[0m"
echo "--------------------------------------------------------"

read -p "Introduce el número completo (ej: +34600111222): " tlf

# Limpieza de variables
clean=${tlf//+/}
clean=${clean// /}
pais_code=${clean:0:2}
digito_control=${clean:2:1}

echo -e "\n\e[33m[*] Iniciando escaneo profundo sobre: +$clean...\e[0m"
echo "--------------------------------------------------------"

# 1. Identificación de Origen (Geolocalización Lógica)
if [[ "$pais_code" == "34" ]]; then
    pais="España (ES)"
    case $digito_control in
        6|7) tipo="Móvil (Personal/Empresa)" ;;
        8|9) tipo="Fijo (Línea Terrestre)" ;;
        *) tipo="Servicio Especial/Premium" ;;
    esac
else
    pais="Internacional / Desconocido"
    tipo="No identificado"
fi

# 2. Análisis de Presencia en WhatsApp (Anti-Bloqueo)
# Usamos el agente de iPhone para saltar el firewall de la web
scan=$(curl -s -L -A "Mozilla/5.0 (iPhone; CPU OS 16_0 like Mac OS X)" "https://wa.me/$clean" | grep -Ei "action=share|whatsapp://send|send\?phone=")

# 3. Generación de Enlace de Auditoría Google (Spam/Reports)
google_search="https://www.google.com/search?q=quien+me+llama+$clean"

# --- RESULTADOS FINALES ---
echo -e "\e[1;36m[ DETALLES TÉCNICOS ]\e[0m"
echo -e " > País detectado:  $pais"
echo -e " > Tipo de red:     $tipo"
echo -e " > Formato E.164:   +$clean"
echo "--------------------------------------------------------"

echo -e "\e[1;36m[ ANÁLISIS DE REDES ]\e[0m"
if [ ! -z "$scan" ]; then
    echo -e " > WhatsApp:        \e[32mESTADO ACTIVO (Perfil detectado)\e[0m"
else
    echo -e " > WhatsApp:        \e[31mESTADO INACTIVO (Sin rastro)\e[0m"
fi
echo "--------------------------------------------------------"

echo -e "\e[1;36m[ ACCIONES EXTERNAS ]\e[0m"
echo -e " > Buscar reportes: \e[34m$google_search\e[0m"
echo "--------------------------------------------------------"
read -p "Presiona Enter para cerrar el ojo de Nox..."


