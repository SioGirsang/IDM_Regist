<div align="center">
  <h1>⚡ IDM Trial Reset Tool</h1>
  <p><strong>Internet Download Manager — Registry Reset Utility</strong></p>
  <p>
    <img src="https://img.shields.io/badge/PowerShell-5.1+-blue?logo=powershell&logoColor=white" alt="PowerShell">
    <img src="https://img.shields.io/badge/Platform-Windows-brightgreen?logo=windows&logoColor=white" alt="Windows">
    <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
    <img src="https://img.shields.io/badge/Maintained-Yes-green" alt="Maintained">
  </p>
  <br>
</div>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🤖 **Fully Automated** | Scans all user registry hives and deletes the IDM trial key automatically |
| 🎨 **Animated Terminal UI** | Spinner animation, progress bar, color-coded status icons |
| 🛡️ **Admin Check** | Verifies Administrator privileges before execution |
| 👥 **Multi-User Support** | Handles all user profiles under `HKEY_USERS` |
| 🧹 **Clean & Safe** | Confirms deletion, no leftover traces |

## 🚀 Quick Start

```powershell
# Option 1: Right-click → Run with PowerShell (recommended)
# Option 2: From admin terminal
powershell -ExecutionPolicy Bypass -File .\reset-idm-trial.ps1
```

### Requirements

- Windows 7 / 8 / 10 / 11
- PowerShell 5.1 or later
- Administrator privileges

## ⚙️ How It Works

The script targets this registry key:

```
HKEY_USERS\*\Classes\{07999AC3-058B-40BF-984F-69EB1E554CA7}
```

1. Enumerates all user hives ending with `_Classes`
2. Searches for the IDM trial GUID `{07999AC3-058B-40BF-984F-69EB1E554CA7}`
3. Deletes the key (recursively) if found
4. Displays a summary of what was cleaned

Deleting this key resets IDM's trial activation state, allowing you to reuse the 30-day trial period.

## 🖥️ Preview

```
  ╔══════════════════════════════════════════════╗
  ║                                              ║
  ║            IDM TRIAL RESET TOOL              ║
  ║         Internet Download Manager            ║
  ║            Registry Cleaner v1.0              ║
  ║                                              ║
  ╚══════════════════════════════════════════════╝

  [>] Scanning hives...
  [██████████████████████████████] 100%
  [v] Key found & deleted!
```

## ⚠️ Disclaimer

> **Use at your own risk.** This tool modifies the Windows Registry. While it only deletes the specific IDM trial key, it is recommended to create a system restore point before running. The author is not responsible for any damage caused by misuse.

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/SioGirsang">SioGirsang</a>
</p>
