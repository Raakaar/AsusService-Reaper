# Cerulean Reaper v1.1.1 – Targeted Stability + Robust Logging

This update refines Cerulean Reaper’s ability to reliably neutralize problematic ASUS services that trigger shutdowns due to false water leak alerts on ROG motherboards.

### 🚀 What's New

- **Elevation Detection and Auto-Relaunch**  
  Script now detects non-admin execution and auto-relaunches with elevated permissions.

- **Robust Logging with Rotation & Archiving**  
  - Logs are now saved in `%ProgramData%\ASUS-Reaper`
  - Automatically archives logs beyond 30
  - Deletes oldest archived logs if count exceeds 100

- **Non-Destructive Logging Function**  
  Unified `Log()` function used throughout the script to capture all actions and errors.

- **Retry Logic for Service Control**  
  Now attempts to disable stubborn services up to 5 times before giving up.

- **Task Cleanup**  
  Removes ASUS-related scheduled tasks using `Unregister-ScheduledTask`.

- **Script Failures Now Surface Clearly**  
  User-friendly message boxes appear when deployment or task registration fails.

---

### 🛠 Files Affected

- `Reaper-ASUS.ps1`  
- `Register-ReaperTask.ps1`

---

This version sets the foundation for a broader modular design in future 1.2.x releases.

---

🔗 [Readme](./README.md) | 🪲 [Report Issues](https://github.com/your_repo/issues)
