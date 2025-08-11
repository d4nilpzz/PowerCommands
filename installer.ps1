$destination = "C:\PowerCommands"
$binSource = Join-Path -Path $PSScriptRoot -ChildPath "bin"
$binDestination = Join-Path -Path $destination -ChildPath "bin"

if (!(Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
}

if (Test-Path $binSource) {
    Copy-Item -Path $binSource -Destination $destination -Recurse -Force
} else {
    Write-Host "The 'bin' folder was not found in the installer's directory." -ForegroundColor Red
    exit 1
}

$envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$binDestination*") {
    $newPath = "$envPath;$binDestination"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "'$binDestination' has been added to the PATH." -ForegroundColor Green
} else {
    Write-Host "'$binDestination' is already in the PATH." -ForegroundColor Yellow
}

Write-Host "Installation completed." -ForegroundColor Green
