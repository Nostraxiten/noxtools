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
    echo " 3. Volver al menú NOSTRAX"
    echo "----------------------------------------------------"
    read -p " Selecciona una opción > " check_opt

    case $check_opt in
        1)
            echo -e "\n\e[33m[*] Archivos detectados:\e[0m"
            ls Noxphone*.txt 2>/dev/null
            echo "----------------------------------------------------"
            read -p " ¿Dónde busco los números? > " lista

            if [ ! -f "$lista" ]; then
                echo -e "\e[31m[!] El archivo '$lista' no existe.\e[0m"
                sleep 2; continue
            fi

            archivo_validos="validos_${lista}"
            > "$archivo_validos"

            while IFS= read -r linea; do
                num=$(echo $linea | awk '{print $1}' | tr -d '+')
                
                # Petición con User-Agent de Android para evitar bloqueos
                # Verificamos si existe el botón de mensaje directo en el HTML
                check=$(curl -s -L -A "Mozilla/5.0 (Linux; Android 10; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5735.196 Mobile Safari/537.36" "https://wa.me/$num" | grep -E "action=share|whatsapp://send")

                if [ ! -z "$check" ]; then
                    echo -e "\e[32m[ACTIVO]\e[0m +$num"
                    echo "+$num" >> "$archivo_validos"
                else
                    echo -e "\e[31m[INACTIVO]\e[0m +$num"
                fi
                sleep 1.5 # Pausa de seguridad para tu IP 213.194.155.205
            done < "$lista"
            read -p "Presiona Enter para continuar..."
            ;;

        2)
            echo -e "\n\e[34m[ MODO MANUAL ]\e[0m"
            echo "Ejemplo -> Prefijo: +34 | Número: 600111222"
            read -p " Prefijo (ej: +34): " pref
            read -p " Número (ej: 600111222): " tlf
            
            p_clean=${pref//+/}
            full_num="${p_clean}${tlf}"
            
            # Buscamos rastro de cuenta activa en el código fuente de la web
            check=$(curl -s -L -A "Mozilla/5.0 (Linux; Android 10; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5735.196 Mobile Safari/537.36" "https://wa.me/$full_num" | grep -E "action=share|whatsapp://send")
            
            # Formateo visual de seguridad
            f_tlf=$(echo $tlf | sed 's/\(...\)\(..\)\(..\)\(..\)/\1 \2 \3 \4/')
            
            if [ ! -z "$check" ]; then
                echo -e "\n\e[32m[!] El número $pref $f_tlf está ACTIVO.\e[0m"
            else
                echo -e "\n\e[31m[!] El número $pref $f_tlf está INACTIVO.\e[0m"
            fi
            read -p "Presiona Enter para continuar..."
            ;;
            
        3) break ;;
        *) echo "Opción no válida"; sleep 1 ;;
    esac
done

