#!/bin/bash

# --- Paleta de Colores ---
P='\e[1;35m'  # Púrpura/Rosa (Banner y detalles)
G='\e[1;32m'  # Verde (Encabezados)
Y='\e[1;33m'  # Amarillo (Estado/Advertencia)
C='\e[1;36m'  # Cyan (Separadores y Prompt)
W='\e[1;37m'  # Blanco (Opciones)
R='\e[0m'     # Reset

# --- Función de Ejecución ---
run_tool() {
    local file=$1
    if [ -f "$file" ]; then
        echo -e "${G}[+] Iniciando: $file...${R}"
        chmod +x "$file"
        if [[ "$file" == *.py ]]; then
            python3 "$file"
        else
            bash "$file"
        fi
    else
        echo -e "${P}[!] Error: No se encuentra $file${R}"
    fi
    echo -e "\n${Y}Presiona ENTER para volver...${R}"
    read
}

# --- Interfaz Visual ---
while true; do
    clear
    echo -e "${P}"
    echo "  _   _  ___  ____ _____ ____      _    __  __ "
    echo " | \ | |/ _ \/ ___|_   _|  _ \    / \   \ \/ / "
    echo " |  \| | | | \___ \ | | | |_) |  / _ \   \  /  "
    echo " | |\  | |_| |___) || | |  _ <  / ___ \  /  \  "
    echo " |_| \_|\___/|____/ |_| |_| \_\/_/   \_\/_/\_\ "
    echo "                                               "
    echo -e "         [ NOSTRAX - NOXTOOLS v3.2 ]         "
    echo -e "${C}----------------------------------------------------${R}"
    echo -e "${Y} >> NOSTRAXITEN DOMINION | ANDROID: 15# | ROOT ACCESS <<${R}"
    echo -e "${C}----------------------------------------------------${R}"

    echo -e "${G}# Herramientas Disponibles (.sh y .py):${R}"
    
    echo -e "${W}[1] A.D.OX Tool         ${P}(ADox.sh)${R}"
    echo -e "${W}[2] Nox Integrity Check ${P}(NoxCheck.sh)${R}"
    echo -e "${W}[3] Auto PC Connector   ${P}(autopc.sh)${R}"
    echo -e "${W}[4] Gen. Números Priv.  ${P}(nomx.sh)${R}"
    echo -e "${W}[5] Nox Multi-Port      ${P}(noxmp.sh)${R}"
    echo -e "${W}[6] Nox Wifi Auditor    ${P}(noxws.sh)${R}"
    echo -e "${W}[7] NOPSI Scanner       ${P}(NOPSI.sh)${R}"
    echo -e "${W}[8] Auto_Phone Móvil    ${P}(Noxphone.sh)${R}"
    echo -e "${W}[9] Sherlock OSINT      ${P}(catseye.sh)${R}"
    echo -e "${W}[10] Network Interfaces ${P}(noxif.sh)${R}"
    echo -e "${W}[11] NoxSee Python      ${P}(noxsee.py)${R}"
    echo -e "${W}[12] Zero IP Scanner    ${P}(zero.sh)${R}"

    echo -e "\n${P}[0] SALIR${R}"
    
    echo -n -e "\n${C}NOSTRAXITEN-Root# ${R}"
    read opcion

    case $opcion in
        1) run_tool "ADox.sh" ;;
        2) run_tool "NoxCheck.sh" ;;
        3) run_tool "autopc.sh" ;;
        4) run_tool "nomx.sh" ;;
        5) run_tool "noxmp.sh" ;;
        6) run_tool "noxws.sh" ;;
        7) run_tool "NOPSI.sh" ;;
        8) run_tool "Noxphone.sh" ;;
        9) run_tool "catseye.sh" ;;
        10) run_tool "noxif.sh" ;;
        11) run_tool "noxsee.py" ;;
        12) run_tool "zero.sh" ;;
        0) exit 0 ;;
        *) echo -e "${P}[!] Opción no válida${R}"; sleep 1 ;;
    esac
done

