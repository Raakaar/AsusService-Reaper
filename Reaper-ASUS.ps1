<# 
    .Title
        Cerulean Reaper - ASUS Service Neutralizer
    .SYNOPSIS
        Disables problematic ASUS services, tasks, and processes that can trigger false leak shutdowns.
    .DESCRIPTION
        Terminates known ASUS background processes, disables services, and unregisters scheduled tasks 
        known to cause issues with embedded WB_SENSOR logic on select ROG motherboards. 
        Now includes elevation and robust error handling.
    .AUTHOR
        Osei Harper
    .LINTER
        ChatGPT (OpenAI)
    .LICENSE
        MIT License
    .REQUIRES
        Run as Administrator
    .CHANGELOG
        2025-07-30 Original code
        2025-08-06 Added .Notation to header, added elevation logic, standardized CamelCase, 
        2025-08-06 Refined error handling, added non-destructive logging, added archiving and log and archive size limits 
#>

# Elevate script if not running as Administrator
If (-Not ([Security.Principal.WindowsPrincipal]`
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole]::Administrator)) 
    {
        Try 
            {
                Start-Process -FilePath "powershell.exe" `
                    -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`"" `
                    -Verb RunAs -ErrorAction Stop

                Exit
            } 
        
        Catch 
            {
                Write-Error "Elevation failed or cancelled. Script cannot proceed without administrative privileges."
                Exit 1
            }
    }

# Set log and archive locations
Try 
    {
        $LogFolder = "$env:ProgramData\ASUS-Reaper"
        $BaseLog   = "kill.log"
        $LogPath   = Join-Path $LogFolder $BaseLog

        # Create Log Folder
        If (!(Test-Path -Path $LogFolder)) 
            {
                New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
            }

        #Archive older logs
        $ArchiveFolder = Join-Path $LogFolder "Archive"
        If (!(Test-Path -Path $LogFolder)) 
            {
                New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
            }

        #Create an archive folder
        If (!(Test-Path -Path $ArchiveFolder)) 
            {
                New-Item -ItemType Directory -Path $ArchiveFolder -Force | Out-Null
            }

        # Move any logs >30  to archive folder
        $MaxLogs = 30
        $LogFiles = Get-ChildItem -Path $LogFolder -Filter "*.log" | Sort-Object LastWriteTime

        If ($LogFiles.Count -ge $MaxLogs) 
            {
                $LogsToArchive = $LogFiles | Select-Object -First ($LogFiles.Count - $MaxLogs + 1)
                ForEach ($OldLog in $LogsToArchive) 
                    {
                        $TimeStamp = $OldLog.LastWriteTime.ToString("yyyy-MM-dd_HHmmss")
                        $ArchiveName = "Archived_$TimeStamp.log"
                        $Destination = Join-Path $ArchiveFolder $ArchiveName
                        Move-Item -Path $OldLog.FullName -Destination $Destination -Force
                    }
            }

        # Cleanup Archive Folder if >100 entries
        $MaxArchiveCount = 100
        $ArchivedLogs = Get-ChildItem -Path $ArchiveFolder -Filter "*.log" | Sort-Object LastWriteTime

        If ($ArchivedLogs.Count -gt $MaxArchiveCount) 
            {
                $ExtraLogs = $ArchivedLogs | Select-Object -First ($ArchivedLogs.Count - $MaxArchiveCount)
                ForEach ($Log in $ExtraLogs) 
                    {
                        Remove-Item $Log.FullName -Force
                    }
            }


        
        # If the log file already exists, append numeric suffix
        If (Test-Path $LogPath) 
            {
                $i = 1
                Do 
                    {
                        $LogPath = Join-Path $LogFolder "kill_{0:000}.log" -f $i
                        $i++
                    } 
                Until(-Not (Test-Path $LogPath))
            }
    }
Catch 
    {
        Write-Error "Unable to create log directory at $LogPath. Exiting."
        Exit 1
    }

# Logging Function
Function Log($Msg) 
    {
        "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Msg" | Out-File -FilePath $LogPath -Append
    }

$Targets = @(
    "asus_framework", "ASUSFanControlService", "LightingService",
    "AsusCertService", "AsusUpdateCheck", "asComSvc", "atkexComSvc",
    "ASUSUpdate", "AsSysCtrlService", "DIPAwayMode", "AsIO", "AsUpIO"
    )

Log "=== Cerulean Reaper Triggered ==="

# Terminate ASUS processes
Get-Process -ErrorAction SilentlyContinue | Where-Object { $Targets -contains $_.Name } | ForEach-Object {
    Try 
        {
            Stop-Process -Id $_.Id -Force -ErrorAction Stop
            Log "Terminated: $($_.Name) (PID $($_.Id))"
        } 
    Catch 
        {
            Log "Failed to kill: $($_.Name)"
        }
    }

# Disable ASUS services
ForEach ($Svc in $Targets) 
    {
        $MaxRetries = 5
        $Attempt = 0
        $Success = $False
        $Service = $Null
        While (! $Success -and $Attempt -lt $MaxRetries)
            {

                Try 
                    {                
                        $Service = Get-CimInstance -ClassName Win32_Service -Filter "Name = '$Svc'" | Select-Object Name, StartMode
                        Set-Service -Name $Svc -StartupType Disabled -ErrorAction Stop
                        Stop-Service -Name $Svc -Force -ErrorAction Stop
                        Start-Sleep 2
                        Log "Disabled service: $Svc"
                        $Success = $True
                    } 
                Catch 
                    {
                        $Attempt++
                        Start-Sleep 1
                    }
            }

        If (!$Success) 
            {
                If ($Service -and $Service.StartMode -eq "Disabled") 
                    {
                        Log "Service $Svc is already disabled."
                    } 
                Else 
                    {
                        Log "$Svc not found or could not be disabled after $MaxRetries attempts."
                    }
            }
    }

# Remove ASUS scheduled tasks
Get-ScheduledTask | Where-Object { $_.TaskName -like "*ASUS*" -or $_.TaskPath -like "*ASUS*" } | ForEach-Object {
    Try 
        {
            Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction Stop
            Log "Removed scheduled task: $($_.TaskName)"
        } 
    Catch 
        {
            Log "Failed to remove scheduled task: $($_.TaskName)"
        }
    }

Log "=== Cerulean Reaper Complete ==="