#!/bin/bash

# --- NOXPHONE v3: REALISMO AUMENTADO ---
clear
echo -e "\e[33m[ Noxphone: Generador de Números Reales ]\e[0m"

# Sistema incremental de archivos
i=1
while [ -f "Noxphone$i.txt" ]; do
    i=$((i + 1))
done
archivo="Noxphone$i.txt"

echo -e "[*] Generando 15 números realistas en: \e[36m$archivo\e[0m"

for ((n=1; n<=15; n++)); do
    # 1. Prefijo de móvil en España (6 o 7)
    pref=$(( (RANDOM % 2) + 6 ))
    
    # 2. Generar los siguientes 8 dígitos uno por uno para mayor aleatoriedad
    resto=""
    for ((d=1; d<=8; d++)); do
        digito=$(( RANDOM % 10 ))
        resto="${resto}${digito}"
    done
    
    echo "+34$pref$resto" >> "$archivo"
    echo -e "\e[32m[+]\e[0m +34$pref$resto"
done

echo -e "\n\e[32m[!] Archivo guardado. Ahora los números son mucho más caóticos y reales.\e[0m"

