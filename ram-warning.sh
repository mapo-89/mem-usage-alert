#!/bin/bash
# 📧 Sendet E-Mail-Benachrichtigungen bei hoher RAM-Auslastung

# Setze ROOT_DIR aus der installierten Version (wird ersetzt)
SCRIPT_DIR="__SCRIPT_DIR__"

source "${BASH_UTILS_DIR:-/usr/local/bin/bash-utils}/core/lib.sh"

timestamp=$(date "+%Y-%m-%d %H:%M:%S")

log_info "[$timestamp] START: RAM-Warnsystem"
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
log_info "🔍  RAM-Auslastung: ${USED_PERCENT}% (Grenze: ${RAM_LIMIT}%)"

# === 🚨 Warnung bei Überschreitung ===
if (( USED_PERCENT > RAM_LIMIT )); then
  log_warning "🚨 RAM-Limit überschritten!"

  # Top 10 Prozesse für Anzeige (alle Prozesse)
  TOP_PROCESSES=$(ps axo pid,comm,%mem,rss --sort=-rss | head -n 11 | awk 'NR>1 {printf "%-6s %-20s %4s%%  %s MB\n", $1, $2, $3, int($4/1024)}')

  # Top 5 Prozesse zum Neustartversuch (systemd only)
  RAW_TOP=$(ps -eo pid,comm,%mem --sort=-%mem | awk 'NR>1' | head -n 10)
  RESTART_ACTIONS=""
if [[ "$1" != "--test" ]]; then
  while read -r PID COMMAND MEM; do
    UNIT=$(ps -p "$PID" -o unit= | grep -o '^[^ ]*\.service' | head -n1)

    if [[ -n "$UNIT" ]]; then
      if systemctl restart "$UNIT" &>/dev/null; then
        log_info "🔁  Service $UNIT (PID $PID, $MEM%) neu gestartet"
        RESTART_ACTIONS+="✅  $UNIT (PID $PID, $MEM%) neu gestartet\n"
      else
        log_warning "Fehler beim Neustart von $UNIT"
        RESTART_ACTIONS+="⚠️  Fehler beim Neustart von $UNIT (PID $PID)\n"
      fi
    else
      RESTART_ACTIONS+="⏩  Kein systemd-Service: $COMMAND (PID $PID, $MEM%)\n"
    fi
  done <<< "$RAW_TOP"
fi

  # Finaler Mail-Body
  MESSAGE=$(cat <<EOF
🚨 RAM-Auslastung überschritten!

🔢 Aktuelle Nutzung: ${USED_PERCENT}%
🎯 Konfiguriertes Limit: ${RAM_LIMIT}%

🔟 RAM-intensivste Prozesse:
$TOP_PROCESSES

🔁 Automatischer Neustart der RAM-lastigsten Services:
$RESTART_ACTIONS

💡 Modus: $([[ "$1" == "--test" ]] && echo "Test" || echo "Echtbetrieb")
EOF
)

  echo -e "Subject: 🚨 RAM-Warnung\nContent-Type: text/plain; charset=UTF-8\n\n$MESSAGE" | msmtp "$ALERT_EMAIL"
  log_success "📧 RAM-Warnung gesendet an $ALERT_EMAIL"

  # Loggen der Warnung im Logfile
  log_warning "🚨 RAM-Warnung ausgelöst: ${USED_PERCENT}% Nutzung überschreitet das Limit von ${RAM_LIMIT}%"
  log_debug "Top RAM-Prozesse:\n$TOP_PROCESSES"
  log_debug "Service-Neustarts:\n$RESTART_ACTIONS"
else
  log_success " RAM-Nutzung unterhalb des Limits."
fi