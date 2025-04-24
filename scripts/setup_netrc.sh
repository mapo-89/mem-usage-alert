#!/bin/bash
# 📧 Einrichten der .netrc-Datei für msmtp

# === 📚 Bibliotheken laden ===
source ./utils/lib.sh

NETRC_PATH="$HOME/.netrc"

log_info "🔐 Starte Einrichtung der .netrc-Datei für msmtp."

# === ✍️ Nutzerinformationen abfragen ===
read -rp "🌐  SMTP-Server (z.B. smtp.t-online.de): " smtp_host
read -rp "📧  SMTP-Benutzername (z.B. deine@mail.de): " smtp_user

echo -n "🔑  SMTP-Passwort (wird nicht angezeigt): "
read -rs smtp_pass
echo ""

# === 📁 Bestehende .netrc sichern, falls vorhanden ===
if [[ -f "$NETRC_PATH" ]]; then
  cp "$NETRC_PATH" "${NETRC_PATH}.bak"
  log_info "Bestehende .netrc wurde gesichert als .netrc.bak"
fi

# === 📝 Neue .netrc schreiben ===
cat > "$NETRC_PATH" <<EOF
machine $smtp_host
login $smtp_user
password $smtp_pass
EOF

chmod 600 "$NETRC_PATH"
log_success ".netrc erfolgreich erstellt unter $NETRC_PATH"

# === 🔍 Ausgabe anzeigen ===
echo
log_info "Inhalt von ~/.netrc:"
echo
cat "$NETRC_PATH" | sed 's/password .*/password ********/' | sed 's/^/   /'

echo
log_warning "Achte darauf, dass diese Datei vertraulich bleibt."

# ==== ✉️ Testversand (optional) ====

read -p "📤 Möchtest du eine Testmail senden? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  require_var "TEST_EMAIL" "Empfängeradresse (TEST_EMAIL) in .env"
  echo -e "Subject: Testmail von $(hostname)\n\nDies ist eine Testmail über msmtp." | msmtp "$TEST_EMAIL" \
    && log_success "📨 Testmail erfolgreich gesendet an $TEST_EMAIL." \
    || log_error "Testmail konnte nicht gesendet werden."
fi