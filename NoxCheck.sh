#!/bin/bash
# --- NOXCHECK v4.1: MÁXIMA PRECISIÓN ---

while true; do
    clear
    echo -e "\e[35m"
    echo "  _   _                 ____ _               _    "
    echo " | \ | | _____  __  __/ ___| |__   ___  ___| | __ "
    echo " |  \| |/ _ \ \/ / / / |   | '_ \ / _ \/ __| |/ / "
    echo " | |\  | (_) >  < / /| |___| | | |  __/ (__|   <  "
    echo " |_| \_|\___/_/\_/_/  \____|_| |_|\___|\___|_|\_\ "
    echo -e "\e[0m"
    echo "----------------------------------------------------"
    echo " 1. Analizar archivo (.txt)"
    echo " 2. Consultar un solo número"
    echo " 3. VOLVER AL MENÚ NOSTRAX"
    echo "----------------------------------------------------"
    read -p "Selecciona una opción > " check_opt

    case $check_opt in
        1)
            # Lista archivos generados por Noxphone
            ls Noxphone*.txt 2>/dev/null
            read -p "¿Dónde busco los números? > " lista
            [ ! -f "$lista" ] && echo -e "\e[31mArchivo no encontrado\e[0m" && sleep 2 && continue
            
            while IFS= read -r linea; do
                num=$(echo $linea | awk '{print $1}' | tr -d '+')
                # Verificación real por rastro de API en HTML con User-Agent de iPhone
                check=$(curl -s -L -A "Mozilla/5.0 (iPhone; CPU OS 16_0 like Mac OS X)" "https://wa.me/$num" | grep -Ei "action=share|whatsapp://send|send\?phone=")
                if [ ! -z "$check" ]; then
                    echo -e "\e[32m[ACTIVO]\e[0m +$num"
                else
                    echo -e "\e[31m[INACTIVO]\e[0m +$num"
                fi
                sleep 1.5 # Pausa para evitar bloqueo de IP
            done < "$lista"
            read -p "Presiona Enter..." ;;
            
        2)
            echo -e "\n\e[34m[ MODO MANUAL ]\e[0m"
            echo "Ejemplo -> Prefijo: +34 | Número: 600111222"
            read -p "Prefijo (ej: +34): " pref
            read -p "Número: " tlf
            full="${pref//+/}${tlf}"
            
            # Buscamos rastro de cuenta activa en el código fuente
            check=$(curl -s -L -A "Mozilla/5.0 (iPhone; CPU OS 16_0 like Mac OS X)" "https://wa.me/$full" | grep -Ei "action=share|whatsapp://send|send\?phone=")
            
            # Formateo visual del número
            f_tlf=$(echo $tlf | sed 's/\(...\)\(..\)\(..\)\(..\)/\1 \2 \3 \4/')
            
            if [ ! -z "$check" ]; then
                echo -e "\n\e[32m[!] El número $pref $f_tlf está ACTIVO.\e[0m"
            else
                echo -e "\n\e[31m[!] El número $pref $f_tlf está INACTIVO.\e[0m"
            fi
            read -p "Presiona Enter para continuar..." ;;
            
        3) break ;;
    esac
done

