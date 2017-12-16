
# Fix10.bat full documentation
## for version 1.1.4
# The document is still a heavy work in progress, and it will likely be finished in the coming days.
This document provides a list of the changes performed by Fix10.bat, as well as a detailed explanation for every one of them. 

It is not known whether any of the changes are restricted to specific versions of Windows 10 (original, Anniversary, Creators, Fall Creators...) or editions (Home, Pro, Enterprise), but it is likely that some of the changes will not work on Home or Pro.

The documentation will be provided in sections ordered according to their order of appearance in the source code of the batch file itself.

# Disclaimer
The batch file in question requires administrative privileges to run on a system and is intended to only be run on Windows 10. Regardless of conditions, the script is run at your own risk, and HandleSoft cannot be responsible for increased boot times (will likely happen) or, perhaps even worse, features removed from the system or the system refusing to function or start up properly, or any other adverse side effects. By running the batch file, you accept that you have read this disclaimer and understand its and the script's consequences.

# Disable services
Several of the services are either disabled here or set to start on demand (so not automatically on startup).

## DiagTrack, Diagnostics Tracking Service
This service is also known as the **Connected User Experiences and Telemetry** starting from Windows 10 Anniversary Update onwards. DiagTrack is the service's actual underlying technical name, and is also referred by Fix10.bat to maintain compatibility. 

The service in question is used to upload telemetry information to Microsoft's servers, and the data sent is described in detail on Microsoft's website: https://docs.microsoft.com/en-us/windows/configuration/configure-windows-telemetry-in-your-organization
> Use this article to make informed decisions about how you might configure telemetry in your organization. Telemetry is a term that means different things to different people and organizations. For this article, we discuss telemetry as system data that is uploaded by the **Connected User Experience and Telemetry** component. The telemetry data is used to help keep Windows devices secure by identifying malware trends and other threats and to help Microsoft improve the quality of Windows and Microsoft services.

Disabling the service is used as a preventive measure to block any data being sent. The drawbacks of leaving such telemetry on include its intrusiveness, active usage of the Internet connection (especially a problem on metered or limited connections) and the questionable level of privacy. 

## dmwappushsvc, Dmwappushservice
This service is the WAP Push Message Routing Service. Microsoft has not documented this service extensively, but it is used for system bootstrapping and provisioning, and is often also considered to be connected with telemetry (see the service above), so it is often recommended to disable it along DiagTrack.

**Important note: disabling this service will break the *sysprep* script: the script will simply freeze.** To fix this issue, simply enable the service again with the following command under the Command Line running as an administrator: `sc config Dmwappushsvc start= auto & net start Dmwappushsvc`

## diagnosticshub.standardcollector.service
The full name of this service is *Microsoft (R) Diagnostics Hub Standard Collector Service*. The service collected real-time ETW event data and processes it for diagnostic purposes. Since it is connected to telemetry, it is often disabled as well.

## TrkWks
TrkWks is the technical name of the *Distributed Link Tracking Client* service, which "maintains links between NTFS files within a computer or across computers in a network domain." The service is disabled mostly for optimization and telemetry purposes.

## WMPNetworkSvc
The *Windows Media Player Network Sharing Service* shares Windows Media Player libraries with other devices using UPnP. It is sometimes connected with high CPU usage and most people are likely to use something else for playing media, which is why the service isn't of any importance to them.

## DoSvc
DoSvc, or the *Delivery Optimization Service*, is used for Delivery Optimization and download updates on Windows Update. Since it seems necessary in order to use Windows Update, the service is not disabled, but rather set to start up on demand (which is the default setting on some newer editions of Windows 10 as well).

## DcpSvc
DcpSvc, or *DataCollectionPublishingService*, was used in older versions of Windows 10 to send data to other applications. Starting it manually seems to be the default setting for it, and this is what Fix10.bat sets it to as well (since applications may need this service to run properly). The service is not present in newer versions of Windows 10 (Creators Update onwards?).

# Disable scheduled tasks
All the tasks mentioned here are disabled with the `schtasks` command.

## Microsoft Compatibility Appraiser
This scheduled task is used with the Customer Experience Improvement Program (CEIP), and is disabled, since Fix10.bat opts the computer out from CEIP. The task itself is used to check for program compatibility upon a major Windows 10 update, and could even be connected to program uninstallations on upgrades.

