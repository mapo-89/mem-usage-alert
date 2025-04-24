[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo "❌ Dieses Skript ist als Bibliothek gedacht und nicht direkt ausführbar."; exit 1; };

# utils/validators.sh - Validatoren für Skripte

# === 🔍 IP-Adresse validieren (IPv4, optional mit /CIDR) ===
validate_ip() {
  local ip="$1"

  # Überprüfen, ob die IP-Adresse entweder im Format "IP-Adresse" oder "IP-Adresse/Prefix" vorliegt
  if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/([0-9]|[1-2][0-9]|3[0-2]))?$ ]]; then
    log_error "Ungültiges IP-Adressformat: $ip"
    return 1
  fi
 
  # Extrahieren der IP-Adresse und des optionalen Prefixes
  local ip_address
  local prefix
  # Zerlegen in IP und Prefix (wenn vorhanden)
  if [[ "$ip" == */* ]]; then
    ip_address=$(echo "$ip" | cut -d'/' -f1)
    prefix=$(echo "$ip" | cut -d'/' -f2)
  else
    ip_address="$ip"
    prefix=""
  fi

  # Überprüfen, ob die IP-Adresse im gültigen Bereich ist (0-255 für jedes Oktett)
  IFS='.' read -r -a ip_array <<< "$ip_address"
  for octet in "${ip_array[@]}"; do
    if [[ "$octet" -lt 0 || "$octet" -gt 255 ]]; then
      log_error "Ungültige IP-Adresse: $ip_address"
      return 1
    fi
  done

  # Wenn ein Prefix angegeben ist, überprüfen, ob dieser im gültigen Bereich (0-32) liegt
  if [[ -n "$prefix" && ("$prefix" -lt 0 || "$prefix" -gt 32) ]]; then
    log_error "Ungültiger Prefix: /$prefix"
    return 1
  fi

  log_success "Gültige IP-Adresse: $ip"
  return 0
}

# === 🌐 Domain validieren ===
validate_domain() {
  local domain="$1"

  if [[ "$domain" =~ ^([a-zA-Z0-9][-a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$ ]]; then
    log_success "Gültige Domain: $domain"
    return 0
  else
    log_error "Ungültige Domain: $domain"
    return 1
  fi
}

# === 🔢 Port validieren (1–65535) ===
validate_port() {
  local port="$1"

  if [[ "$port" =~ ^[0-9]+$ ]] && [[ "$port" -ge 1 && "$port" -le 65535 ]]; then
    log_success "Gültiger Port: $port"
    return 0
  else
    log_error "Ungültiger Port: $port"
    return 1
  fi
}

# === 📁 Verzeichnis prüfen ===
validate_directory() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    log_success "Verzeichnis existiert: $dir"
    return 0
  else
    log_error "Verzeichnis nicht gefunden: $dir"
    return 1
  fi
}

# === 📝 Datei prüfen ===
validate_file() {
  local file="$1"

  if [[ -f "$file" ]]; then
    log_success "Datei existiert: $file"
    return 0
  else
    log_error "Datei nicht gefunden: $file"
    return 1
  fi
}