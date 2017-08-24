# GCPowerShell

An assortment of PowerShell modules

## Description

This repository contains a collection of PowerShell modules that contain tools to help you work with the Windows platform. The modules have been published to the [PowerShell Gallery](https://www.powershellgallery.com/items?q=grantcarthew).

To prevent function name collisions, every function has a prefix of `GC` being my initials.

## Module List

Following is a list of the modules within this repository. For details of what each module and function does click the hyperlinks to read the module description and function help in the source code.

*   [GCHostsFile](#gchostsfile): Hosts file management tools for local name resolution.
*   [GCTest](#gctest): Basic True/False system tests.
*   [GCWindowsUpdate](#gcwindowsupdate): Control the Windows Update background service.

### GCHostsFile

```posh
Install-Module -Name GCHostsFile -Force
```

The GCHostsFile module contains a number of functions to help you manage the hosts file on the Windows platform.

The hosts file is the first place Windows checks for name resolution. It is loaded into the DNS cache whenever it gets updated.

Read more about the hosts file on [Wikipedia](https://en.wikipedia.org/wiki/Hosts_(file))

The GCHostsFile module contains the following functions:

*   [Add-GCHostsFileEntry](GCHostsFile/Add-GCHostsFileEntry.ps1): Add host entries to the hosts file.
*   [Clear-GCHostsFile](GCHostsFile/Clear-GCHostsFile.ps1): Delete all contents of the hosts file.
*   [Export-GCHostsFile](GCHostsFile/Export-GCHostsFile.ps1): Create a copy of the hosts file.
*   [Get-GCHostsFileEntry](GCHostsFile/Get-GCHostsFileEntry.ps1): Retrieve hosts file entries as PSCustomObjects.
*   [Import-GCHostsFile](GCHostsFile/Import-GCHostsFile.ps1): Replaces the hosts file with a source files contents.
*   [Install-GCHostsFileBlockList](GCHostsFile/Install-GCHostsFileBlockList.ps1): Installs a block list managed by [Steven Black](https://github.com/StevenBlack/hosts).
*   [Open-GCHostsFile](GCHostsFile/Open-GCHostsFile.ps1): Opens the hosts file in notepad.exe.
*   [Remove-GCHostsFileEntry](GCHostsFile/Remove-GCHostsFileEntry.ps1): Removes entries from the hosts file using filters.
*   [Set-GCHostsFileEntry](GCHostsFile/Set-GCHostsFileEntry.ps1): Updates or adds hosts file entries. 

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