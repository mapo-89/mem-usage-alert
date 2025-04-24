[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo "❌ Dieses Skript ist als Bibliothek gedacht und nicht direkt ausführbar."; exit 1; };

# utils/colors.sh - Farben

# ==== Textfarben ====
RED='\033[0;31m'           # Rot
GREEN='\033[0;32m'         # Grün
BLUE='\033[0;34m'          # Blau
YELLOW='\033[0;33m'        # Gelb
LIGHT_BLUE='\033[1;34m'    # Helles Blau
CYAN='\033[0;36m'          # Cyan
MAGENTA='\033[0;35m'       # Magenta
WHITE='\033[1;37m'         # Weißer Text
LIGHT_GRAY='\033[0;37m'    # Hellgrau
DARK_GRAY='\033[1;30m'     # Dunkelgrau

# ==== Hintergrundfarben ====
BLUE_BG='\033[44m'         # Blauer Hintergrund
RED_BG='\033[41m'          # Roter Hintergrund
GREEN_BG='\033[42m'        # Grüner Hintergrund
YELLOW_BG='\033[43m'       # Gelber 

# ==== Zurücksetzen der Farben auf Standard ====
NC='\033[0m'               # Keine Farbe (zurück zum Standard)