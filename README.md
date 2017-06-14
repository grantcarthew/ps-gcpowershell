# GCPowerShell

An assortment of PowerShell modules

## Description

This repository contains a collection of PowerShell modules that contain tools to help you work with the Windows platform. The modules have been published to the [PowerShell Gallery](https://www.powershellgallery.com/items?q=grantcarthew).

To prevent function name collisions, every function has a prefix of `GC` being my initials.

## Installation

To install any of the modules within this repository type the following into a PowerShell console:

```PowerShell

Install-Module -Name <module name> -Force

# Example:

Install-Module -Name GCTest -Force

```

## Module List

Following is a list of the modules within this repository and the functions they contain. For details of what each function does click the hyperlink to read the function help in the source code.

### GCTest

The GCTest module contains `Test-GC*` functions for basic True/False system tests.

#### GCTest Functions

*   [Test-GCAdminShell](GCTest/Test-GCAdminShell.ps1): Test the console to see if it is running 'as Administrator'.

### GCWindowsUpdate

This module contains functions to interact with the Windows Update service.

I have lost data from open applications because Windows Update decided to reboot on me without retaining current state. After this happened a few times I decided to disable the Windows Update service. This worked well letting me update the platform when I wanted to update. After manually enabling and disabling the Windows Update service I wrote these functions.

__Warning:__ Calling `Stop-GCWindowsUpdate` will disable the Windows Update background service. This will prevent your system from installing updates until you start the service or run `Start-GCWindowsUpdate`.

#### GCWindowsUpdate Functions

*   [Start-GCWindowsUpdate](GCWindowsUpdate/Start-GCWindowsUpdate.ps1): Downloads and installs update packages.
*   [Stop-GCWindowsUpdate](GCWindowsUpdate/Stop-GCWindowsUpdate.ps1): Stops and disables the Windows Update service.