# 🚀 WinRAR 自动更新器

<div align="center">

![WinRAR](https://img.shields.io/badge/WinRAR-Supported-blue?style=for-the-badge&logo=winrar)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?style=for-the-badge&logo=powershell)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue?style=for-the-badge&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**智能高效地自动更新WinRAR到最新版本**

[功能特性](#-功能特性) •
[安装](#-安装) •
[使用方法](#-使用方法) •
[配置](#️-配置) •
[常见问题](#-常见问题)

</div>

---

## 🌍 语言

| 语言 | README |
|------|--------|
| 🇺🇸 English | [README.md](README.md) |
| 🇻🇳 Tiếng Việt | [README-vi.md](README-vi.md) |
| 🇨🇳 **中文** | **README-zh.md** |
| 🇷🇺 Русский | [README-ru.md](README-ru.md) |

---

## 📋 目录

- [🎯 介绍](#-介绍)
- [✨ 功能特性](#-功能特性)
- [📥 安装](#-安装)
- [🚀 使用方法](#-使用方法)
- [⚙️ 配置](#️-配置)
- [📊 日志](#-日志)
- [🔧 故障排除](#-故障排除)
- [❓ 常见问题](#-常见问题)
- [🤝 贡献](#-贡献)
- [📄 许可证](#-许可证)

## 🎯 介绍

**WinRAR Auto Updater** 是一个智能的PowerShell脚本，帮助您自动更新WinRAR到最新版本，无需手动干预。脚本支持稳定版和测试版，自动安排每日运行。

### 🎪 演示

```powershell
# 立即运行更新
.\winrar-auto-updater.ps1

# 注册计划任务（每天凌晨3:00运行）
.\winrar-auto-updater.ps1 -register
```

## ✨ 功能特性

### 🔄 **自动更新**
- ✅ 自动检测当前WinRAR版本
- ✅ 从官方RARLab网站检查最新版本
- ✅ 支持**稳定版**和**测试版**
- ✅ 自动下载并安装新版本

### 📅 **计划任务**
- ⏰ 自动创建Windows计划任务
- 🕒 每天**凌晨3:00**运行
- 🔒 以管理员权限运行
- 📝 详细记录所有活动

### 🛡️ **安全与智能**
- 🚫 如果WinRAR正在运行则跳过更新
- 🔍 更新前检查版本（避免降级）
- 🧹 安装后自动清理临时文件
- 📋 带时间戳的完整日志

### 🏗️ **架构支持**
- 💻 **x64**（64位）- 优先
- 💻 **x32**（32位）- 自动检测


---

<div align="center">

### 🌟 如果项目对您有帮助，请给我们一个星星！

**由 [vnsur](https://github.com/vnsur) 用 ❤️ 制作**

</div>
