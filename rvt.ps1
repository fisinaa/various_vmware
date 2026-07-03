# This PowerShell script automates the generation of RVTools reports. To tailor the script to your infrastructure, update the specified variables accordingly. The script has been successfully tested with the latest RVTools version (4.7).

# Instructions:

# Install RVTools 4.7 on a Windows machine.

# Obtain the encrypted password.

# Update the variables in the script with your infrastructure details.

# Test the script to ensure it functions correctly.

# You can schedule this script to run daily using Windows Task Scheduler.

# Variables:                                                                    ### Fields you should change ###
$rvtoolsPath = "C:\Program Files (x86)\Dell\RVTools\RVTools.exe"                # The "RVTools.exe" path
$basePath = 'C:\path\to\save\reports'                                           # Base Path of report files.
$vCenters = @("vCenter", "IP Address", "or FQDN")                               # vCenter Server FQDN or IP Addresses. Example: @("vcs1.domain.local", "192.168.1.201", ...)
$encryptedPassword = "_RVToolsLongLongLongEncryptedPassword"                    # Run command 'C:\Program Files (x86)\Dell\RVTools\RVToolsPasswordEncryption.ps1' in Powershell to get the encrypted password
$user = "vsphere.local\user"                                                    # vCenter Server User
$date = Get-Date
$monthPath = ($date).ToString("MM-yyyy") 
$dayPath = ($date).ToString("dd-MM")
$fullMonthPath = Join-Path -Path $basePath -ChildPath $monthPath
$fullDayPath = Join-Path -Path $fullMonthPath -ChildPath $dayPath
$logFile = Join-Path -Path $basePath -ChildPath "Log.txt"

# Log Messages
Function Log-Message {
    param (
        [string]$message
    )
    $timeStamp = ($date).ToString("yyyy-MM-dd ; HH:mm:ss")
    Add-Content -Path $logFile -Value "$timeStamp - $message"
}

# Create Month Directory:
if (-not (Test-Path -Path $fullMonthPath)){
    New-Item -Path $basePath -Name $monthPath -ItemType Directory | Out-Null
}

# Create Day Directory:
if (-not (Test-Path -Path $fullDayPath)){
    New-Item -Path $fullMonthPath -Name $dayPath -ItemType Directory | Out-Null
}

# Command Execution:                                                    
foreach ($vCenter in $vCenters){
    $fileName = "$vCenter.xlsx"
    $arguments = "-u $user -p $encryptedPassword -s $vCenter -c ExportAll2xlsx -d $fullDayPath -f $fileName"
    $process = Start-Process -FilePath $rvtoolsPath -ArgumentList $arguments -Wait -NoNewWindow -PassThru
    Log-Message "Running process with Id $($process.Id) for $vCenter"
    if ($process -ne $null){
       ($process).WaitForExit()
       $exitCode = ($process).ExitCode
        if ($exitCode -eq 0){
            Log-Message "Report generated for $vCenter"
        } else {
            Log-Message "Process exited with code $exitCode for $vCenter"
        }
    } else {
        Log-Message "Failed to start RVTools process for $vCenter" 
    }
}
