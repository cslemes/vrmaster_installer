param (
    [string]$server
)

if (-not $server) {
    $server = Read-Host "Digite o numero do servidor (ex: 1, 2, 3, 4, 5 ou 6)"
}

if (-not $server) {
    Write-Host "Uso: .\vr_install.ps1 <servidor> (ex: 1, 2, 3, 4, 5 ou 6)"
    exit 1
}

$apps = @(
    @{ server = "1"; address = "10.200.101.196" },
    @{ server = "2"; address = "10.200.101.197" },
    @{ server = "3"; address = "10.200.101.198" },
    @{ server = "4"; address = "10.200.101.199" },
    @{ server = "5"; address = "10.200.101.200" },
    @{ server = "6"; address = "10.200.101.201" },
    @{ server = "8"; address = "172.29.0.10" }
)

foreach ($app in $apps) {
    if ($app.server -eq $server) {
        
        $remoteAppParams = @(
            "alternate full address:s:$($app.address)"
            "alternate shell:s:rdpinit.exe"
            "full address:s:$($app.address)"
            "remoteapplicationmode:i:1"
            "remoteapplicationname:s:VRMaster"
            "remoteapplicationprogram:s:||VRMaster-Prep$($app.server)"
            "disableremoteappcapscheck:i:1"
            "drivestoredirect:s:*"
            "prompt for credentials:i:1"
            "promptcredentialonce:i:0"
            "redirectcomports:i:1"
            "span monitors:i:1"
            "use multimon:i:1"
        ) -join "`n"


    }
}


$icoURL = "https://raw.githubusercontent.com/cslemes/vrmaster_installer/refs/heads/main/VRMaster.ico"
#$icoURL = "https://storage.googleapis.com/linux-pdv/gbardini/util/img/VRMaster.ico"
$icoPath = [System.IO.Path]::Combine($userPath, "VRMaster.ico")

Invoke-WebRequest -Uri $icoURL -OutFile $icoPath


$userPath = [System.Environment]::GetFolderPath('UserProfile')
$shortcutPath = [System.IO.Path]::Combine($userPath, "Desktop", "VRMaster (Nuvem).lnk")
$rdpFilePath = [System.IO.Path]::Combine($userPath, "VRMaster.rdp")
$icoPath = [System.IO.Path]::Combine($userPath, "VRMaster.ico")


Set-Content -Path $rdpFilePath -Value $remoteAppParams
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $rdpFilePath
$Shortcut.IconLocation = $icoPath
$Shortcut.WorkingDirectory = $userPath
$Shortcut.Save()


Write-Host "Atalho atualizado!"
