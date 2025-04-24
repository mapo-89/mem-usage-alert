[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo "❌ Dieses Skript ist als Bibliothek gedacht und nicht direkt ausführbar."; exit 1; };

# utils/file_helper.sh - Hilfsfunktionen für den Umgang mit Dateien

# Funktion zum Überprüfen und Einlesen des Inhalts einer Datei
get_file_content() {
  local file="$1"
  local error_message="$2"

  # Überprüfen, ob die Datei existiert
  if [ ! -f "$file" ]; then
    log_error "$error_message"
    exit 1  # Skript sofort beenden, wenn die Datei fehlt
  fi

  # Den Inhalt der Datei einlesen
  local content=$(<"$file")

  # Überprüfen, ob die Datei leer ist
  if [ -z "$content" ]; then
    log_error "Die Datei $file ist leer. Bitte stelle sicher, dass sie gültige Daten enthält."
    exit 1  # Skript sofort beenden, wenn der Inhalt leer ist
  fi

  # Rückgabe des Inhalts der Datei
  echo "$content"
}