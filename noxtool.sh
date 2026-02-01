#!/bin/bash
# ========================================================
#           NOSTRAXITEN DOMINION v2.2 - PURPLE
# ========================================================

# Colores Nostrax (Morado y Cian)
PURPLE='\033[1;35m'
NC='\033[0m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'

run_t() {
    if [ -f "$1" ]; then
        chmod +x "$1"
        ./"$1"
    else
        echo -e "${PURPLE}[!] Error: Archivo $1 no encontrado.${NC}"
        sleep 2
    fi
}

clear
# Banner NOSTRAX en Grande (Morado)
echo -e "${PURPLE}"
echo "  _   _  ____   _____ _______ _____            __   __"
echo " | \ | |/ __ \ / ____|__   __|  __ \     /\    \ \ / /"
echo " |  \| | |  | | (___    | |  | |__) |   /  \    \   / "
echo " | . ' | |  | |\___ \   | |  |  _  /   / /\ \    > <  "
echo " | |\  | |__| |____) |  | |  | | \ \  / ____ \  / . \ "
echo " |_| \_|\____/|_____/   |_|  |_|  \_\/_/    \_\/_/ \_\\"
echo -e "          [ NOSTRAXITEN DOMINION v2.2 ]"
echo -e "${NC}"

echo -e "${CYAN}ID VIC: 23117RA68G | ANDROID: 15${NC}"
echo -e "${PURPLE}--------------------------------------------------------${NC}"

# Las 11 Herramientas Reales de la Suite
echo -e "${YELLOW} 1. Cat's Eye   ${WHITE}-> Sherlock OSINT (catseye.sh)${NC}"
echo -e "${YELLOW} 2. Adox        ${WHITE}-> Auto-Dox Móvil (ADox.sh)${NC}"
echo -e "${YELLOW} 3. NoxCheck    ${WHITE}-> Verificador WhatsApp (NoxCheck.sh)${NC}"
echo -e "${YELLOW} 4. NoxPhone    ${WHITE}-> Generador de Números (Noxphone.sh)${NC}"
echo -e "${YELLOW} 5. AutoPC      ${WHITE}-> Doxxing Remoto PC (autopc.sh)${NC}"
echo -e "${YELLOW} 6. Nopsi       ${WHITE}-> Rastreador de IPs (NOPSI.sh)${NC}"
echo -e "${YELLOW} 7. Nox MX      ${WHITE}-> OSINT de Correo (nomx.sh)${NC}"
echo -e "${YELLOW} 8. NoxSee      ${WHITE}-> Info de Número WA (noxsee.sh)${NC}"
echo -e "${YELLOW} 9. NoxMP       ${WHITE}-> Rastreo Enlaces/IP (noxmp.sh)${NC}"
echo -e "${YELLOW} 10. NoxWS      ${WHITE}-> Rastreo URL WA (noxws.sh)${NC}"
echo -e "${YELLOW} 11. NoxIF      ${WHITE}-> Rastreo URL Interfaz (noxif.sh)${NC}"
echo -e "${PURPLE}--------------------------------------------------------${NC}"
echo -e "${PURPLE} 12. SALIR${NC}"
echo -e "${PURPLE}--------------------------------------------------------${NC}"
echo -ne "${PURPLE}Nostraxiten-Root# ${NC}"

read opt
case $opt in
    1) run_t "catseye.sh" ;;
    2) run_t "ADox.sh" ;;
    3) run_t "NoxCheck.sh" ;;
    4) run_t "Noxphone.sh" ;;
    5) run_t "autopc.sh" ;;
    6) run_t "NOPSI.sh" ;;
    7) run_t "nomx.sh" ;;
    8) run_t "noxsee.py" ;;
    9) run_t "noxmp.sh" ;;
    10) run_t "noxws.sh" ;;
    11) run_t "noxif.sh" ;;
    12) exit 0 ;;
    *) ./noxtool.sh ;;
esac

