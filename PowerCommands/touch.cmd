@echo off
:loop
if "%~1"=="" goto endloop

set file=%1
if not exist %file% (
    echo.>%file%
) else (
    copy /b %file% +,, >nul
)

shift
goto loop

:endloop
