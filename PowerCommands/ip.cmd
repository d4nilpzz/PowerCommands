
@echo off
if "%~1"=="" goto usage

:loop
if "%~1"=="" goto endloop

if /I "%~1"=="a" (
    echo.
    ipconfig | findstr /R /C:"IPv4 Address" /C:"IPv6 Address"
    echo.
) else if /I "%~1"=="v4" (
    echo.
    ipconfig | findstr /R /C:"IPv4 Address"
    echo.
) else if /I "%~1"=="v6" (
    echo.
    ipconfig | findstr /R /C:"IPv6 Address"
    echo.
) else if /I "%~1"=="all" (
    echo.
    ipconfig /all
    echo.
) else if /I "%~1"=="renew" (
    echo.
    ipconfig /renew
    echo.
) else if /I "%~1"=="release" (
    echo.
    ipconfig /release
    echo.
) else (
    echo Invalid argument: %~1
    echo Usage: ip.cmd [a|v4|v6|all|renew|release]
)

shift
goto loop

:endloop
goto end

:usage
echo Usage: ip.cmd [a|v4|v6|all|renew|release]
goto end

:end
