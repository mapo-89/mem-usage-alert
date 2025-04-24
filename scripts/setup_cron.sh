#!/bin/bash
# ⏰ Cronjob für RAM-Warnung einrichten

CRON_LINE="*/5 * * * * /usr/local/bin/ram-warning.sh > /dev/null 2>&1"

if crontab -l | grep -Fq "ram-warning.sh"; then
    echo "ℹ️ Cronjob existiert bereits."
else
    (crontab -l 2>/dev/null; echo "$CRON_LINE") | crontab -
    echo "✅ Cronjob eingerichtet: alle 5 Minuten RAM prüfen."
fi