@echo off
set PING_URL=%1
if "%PING_URL%"=="" set PING_URL=8.8.8.8

echo Ping URL: %PING_URL%
rem Add commands to compile and install the Magisk module for Windows

zip -r MagiskModemPing.zip META-INF system install.sh install.bat module.prop
echo Module compiled to MagiskModemPing.zip
pause
