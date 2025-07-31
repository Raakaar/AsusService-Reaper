# Cerulean Reaper  

![PowerShell](https://img.shields.io/badge/Built%20with-PowerShell-blue.svg)
![MIT License](https://img.shields.io/github/license/Raakaar/AsusService-Reaper)
![GitHub Releases](https://img.shields.io/github/v/release/Raakaar/AsusService-Reaper)
![Security](https://img.shields.io/badge/Mitigates-CVE--2025--3462|3463-critical)
![License](https://img.shields.io/github/license/Raakaar/AsusService-Reaper)
## ASUS Service Neutralization Utility  

ASUS Service Neutralization Utility

- Repository: AsusService-Reaper
- Author: Osei Harper
- Contributor: ChatGPT (OpenAI)
- License: MIT
- Version: 1.0

Release Date: July 30, 2025

---

## 🧭 Overview

**Cerulean Reaper** is a PowerShell-based defensive utility designed to detect and neutralize rogue ASUS background services, drivers, and scheduled tasks that can trigger unwanted system shutdowns.  
It addresses recent ASUS driver vulnerabilities (CVE-2025-3462, CVE-2025-3463) by minimizing persistent background services that compromise system stability.

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

Certain ASUS motherboards—particularly those used in enthusiast builds with water cooling, AIOs, or Armoury Crate—may experience unexpected, clean shutdowns triggered by false thermal, pump, or leak alerts.

- Typical symptoms include:

-- Sudden shutdowns logged as:
--- The process wininit.exe (127.0.0.1) has initiated the shutdown...
--- Reason Code: 0x80070000 (Legacy API shutdown)
-- Kernel Event ID 41 or 1074
-- Event Log codes: 1074 or Kernel-Power 41
-- No Windows Update, task, or user action responsible

Cerulean Reaper neutralizes these conditions before they can take effect..

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

File	Purpose
Reaper-ASUS.ps1	Main kill routine for ASUS processes, services, and tasks
Register-ReaperTask.ps1	One-time setup script for persistent boot scheduling
.gitignore	Ignores logs, temp files, and PowerShell editor artifacts
LICENSE	MIT License (fully open-source)
README.md	This file

---

## 🧯 Uninstallation

To remove Cerulean Reaper:

### 1. Delete the scheduled task:

Unregister-ScheduledTask -TaskName "Cerulean-ASUS-Reaper" -Confirm:$false

### 2. Delete the script folder:

Remove-Item "C:\ProgramData\ASUS-Reaper" -Recurse -Force

---

## 🧠 Future Enhancements

- 🔔 Optional email or popup alert if ASUS services respawn
- ⛔ AppLocker / Defender policy to permanently block ASUS services
- 🧬 WMI/Registry watcher for ASUS reinstall attempts

---

## 🙌 Credits

Author: Osei Harper
Collaborator/Formatter: ChatGPT (OpenAI)

---

## 📜 License

MIT License. Use, fork, enhance, or adapt freely.

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
