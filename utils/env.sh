[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo "❌ Dieses Skript ist als Bibliothek gedacht und nicht direkt ausführbar."; exit 1; };

# utils/env.sh - Hilfsfunktionen für den Umgang mit Umgebungsvariablen

# === 🔄 .env-Datei laden ===
load_env() {
  local env_file=".env"

  if [[ -f "$env_file" ]]; then
    export $(grep -vE '^\s*#' "$env_file" | grep -vE '^\s*$' | xargs)
    log_success --no-log "Umgebungsvariablen aus $env_file geladen."
  else
    log_error --no-log ".env-Datei nicht gefunden im aktuellen Verzeichnis."
    exit 1
  fi
}

# === ❗ Pflichtvariable prüfen ===
require_var() {
  local var_name="$1"
  local description="$2"
  local value="${!var_name}"

  if [ -z "$value" ]; then
    log_error "$var_name ist nicht gesetzt. $description"
    exit 1
  fi
}
