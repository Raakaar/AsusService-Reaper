![PowerShell](https://img.shields.io/badge/Built%20with-PowerShell-blue.svg)
![MIT License](https://img.shields.io/github/license/Raakaar/AsusService-Reaper)
![GitHub Releases](https://img.shields.io/github/v/release/Raakaar/AsusService-Reaper)

# Cerulean Reaper  

### ASUS Service Neutralization Utility  

**Repo Name**: `AsusService-Reaper`  
Author: **Osei Harper**  
Contributor: *ChatGPT (OpenAI)*  
License: MIT  
Version: 1.0  
Release Date: July 30, 2025

---

## 🧭 Overview

**Cerulean Reaper** is a PowerShell-based defensive utility that detects and neutralizes background ASUS services, drivers, and scheduled tasks known to trigger *undesired system shutdowns*, particularly those caused by phantom sensor alerts or embedded BIOS-linked components on high-end ASUS motherboards.

The tool deploys as a **boot-time scheduled task** running with SYSTEM-level privileges and neutralizes:

- ASUS background processes (e.g., `asus_framework`, `atkexComSvc`)
- Sensor and fan control services (`AsusFanControlService`)
- Preloaded shutdown triggers (`wininit.exe` via `NT AUTHORITY\SYSTEM`)
- ASUS-related scheduled tasks and update hooks

---

## ⚠️ What Problem Does It Solve?

Systems with ASUS motherboards—especially those involving custom water loops, AIOs, or heavy ASUS software integration—may experience **automated shutdowns triggered by false leak, thermal, or pump alerts**, often without user consent or visible cause.

Symptoms include:

- Clean but unrequested shutdowns logged as:
-- The process wininit.exe (127.0.0.1) has initiated the shutdown...
-- Reason Code: 0x80070000 (Legacy API shutdown)
- Kernel Event ID 41 or 1074
- No scheduled tasks or Windows Updates responsible

Cerulean Reaper **detects and eliminates** these triggers before they can activate.

---

## 🔐 Security Justification

This tool also lowers the attack surface exposed by ASUS firmware-integrated software components. These services persist even after uninstalling Armoury Crate or AI Suite and have been tied to privilege escalation and remote code execution vulnerabilities.

### 🧷 Cited Vulnerabilities & Research

- **Security researcher**: Paul (“Mr Bruh”)
- [ASUS DriverHub Threats](https://mrbruh.com/asusdriverhub/)
- [ASUS RMA System Exploit](https://mrbruh.com/asus_p2/)

- **Related CVEs:**
- [CVE-2025-3462](https://www.cve.org/CVERecord?id=CVE-2025-3462) – Armoury Crate privilege escalation via AsusCertService
- [CVE-2025-3463](https://www.cve.org/CVERecord?id=CVE-2025-3463) – DLL sideloading vulnerability in ASUS system control stack

- **Other references:**
- [AsIO3.sys Driver Vulnerability (Talos)](https://blog.talosintelligence.com/deep-dive-into-asio3/)
- [TALOS-2022-1485 – Armoury Crate LPE](https://talosintelligence.com/vulnerability_reports/TALOS-2022-1485)
- [AyySSHush ASUS Router Exploit](https://www.labs.greynoise.io/grimoire/ayysshush)
- [ASUS Stealth Botnet Vector](https://www.greynoise.io/blog/stealth-botnet-asus/)

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

## 🧪 Usage

### 1. Clone or Download the Repository

git clone https://github.com/<your-username>/AsusService-Reaper.git

### 2. Run the Installer

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

### 🧯 Uninstallation

To remove Cerulean Reaper:

## 1. Delete the scheduled task:

Unregister-ScheduledTask -TaskName "Cerulean-ASUS-Reaper" -Confirm:$false

## 2. Delete the script folder:

Remove-Item "C:\ProgramData\ASUS-Reaper" -Recurse -Force

---

### 🧠 Future Ideas

 - 🔔 Optional email or popup alert if ASUS services respawn
 - ⛔ AppLocker / Defender policy to permanently block ASUS services
 - 🧬 WMI/Registry watcher for ASUS reinstall attempts

---

### 🙌 Credits

Author: Osei Harper
Code Co-pilot: ChatGPT (OpenAI)

---

### 📜 License
MIT License. Use, fork, enhance, or adapt freely.
