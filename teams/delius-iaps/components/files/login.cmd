Powershell -Command "Set-ExecutionPolicy Unrestricted CurrentUser" >> "%TEMP%\StartupLog.txt" 2>&1
Powershell C:\scripts\login.ps1 >> "%TEMP%\StartupLog.txt" 2>&1
