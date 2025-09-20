# 🚀 WinRAR Auto Updater

<div align="center">

![WinRAR](https://img.shields.io/badge/WinRAR-Supported-blue?style=for-the-badge&logo=winrar)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?style=for-the-badge&logo=powershell)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue?style=for-the-badge&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Automatically update WinRAR to the latest version intelligently and efficiently**
<br/>
**Tự động cập nhật WinRAR đến phiên bản mới nhất một cách thông minh và hiệu quả**

</div>

---

## 🌍 Languages | Ngôn ngữ | 语言 | Языки

| Language | README |
|----------|--------|
| 🇺🇸 English | [README.md](README.md) |
| 🇻🇳 Tiếng Việt | [README-vi.md](README-vi.md) |
| 🇨🇳 中文 | [README-zh.md](README-zh.md) |
| 🇷🇺 Русский | [README-ru.md](README-ru.md) |

---

## 📋 Table of Contents

- [🎯 Introduction](#-introduction)
- [✨ Features](#-features)
- [📥 Installation](#-installation)
- [🚀 Usage](#-usage)
- [⚙️ Configuration](#️-configuration)
- [📊 Logs](#-logs)
- [🔧 Troubleshooting](#-troubleshooting)
- [❓ FAQ](#-faq)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🎯 Introduction

**WinRAR Auto Updater** is an intelligent PowerShell script that helps you automatically update WinRAR to the latest version without manual intervention. The script supports both stable and beta versions, automatically scheduling daily runs.

### 🎪 Demo

```powershell
# Run update immediately
.\winrar-auto-updater.ps1

# Register scheduled task (runs daily at 3:00 AM)
.\winrar-auto-updater.ps1 -register
```

## ✨ Features

### 🔄 **Auto Update**
- ✅ Automatically detect current WinRAR version
- ✅ Check latest version from official RARLab website
- ✅ Support both **Stable** and **Beta** versions
- ✅ Automatically download and install new version

### 📅 **Scheduled Task**
- ⏰ Automatically create Windows Scheduled Task
- 🕒 Run daily at **3:00 AM**
- 🔒 Run with Administrator privileges
- 📝 Detailed logging of all activities

### 🛡️ **Safe & Smart**
- 🚫 Skip update if WinRAR is running
- 🔍 Check version before update (avoid downgrade)
- 🧹 Automatically clean up temporary files after installation
- 📋 Complete logs with timestamps

### 🏗️ **Architecture Support**
- 💻 **x64** (64-bit) - Priority
- 💻 **x32** (32-bit) - Auto-detect

## 📥 Installation

### System Requirements

| Component | Requirement |
|-----------|-------------|
| **OS** | Windows 10/11 |
| **PowerShell** | 5.1+ |
| **Privileges** | Administrator |
| **Internet** | Stable connection |

### 🔧 Quick Installation

1. **Download script**
   ```bash
   git clone https://github.com/vnsur/winrar-auto-updater.git
   cd winrar-auto-updater
   ```

2. **Set PowerShell execution policy** (one time only)
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Run with Administrator privileges**
   ```powershell
   # Right-click PowerShell -> "Run as Administrator"
   .\winrar-auto-updater.ps1 -register
   ```

## 🚀 Usage

### ⚡ Run Immediately

```powershell
# Update WinRAR right now
.\winrar-auto-updater.ps1
```

### 📅 Register Scheduled Task

```powershell
# Create task to run automatically daily at 3:00 AM
.\winrar-auto-updater.ps1 -register
```

### 🗑️ Remove Scheduled Task

```powershell
# Remove created task
Unregister-ScheduledTask -TaskName "AutoUpdateWinRAR_DarkMethod" -Confirm:$false
```

## ⚙️ Configuration

### 🕒 Change Run Time

Open the script file and modify this line:

```powershell
# Change from 03:00:00 to desired time
$time = [datetime]"03:00:00"  # Example: "01:30:00" for 1:30 AM
```

### 📁 Change Log File Location

```powershell
# Change log file path
$logfile = "C:\winrar-auto-update.log"  # Example: "D:\Logs\winrar.log"
```

### 🎯 Stable Version Only

To disable beta updates, comment these lines:

```powershell
# Comment this block to skip beta versions
# $betaPattern = 'WinRAR.+(\d+\.\d+)\s+beta\s*(\d*)'
# if ($downloadPage -match $betaPattern) {
#     ...
# }
```

## 📊 Logs

Script creates log file at: `C:\winrar-auto-update.log`

### 📋 Log Example

```
[09/20/2025 09:30:15] WinRAR is not running. Proceeding with update...
[09/20/2025 09:30:16] Found stable version: WinRAR 7.13.0
[09/20/2025 09:30:16] Starting update...
[09/20/2025 09:30:45] WinRAR has been updated to version 7.13.0
```

### 📈 Log Status

| Status | Meaning |
|--------|---------|
| ✅ `WinRAR has been updated` | Successfully updated |
| ⏭️ `WinRAR is already up to date` | Already latest version |
| ⚠️ `WinRAR is currently running` | Skipped because WinRAR is running |
| ❌ `Failed to update WinRAR` | Error during update |

## 🔧 Troubleshooting

### ❗ Common Errors

<details>
<summary><b>🚫 "Execution Policy" Error</b></summary>

**Error:**
```
cannot be loaded because running scripts is disabled on this system
```

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
</details>

<details>
<summary><b>🔒 "Access Denied" Error</b></summary>

**Cause:** No Administrator privileges

**Solution:** Right-click PowerShell → "Run as Administrator"
</details>

<details>
<summary><b>🌐 "Download Failed" Error</b></summary>

**Causes:** 
- No internet connection
- Firewall blocking PowerShell
- Download URL changed

**Solutions:**
1. Check internet connection
2. Temporarily disable antivirus/firewall
3. Re-run script
</details>

<details>
<summary><b>📁 "WinRAR not found" Error</b></summary>

**Cause:** WinRAR not installed

**Solution:** Install WinRAR manually before running script
</details>

### 🔍 Debug Mode

To enable debug mode, add this line at the beginning of script:

```powershell
$DebugPreference = "Continue"
```

## ❓ FAQ

<details>
<summary><b>❓ Is the script safe?</b></summary>

✅ **Completely safe!** Script only downloads from official RARLab website and contains no malware.
</details>

<details>
<summary><b>❓ Does it work with cracked WinRAR?</b></summary>

⚠️ Script will overwrite cracked version. We recommend using official version.
</details>

<details>
<summary><b>❓ How to disable auto update?</b></summary>

```powershell
Unregister-ScheduledTask -TaskName "AutoUpdateWinRAR_DarkMethod" -Confirm:$false
```
</details>

<details>
<summary><b>❓ Does it support portable WinRAR?</b></summary>

❌ Currently only supports standard installation, no portable version support.
</details>

<details>
<summary><b>❓ Why does script run at 3:00 AM?</b></summary>

🌙 This is when most people don't use their computers, avoiding work interruption.
</details>

## 🤝 Contributing

We welcome all contributions! 

### 🛠️ How to Contribute

1. **Fork** this repo
2. **Create branch** for new feature: `git checkout -b feature/amazing-feature`
3. **Commit** changes: `git commit -m 'Add amazing feature'`
4. **Push** to branch: `git push origin feature/amazing-feature`
5. **Create Pull Request**

### 🐛 Report Bugs

If you encounter bugs, please [create issue](https://github.com/vnsur/winrar-auto-updater/issues) with information:

- OS version
- PowerShell version  
- Log file content
- Detailed error description

### 💡 Feature Requests

Have a great idea? [Create issue](https://github.com/vnsur/winrar-auto-updater/issues) with `enhancement` label!

## 📄 License

This project is distributed under [MIT License](LICENSE).

```
MIT License - You can use, modify and distribute freely.
```

---

<div align="center">

### 🌟 If this project is helpful, please give us a star! 

**Made with ❤️ by [vnsur](https://github.com/vnsur)**

![GitHub stars](https://img.shields.io/github/stars/vnsur/winrar-auto-updater?style=social)
![GitHub forks](https://img.shields.io/github/forks/vnsur/winrar-auto-updater?style=social)

</div>
