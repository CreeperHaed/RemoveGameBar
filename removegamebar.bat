@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: uninstall Game Bar
powershell -Command "Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage"

:: deactivate Game DVR
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR /f /t REG_DWORD /v AppCaptureEnabled /d 0
reg add HKCU\System\GameConfigStore /f /t REG_DWORD /v GameDVR_Enabled /d 0

:: ms-gamebar handler
reg add HKCR\ms-gamebar /f /ve /d "URL:ms-gamebar"
reg add HKCR\ms-gamebar /f /v "URL Protocol" /d ""
reg add HKCR\ms-gamebar /f /v "NoOpenWith" /d ""
reg add HKCR\ms-gamebar\shell\open\command /f /ve /d "\"%SystemRoot%\\System32\\systray.exe\""

:: ms-gamebarservices handler
reg add HKCR\ms-gamebarservices /f /ve /d "URL:ms-gamebarservices"
reg add HKCR\ms-gamebarservices /f /v "URL Protocol" /d ""
reg add HKCR\ms-gamebarservices /f /v "NoOpenWith" /d ""
reg add HKCR\ms-gamebarservices\shell\open\command /f /ve /d "\"%SystemRoot%\\System32\\systray.exe\""

:: restart choice
echo Restart now? [y/n]
choice /c YN /n
if errorlevel 2 exit
if errorlevel 1 shutdown /r /t 0 -dp 0:0
