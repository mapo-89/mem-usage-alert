#!/bin/bash
# 📥 Prüft, ob ram-warning.sh existiert, und installiert es, falls nötig. Danach Testmodus ausführen.

echo 

source "${BASH_UTILS_DIR:-/usr/local/bin/bash-utils}/lib.sh"

# Zielpfad, an dem das Skript installiert sein sollte
INSTALL_PATH="/usr/local/bin/ram-warning.sh"

# Funktion zum Fragen, ob die Installation durchgeführt werden soll
ask_installation() {
  read -p "❓ Möchtest du das RAM-Warnskript jetzt installieren? (j/n): " user_choice
  if [[ "$user_choice" == "j" || "$user_choice" == "J" ]]; then
    log_info "🔄  Installation wird durchgeführt..."
    # Hier installierst du das RAM-Warnskript
    ./install_ram_warning.sh  # Der Pfad zum Installationsskript (ändern, falls nötig)
  else
    log_error "Installation abgebrochen."
    exit 1
  fi
}

# Prüfen, ob das Skript bereits installiert ist
if [[ ! -f "$INSTALL_PATH" ]]; then
    log_error "Das RAM-Warnskript ist nicht installiert."
    
    # Den Benutzer fragen, ob er installieren möchte
    ask_installation
fi

# RAM-Warnung im Testmodus ausführen
$INSTALL_PATH --test