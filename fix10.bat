@echo off
rem ///////////////// Intro
echo ===============================
echo  FFFFF IIIII X   X   1    000
echo  F       I    X X   11   0   0
echo  FFF     I     X     1   0 0 0
echo  F       I    X X    1   0   0
echo  F     IIIII X   X  111   000
echo.
echo v1.0.4                     .bat
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
echo * Restore Windows Photo Viewer
echo * Win+X: PowerShell to CMD
echo * Re-add CMD to Context menu (if Shift down)
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
echo [HKEY_CLASSES_ROOT\Drive\shell\cmd2] >> %TEMP%\fix10bat.reg
echo @="@shell32.dll,-8506" >> %TEMP%\fix10bat.reg
echo "Extended"="" >> %TEMP%\fix10bat.reg
echo "Icon"="imageres.dll,-5323" >> %TEMP%\fix10bat.reg
echo "Nodefault"="" >> %TEMP%\fix10bat.reg
echo "NoWorkingDirectory"="" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Drive\shell\cmd2\command] >> %TEMP%\fix10bat.reg
echo @="cmd.exe /s /k pushd \"%%V\"" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Directory\shell\cmd2] >> %TEMP%\fix10bat.reg
echo @="@shell32.dll,-8506" >> %TEMP%\fix10bat.reg
echo "Extended"="" >> %TEMP%\fix10bat.reg
echo "Icon"="imageres.dll,-5323" >> %TEMP%\fix10bat.reg
echo "Nodefault"="" >> %TEMP%\fix10bat.reg
echo "NoWorkingDirectory"="" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Directory\shell\cmd2\command] >> %TEMP%\fix10bat.reg
echo @="cmd.exe /s /k pushd \"%%V\"" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Directory\Background\shell\cmd2] >> %TEMP%\fix10bat.reg
echo @="@shell32.dll,-8506" >> %TEMP%\fix10bat.reg
echo "Extended"="" >> %TEMP%\fix10bat.reg
echo "Icon"="imageres.dll,-5323" >> %TEMP%\fix10bat.reg
echo "Nodefault"="" >> %TEMP%\fix10bat.reg
echo "NoWorkingDirectory"="" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Directory\Background\shell\cmd2\command] >> %TEMP%\fix10bat.reg
echo @="cmd.exe /s /k pushd \"%%V\"" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo ; ======================================================================================== >> %TEMP%\fix10bat.reg
echo ; https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html >> %TEMP%\fix10bat.reg
echo ; ======================================================================================== >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\jpegfile\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\pngfile\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open] >> %TEMP%\fix10bat.reg
echo "MuiVerb"="@photoviewer.dll,-3043" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Bitmap] >> %TEMP%\fix10bat.reg
echo "ImageOptionFlags"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "FriendlyTypeName"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,\ >> %TEMP%\fix10bat.reg
echo   00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,\ >> %TEMP%\fix10bat.reg
echo   77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,\ >> %TEMP%\fix10bat.reg
echo   00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   65,00,72,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,35,00,36,00,00,\ >> %TEMP%\fix10bat.reg
echo   00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Bitmap\DefaultIcon] >> %TEMP%\fix10bat.reg
echo @="%%SystemRoot%%\\System32\\imageres.dll,-70" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Bitmap\shell\open\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.JFIF] >> %TEMP%\fix10bat.reg
echo "EditFlags"=dword:00010000 >> %TEMP%\fix10bat.reg
echo "ImageOptionFlags"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "FriendlyTypeName"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,\ >> %TEMP%\fix10bat.reg
echo   00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,\ >> %TEMP%\fix10bat.reg
echo   77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,\ >> %TEMP%\fix10bat.reg
echo   00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   65,00,72,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,35,00,35,00,00,\ >> %TEMP%\fix10bat.reg
echo   00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.JFIF\DefaultIcon] >> %TEMP%\fix10bat.reg
echo @="%%SystemRoot%%\\System32\\imageres.dll,-72" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.JFIF\shell\open] >> %TEMP%\fix10bat.reg
echo "MuiVerb"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,\ >> %TEMP%\fix10bat.reg
echo   69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,\ >> %TEMP%\fix10bat.reg
echo   00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,\ >> %TEMP%\fix10bat.reg
echo   72,00,5c,00,70,00,68,00,6f,00,74,00,6f,00,76,00,69,00,65,00,77,00,65,00,72,\ >> %TEMP%\fix10bat.reg
echo   00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,34,00,33,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.JFIF\shell\open\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Jpeg] >> %TEMP%\fix10bat.reg
echo "EditFlags"=dword:00010000 >> %TEMP%\fix10bat.reg
echo "ImageOptionFlags"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "FriendlyTypeName"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,\ >> %TEMP%\fix10bat.reg
echo   00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,\ >> %TEMP%\fix10bat.reg
echo   77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,\ >> %TEMP%\fix10bat.reg
echo   00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   65,00,72,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,35,00,35,00,00,\ >> %TEMP%\fix10bat.reg
echo   00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Jpeg\DefaultIcon] >> %TEMP%\fix10bat.reg
echo @="%%SystemRoot%%\\System32\\imageres.dll,-72" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Jpeg\shell\open] >> %TEMP%\fix10bat.reg
echo "MuiVerb"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,\ >> %TEMP%\fix10bat.reg
echo   69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,\ >> %TEMP%\fix10bat.reg
echo   00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,\ >> %TEMP%\fix10bat.reg
echo   72,00,5c,00,70,00,68,00,6f,00,74,00,6f,00,76,00,69,00,65,00,77,00,65,00,72,\ >> %TEMP%\fix10bat.reg
echo   00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,34,00,33,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Jpeg\shell\open\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Gif] >> %TEMP%\fix10bat.reg
echo "ImageOptionFlags"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "FriendlyTypeName"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,\ >> %TEMP%\fix10bat.reg
echo   00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,\ >> %TEMP%\fix10bat.reg
echo   77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,\ >> %TEMP%\fix10bat.reg
echo   00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   65,00,72,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,35,00,37,00,00,\ >> %TEMP%\fix10bat.reg
echo   00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Gif\DefaultIcon] >> %TEMP%\fix10bat.reg
echo @="%%SystemRoot%%\\System32\\imageres.dll,-83" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Gif\shell\open\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Png] >> %TEMP%\fix10bat.reg
echo "ImageOptionFlags"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "FriendlyTypeName"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,\ >> %TEMP%\fix10bat.reg
echo   00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,\ >> %TEMP%\fix10bat.reg
echo   77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,\ >> %TEMP%\fix10bat.reg
echo   00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   65,00,72,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,35,00,37,00,00,\ >> %TEMP%\fix10bat.reg
echo   00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Png\DefaultIcon] >> %TEMP%\fix10bat.reg
echo @="%%SystemRoot%%\\System32\\imageres.dll,-71" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Png\shell\open\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Png\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Wdp] >> %TEMP%\fix10bat.reg
echo "EditFlags"=dword:00010000 >> %TEMP%\fix10bat.reg
echo "ImageOptionFlags"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Wdp\DefaultIcon] >> %TEMP%\fix10bat.reg
echo @="%%SystemRoot%%\\System32\\wmphoto.dll,-400" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Wdp\shell\open] >> %TEMP%\fix10bat.reg
echo "MuiVerb"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,\ >> %TEMP%\fix10bat.reg
echo   69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,\ >> %TEMP%\fix10bat.reg
echo   00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,\ >> %TEMP%\fix10bat.reg
echo   72,00,5c,00,70,00,68,00,6f,00,74,00,6f,00,76,00,69,00,65,00,77,00,65,00,72,\ >> %TEMP%\fix10bat.reg
echo   00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,34,00,33,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Wdp\shell\open\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget] >> %TEMP%\fix10bat.reg
echo "Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\Image Preview\command] >> %TEMP%\fix10bat.reg
echo @=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\ >> %TEMP%\fix10bat.reg
echo   6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\ >> %TEMP%\fix10bat.reg
echo   25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\ >> %TEMP%\fix10bat.reg
echo   00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\ >> %TEMP%\fix10bat.reg
echo   6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\ >> %TEMP%\fix10bat.reg
echo   00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\ >> %TEMP%\fix10bat.reg
echo   5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\ >> %TEMP%\fix10bat.reg
echo   00,31,00,00,00 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\Image Preview\DropTarget] >> %TEMP%\fix10bat.reg
echo "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"="" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities] >> %TEMP%\fix10bat.reg
echo "ApplicationDescription"="@%%ProgramFiles%%\\Windows Photo Viewer\\photoviewer.dll,-3069" >> %TEMP%\fix10bat.reg
echo "ApplicationName"="@%%ProgramFiles%%\\Windows Photo Viewer\\photoviewer.dll,-3009" >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations] >> %TEMP%\fix10bat.reg
echo ".jpg"="PhotoViewer.FileAssoc.Jpeg" >> %TEMP%\fix10bat.reg
echo ".wdp"="PhotoViewer.FileAssoc.Wdp" >> %TEMP%\fix10bat.reg
echo ".jfif"="PhotoViewer.FileAssoc.JFIF" >> %TEMP%\fix10bat.reg
echo ".dib"="PhotoViewer.FileAssoc.Bitmap" >> %TEMP%\fix10bat.reg
echo ".png"="PhotoViewer.FileAssoc.Png" >> %TEMP%\fix10bat.reg
echo ".jxr"="PhotoViewer.FileAssoc.Wdp" >> %TEMP%\fix10bat.reg
echo ".bmp"="PhotoViewer.FileAssoc.Bitmap" >> %TEMP%\fix10bat.reg
echo ".jpe"="PhotoViewer.FileAssoc.Jpeg" >> %TEMP%\fix10bat.reg
echo ".jpeg"="PhotoViewer.FileAssoc.Jpeg" >> %TEMP%\fix10bat.reg
echo ".gif"="PhotoViewer.FileAssoc.Gif" >> %TEMP%\fix10bat.reg
echo ".tif"="PhotoViewer.FileAssoc.Tiff" >> %TEMP%\fix10bat.reg
echo ".tiff"="PhotoViewer.FileAssoc.Tiff" >> %TEMP%\fix10bat.reg
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