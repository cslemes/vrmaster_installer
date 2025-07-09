param (
    [string]$server
)

[int]$serverNumber = 0

while ($true) {
    $server = Read-Host "Digite o número do servidor (1-7) ou 'q' para sair"

    if ($server -eq 'q') {
        Write-Host "Saindo..."
        exit 0
    }

    if ([int]::TryParse($server, [ref]$serverNumber) -and $serverNumber -ge 1 -and $serverNumber -le 7) {
        break
    } else {
        Write-Host "Entrada inválida. Por favor, digite um número entre 1 e 7 ou 'q' para sair."
    }
}

Write-Host "Servidor selecionado: $serverNumber"

$apps = @(
    @{ server = "1"; address = "10.200.101.196" },
    @{ server = "2"; address = "10.200.101.197" },
    @{ server = "3"; address = "10.200.101.198" },
    @{ server = "4"; address = "10.200.101.199" },
    @{ server = "5"; address = "10.200.101.200" },
    @{ server = "6"; address = "10.200.101.201" },
    @{ server = "7"; address = "172.29.0.10" }
)

foreach ($app in $apps) {
    if ($app.server -eq $server) {
        $program = if ($app.server -ne "7") { "||VRMaster-Prep$($app.server)" } else { "||VRMaster" }

        $remoteAppParams = @(
            "alternate full address:s:$($app.address)"
            "alternate shell:s:rdpinit.exe"
            "full address:s:$($app.address)"
            "remoteapplicationmode:i:1"
            "remoteapplicationname:s:VRMaster"
            "remoteapplicationprogram:s:$program"
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
