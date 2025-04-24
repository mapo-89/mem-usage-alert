#!/bin/bash
# 📧 Konfiguriert msmtp mit Login-Daten aus ~/.netrc

# ==== 📦 Abhängigkeiten prüfen und installieren ====

source $BASH_UTILS_DIR/lib.sh

log_info "📦 Prüfe auf benötigte Pakete: msmtp & msmtp-mta..."
if ! dpkg -s msmtp msmtp-mta &> /dev/null; then
  log_info "🔧 Installiere msmtp & msmtp-mta..."
  sudo apt update && sudo apt install -y msmtp msmtp-mta
  log_success "msmtp wurde installiert."
else
  log_info "msmtp ist bereits installiert."
fi

# ==== 🛠️ Konfiguration erstellen ====

require_var "SMTP_HOST"      "Beispiel: smtp.t-online.de"
require_var "SMTP_PORT"      "Beispiel: 587"
require_var "SMTP_USER"      "Deine Login-E-Mail"
require_var "SMTP_PASSWORD"  "Dein Passwort"
require_var "SMTP_FROM"      "Von-Adresse für den Mailversand"

CONFIG_PATH="$HOME/.msmtprc"
NETRC_PATH="$HOME/.netrc"
LOGFILE_PATH="$HOME/.msmtp.log"

# === 📝 msmtp-Konfigurationsdatei erstellen ===
log_info "📝 Erstelle Konfigurationsdatei: $CONFIG_PATH"

cat > "$CONFIG_PATH" <<EOF
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        $LOGFILE_PATH

account        default
host           $SMTP_HOST
port           $SMTP_PORT
from           $SMTP_FROM
user           $SMTP_USER
passwordeval   "sed -n 's/^password //p' ~/.netrc | head -n1"
EOF

chmod 600 "$CONFIG_PATH"
log_success "msmtp-Konfiguration gespeichert."

# === 🔐 .netrc-Datei erstellen (optional) ===
if [ ! -f "$NETRC_PATH" ]; then
  log_info "🔐 Erstelle ~/.netrc für Passwortspeicherung..."

  cat > "$NETRC_PATH" <<EOF
machine $SMTP_HOST
login $SMTP_USER
password $SMTP_PASSWORD
EOF

  chmod 600 "$NETRC_PATH"
  log_success "Passwort in ~/.netrc gespeichert."
else
  log_info "🔐 ~/.netrc existiert bereits. Passwort nicht überschrieben."
fi

# ==== ✉️ Testversand (optional) ====

read -p "📤 Möchtest du eine Testmail senden? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  require_var "TEST_EMAIL" "Empfängeradresse (TEST_EMAIL) in .env"
  echo -e "Subject: Testmail von $(hostname)\n\nDies ist eine Testmail über msmtp." | msmtp "$TEST_EMAIL" \
    && log_success "📨 Testmail erfolgreich gesendet an $TEST_EMAIL." \
    || log_error "Testmail konnte nicht gesendet werden."
fi
