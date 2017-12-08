# Fix10.bat

This is a batch file intended for power users to apply some registry and other small patches to Windows 10 to increase privacy and usability.

## Disclaimer

The batch file in question requires administrative privileges to run on a system and is intended to only be run on Windows 10. Regardless of conditions, the script is run at your own risk, and HandleSoft cannot be responsible for increased boot times (will likely happen) or, perhaps even worse, features removed from the system or the system refusing to function or start up properly, or any other adverse side effects. By running the batch file, you accept that you have read this disclaimer and understand its and the script's consequences.

## Notes on Windows 10 editions

Several of the modifications rely on registry settings, some of which are Group Policy settings. Due to Microsoft's will to restrict users, some of the changes might not work in some editions of Windows 10, most notably the Home and Pro editions.

## List of changes applied so far

* Disable diagnostics and tracking services
* Disable Windows Defender
* Try to set Updates to Ask before Download
* Uninstall OneDrive
* Disable Bing Search
* Disable Application Telemetry
* Disable Steps Recorder
* Disable "Delivery Optimization"
* Turn off advertising ID
* Disable Suggested app download (you will still need to uninstall those already downloaded yourself)
* Disable Windows Spotlight
* Disable keylogger ("improve typing")
* Opt out from CEIP
* Disable Cortana
* Restore Windows Photo Viewer ([source](https://www.tenforums.com/tutorials/14312-restore-windows-photo-viewer-windows-10-a.html))
* Win+X: PowerShell to CMD
* Re-add CMD to Context menu (if Shift down)
* Enable seconds in the tray
* Show file extensions
* Enables Legacy Boot Loader + F8 Safe Mode 
  * This might slow down booting by a few seconds, but it enables Advanced Boot Options, and I consider it a fair trade-off.
* Disable Fast Startup (!!!)
  * This might slow down booting by a few seconds too. It's related to the above, and makes sure your system actually shuts down instead of just pretending to. 
* Disable Smart Screen? (!!!)
  * This might be a security issue, so make sure you take note of this.
