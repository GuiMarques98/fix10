
# Fix10.bat full documentation
## for version 1.1.4

# The document is still a heavy work in progress, and it will likely be finished in the coming days.

This document provides a list of the changes performed by Fix10.bat, as well as a detailed explanation for every one of them. 

It is not known whether any of the changes are restricted to specific versions of Windows 10 (original, Anniversary, Creators, Fall Creators...) or editions (Home, Pro, Enterprise), but it is likely that some of the changes will not work on Home or Pro.

The documentation will be provided in sections ordered according to their order of appearance in the source code of the batch file itself.

# Disable services

Several of the services are either disabled here or set to start on demand (therefore, not automatically).

## DiagTrack, Diagnostics Tracking Service
This service is also known as the **Connected User Experiences and Telemetry** starting from Windows 10 Anniversary Update onwards. DiagTrack is the service's actual underlying technical name, and is also referred by Fix10.bat to maintain compatibility. 

The service in question is used to upload telemetry information to Microsoft's servers, and the data sent is described in detail on Microsoft's website: https://docs.microsoft.com/en-us/windows/configuration/configure-windows-telemetry-in-your-organization
> Use this article to make informed decisions about how you might configure telemetry in your organization. Telemetry is a term that means different things to different people and organizations. For this article, we discuss telemetry as system data that is uploaded by the **Connected User Experience and Telemetry** component. The telemetry data is used to help keep Windows devices secure by identifying malware trends and other threats and to help Microsoft improve the quality of Windows and Microsoft services.

Disabling the service is used as a preventive measure to block any data being sent. The drawbacks of leaving such telemetry on include its intrusiveness, active usage of the Internet connection (especially a problem on metered or limited connections) and the questionable level of privacy. 

## dmwappushsvc, Dmwappushservice

This service is the WAP Push Message Routing Service. Microsoft has not documented this service extensively, but it is used for system bootstrapping and provisioning, and is often also considered to be connected with telemetry (see the service above), so it is often recommended to disable it along DiagTrack.

**Important note: disabling this service will break the *sysprep* script: the script will simply freeze.** To fix this issue, simply enable the service again with the following command under the Command Line running as an administrator: `sc config Dmwappushsvc start= auto & net start Dmwappushsvc`
