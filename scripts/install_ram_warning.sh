#!/bin/bash
# 📥 Installiert das RAM-Warnskript

echo 

# Bash-Utils einbinden
source "${BASH_UTILS_DIR:-/usr/local/bin/bash-utils}/core/lib.sh"

# Zielpfad für das Skript
TARGET="/usr/local/bin/ram-warning.sh"

echo
log_info "📥  Installiere ram-warning.sh nach $TARGET..."

# Ersetze '__SCRIPT_DIR__' mit dem aktuellen SCRIPT_DIR in der Vorlage
sed "s|__SCRIPT_DIR__|$SCRIPT_DIR|g" ./ram-warning.sh > "$TARGET"

# Mach das Skript ausführbar
chmod +x "$TARGET"

log_success "RAM-Warnskript wurde installiert und ist bereit."
