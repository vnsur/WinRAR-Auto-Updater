# 🚀 WinRAR Auto Updater

<div align="center">

![WinRAR](https://img.shields.io/badge/WinRAR-Supported-blue?style=for-the-badge&logo=winrar)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?style=for-the-badge&logo=powershell)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue?style=for-the-badge&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Tự động cập nhật WinRAR đến phiên bản mới nhất một cách thông minh và hiệu quả**

[Tính năng](#-tính-năng) •
[Cài đặt](#-cài-đặt) •
[Sử dụng](#-sử-dụng) •
[Cấu hình](#️-cấu-hình) •
[FAQ](#-faq)

</div>

---

## 🌍 Ngôn ngữ

| Ngôn ngữ | README |
|----------|--------|
| 🇺🇸 English | [README.md](README.md) |
| 🇻🇳 **Tiếng Việt** | **README-vi.md** |
| 🇨🇳 中文 | [README-zh.md](README-zh.md) |
| 🇷🇺 Русский | [README-ru.md](README-ru.md) |

---

## 📋 Mục lục

- [🎯 Giới thiệu](#-giới-thiệu)
- [✨ Tính năng](#-tính-năng)
- [📥 Cài đặt](#-cài-đặt)
- [🚀 Sử dụng](#-sử-dụng)
- [⚙️ Cấu hình](#️-cấu-hình)
- [📊 Logs](#-logs)
- [🔧 Khắc phục sự cố](#-khắc-phục-sự-cố)
- [❓ FAQ](#-faq)
- [🤝 Đóng góp](#-đóng-góp)
- [📄 Giấy phép](#-giấy-phép)

## 🎯 Giới thiệu

**WinRAR Auto Updater** là một PowerShell script thông minh giúp bạn tự động cập nhật WinRAR đến phiên bản mới nhất mà không cần can thiệp thủ công. Script hỗ trợ cả phiên bản stable và beta, tự động lên lịch chạy hàng ngày.

### 🎪 Demo

```powershell
# Chạy update ngay lập tức
.\winrar-auto-updater.ps1

# Đăng ký scheduled task (chạy hàng ngày lúc 3:00 AM)
.\winrar-auto-updater.ps1 -register
```

## ✨ Tính năng

### 🔄 **Tự động cập nhật**
- ✅ Tự động phát hiện phiên bản WinRAR hiện tại
- ✅ Kiểm tra phiên bản mới nhất từ trang chính thức RARLab
- ✅ Hỗ trợ cả phiên bản **Stable** và **Beta**
- ✅ Tự động tải xuống và cài đặt phiên bản mới

### 📅 **Lên lịch tự động**
- ⏰ Tự động tạo Windows Scheduled Task
- 🕒 Chạy hàng ngày lúc **3:00 sáng**
- 🔒 Chạy với quyền Administrator
- 📝 Ghi log chi tiết mọi hoạt động

### 🛡️ **An toàn & Thông minh**
- 🚫 Bỏ qua update nếu WinRAR đang chạy
- 🔍 Kiểm tra version trước khi update (tránh downgrade)
- 🧹 Tự động dọn dẹp file tạm sau khi cài đặt
- 📋 Log đầy đủ với timestamp

### 🏗️ **Hỗ trợ kiến trúc**
- 💻 **x64** (64-bit) - Ưu tiên
- 💻 **x32** (32-bit) - Tự động phát hiện

*[Nội dung tiếp theo tương tự như README chính nhưng bằng tiếng Việt]*

---

<div align="center">

### 🌟 Nếu project hữu ích, hãy cho chúng tôi một star! 

**Được tạo với ❤️ bởi [vnsur](https://github.com/vnsur)**

</div>
