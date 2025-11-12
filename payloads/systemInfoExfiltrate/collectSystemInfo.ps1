# System Information Collection Script
# Collects various system information and saves to USB device

$outputPath = "D:\system_info_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$usbDrive = "D:\"

# Check if USB drive is accessible
if (-not (Test-Path $usbDrive)) {
    # Try alternative common drive letters
    $drives = @("E:\", "F:\", "G:\", "H:\")
    foreach ($drive in $drives) {
        if (Test-Path $drive) {
            $usbDrive = $drive
            $outputPath = "$usbDrive\system_info_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            break
        }
    }
}

$output = @"
================================================================================
SYSTEM INFORMATION REPORT
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
================================================================================

"@

# System Information
$output += @"

[OPERATING SYSTEM]
"@
$output += "OS Name: $((Get-CimInstance Win32_OperatingSystem).Caption)`n"
$output += "OS Version: $((Get-CimInstance Win32_OperatingSystem).Version)`n"
$output += "OS Architecture: $((Get-CimInstance Win32_OperatingSystem).OSArchitecture)`n"
$output += "Build Number: $((Get-CimInstance Win32_OperatingSystem).BuildNumber)`n"
$output += "Install Date: $((Get-CimInstance Win32_OperatingSystem).InstallDate)`n"
$output += "Serial Number: $((Get-CimInstance Win32_OperatingSystem).SerialNumber)`n"

# Computer Information
$output += @"

[COMPUTER INFORMATION]
"@
$output += "Computer Name: $env:COMPUTERNAME`n"
$output += "Domain: $env:USERDOMAIN`n"
$output += "Username: $env:USERNAME`n"
$output += "Manufacturer: $((Get-CimInstance Win32_ComputerSystem).Manufacturer)`n"
$output += "Model: $((Get-CimInstance Win32_ComputerSystem).Model)`n"
$output += "Total Physical Memory: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)) GB`n"

# Processor Information
$output += @"

[PROCESSOR]
"@
$output += "Processor: $((Get-CimInstance Win32_Processor).Name)`n"
$output += "Cores: $((Get-CimInstance Win32_Processor).NumberOfCores)`n"
$output += "Logical Processors: $((Get-CimInstance Win32_Processor).NumberOfLogicalProcessors)`n"

# Network Information
$output += @"

[NETWORK ADAPTERS]
"@
$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
foreach ($adapter in $adapters) {
    $output += "Adapter: $($adapter.Description)`n"
    $output += "  MAC Address: $($adapter.MACAddress)`n"
    $output += "  IP Address: $($adapter.IPAddress -join ', ')`n"
    $output += "  Subnet Mask: $($adapter.IPSubnet -join ', ')`n"
    $output += "  Default Gateway: $($adapter.DefaultIPGateway -join ', ')`n"
    $output += "  DNS Servers: $($adapter.DNSServerSearchOrder -join ', ')`n`n"
}

# Local Users
$output += @"

[LOCAL USERS]
"@
$users = Get-CimInstance Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true }
foreach ($user in $users) {
    $output += "Username: $($user.Name) | SID: $($user.SID) | Disabled: $($user.Disabled)`n"
}

# Running Processes
$output += @"

[RUNNING PROCESSES] (Top 20 by CPU)
"@
$processes = Get-Process | Sort-Object CPU -Descending | Select-Object -First 20
foreach ($proc in $processes) {
    $output += "$($proc.ProcessName) | PID: $($proc.Id) | CPU: $($proc.CPU) | Memory: $([math]::Round($proc.WorkingSet64 / 1MB, 2)) MB`n"
}

# Installed Software (Top 30)
$output += @"

[INSTALLED SOFTWARE] (Recent Installations)
"@
$software = Get-CimInstance Win32_Product | Select-Object Name, Version, InstallDate | Sort-Object InstallDate -Descending | Select-Object -First 30
foreach ($app in $software) {
    $output += "$($app.Name) | Version: $($app.Version) | Installed: $($app.InstallDate)`n"
}

# Disk Information
$output += @"

[DISK INFORMATION]
"@
$disks = Get-CimInstance Win32_LogicalDisk
foreach ($disk in $disks) {
    $output += "Drive: $($disk.DeviceID) | Label: $($disk.VolumeName)`n"
    $output += "  Size: $([math]::Round($disk.Size / 1GB, 2)) GB | Free: $([math]::Round($disk.FreeSpace / 1GB, 2)) GB | Used: $([math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 2)) GB`n`n"
}

# System Uptime
$output += @"

[SYSTEM UPTIME]
"@
$uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$output += "Days: $($uptime.Days) | Hours: $($uptime.Hours) | Minutes: $($uptime.Minutes)`n"

# Environment Variables (Sensitive ones)
$output += @"

[ENVIRONMENT VARIABLES]
"@
$output += "TEMP: $env:TEMP`n"
$output += "TMP: $env:TMP`n"
$output += "USERPROFILE: $env:USERPROFILE`n"
$output += "APPDATA: $env:APPDATA`n"
$output += "LOCALAPPDATA: $env:LOCALAPPDATA`n"

$output += @"

================================================================================
END OF REPORT
================================================================================
"@

# Save to USB device
try {
    $output | Out-File -FilePath $outputPath -Encoding UTF8
    # Also create a simple marker file
    "System info collected successfully" | Out-File -FilePath "$usbDrive\.system_info_done" -Encoding ASCII
} catch {
    # If write fails, try to save to temp and copy
    $tempFile = "$env:TEMP\system_info_temp.txt"
    $output | Out-File -FilePath $tempFile -Encoding UTF8
    Start-Sleep -Seconds 2
    Copy-Item $tempFile $outputPath -ErrorAction SilentlyContinue
}

# Self-delete script if possible
Start-Sleep -Seconds 1
Remove-Item $MyInvocation.InvocationName -ErrorAction SilentlyContinue

