@echo off & setlocal & rem https://textu.red/e/win10/
                       rem https://github.com/HandleSoft/fix10
                       rem Fix10 v1.1.0
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Config
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=

rem Enable dropping under %SYSTEMROOT%\System32 (for Run & cmd):
rem   xqacl.bat: opens an elevated command prompt at given location
rem   xqgod.bat: opens the All Tasks directory
rem 0 = disable (default), 1 = enable
set fix10dropbatchutils=0

rem Enable removing Mixed Reality
rem 0 = disable (default), 1 = enable
set fix10removemixed=0

rem Enable deleting Cortana
rem 0 = disable (default), 1 = enable
set fix10delcortana=0

rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Intro
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
echo ===============================
echo  FFFFF IIIII X   X   1    000
echo  F       I    X X   11   0   0
echo  FFF     I     X     1   0 0 0
echo  F       I    X X    1   0   0
echo  F     IIIII X   X  111   000
echo.
echo v1.1.0                     .bat
echo ===============================
echo  HandleSoft, https://textu.red
echo             2 0 1 7
echo ===============================
echo.
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Admin check
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
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
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// OS version check
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" goto win10ok
echo.
echo.
color 4f
echo The operating system does not seem to be Windows 10.
echo Running this script in another version of Windows
echo will cause unpredictable results.
echo.
:win10choice
set /P contanyway=Continue anyway [Y/N]?
if /I "%c%" == "Y" goto win10ok
if /I "%c%" == "N" goto endscript
goto win10choice
echo.
color
:win10ok
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// List
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
echo This batch file will:
echo.
echo * Disable diagnostics and tracking services
echo * Disable advertisements and "tips"
echo * Disable Windows Defender
echo * Try to set Updates to Ask before Download
echo * Uninstall and disable OneDrive
echo * Disable Feedback notifications
echo * Disable Bing Search
echo * Disable Application Telemetry
echo * Disable Steps Recorder
echo * Disable "Delivery Optimization"
echo * Disable Wi-Fi Sense
echo * Turn off advertising ID
echo * Disable Suggested app download
echo   (you will still need to uninstall those already downloaded yourself)
echo * Disable Windows Spotlight
echo * Disable keylogger ("improve typing")
echo * Disable "Getting to know you"
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
echo Modify the file to enable (disabled by default):
echo * Drops batch utilities
echo * Remove Mixed Reality
echo * Delete Cortana
echo.
echo The list is long - scroll all the way through!
echo Some changes may require a reboot afterwards.
echo Some stuff may not work on 10 Home/Pro!
echo.
echo Hit Ctrl-C and Y or close the window to cancel
echo Do the above, if you are not 100% sure!
echo.
pause
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Disable services
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
sc config dmwappushsvc start= disabled
sc config "Diagnostics Tracking Service" start= disabled
sc config DiagTrack start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config TrkWks start= disabled
sc config WMPNetworkSvc start= disabled
sc config DoSvc start= disabled
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Disable scheduled tasks
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
schtasks /change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE
schtasks /change /TN "\Microsoft\Windows\AppID\SmartScreenSpecific" /DISABLE
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Search UI firewall
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
powershell -Command New-NetFirewallRule -DisplayName "Search" -Direction Outbound -Action Block -Profile "Domain, Private, Public" -Program "C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe"
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Telemetry stuff
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
pushd %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger
echo > AutoLogger-Diagtrack-Listener.etl
echo Y | cacls AutoLogger-Diagtrack-Listener.etl /d SYSTEM
popd
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Registry header
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
echo Windows Registry Editor Version 5.00 > %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Registry HKLM
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
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
echo "DoNotShowFeedbackNotifications"=dword:00000001 >> %TEMP%\fix10bat.reg
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
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power] >> %TEMP%\fix10bat.reg
echo "HiberbootEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\CloudContent] >> %TEMP%\fix10bat.reg
echo "DisableSoftLanding"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "DisableWindowsConsumerFeatures"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "DisableWindowsSpotlightFeatures"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo] >> %TEMP%\fix10bat.reg
echo "Enabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AdvertisingInfo] >> %TEMP%\fix10bat.reg
echo "DisabledByGroupPolicy"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient\Windows] >> %TEMP%\fix10bat.reg
echo "CEIPEnable"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppCompat] >> %TEMP%\fix10bat.reg
echo "AITEnable"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "DisableUAR"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search] >> %TEMP%\fix10bat.reg
echo "AllowCortana"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "DisableWebSearch"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "ConnectedSearchUseWeb"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "ConnectedSearchPrivacy"=dword:00000003 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive] >> %TEMP%\fix10bat.reg
echo "DisableFileSyncNGSC"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive] >> %TEMP%\fix10bat.reg
echo "PreventNetworkTrafficPreUserSignIn"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\InputPersonalization] >> %TEMP%\fix10bat.reg
echo "AllowInputPersonalization"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "RestrictImplicitInkCollection"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config] >> %TEMP%\fix10bat.reg
echo "AutoConnectAllowedOEM"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Registry HKCU for current user
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced] >> %TEMP%\fix10bat.reg
echo "DontUsePowerShellOnWinX"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "HideFileExt"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "ShowSyncProviderNotifications"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CloudContent] >> %TEMP%\fix10bat.reg
echo "DisableWindowsConsumerFeatures"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "DisableWindowsSpotlightFeatures"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PenWorkspace] >> %TEMP%\fix10bat.reg
echo "PenWorkspaceAppSuggestionsEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager] >> %TEMP%\fix10bat.reg
echo "RotatingLockScreenEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "RotatingLockScreenOverlayEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SilentInstalledAppsEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SoftLandingEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SubscribedContent-310093Enabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SystemPaneSuggestionsEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\TIPC] >> %TEMP%\fix10bat.reg
echo "Enabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search] >> %TEMP%\fix10bat.reg
echo "CortanaEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "BingSearchEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Personalization\Settings] >> %TEMP%\fix10bat.reg
echo "AcceptedPrivacyPolicy"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore] >> %TEMP%\fix10bat.reg
echo "HarvestContacts"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Registry HKCU for default user
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced] >> %TEMP%\fix10bat.reg
echo "DontUsePowerShellOnWinX"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "HideFileExt"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "ShowSyncProviderNotifications"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\Software\Policies\Microsoft\Windows\CloudContent] >> %TEMP%\fix10bat.reg
echo "DisableWindowsConsumerFeatures"=dword:00000001 >> %TEMP%\fix10bat.reg
echo "DisableWindowsSpotlightFeatures"=dword:00000001 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\PenWorkspace] >> %TEMP%\fix10bat.reg
echo "PenWorkspaceAppSuggestionsEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager] >> %TEMP%\fix10bat.reg
echo "RotatingLockScreenEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "RotatingLockScreenOverlayEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SilentInstalledAppsEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SoftLandingEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SubscribedContent-310093Enabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "SystemPaneSuggestionsEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Input\TIPC] >> %TEMP%\fix10bat.reg
echo "Enabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search] >> %TEMP%\fix10bat.reg
echo "CortanaEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo "BingSearchEnabled"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Personalization\Settings] >> %TEMP%\fix10bat.reg
echo "AcceptedPrivacyPolicy"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
echo [HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore] >> %TEMP%\fix10bat.reg
echo "HarvestContacts"=dword:00000000 >> %TEMP%\fix10bat.reg
echo. >> %TEMP%\fix10bat.reg
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Registry HKCR
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
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
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Registry: Photo Viewer
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
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
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Legacy Bootloader & Safe Mode
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
bcdedit /set {current} bootmenupolicy Legacy
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Uninstall OneDrive
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
%SystemRoot%\System32\OneDriveSetup /uninstall 2>nul
%SystemRoot%\SysWOW64\OneDriveSetup /uninstall 2>nul
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Batch utilities (if enabled)
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
if not %fix10dropbatchutils% == 1 goto fix10_nodropbatchutils 
echo. > %SYSTEMROOT%\System32\xqacl.bat
echo. > %SYSTEMROOT%\System32\xqgod.bat
echo @echo off >> %SYSTEMROOT%\System32\xqacl.bat
echo if not %1.==. goto gotargs
echo powershell -Command Start-Process cmd -Verb runas -WorkingDirectory "%cd%" -ArgumentList /k,cd,"%cd%" >> %SYSTEMROOT%\System32\xqacl.bat
echo goto :eof >> %SYSTEMROOT%\System32\xqacl.bat
echo :gotargs >> %SYSTEMROOT%\System32\xqacl.bat
echo powershell -Command Start-Process cmd -Verb runas -WorkingDirectory "%cd%" -ArgumentList /c,%* >> %SYSTEMROOT%\System32\xqacl.bat
echo @start "" "explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" >> %SYSTEMROOT%\System32\xqgod.bat
:fix10_nodropbatchutils 
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Remove Mixed Reality (if enabled)
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
if not %fix10removemixed% == 1 goto fix10_noremovemixed
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Holographic4 /v FirstRunSucceeded /t REG_DWORD /d 0
:fix10_noremovemixed 
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Delete Cortana (if enabled)
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
if not %fix10delcortana% == 1 goto fix10_nodelcortana
set dirbase="%SYSTEMROOT%\SystemApps\Microsoft.Windows.Cortana_"
for /D %%x in (%dirbase%*) do if not defined dir set "dir=%%x"
set proc="SearchUI.exe"
taskkill /f /im %proc%
takeown /f %dir% /r
icacls "%dir%\*" /t /c /grant %username%:f
timeout 2 & taskkill /f /im %proc% & rd /s /q %dir%
timeout 2 & taskkill /f /im %proc% & rd /s /q %dir%
timeout 2 & taskkill /f /im %proc% & rd /s /q %dir%
timeout 2 & taskkill /f /im %proc% & rd /s /q %dir%
timeout 2 & taskkill /f /im %proc% & rd /s /q %dir%
:fix10_nodelcortana
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
rem ///////////////// Script complete
rem /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=
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
if /i not "%CMDFLAG%" == "/c" goto endscript
echo You can now close this window.
echo.
:closewindow
pause >NUL 2>NUL
goto closewindow
:getsecondparameter
set CMDFLAG=%2
goto return
:endscript
pause
echo.
color
endlocal
:return