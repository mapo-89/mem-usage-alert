[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo "❌ Dieses Skript ist als Bibliothek gedacht und nicht direkt ausführbar."; exit 1; };

# utils/menu.sh – Funktionen für Menüs

# Farben laden
source ./utils/colors.sh

# Funktion für eine Trennlinie
function print_line {
  local color="$1"
    echo -e "${color}════════════════════════════════════════════════════════════${NC}"
}

# Funktion mit Leerzeilen
function print_line_new {
  local color="$1"
  print_line "$color"
  echo
}

# Funktion mit Einzug
function indented_echo {
    local text="$1"
    local indent="  "      # Einrückung (zwei Leerzeichen, kann angepasst werden)
    echo -e "${indent}${text}"
}

# Funktion zum Zentrieren von Text
function center_text {
    local text="$1"
    local cols=60
    local text_length=${#text}
    local padding=$(( (cols - text_length) / 2 ))
    printf "%${padding}s%s\n" "" "$text"
}

# Funktion zum Zentrieren von farbigem Text
function center_colored_text {
    local text="$1"
    local color="$2"
    local cols=60
    local text_length=${#text}
    local padding=$(( (cols - text_length) / 2 ))
    printf "%${padding}s${color}%s${NC}\n" "" "$text"
}