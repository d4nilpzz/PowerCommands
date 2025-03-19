$destination = "C:\PowerCommands"
$binSource = Join-Path -Path $PSScriptRoot -ChildPath "bin"
$binDestination = Join-Path -Path $destination -ChildPath "bin"

if (!(Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
}

if (Test-Path $binSource) {
    Copy-Item -Path $binSource -Destination $destination -Recurse -Force
} else {
    Write-Host "La carpeta 'bin' no se encontró en el mismo directorio del instalador." -ForegroundColor Red
    exit 1
}

$envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$binDestination*") {
    $newPath = "$envPath;$binDestination"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "Se ha agregado '$binDestination' al PATH." -ForegroundColor Green
} else {
    Write-Host "'$binDestination' ya está en el PATH." -ForegroundColor Yellow
}

Write-Host "Instalación completada." -ForegroundColor Green

