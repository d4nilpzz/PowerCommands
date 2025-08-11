param (
    [switch]$B,    # Boot into BIOS/UEFI
    [int]$t = 0    # Wait time in seconds
)

if ($t -gt 0) {
    Write-Host "Waiting for $t seconds before rebooting..."
    Start-Sleep -Seconds $t
}

if ($B) {
    Write-Host "Rebooting into BIOS/UEFI..."
    shutdown /r /fw /t 0
} else {
    Write-Host "Rebooting normally..."
    Restart-Computer -Force
}
