param (
    [int]$t = 0
)

if ($t -gt 0) {
    Write-Host "Waiting for $t seconds before rebooting..."
    Start-Sleep -Seconds $t
}

Restart-Computer -Force

