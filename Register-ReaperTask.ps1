# Author: Osei Harper | Contributor: ChatGPT (OpenAI)
# MIT License

$taskName = "Cerulean-ASUS-Reaper"
$scriptPath = "C:\ProgramData\ASUS-Reaper\Reaper-ASUS.ps1"

# Ensure script is deployed
$scriptContent = Get-Content -Raw ".\Reaper-ASUS.ps1"
New-Item -ItemType Directory -Path (Split-Path $scriptPath) -Force | Out-Null
$scriptContent | Set-Content -Path $scriptPath -Encoding UTF8

# Define task
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

# Register it
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Description "Executes ASUS kill routine on boot" -Force

Write-Host "✔️ Cerulean Reaper boot task registered successfully."
