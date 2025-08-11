$chars = ([char[]]"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
$secret = -join (1..64 | ForEach-Object { $chars | Get-Random })
Write-Output $secret
