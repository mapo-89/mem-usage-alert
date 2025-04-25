# 🧑‍💻 RAM-Warnung und E-Mail-Benachrichtigung über `msmtp` 📧

Dieses Tool überwacht die **RAM-Auslastung** deines Systems und sendet eine **E-Mail-Benachrichtigung**, wenn der RAM über einen definierten Schwellenwert hinaus ausgelastet ist. Das Skript kann mit **jedem SMTP-Server** verwendet werden, der Passwort-Authentifizierung unterstützt (z. B. Telekom, Gmail, etc.). Es nutzt **msmtp** zum Versand der E-Mails.

Ideal für Server-Monitoring, Performance-Management und Ressourcen-Überwachung.

📖 Diese README ist auch auf [🇬🇧 Englisch](README.md) verfügbar.

## ✨ Features

- ✅ Überwacht die **RAM-Auslastung** deines Systems
- 🧠 Sendet eine **E-Mail-Benachrichtigung** bei RAM-Überlastung
- ✨ Unterstützt **jedem SMTP-Server** mit Passwort-Authentifizierung
- 🔧 Modularer Aufbau mit separaten Skripten für **Installation** und **Konfiguration**
- 📧 Verwendet `msmtp` für den **E-Mail-Versand**
- 🔒 Möglichkeit zur sicheren **Passwortspeicherung** via `.netrc`
- 🔍 Detaillierte **Log-Dateien** zur Diagnose von Fehlern


## ⚙️ Voraussetzungen

Bevor du das Skript verwendest, stelle sicher, dass dein System die folgenden Anforderungen erfüllt:

- 🐧 **Linux-basiertes System** (z. B. Ubuntu, Debian, etc.)
- 📡 Ein **SMTP-Server** mit Passwort-Authentifizierung (z. B. Telekom, Gmail, etc.)
- 📝 `msmtp` für den E-Mail-Versand
- 📜 `awk`, `bc`, `free`, `bash` für das RAM-Überwachungsskript
- 🛠️ `sudo`-Zugriff für die Installation und Konfiguration
- 🔧 **[bash-utils](https://github.com/mapo-89/bash-utils)** muss auf deinem System installiert sein, da es die Basisbibliotheken für das Skript stellt.


## 🚀 Schnellstart

Folge diesen einfachen Schritten, um das RAM-Warnskript schnell auf deinem System zu installieren und zu konfigurieren.

### 📥 Repository klonen:

Lade das Repository auf dein System:

```bash
git clone https://github.com/mapo-89/mem-usage-alert.git
cd mem-usage-alert
chmod +x ./menu.sh
chmod +x scripts/*.sh
```

### ⚙️ Konfiguration

Folgenden Umgebungsvariablen müssen in deiner .env-Datei gesetzt sein:

```bash
# 📧 Mail-Einstellungen
SMTP_USER="user@example.com"         # Dein SMTP-Benutzername
SMTP_HOST="securesmtp.domain.de"     # Dein SMTP-Host (z.B. Gmail, Outlook, etc.)
SMTP_PORT=587                        # SMTP-Port (normalerweise 587 für TLS)
SMTP_PASSWORD="PASSWORD"             # Dein SMTP-Passwort
SMTP_FROM="from@example.com"         # Absender-E-Mail-Adresse
TEST_EMAIL="test@example.com"        # E-Mail-Adresse für den Testversand
ALERT_EMAIL="alert@example.com"      # E-Mail-Adresse für RAM-Warnungen

# ⚠️ Maximale RAM-Auslastung (in Prozent) für Warnungen
RAM_LIMIT=90

# Maximale Einzelprozess-Warnung in MB
RAM_LIMIT_PROC=500
```

### 🛠️ Installations- und Konfigurationsmenü ausführen

Starte das Installationsskript, das dich durch alle notwendigen Schritte führt:

```bash
./menu.sh
```


## 🧑‍💻 Menü zur Verwaltung und Konfiguration

Das Tool bietet ein interaktives Menü, mit dem du verschiedene Aktionen durchführen kannst. Nachdem du das Skript gestartet hast, wirst du aufgefordert, eine der folgenden Optionen auszuwählen:

### Menüoptionen:

1. **📥 RAM-Warnskript installieren**  
   Installiert das `ram-warning.sh`-Skript und kopiert es nach `/usr/local/bin`, um es systemweit auszuführen.

2. **📧 msmtp konfigurieren (SMTP-Mail)**  
   Konfiguriert den E-Mail-Versand über `msmtp`, indem es die erforderlichen Einstellungen für den SMTP-Server, Benutzername und Passwort hinzufügt.

3. **🔐 .netrc-Datei für msmtp manuell einrichten**  
   Tauscht die msmtp-E-Mail-Zugangsdaten sicher in die Datei `~/.netrc` aus, die von msmtp zur Authentifizierung genutzt wird.

4. **🧪 RAM-Warnung testen (manueller Test)**  
   Testet das Skript im Testmodus, um sicherzustellen, dass alles funktioniert, ohne die eigentliche RAM-Auslastung zu überschreiten.

5. **⏰ Cronjob zur Überwachung einrichten**  
   Setzt einen Cronjob, der regelmäßig die RAM-Auslastung überprüft und bei Überschreitung des festgelegten Limits eine E-Mail-Benachrichtigung sendet.

6. **📋 Menü zur Verwaltung von Cronjobs & Logs**  
   Das Projekt enthält zusätzlich ein interaktives Menü, mit dem du Cronjobs verwalten, Logs einsehen und Test-E-Mails versenden kannst.

7. **❌ Beenden**  
   Beendet das Menü und das Skript.

Das Menü führt dich durch die einzelnen Schritte, sodass du die Konfiguration und das Testen der RAM-Überwachung einfach durchführen kannst.


## 🔧 Troubleshooting

Falls du auf Probleme stößt:

1. **Log-Dateien überprüfen:** Schau in die Log-Datei von `msmtp`, um mögliche Fehler zu diagnostizieren: `~/.msmtp.log`.

2. **SMTP-Daten prüfen:** Vergewissere dich, dass deine SMTP-Konfiguration in `msmtprc` korrekt ist (Host, Port, Benutzername und Passwort).

3. **Fehlende Abhängigkeiten:** Überprüfe, ob alle erforderlichen Pakete (z. B. `msmtp`, `bc`, `awk`) installiert sind.


## 📜 Lizenz

Dieses Projekt ist unter der MIT Lizenz lizenziert. 📝


### Zusammenfassung:

Dieses RAM-Warnung & E-Mail-Benachrichtigung-Tool bietet eine einfache Möglichkeit, die RAM-Nutzung deines Systems zu überwachen und automatisch Benachrichtigungen zu versenden. Mit der Konfiguration von msmtp kannst du das Tool flexibel an jeden SMTP-Server anpassen. Ideal für Server-Monitoring und Performance-Management! 🧑‍💻📧