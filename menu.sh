#!/bin/bash
# ./menu.sh – RAM-Warnsystem Setup & Konfiguration

# === 📌 Projekt-Kontext initialisieren ===
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"       # ✅ globaler Pfad zu allen Scripts
LOG_DIR="$SCRIPT_DIR/logs"

# 🔓 Skripte ausführbar machen
find "$SCRIPT_DIR" -type f -name "*.sh" -exec chmod +x {} \;

export ROOT_DIR SCRIPT_DIR SCRIPTS_DIR LOG_DIR

# === 🔗 Bash-Utils laden ===
# Optional: Pfad zu den Bash-Utils überschreiben (wenn lokal statt global)
# BASH_UTILS_DIR="$ROOT_DIR/vendor/bash-utils"
source "${BASH_UTILS_DIR:-/usr/local/bin/bash-utils}/lib.sh"
source "${BASH_UTILS_DIR:-/usr/local/bin/bash-utils}/ui/menu.sh"

# === Menü anzeigen ===
main_menu() {
    clear
    print_line "${GREEN}"
    center_colored_text "📈  RAM-Warnsystem & E-Mail-Benachrichtigung" "${GREEN}"
    print_line_new "${GREEN}"
    center_colored_text "Bitte wähle eine Option zur Installation oder Verwaltung:" "${CYAN}"
    print_line_new "${CYAN}"
}

# Menüoptionen anzeigen
function show_menu {
    echo -e "${CYAN}1)${NC} 📥  RAM-Warnskript installieren"
    echo -e "${CYAN}2)${NC} 📧  msmtp konfigurieren (SMTP-Mail)"
    echo -e "${CYAN}3)${NC} 🔐  .netrc-Datei für msmtp manuell einrichten"
    echo -e "${CYAN}4)${NC} 🧪  RAM-Warnung testen (manueller Test)"
    echo -e "${CYAN}5)${NC} ⏰  Cronjob zur Überwachung einrichten"
    echo -e "${CYAN}6)${NC} 📋  Cronjob-Checker starten"
    echo -e "${CYAN}Esc)${NC} ❌ Beenden"
}

# Funktion zum Handhaben der Auswahl
function handle_selection {
    local choice="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local action=""
    echo
    case "$choice" in
        1)  action="RAM-Warnskript installieren"
            echo "[$timestamp] START: $action" >> "$LOG_FILE"
            $SCRIPTS_DIR/install_ram_warning.sh ;;
        2)  action="msmtp konfigurieren"
            echo "[$timestamp] START: $action" >> "$LOG_FILE"
            $SCRIPTS_DIR/configure_msmtp.sh ;;
        3)  action=".netrc einrichten"
            echo "[$timestamp] START: $action" >> "$LOG_FILE"
            $SCRIPTS_DIR/setup_netrc.sh ;;
        4)  action="RAM-Warnung testen"
            echo "[$timestamp] START: $action" >> "$LOG_FILE"
            $SCRIPTS_DIR/test_ram_warning.sh  ;;
        5)  action="Cronjob einrichten"
            echo "[$timestamp] START: $action" >> "$LOG_FILE"
            $SCRIPTS_DIR/setup_cron.sh ;;
        6)  action="Cronjob-Checker anzeigen"
            $SCRIPTS_DIR/cron-checker.sh  ;;
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
