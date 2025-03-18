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
        return
    }

    Write-Output "Updating [$section] $key=$newValue in $filePath"

    # Asegurar permisos de escritura
    if ((Get-Item $filePath).IsReadOnly) {
        Write-Output "Error: config.ini is read-only. Removing read-only attribute..."
        Set-ItemProperty -Path $filePath -Name IsReadOnly -Value $false
    }

    $content = Get-Content $filePath
    $updatedContent = @()
    $inSection = $false
    $keyUpdated = $false

    foreach ($line in $content) {
        if ($line -match "^\[$section\]$") {
            $inSection = $true
        } elseif ($inSection -and $line -match "^\[.+\]$") {
            $inSection = $false
        }

        if ($inSection -and $line -match "^\s*$key\s*=") {
            $updatedContent += "$key=$newValue"
            $keyUpdated = $true
        } else {
            $updatedContent += $line
        }
    }

    if (-not $inSection) {
        $updatedContent += "`r`n[$section]"
    }

    if (-not $keyUpdated) {
        $updatedContent += "$key=$newValue"
    }

    Write-Output "Writing new content to file..."
    $updatedContent | Set-Content -Path $filePath -Encoding UTF8
    Write-Output "Update complete!"
}

if ($args.Length -eq 0) {
    $config = Read-IniFile $ConfigFile
    if ($config.Development.path) {
        Set-Location $config.Development.path
        if ($config.Development.clear -eq "true") {
            Clear-Host
        }
    } else {
        Write-Output "Path not found in config.ini"
    }
}
elseif (($args[0] -eq "-h") -or ($args[0] -eq "--help")) {
    Write-Output "Usage:"
    Write-Output "  dev          -> Change to the path in config.ini"
    Write-Output "  dev config   -> Show the current configuration."
    Write-Output "  dev set <section> <key> <value> -> Update a key in a section in config.ini"
}
elseif ($args[0] -eq "set" -and $args.Length -eq 4) {
    $section = $args[1]
    $key = $args[2]
    $value = $args[3]
    Update-IniFile $ConfigFile $section $key $value
    Write-Output "Updated $section/$key to: $value"
}
elseif ($args[0] -eq "config") {
    if (Test-Path $ConfigFile) {
        Get-Content $ConfigFile | Write-Output
    } else {
        Write-Output "config.ini not found."
    }
}
