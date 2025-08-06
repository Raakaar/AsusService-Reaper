# Cerulean Reaper

![PowerShell](https://img.shields.io/badge/Built%20with-PowerShell-blue.svg)
![MIT License](https://img.shields.io/github/license/Raakaar/AsusService-Reaper)
![GitHub Releases](https://img.shields.io/github/v/release/Raakaar/AsusService-Reaper)
![Security](https://img.shields.io/badge/Mitigates-CVE--2025--3462|3463-critical)

## Why "Reaper"?  

- It reaps unstable processes ASUS won’t.  
- It resurrects systems they abandoned.  
- Unlike ASUS, it leaves control in *your* hands.  

## ASUS Service Neutralization Utility  

### This tool disables ASUS services that *they* won’t fix

If your ASUS ROG motherboard suddenly displays “Water Leak Detected” and shuts down your system—even when you're not using a water cooling loop—this script is for you. This open-source PowerShell tool disables false telemetry from WB_SENSOR headers that trigger unexpected shutdowns on Crosshair, Maximus, and other ROG boards.

- Repository: AsusService-Reaper
- Author: Osei Harper
- Documentation Assistance: ChatGPT (OpenAI)
- License: MIT
- Version: 1.1.1

Release Date: August 6, 2025

---

## 🆕 What’s New in v1.1.1

- Automatic UAC elevation  
- Centralized timestamped logging with rotation  
- Archive cleanup after 100+ logs  
- Retry logic for stubborn ASUS services  
- Improved error messaging and log clarity  
- Silent background registration of the kill script  

---

## 🧭 Overview

**Cerulean Reaper** is a PowerShell-based defensive utility designed to detect and disable telemetry services, drivers, and scheduled tasks with known CVEs that trigger false shutdowns. ASUS has not patched these.  
It addresses recent ASUS driver vulnerabilities (CVE-2025-3462, CVE-2025-3463) by minimizing persistent background services that compromise system stability.

Built for creators, gamers, and professionals using ASUS motherboards—who deserve peace, not phantom processes.

The utility deploys a **boot-time SYSTEM-level scheduled task** that proactively disables:

- ASUS service processes (e.g., asus_framework, atkexComSvc)
- Fan and sensor control daemons (AsusFanControlService)
- Preloaded shutdown triggers initiated by wininit.exe
- ASUS-linked scheduled tasks and update trapshooks

---

## ⚠️ What Problem Does It Solve?

Systems with ASUS motherboards—especially those involving custom water loops, AIOs, or heavy ASUS software integration—may experience **automated shutdowns triggered by false leak, thermal, or pump alerts**, often without user consent or visible cause.

### Typical symptoms include:

Sudden shutdowns logged as:

- The process wininit.exe (127.0.0.1) has initiated the shutdown...
- Reason Code: 0x80070000 (Legacy API shutdown)
- Kernel Event ID 41 or 1074
- Event Log codes: 1074 or Kernel-Power 41
- No Windows Update, task, or user action responsible

Cerulean Reaper neutralizes these conditions before they can take effect.

### ⚠️ **Note**: Disabling these services will break ASUS software features (e.g., RGB lighting control, fan curve tuning, Armoury Crate). Only use this tool if ASUS tools are impacting your system stability or you care about security.

---

## 🔐 Security Justification

ASUS' recent BIOS-level driver behavior has led to system instability, unexpected shutdowns, and elevated attack surfaces. This tool directly mitigates patterns related to:

- **CVE-2025-3462**: Vulnerability in Armoury Crate background service installation behavior
- **CVE-2025-3463**: ASUS DriverHub privilege escalation vector via persistent scheduled tasks and AsIO3.sys

**Cerulean Reaper** disables known ASUS system hooks and services that align with these CVEs, helping protect users who cannot afford to replace expensive hardware.

See official CVE entries:  
[CVE-2025-3462 – NVD](https://nvd.nist.gov/vuln/detail/CVE-2025-3462)  
[CVE-2025-3463 – NVD](https://nvd.nist.gov/vuln/detail/CVE-2025-3463)

### 🧷 Cited Vulnerabilities & Research

- **Researcher**: Paul (“Mr Bruh”)
-- [ASUS DriverHub Threats](https://mrbruh.com/asusdriverhub/)
-- [ASUS RMA System Exploit](https://mrbruh.com/asus_p2/)

- **Related CVEs:**
-- [CVE-2025-3462](https://www.cve.org/CVERecord?id=CVE-2025-3462) – Armoury Crate privilege escalation via AsusCertService
-- [CVE-2025-3463](https://www.cve.org/CVERecord?id=CVE-2025-3463) – DLL sideloading vulnerability in ASUS system control stack

- **Additional references:**
-- [AsIO3.sys Driver Vulnerability (Talos)](https://blog.talosintelligence.com/deep-dive-into-asio3/)
-- [TALOS-2022-1485 – Armoury Crate LPE](https://talosintelligence.com/vulnerability_reports/TALOS-2022-1485)
-- [AyySSHush ASUS Router Exploit](https://www.labs.greynoise.io/grimoire/ayysshush)
-- [ASUS Stealth Botnet Vector](https://www.greynoise.io/blog/stealth-botnet-asus/)

> **By proactively disabling these services at boot**, Cerulean Reaper defends both system stability and local exploit resilience.

---

## ⚙️ Features

- 🔐 Auto-elevates with UAC prompt if not run as Administrator  
- 📁 Rotates logs and archives older ones automatically  
- 🔄 Retries failed service disables up to 5 times  
- 🛠️ Registers self-running SYSTEM task with robust error handling  
- 🛡️ Terminates ASUS background processes on boot
- ⛔ Disables services tied to thermal/leak shutdowns
- 🧹 Removes ASUS-related scheduled tasks
- 🔁 Persistent via SYSTEM-level scheduled task
- 📄 Logs all actions to `C:\ProgramData\ASUS-Reaper\kill.log`
- 🔓 Licensed under MIT for open sharing and modification

---

## 🧪 Installation

### 1. Clone or Download the Repository

- git clone https://github.com/Raakaar/AsusService-Reaper.git

### 2. Register the Task

Open PowerShell as Administrator, then:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Register-ReaperTask.ps1

This will:

- Copy Reaper-ASUS.ps1 into C:\ProgramData\ASUS-Reaper\
- Create a boot-triggered task named Cerulean-ASUS-Reaper
- Register it to run silently and immediately on every startup

---

### 3. Reboot

The tool will now neutralize ASUS threats automatically at each boot.

### 📁 Files Included

| File | Purpose |
|---------------------------|-------------------------------------------------------------------------|
| Reaper-ASUS.ps1 | Main kill routine for ASUS processes, services, and tasks |
| Register-ReaperTask.ps1 | One-time setup script for persistent boot scheduling |
| .gitignore | Ignores logs, temp files, and PowerShell editor artifacts |
| LICENSE | MIT License (fully open-source) |
| README.md | This file |

---

## 🧯 Uninstallation

To remove Cerulean Reaper:

### 1. Delete the scheduled task:

Unregister-ScheduledTask -TaskName "Cerulean-ASUS-Reaper" -Confirm:$false

### 2. Delete the script folder:

Remove-Item "C:\ProgramData\ASUS-Reaper" -Recurse -Force

### 3. Reboot twice. ASUS services (ArmoryCrate, MyAsus) will reinstall or prompt for reinstallation automatically on next boot. (Some features may require manual ASUS software reinstallation)

---

## 🧠 Future Enhancements

- 🔔 Optional email or popup alert if ASUS services respawn
- ⛔ AppLocker / Defender policy to permanently block ASUS services
- 🧬 WMI/Registry watcher for ASUS reinstall attempts

---

## 🙌 Credits

Author: Osei Harper
Documentation Assistance: ChatGPT (OpenAI)
Proofreader: DeepSeek

---

## 📜 License

MIT License

Copyright (c) 2025, Osei Harper 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

**Disclaimer**: ASUS is a registered trademark of ASUSTeK Computer Inc. This project is not affiliated with ASUS. Use at your own risk.

---

## Corporate Response Protocol

### 🚨 If ASUS Contacts You  

- Politely decline NDAs.  
- Redirect to public GitHub issues.  
- Cite their silence: *"No official patch exists as of {current date}."*

---

## 💸 Support This Project

If Cerulean Reaper saved your system, spared your sanity, or inspired your curiosity—consider supporting continued development and new features.

- [![Sponsor](https://img.shields.io/badge/Sponsor-%E2%9D%A4-lightgrey?logo=github)](https://github.com/sponsors/Raakaar)
- [![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-Support%20the%20Project-yellow?logo=buy-me-a-coffee&logoColor=white)](https://coff.ee/raakaar)
- [![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/OseiHarper)

Every bit helps. Thank you 🙏

---

## 🙏 Appreciation

If this tool helped you stabilize your system or saved you time, consider **⭐ starring** the repo to help others find it.

Feedback, forks, and pull requests are welcome—especially if you’ve got improvements to error handling, service detection, or OS compatibility.

---

## 📋 Documentation

- [CHANGELOG.md](./CHANGELOG.md) for a full list of updates.
- [Release Notes](./RELEASENOTES.md)
