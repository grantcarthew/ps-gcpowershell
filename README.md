# GCPowerShell

An assortment of PowerShell modules

## Description

This repository contains a collection of PowerShell modules that contain tools to help you work with the Windows platform. The modules have been published to the [PowerShell Gallery](https://www.powershellgallery.com/items?q=grantcarthew).

To prevent function name collisions, every function has a prefix of `GC` being my initials.

## Module List

Following is a list of the modules within this repository. For details of what each module and function does click the hyperlinks to read the module description and function help in the source code.

*   [GCTest](#gctest): Basic True/False system tests.
*   [GCWindowsUpdate](#gcwindowsupdate): Control the Windows Update background service.

### GCTest

```posh
Install-Module -Name GCTest -Force
```

The GCTest module contains `Test-GC*` functions for simple True/False system tests.

*   [Test-GCAdminShell](GCTest/Test-GCAdminShell.ps1): Test the console to see if it is running 'as Administrator'.
*   [Test-GCHostsFile](GCTest/Test-GCHostsFile.ps1): Existence and format tests against the local hosts file. 

### GCWindowsUpdate

```posh
Install-Module -Name GCWindowsUpdate -Force
```

This module contains functions to interact with the Windows Update service.

I have lost data from open applications because Windows Update decided to reboot on me without retaining current state. After this happened a few times I decided to disable the Windows Update service. This worked well letting me update the platform when I wanted to update. After manually enabling and disabling the Windows Update service I wrote these functions.

__Warning:__ Calling `Stop-GCWindowsUpdate` will disable the Windows Update background service. This will prevent your system from installing updates until you start the service or run `Start-GCWindowsUpdate`.

*   [Start-GCWindowsUpdate](GCWindowsUpdate/Start-GCWindowsUpdate.ps1): Downloads and installs update packages.
*   [Stop-GCWindowsUpdate](GCWindowsUpdate/Stop-GCWindowsUpdate.ps1): Stops and disables the Windows Update service.