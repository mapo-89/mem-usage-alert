#!/bin/bash
# 📧 Sendet E-Mail-Benachrichtigungen bei hoher RAM-Auslastung

# Setze ROOT_DIR aus der installierten Version (wird ersetzt)
ROOT_DIR="__ROOT_DIR__"

source "$ROOT_DIR/utils/lib.sh"

# === ⚙️ Konfiguration laden ===
# Bei Testlauf → RAM-Limit künstlich niedrig setzen
if [[ "$1" == "--test" ]]; then
  RAM_LIMIT=1
  log_warning "🧪 Testmodus aktiv – RAM_LIMIT auf 1% gesetzt"
else
  require_var "RAM_LIMIT" "z.B. RAM_LIMIT=90 in .env"
fi

require_var "ALERT_EMAIL" "z.B. ALERT_EMAIL=admin@example.com in .env"

# === 📈 RAM-Nutzung analysieren ===
USED_PERCENT=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
log_info "🔍 RAM-Auslastung: ${USED_PERCENT}% (Grenze: ${RAM_LIMIT}%)"

# === 🚨 Warnung bei Überschreitung ===
if (( USED_PERCENT > RAM_LIMIT )); then
  log_warning "🚨 RAM-Limit überschritten!"

  TOP_PROCESSES=$(ps axo pid,comm,%mem,rss --sort=-rss | head -n 11 | awk 'NR>1 {printf "%-6s %-20s %4s%%  %s MB\n", $1, $2, $3, int($4/1024)}')

  MESSAGE=$(cat <<EOF
🚨 RAM-Auslastung überschritten!

🔢 Aktuelle Nutzung: ${USED_PERCENT}%
🎯 Konfiguriertes Limit: ${RAM_LIMIT}%

🔟 RAM-intensivste Prozesse:
$TOP_PROCESSES

💡 Modus: $([[ "$1" == "--test" ]] && echo "Test" || echo "Echtbetrieb")
EOF
)

  echo -e "Subject: 🚨 RAM-Warnung\nContent-Type: text/plain; charset=UTF-8\n\n$MESSAGE" | msmtp "$ALERT_EMAIL"
  log_success "📧 RAM-Warnung gesendet an $ALERT_EMAIL"

  # Loggen der Warnung im Logfile
  log_warning "🚨 RAM-Warnung ausgelöst: ${USED_PERCENT}% Nutzung überschreitet das Limit von ${RAM_LIMIT}%"
  log_debug "Top RAM-Prozesse:\n$TOP_PROCESSES"
else
  log_success " RAM-Nutzung unterhalb des Limits."
  log_debug "Aktuelle RAM-Nutzung: ${USED_PERCENT}%"
fi