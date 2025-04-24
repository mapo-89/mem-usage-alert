# 🧑‍💻 RAM Monitoring and Email Notification via `msmtp` 📧

This tool monitors the **RAM usage** of your system and sends an **email notification** when the RAM exceeds a defined threshold. The script can be used with **any SMTP server** that supports password authentication (e.g., Telekom, Gmail, etc.). It uses **msmtp** to send the emails.

Ideal for server monitoring, performance management, and resource tracking.

📖 This README is also available in [🇩🇪 German](README.de.md).

---

## ✨ Features

- ✅ Monitors the **RAM usage** of your system
- 🧠 Sends an **email notification** on RAM overload
- ✨ Supports **any SMTP server** with password authentication
- 🔧 Modular structure with separate scripts for **installation** and **configuration**
- 📧 Uses `msmtp` for **email sending**
- 🔒 Option for secure **password storage** via `.netrc`
- 🔍 Detailed **log files** for error diagnostics

---

## ⚙️ Prerequisites

Before using the script, ensure your system meets the following requirements:

- 🐧 **Linux-based system** (e.g., Ubuntu, Debian, etc.)
- 📡 An **SMTP server** with password authentication (e.g., Telekom, Gmail, etc.)
- 📝 `msmtp` for email sending
- 📜 `awk`, `bc`, `free`, `bash` for the RAM monitoring script
- 🛠️ `sudo` access for installation and configuration

---

## 🚀 Quick Start

Follow these simple steps to quickly install and configure the RAM monitoring script on your system.

### 📥 Clone the Repository:

Clone the repository to your system:

```bash
git clone https://github.com/mapo-89/mem-usage-alert.git
cd mem-usage-
chmod +x ./menu.sh
chmod +x scripts/*.sh
```

### ⚙️ Configuration

Set the following environment variables in your .env file:

```bash
# 📧 Email Settings
SMTP_USER="user@example.com"         # Your SMTP username
SMTP_HOST="securesmtp.domain.de"     # Your SMTP host (e.g., Gmail, Outlook, etc.)
SMTP_PORT=587                        # SMTP port (usually 587 for TLS)
SMTP_PASSWORD="PASSWORD"             # Your SMTP password
SMTP_FROM="from@example.com"         # Sender email address
TEST_EMAIL="test@example.com"        # Email address for test sending
ALERT_EMAIL="alert@example.com"      # Email address for RAM warnings

# 📁 Directories (automatically created)
SCRIPTS_DIR="./scripts"
LOG_DIR="./logs"

# ⚠️ Maximum RAM usage (in percentage) for warnings
RAM_LIMIT=90

# Maximum single-process warning in MB
RAM_LIMIT_PROC=500
```

### 🛠️ Run the Installation and Configuration Menu

Run the installation script that guides you through all necessary steps:

```bash
./menu.sh
```


## 🧑‍💻 Menu for Management and Configuration

The tool provides an interactive menu where you can perform various actions. After starting the script, you'll be prompted to select one of the following options:

### 📋 Menu Options

1. **📥 Install RAM Warning Script**  
   Installs the `ram-warning.sh` script and copies it to `/usr/local/bin` for system-wide use.

2. **📧 Configure msmtp (SMTP Email)**  
   Configures email sending via `msmtp` by adding the required settings for the SMTP server, username, and password.

3. **🔐 Manually Set Up `.netrc` File for msmtp**  
   Securely stores the msmtp email credentials in the `~/.netrc` file, which is used by msmtp for authentication.

4. **🧪 Test RAM Warning (Manual Test)**  
   Tests the script in test mode to ensure everything works without exceeding actual RAM usage.

5. **⏰ Set Up Monitoring Cronjob**  
   Creates a cronjob that regularly checks RAM usage and sends an email alert if the defined limit is exceeded.

6. **📜 View Logs**  
   Displays log files to review script output and diagnose errors.

7. **❌ Exit**  
   Exits the menu and closes the script.

The menu guides you step by step so you can easily configure and test RAM monitoring.

---

## 🔧 Troubleshooting

If you run into any issues:

1. **Check log files:** Look into the `msmtp` log file to diagnose errors: `~/.msmtp.log`.

2. **Verify SMTP settings:** Make sure your SMTP configuration in `msmtprc` is correct (host, port, username, and password).

3. **Check dependencies:** Ensure all required packages (e.g., `msmtp`, `bc`, `awk`) are installed.

---

## 📜 License

This project is licensed under the MIT License. 📝

---

### Summary

This RAM Monitoring & Email Notification tool provides a simple way to track your system's RAM usage and automatically send alerts. With `msmtp` configuration, the tool is flexible for any SMTP provider. Perfect for server monitoring and performance management! 🧑‍💻📧