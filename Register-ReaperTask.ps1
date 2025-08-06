<# 
    .Title
        Cerulean Reaper - Reaper Scheduled Task
    .SYNOPSIS
        Automatically runs script to disable problematic ASUS services as a scheduled system task.
    .DESCRIPTION
        Schedules a Task to run at boot that calls Cerulean Reaper. 
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

Add-Type -AssemblyName System.Windows.Forms
$TaskName = "Cerulean-ASUS-Reaper"
$ScriptPath = "C:\ProgramData\ASUS-Reaper\Reaper-ASUS.ps1"

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
                Exit
            }
    }

# Set log and archive locations
Try 
    {
        $LogFolder = "$env:ProgramData\Register-ReaperTask"
        $BaseLog   = "Task.log"
        $LogPath   = Join-Path $LogFolder $BaseLog

        #Create Log Folder
        If (!(Test-Path -Path $LogFolder)) 
            {
                New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
            }

        #Archive older logs
        $ArchiveFolder = Join-Path $LogFolder "Archive"

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
                        $LogPath = Join-Path $LogFolder "Task_{0:000}.log" -f $i
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

Function Log($Msg) 
    {
        "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Msg" | Out-File -FilePath $LogPath -Append
    }
    # Ensure script is deployed

Log "===Starting Register-Reaper Task==="
Try
    {
        $ScriptContent = Get-Content -Raw ".\Reaper-ASUS.ps1"
        New-Item -ItemType Directory -Path (Split-Path $ScriptPath) -Force | Out-Null
        $ScriptContent | Set-Content -Path $ScriptPath -Encoding UTF8
    }
Catch 
    {
        Log "Error deploying Script $($_.Exception.Message)"
        $Message = "Script Failed - please see log:`n$LogPath`n`nClick OK to continue."
        [System.Windows.Forms.MessageBox]::Show($Message, "Installer Alert", 'OK', 'Error')
        Exit 1
    }

# Define task
Try 
    {
        $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
        $Trigger = New-ScheduledTaskTrigger -AtStartup
        $Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

        #Register Task
        Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Description "Executes ASUS kill routine on boot" -Force
    }
Catch 
    {
        Log "Error Scheduling Task $($_.Exception.Message)"
        $Message = "Script Failed - please see log:`n$LogPath`n`nClick OK to continue."
        [System.Windows.Forms.MessageBox]::Show($Message, "Installer Alert", 'OK', 'Error')


        Exit 1
    }

Log "✔️ Cerulean Reaper boot task registered successfully."
