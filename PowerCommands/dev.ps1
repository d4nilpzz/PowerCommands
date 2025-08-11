$ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath "config.ini"

function Read-IniFile($filePath) {
    $ini = @{}
    $section = "global"
    Get-Content $filePath | ForEach-Object {
        $_ = $_.Trim()
        if ($_ -match "^\[(.+)\]$") {
            $section = $matches[1]
        } elseif ($_ -match "^(.*?)=(.*)$") {
            if (-not $ini[$section]) { $ini[$section] = @{} }
            $ini[$section][$matches[1].Trim()] = $matches[2].Trim()
        }
    }
    return $ini
}

function Update-IniFile($filePath, $section, $key, $newValue) {
    if (-not (Test-Path $filePath)) {
        Write-Output "Error: config.ini not found."
        return $false
    }

    if ((Get-Item $filePath).IsReadOnly) {
        Set-ItemProperty -Path $filePath -Name IsReadOnly -Value $false
    }

    $content = Get-Content $filePath
    $updatedContent = @()
    $inSection = $false
    $keyUpdated = $false

    foreach ($line in $content) {
        if ($line -match "^\[$section\]$") {
            $inSection = $true
            $updatedContent += $line
            continue
        } elseif ($inSection -and $line -match "^\[.+\]$") {
            if (-not $keyUpdated) {
                $updatedContent += "$key=$newValue"
                $keyUpdated = $true
            }
            $inSection = $false
        }

        if ($inSection -and $line -match "^\s*$key\s*=") {
            $updatedContent += "$key=$newValue"
            $keyUpdated = $true
        } else {
            $updatedContent += $line
        }
    }

    if (-not $keyUpdated) {
        if (-not $inSection) {
            $updatedContent += "`r`n[$section]"
        }
        $updatedContent += "$key=$newValue"
    }

    $updatedContent | Set-Content -Path $filePath -Encoding UTF8
    return $true
}

if ($args.Length -eq 0) {
    $config = Read-IniFile $ConfigFile
    if ($config.dev.path) {
        Set-Location $config.dev.path
    } else {
        Write-Output "Path not found in config.ini"
    }
}
elseif (($args[0] -eq "-h") -or ($args[0] -eq "--help")) {
    Write-Output " "
    Write-Output "  dev                -> Change to the path in config.ini"
    Write-Output "  dev set <path>     -> Update dev path in config.ini"
    Write-Output "  dev -h             -> Show help information about the command"
    Write-Output "  dev --help         -> Show help information about the command"
    Write-Output " "
}
elseif ($args[0] -eq "set" -and $args.Length -eq 2) {
    $newPath = $args[1]
    if (Update-IniFile $ConfigFile "dev" "path" $newPath) {
        Write-Output "New path: $newPath"
    } else {
        Write-Output "Failed to update config."
    }
}
else {
    Write-Output "Invalid command. Use -h or --help for usage."
}
