param (
    [Parameter(Mandatory = $true)]
    [string[]]$Files
)

foreach ($file in $Files) {
    if (Test-Path $file) {
        Get-Content $file
    } else {
        Write-Host "cat: $file: No such file or directory" -ForegroundColor Red
    }
}
