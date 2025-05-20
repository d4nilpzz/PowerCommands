$ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath "t6/config.ini"


function Enable-T6Script {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ScriptName
    )

    $dest = "C:\Users\josed\AppData\Local\Plutonium\storage\t6\raw\scripts\mp\$ScriptName"
    $src = Join-Path -Path $PSScriptRoot -ChildPath "t6\$ScriptName"
    if (Test-Path $dest) {
        Remove-Item $dest
    }
    Copy-Item $src $dest
}

function Disable-T6Script {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ScriptName
    )

    $src = "C:\Users\josed\AppData\Local\Plutonium\storage\t6\raw\scripts\mp\$ScriptName"
    $dest = Join-Path -Path $PSScriptRoot -ChildPath "t6\$ScriptName"
    if (Test-Path $src) {
        Copy-Item $src $dest
        Remove-Item $src
    }
}

if ($args[0] -eq "--enable") {
    Enable-T6Script $args[1]
    exit
}

if ($args[0] -eq "--disable") {
    Disable-T6Script $args[1]
    exit
}

