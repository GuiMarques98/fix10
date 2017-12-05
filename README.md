# Fix10.bat

This is a batch file intended for power users to apply some registry and other small patches to Windows 10 to increase privacy and useability.

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
* Win+X: PowerShell to CMD
* Enable seconds in the tray
* Show file extensions
* Enables Legacy Boot Loader + F8 Safe Mode 
  * This might slow down booting by a few seconds, but it enables Advanced Boot Options, and I consider it a fair trade-off.
* Disable Fast Startup (!!!)
  * This might slow down booting by a few seconds too. It's related to the above, and makes sure your system actually shuts down instead of just pretending to. 
* Disable Smart Screen? (!!!)
  * This might be a security issue, so make sure you take note of this.
