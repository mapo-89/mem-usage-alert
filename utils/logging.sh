[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo "❌ Dieses Skript ist als Bibliothek gedacht und nicht direkt ausführbar."; exit 1; };

# utils/logging.sh – Logging-Funktionen

# Farben laden
source ./utils/colors.sh

strip_colors() {
  sed 's/\x1B\[[0-9;]*[mK]//g'
}

log() {
  local type="$1"; shift

  # Prüfen ob --no-log Flag übergeben wurde
  [[ "$1" == "--no-log" ]] && { local log=false; shift; } || log=true

  # Definition der Icons, Farben und Textfarben basierend auf Log-Typ
  declare -A icons=( [info]="ℹ️" [success]="✅" [warning]="⚠️" [error]="❌" [debug]="🔍" )
  declare -A colors=( [info]="$BLUE" [success]="$GREEN" [warning]="$YELLOW" [error]="$RED" [debug]="$CYAN" )
  declare -A textcolors=( [info]="$DARK_GRAY" [success]="$WHITE" [warning]="$YELLOW" [error]="$MAGENTA" [debug]="$LIGHT_GRAY" )

  local icon="${icons[$type]}"
  local color="${colors[$type]}"
  local textcolor="${textcolors[$type]}"
  local label="" && [[ "$type" == "error" ]] && label="Fehler:"

  # Formatierte Nachricht
  local msg="${color}${icon}  ${label:+$label }${textcolor}$*${NC}"
  echo -e "$msg"
  # Loggen in die Datei, falls gewünscht
  $log && echo -e "$msg" | strip_colors >> "$LOG_FILE"
}

log_info()    { log info "$@"; }
log_success() { log success "$@"; }
log_warning() { log warning "$@"; }
log_error()   { log error "$@"; }
log_debug()   { log debug "$@"; }
