# Cerulean Reaper - ASUS Neutralizer
# Author: Osei Harper | Contributor: ChatGPT (OpenAI)
# MIT License | Version 1.0

$log = "$env:ProgramData\ASUS-Reaper\kill.log"
New-Item -ItemType Directory -Path (Split-Path $log) -Force | Out-Null

function Log($msg) {
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $msg" | Out-File $log -Append
}

$targets = @(
    "asus_framework", "ASUSFanControlService", "LightingService",
    "AsusCertService", "AsusUpdateCheck", "asComSvc", "atkexComSvc",
    "ASUSUpdate", "AsSysCtrlService", "DIPAwayMode", "AsIO", "AsUpIO"
)

Log "=== Cerulean Reaper Triggered ==="

# Kill ASUS processes
Get-Process | Where-Object { $targets -contains $_.Name } | ForEach-Object {
    try {
        Stop-Process -Id $_.Id -Force
        Log "Terminated: $($_.Name) (PID $($_.Id))"
    } catch {
        Log "Failed to kill: $($_.Name)"
    }
}

# Disable ASUS services
foreach ($svc in $targets) {
    try {
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Log "Disabled service: $svc"
    } catch {
        Log "Service $svc not found or already disabled."
    }
}

# Remove ASUS scheduled tasks
Get-ScheduledTask | Where-Object { $_.TaskName -like "*ASUS*" -or $_.TaskPath -like "*ASUS*" } | ForEach-Object {
    try {
        Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false
        Log "Removed scheduled task: $($_.TaskName)"
    } catch {
        Log "Failed to remove scheduled task: $($_.TaskName)"
    }
}

Log "=== Cerulean Reaper Complete ==="
