@echo off
rem ///////////////// Intro
echo ===============================
echo  FFFFF IIIII X   X   1    000
echo  F       I    X X   11   0   0
echo  FFF     I     X     1   0 0 0
echo  F       I    X X    1   0   0
echo  F     IIIII X   X  111   000
echo.
echo v1.0.3                     .bat
echo ===============================
echo  HandleSoft, https://textu.red
echo             2 0 1 7
echo ===============================
echo Visit our website for:
echo   * updates
echo   * a guide to remove Cortana
echo.
rem ///////////////// Admin check
net session >nul 2>&1
if %errorlevel% == 0 goto adminok
echo.
echo.
color 4f
echo This batch file requires admin rights.
echo Please right-click this file in Explorer
echo and select to "Run as Administrator".
echo.
echo.
pause
exit
:adminok
rem ///////////////// List
echo This batch file will:
echo.
echo * Disable diagnostics and tracking services
echo * Disable Windows Defender
echo * Try to set Updates to Ask before Download
echo * Uninstall OneDrive
echo * Disable Bing Search
echo * Disable Application Telemetry
echo * Disable Steps Recorder
echo * Disable "Delivery Optimization"
echo * Turn off advertising ID
echo * Disable Suggested app download
echo   (you will still need to uninstall those already downloaded yourself)
echo * Disable Windows Spotlight
echo * Disable keylogger ("improve typing")
echo * Opt out from CEIP
echo * Disable Cortana
echo * Win+X: PowerShell to CMD
echo * Enable seconds in the tray
echo * Show file extensions
echo * Enables Legacy Boot Loader + F8 Safe Mode (!!!)
echo * Disable Fast Startup (!!!)
echo * Disable Smart Screen? (!!!)
echo.
echo The list is long - scroll all the way through!
echo Some changes may require a reboot afterwards.
echo Some stuff may not work on 10 Home/Pro!
echo.
echo Hit Ctrl-C and Y or close the window to cancel
echo Do the above, if you are not 100% sure!
echo.
pause
rem ///////////////// Disable services
sc config dmwappushsvc start= disabled
sc config "Diagnostics Tracking Service" start= disabled
sc config DiagTrack start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config TrkWks start= disabled
sc config WMPNetworkSvc start= disabled
sc config DoSvc start= disabled
rem ///////////////// Disable scheduled tasks
schtasks /change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE
schtasks /change /TN "\Microsoft\Windows\AppID\SmartScreenSpecific" /DISABLE
rem ///////////////// Search UI firewall
powershell -Command New-NetFirewallRule -DisplayName "Search" -Direction Outbound -Action Block -Profile "Domain, Private, Public" -Program "C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe"
rem ///////////////// Telemetry stuff
cmd /c cd %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger & echo > AutoLogger-Diagtrack-Listener.etl & echo Y | cacls AutoLogger-Diagtrack-Listener.etl /d SYSTEM
rem ///////////////// Registry
echo Windows Registry Editor Version 5.00 > %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU] >> %TEMP%\fix10bat.reg
echo "AUOptions"=dword:00000002 >> %TEMP%\fix10bat.reg
echo "NoAutoRebootWithLoggedOnUsers"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "RebootRelaunchTimeout"=dword:000005a0 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update] >> %TEMP%\fix10bat.reg
echo "AUOptions"=dword:00000002 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows] >> %TEMP%\fix10bat.reg
echo "DisableFileSync"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config] >> %TEMP%\fix10bat.reg
echo "DownloadMode"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "DODownloadMode"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection] >> %TEMP%\fix10bat.reg
echo "AllowTelemetry"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection] >> %TEMP%\fix10bat.reg
echo "AllowTelemetry"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata] >> %TEMP%\fix10bat.reg
echo "PreventDeviceMetadataFromNetwork"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender] >> %TEMP%\fix10bat.reg
echo "DisableAntiSpyware"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced] >> %TEMP%\fix10bat.reg
echo "DontUsePowerShellOnWinX"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power] >> %TEMP%\fix10bat.reg
echo "HiberbootEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CloudContent] >> %TEMP%\fix10bat.reg
echo "DisableWindowsSpotlightFeatures"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager] >> %TEMP%\fix10bat.reg
echo "SilentInstalledAppsEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AdvertisingInfo] >> %TEMP%\fix10bat.reg
echo "DisabledByGroupPolicy"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\TIPC] >> %TEMP%\fix10bat.reg
echo "Enabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient\Windows] >> %TEMP%\fix10bat.reg
echo "CEIPEnable"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat] >> %TEMP%\fix10bat.reg
echo "AITEnable"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "DisableUAR"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search] >> %TEMP%\fix10bat.reg
echo "AllowCortana"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "DisableWebSearch"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search] >> %TEMP%\fix10bat.reg
echo "CortanaEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "BingSearchEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced] >> %TEMP%\fix10bat.reg
echo "HideFileExt"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
reg import %TEMP%\fix10bat.reg
rem ///////////////// Legacy Bootloader & Safe Mode
bcdedit /set {current} bootmenupolicy Legacy
rem ///////////////// Uninstall OneDrive
%SystemRoot%\System32\OneDriveSetup /uninstall 2>nul
%SystemRoot%\SysWOW64\OneDriveSetup /uninstall 2>nul
rem ///////////////// Script complete
color 2f
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo    OOO     K     K
echo   O   O    K    K
echo  O     O   K   K
echo  O     O   KKKK
echo  O     O   K   K
echo   O   O    K    K
echo    OOO     K     K
echo.
echo Restart recommended!
echo.
echo Please review your privacy settings
echo before restarting. To do it,
echo open Run, and use this command:
echo     ms-settings:privacy
echo.
call :getsecondparameter %CMDCMDLINE%
if /i not "%CMDFLAG%" == "/c" goto eof
echo You can now close this window.
echo.
:closewindow
pause >NUL 2>NUL
goto closewindow
:getsecondparameter
set CMDFLAG=%2
goto return
:eof
pause
echo.
color
:return