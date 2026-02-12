#!/bin/bash
# ==========================================
# NOXTOOLS v2.2 - NOSTRAXITEN DOMINION
# ==========================================

# Definición de colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AZUL='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
AMARILLO='\033[1;33m'
RESET='\033[0m'

# Función de Logo con el nuevo nombre NOSTRAX
function banner() {
    clear
    echo -e "${MAGENTA}"
    echo "  ███╗   ██╗ ██████╗ ███████╗████████╗██████╗  █████╗ ██╗  ██╗"
    echo "  ████╗  ██║██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚██╗██╔╝"
    echo "  ██╔██╗ ██║██║   ██║███████╗   ██║   ██████╔╝███████║ ╚███╔╝ "
    echo "  ██║╚██╗██║██║   ██║╚════██║   ██║   ██╔══██╗██╔══██║ ██╔██╗ "
    echo "  ██║ ╚████║╚██████╔╝███████║   ██║   ██║  ██║██║  ██║██╔╝ ██╗"
    echo "  ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "               [ NOSTRAX - NOXTOOLS v3.2 ]${RESET}"
    echo -e "${CYAN}------------------------------------------------------------${RESET}"
    echo -e "${AMARILLO}  >> NOSTRAXITEN DOMINION | ANDROID: 15# | ROOT ACCESS <<${RESET}"
    echo -e "${CYAN}------------------------------------------------------------${RESET}"
}

# Menú principal
function menu() {
    banner
    echo -e "${VERDE}# Herramientas de Reconocimiento y Ataque:${RESET}"
    echo -e "  [1] Sherlock OSINT       (catsaye.sh)"
    echo -e "  [2] A.D.OX."
    echo -e "  [3] Auto_Phone Móvil"
    echo -e "  [4] adox.b.sh"
    echo -e "  [5] ${AMARILLO}Zero IP Scanner      (Whois + Geo)${RESET}"
    echo -e "  [6] Rastr. de Callers WA (nero.sh)"
    echo -e "  [7] Gen. Números Priv.   (nophs.sh)"
    echo -e "  [8] noxsee.sh"
    echo -e "  [9] noxwifi.sh"
    echo -e "  [10] Escaneo de Puertos Nmap"
    echo -e "  [11] Metasploit (msfconsole)"
    echo -e "  [0] SALIR"
    echo -e ""
    echo -ne "${CYAN}NOSTRAXITEN-Root# ${RESET}"
    read opcion

    case $opcion in
        1) echo "Lanzando Sherlock..."; sleep 2; menu ;;
        2) echo "Lanzando A.D.OX..."; sleep 2; menu ;;
        3) echo "Lanzando Auto_Phone..."; sleep 2; menu ;;
        4) echo "Lanzando adox.b..."; sleep 2; menu ;;
        5) ./zero.sh ;; # Llama al archivo que tienes en la carpeta
        6) echo "Lanzando Nero..."; sleep 2; menu ;;
        7) echo "Lanzando nophs..."; sleep 2; menu ;;
        8) echo "Lanzando noxsee..."; sleep 2; menu ;;
        9) echo "Lanzando noxwifi..."; sleep 2; menu ;;
        10) echo "Iniciando Nmap..."; sleep 2; menu ;;
        11) msfconsole ;;
        0) clear; exit ;;
        *) echo -e "${ROJO}[!] Opción no válida${RESET}"; sleep 1; menu ;;
    esac
}

menu

