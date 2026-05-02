#!/data/data/com.termux/files/usr/bin/bash

# --- COLORS ---
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- SAFE NETWORK DISCOVERY ---
# This method avoids the "netlink" error by looking at 'ip addr' instead of 'ip route'
GET_RANGE=$(ip addr show wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | cut -d. -f1-3 | sed 's/$/.0\/24/')

if [ -z "$GET_RANGE" ]; then
    GET_RANGE="Not Detected"
fi

# --- LOGGING SYSTEM ---
mkdir -p logs
LOG_FILE="logs/scan_$(date +%Y%m%d_%H%M%S).log"

banner() {
    clear
    echo -e "${PURPLE}  ______                      "
    echo " |___  /                      "
    echo "    / / ___ ___  _ __ ___     "
    echo "   / / / __/ _ \| '__/ _ \    "
    echo "  / /_| (_| (_) | | |  __/    "
    echo -e " /_____\___\___/|_|  \___| v2.5${NC}"
    echo -e "${BLUE}      [ Global Scam Hunter Edition ]${NC}"
    echo -e "${CYAN} Network Range: ${GET_RANGE}${NC}\n"
}

# Check if target is set, if not ask user
check_target() {
    if [ "$GET_RANGE" == "Not Detected" ] || [ -z "$GET_RANGE" ]; then
        echo -e "${RED}[!] Automatic network detection failed.${NC}"
        echo -n -e "${YELLOW}[?] Enter Local IP Range (e.g. 192.168.1.0/24): ${NC}"
        read GET_RANGE
    fi
}

menu() {
    banner
    echo -e "${GREEN}[1]${NC} Automated Fast Scan"
    echo -e "${GREEN}[2]${NC} Device Brand Finder (MAC Lookup)"
    echo -e "${GREEN}[3]${NC} Service & Version Detection"
    echo -e "${GREEN}[4]${NC} Full Port Scan (65535 Ports)"
    echo -e "${GREEN}[5]${NC} Vulnerability Scan (NSE)"
    echo -e "${GREEN}[6]${NC} Admin Panel Finder"
    echo -e "${GREEN}[7]${NC} Instagram Scam Hunter"
    echo -e "${GREEN}[8]${NC} Network Info (Public IP)"
    echo -e "${GREEN}[9]${NC} View Logs"
    echo -e "${GREEN}[10]${NC} Update Framework"
    echo -e "${GREEN}[0]${NC} Exit"
    echo ""
    echo -n -e "${PURPLE}Zcore > ${NC}"
    read choice

    case $choice in
        1) check_target; fast_scan ;;
        2) check_target; brand_finder ;;
        3) detailed_scan ;;
        4) deep_scan ;;
        5) vuln_scan ;;
        6) admin_finder ;;
        7) scam_hunter ;;
        8) my_info ;;
        9) view_logs ;;
        10) update_zcore ;;
        0) exit 0 ;;
        *) menu ;;
    esac
}

# --- FUNCTIONS ---

fast_scan() {
    echo -e "${YELLOW}[!] Scanning: $GET_RANGE...${NC}"
    nmap -sn --unprivileged $GET_RANGE | tee -a $LOG_FILE
    read -p "Press Enter..."
    menu
}

brand_finder() {
    echo -e "${YELLOW}[!] Finding brands in $GET_RANGE...${NC}"
    nmap -sP --unprivileged $GET_RANGE | grep -E "report|MAC" | tee -a $LOG_FILE
    read -p "Press Enter..."
    menu
}

detailed_scan() {
    echo -n "Target IP: "; read target
    nmap -sV -T4 --unprivileged $target | tee -a $LOG_FILE
    read -p "Press Enter..."
    menu
}

deep_scan() {
    echo -n "Target IP: "; read target
    nmap -p- -T4 --unprivileged $target | tee -a $LOG_FILE
    read -p "Press Enter..."
    menu
}

vuln_scan() {
    echo -n "Target IP: "; read target
    nmap --script vuln --unprivileged $target | tee -a $LOG_FILE
    read -p "Press Enter..."
    menu
}

admin_finder() {
    echo -n "Target IP: "; read target
    nmap -p 80,443,8080 --script http-enum --unprivileged $target | tee -a $LOG_FILE
    read -p "Press Enter..."
    menu
}

scam_hunter() {
    echo -e "${RED}--- Scam Hunter Analysis ---${NC}"
    read -p "Username: " target
    echo -e "${YELLOW}[*] Logged request for $target${NC}"
    sleep 1
    menu
}

my_info() {
    curl -s https://ifconfig.me/all
    read -p "Press Enter..."
    menu
}

view_logs() {
    ls -lh logs/
    read -p "Press Enter..."
    menu
}

update_zcore() {
    git pull origin main
    sleep 1
    menu
}

menu

