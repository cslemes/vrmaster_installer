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
    @{ server = "6"; address = "10.200.101.201" }
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

$userPath = [System.Environment]::GetFolderPath('UserProfile')

$shortcutPath = [System.IO.Path]::Combine($userPath, "Desktop", "VRMaster.lnk")

$rdpFilePath = [System.IO.Path]::Combine($userPath, "VRMaster.rdp")


Set-Content -Path $rdpFilePath -Value $remoteAppParams

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $rdpFilePath
$Shortcut.Save()


Write-Progress -Activity "Instalando aplicativos..." -Completed
Write-Host "Todos os instaladores foram concluídos!"
