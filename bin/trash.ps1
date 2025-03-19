param (
    [string[]]$files,
    [switch]$o
)

if ($o) {
    Start-Process "shell:RecycleBinFolder"
    exit
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class RecycleBin {
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    public static extern int SHFileOperation(ref SHFILEOPSTRUCT lpFileOp);
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct SHFILEOPSTRUCT {
        public IntPtr hwnd;
        public uint wFunc;
        public string pFrom;
        public string pTo;
        public ushort fFlags;
        public bool fAnyOperationsAborted;
        public IntPtr hNameMappings;
        public string lpszProgressTitle;
    }
    public static void MoveToRecycleBin(string path) {
        SHFILEOPSTRUCT shf = new SHFILEOPSTRUCT();
        shf.wFunc = 3; // FO_DELETE
        shf.pFrom = path + "\0\0";
        shf.fFlags = 0x40; // FOF_ALLOWUNDO
        SHFileOperation(ref shf);
    }
}
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        [RecycleBin]::MoveToRecycleBin((Resolve-Path $file))
        Write-Host "Movido a la papelera: $file"
    } else {
        Write-Host "Archivo no encontrado: $file"
    }
}
