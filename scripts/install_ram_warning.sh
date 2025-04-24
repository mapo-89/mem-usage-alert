#!/bin/bash
# 📥 Installiert das RAM-Warnskript

echo 

source $BASH_UTILS_DIR/lib.sh

# Zielpfad für das Skript
TARGET="/usr/local/bin/ram-warning.sh"

echo
log_info "📥  Installiere ram-warning.sh nach $TARGET..."

# Ersetze '__ROOT_DIR__' mit dem aktuellen ROOT_DIR in der Vorlage
sed "s|__ROOT_DIR__|$ROOT_DIR|g" ./ram-warning.sh > "$TARGET"

# Mach das Skript ausführbar
chmod +x "$TARGET"

log_success "RAM-Warnskript wurde installiert und ist bereit."