## ProgramDataUpdater
This scheduled task is used with the Customer Experience Improvement Program (CEIP), and is disabled, since Fix10.bat opts the computer out from CEIP. Based on the task's name, it is used to collect program data of some kind.

## Consolidator, KernelCeipTask, UsbCeip
These scheduled tasks are used with the Customer Experience Improvement Program (CEIP), and is disabled, since Fix10.bat opts the computer out from CEIP. Consolidator is responsible for running `wsqmcons.exe`, which lacks any documentation but 
> This program collects and sends usage data to Microsoft.
KernelCeipTask (The Kernel CEIP (Customer Experience Improvement Program) Task) "*collects additional information about the system and sends this data to Microsoft.*"
UsbCeip `collects Universal Serial Bus related statistics and information about your machine and sends it to the Windows Device Connectivity engineering group at Microsoft.`

# Search UI firewall
The PowerShell command executed under this section adds a new firewall rule that blocks the `SearchUI.exe` process from sending any information to the Internet. This will effectively break online searching in Windows Search as well as Cortana, but both are also disabled later on.

# Telemetry stuff
The somewhat less descriptive section disables the `AutoLogger-Diagtrack-Listener.etl` file by emptying it and preventing the system from modifying it using file permissions. This file is used for tracking event logs and is connected to telemetry, with some even accusing it of being a component of a "*keylogger*".

# taskmgr, regedit, cmd
This section does a total of six registry changes: all of them involve the policies used to disable the Task Manager, Registry Editor and Command Interpreter. The registry changes simply disable these restrictions, allowing the tools to be used again if blocked that way. 

# Registry header
The registry file that starts to be generated here will be written into the temp directory (full filename `%TEMP%\fix10bat.reg`) and applied once it is finished. The registry changes are numerous, but documentation will be provided for every single one. The header section simply starts the generation of the .reg file by starting with the standard .reg header. 

# Registry HKLM
These changes all apply to `HKEY_LOCAL_MACHINE` and are therefore global for the computer.

*(TODO)*

# Registry HKCU for current user
These changes all apply to `HKEY_CURRENT_USER` and therefore only affect the user that runs the script.

*(TODO)*

# Registry HKCU for default user
These changes all apply to `HKEY_USERS\.DEFAULT` and therefore affects the system or login user. The exact changes are the same applied for the current user in the previous section.

# Registry HKCR
These changes all apply to `HKEY_CLASSES_ROOT`. The only change done here is the addition of the "Open Command Window Here" option under the right-click menu of the File Explorer. This option has a localized name, an icon, and can only be viewed if Shift is held when the right-click menu is opened (to always show the option, remove the lines with `Extended`).

# Registry: Photo Viewer
Changes applied here will enable the classic Windows Photo Viewer. The exact patch `Restore_Windows_Photo_Viewer_ALL_USERS_with_Sort_order_fix.reg` originates from https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html (the link has additional information).

At the end of this section, the generated registry file is finally applied with `reg import`.

# Legacy Bootloader & Safe Mode
This command enables the "legacy" Windows 7 boot loader and boot menu options in Windows 10. While this may slow down the startup process by a second or two, it readds the ability to enter the boot menu directly with F8 and use it to enter Safe Mode, which makes the change welcome in the case Safe Mode will become necessary in order to fix an issue.

# Uninstall OneDrive
These two commands run the 32-bit and 64-bit editions of OneDriveSetup.exe with the /uninstall flag, effectively uninstalling OneDrive from the machine, since most users will not have a use for it, and Microsoft is known to advertise OneDrive with notifications as well as in the File Explorer.

# Disable Automatic Reboot 
These two commands modify the `Reboot` task template used by Windows Update, with the intended purpose being to completely disable Windows Update's ability to restart the computer of its own volition. The first command is used to get a formatted string representing the current date and time. 

# Batch utilities (if enabled)
*(todo)*

# Remove Mixed Reality (if enabled)
*(todo)*

# Delete Cortana (if enabled)
*(todo)*

# Disable SmartScreen (if enabled)
*(todo)*

# Install Linux Subsystem (if enabled)
*(todo)*

# Script complete
Once the script is complete, the final message is written. If the script was opened in an existing command line, control will be returned, but if the batch script was opened in its own window, the file will enter an infinite loop and ask the user to close the window. 

The final message encourages the user to check their privacy settings, provides a command to open them, advises on running the script after every major upgrade and then recommends the user to restart to apply the changes, as it is necessary to do so for some of the changes.
