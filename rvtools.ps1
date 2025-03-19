# 
$rvtoolsPath = "C:\Program Files (x86)\RobWare\RVTools\RVTools.exe"

# 
$servers = @("192.168.2.220", "192.168.2.221", "192.168.2.222")

# 
$username = "Administrator"
$password = "password"

# 
$exportBasePath = "C:\temp"

# 
foreach ($server in $servers) {
    $exportPath = "$exportBasePath\$server"
    
    # 
    if (!(Test-Path -Path $exportPath)) {
        New-Item -ItemType Directory -Path $exportPath -Force | Out-Null
    }

    # 
    Write-Host "Start export for $server..."
    Start-Process -FilePath $rvtoolsPath -ArgumentList "-s $server -u $username -p $password -c ExportAll2csv -d $exportPath" -NoNewWindow -Wait
    Write-Host "export ended $server. file save $exportPath"
}
