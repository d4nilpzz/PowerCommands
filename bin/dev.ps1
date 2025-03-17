$ConfigFile = Join-Path $PSScriptRoot "config.ini"

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
    $content = Get-Content $filePath
    $updatedContent = $content -replace "(?<=\[$section\](?:\r?\n|\r).*?$key=).*", "$key=$newValue"
    
    if ($updatedContent -eq $content) {
        $updatedContent = $content + "`r`n[$section]`r`n$key=$newValue"
    }
    $updatedContent | Set-Content $filePath
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
elseif (($args.Length -eq 0) -or ($args[0] -eq "-h") -or ($args[0] -eq "--help")) {
    Write-Output "Usage:"
    Write-Output "  dev          -> Change to the path in config.ini"
    Write-Output "  dev config   -> Show the current configuration."
    Write-Output "  dev set <section> <key> <value> -> Update a key in a section in config.ini"
}
elseif ($args[0] -eq "set" -and $args.Length -eq 3) {
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
