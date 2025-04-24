[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo "❌ Dieses Skript ist als Bibliothek gedacht und nicht direkt ausführbar."; exit 1; };

# lib.sh – Hauptbibliothek für Skripte

# Farben laden
source ./utils/colors.sh
LOG_FILE=""
source ./utils/logging.sh
source ./utils/env.sh
load_env

# Verzeichnisse initialisieren
mkdir -p "$SCRIPTS_DIR" "$LOG_DIR"
LOG_FILE="$LOG_DIR/main.log"
mkdir -p "$(dirname "$LOG_FILE")"

source ./utils/validators.sh
#source ./utils/file_helpers.sh