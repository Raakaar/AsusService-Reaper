# Changelog

All notable changes to this project will be documented in this file.

---

## [v1.1.1] - 2025-08-06

### Added

- UAC elevation detection with auto-relaunch as administrator
- Modular logging function with timestamped output
- Non-Destructive Logging: Existing log files are never overwritten
- Log rotation: Archives `.log` files > 30 entries
- Archive cap: Deletes oldest archives beyond 100
- Retry logic for service control (up to 5 attempts)
- User-friendly MessageBox pop-ups on script failure
- Automatic deployment of `Reaper-ASUS.ps1` into `%ProgramData%`
- Boot-triggered task creation with SYSTEM privileges

### Fixed

- Inconsistent startup behavior due to lack of elevation
- `Win32_Service` returning null results
- Redundant log overwrites from previous runs
- False logging of results
- Silent failures during script or task registration

### Improved

- Standardized CamelCase formatting
- More informative and non-destructive log messages
- Commented structure for easier collaboration
