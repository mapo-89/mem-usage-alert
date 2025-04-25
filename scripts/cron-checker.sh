#!/bin/bash

# === 🔧 Konfigurationswerte (optional anpassen) ===
SCRIPT_PATH="/usr/local/bin/ram-warning.sh"
LOGFILE="/var/log/ram-warning-cron.log"
TEST_EMAIL_FLAG="--test"

# === 🔗 Bash-Utils laden ===
# Optional: Pfad zu den Bash-Utils überschreiben (wenn lokal statt global)
# BASH_UTILS_DIR="$ROOT_DIR/vendor/bash-utils"
source "${BASH_UTILS_DIR:-/usr/local/bin/bash-utils}/lib.sh"
source "${BASH_UTILS_DIR:-/usr/local/bin/bash-utils}/ui/menu.sh"

# === 🧭 Menü anzeigen ===
main_menu() {
    clear
    print_line "${GREEN}"
    center_colored_text "📋 Cronjob-Checker & RAM-Tool Menü" "${GREEN}"
    print_line_new "${GREEN}"
    center_colored_text "Bitte wähle eine Option zur Installation oder Verwaltung:" "${CYAN}"
    print_line_new "${CYAN}"
}

# Menüoptionen anzeigen
function show_menu {
    echo -e "${CYAN}1)${NC} 📋  Cronjob anzeigen"
    echo -e "${CYAN}2)${NC} 📨  Test-E-Mail auslösen"
    echo -e "${CYAN}3)${NC} 📜  Logs anzeigen"
    echo -e "${CYAN}4)${NC} ⏱️  Letzte Cron-Ausführung checken (syslog)"
    echo -e "${CYAN}Esc)${NC} ❌ Beenden"
}

# Funktion zum Handhaben der Auswahl
function handle_selection {
    local choice="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local action=""
    echo
    case "$choice" in
        1)
          echo ""
          echo "📋 Aktuelle Cronjobs:"
          crontab -l
          ;;
        2)
          echo ""
          echo "📨 Test-E-Mail wird ausgelöst..."
          bash "$SCRIPT_PATH" "$TEST_EMAIL_FLAG"
          ;;
        3)
          echo ""
          echo "📜 Letzte Log-Einträge:"
          tail -n 20 "$LOGFILE"
          ;;
        4)
          echo ""
          echo "⏱️ Suche nach Cron-Ausführungen in /var/log/syslog:"
          grep CRON /var/log/syslog | grep "$(basename $SCRIPT_PATH)" | tail -n 10
          ;;
        5)
          echo "👋 Beende Menü. Bis bald!"
          break
          ;;
        $'\e') echo -e "${RED}❌  Beenden...${NC}"; exit 0 ;;
        *) log_warning --no-log "⚠️ Ungültige Auswahl! Bitte gib eine Zahl zwischen 1 und 6 ein." ;;
      esac
}

# === Start ===
main() {
    while true; do
        main_menu
        show_menu
        echo -n -e "${CYAN}➡️  Bitte wähle eine Option (1–6): ${NC}"
        read -rsn1 choice
        handle_selection "$choice"
        echo
        read -rp "🔁  Drücke [Enter] um fortzufahren..." dummy
    done
}

main