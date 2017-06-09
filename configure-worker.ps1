[CmdletBinding()]
Param(
  [switch] $SkipEngineUpgrade,
  [string] $DockerVersion = "17.06.0-ce-rc2",
  [string] $DTRFQDN,
  [string] $HubUsername,
  [string] $HubPassword,
  [string] $UcpVersion
)

#Variables
$Date = Get-Date -Format "yyyy-MM-dd HHmmss"
$DockerDataPath = "C:\ProgramData\Docker"

function Disable-RealTimeMonitoring () {
    Set-MpPreference -DisableRealtimeMonitoring $true
}

function Install-LatestDockerEngine () {
    #Get Docker Engine from Master Builds
    Invoke-WebRequest -Uri "https://download.docker.com/win/static/test/x86_64/docker-$DockerVersion-x86_64.zip" -OutFile "docker.zip"

    Stop-Service docker
    Remove-Item -f -Recurse $env:ProgramFiles\docker
    Expand-Archive -Path "docker.zip" -DestinationPath $env:ProgramFiles -Force
    Remove-Item docker.zip

    Start-Service docker
}

function Disable-Firewall () {
    #Disable firewall (temporary)
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

    #Ensure public profile is disabled (solves public profile not persisting issue)
    $data = netsh advfirewall show publicprofile
    $data = $data[3]
    if ($data -Match "ON"){
        Set-NetFirewallProfile -Profile Public -Enabled False
    }

}

function Enable-RemotePowershell () {
    #Enable remote powershell for remote management
    Enable-PSRemoting -Force
    Set-Item wsman:\localhost\client\trustedhosts * -Force
}

function Set-DtrHostnameEnvironmentVariable() {
    $DTRFQDN | Out-File (Join-Path $DockerDataPath "dtr_fqdn")
}

function Fetch-UcpImages() {
    docker login -p $HubPassword -u $HubUsername
    docker pull dockerorcadev/ucp-dsinfo-win:$UcpVersion
    docker pull dockerorcadev/ucp-agent-win:$UcpVersion
}

#Start Script
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

try
{
    Start-Transcript -path "C:\ProgramData\Docker\configure-worker $Date.log" -append

    Write-Host "Disabling Real Time Monitoring"
    Disable-RealTimeMonitoring
    
    if (-not ($SkipEngineUpgrade.IsPresent)) {
        Write-Host "Upgrading Docker Engine"
        Install-LatestDockerEngine
    }

    Write-Host "Disabling Firewall"
    Disable-Firewall

    Write-Host "Enabling Remote Powershell"
    Enable-RemotePowershell

    Write-Host "Set DTR FQDN Environment Variable"
    Set-DtrHostnameEnvironmentVariable

    Write-Host "Restarting machine"
    Stop-Transcript
}
catch
{
    Write-Error $_
}
