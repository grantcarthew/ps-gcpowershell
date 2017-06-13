# GCPowerShell

An assortment of PowerShell modules

## Description

This repository contains a collection of PowerShell modules that contain tools to help you work with the Windows platform. The modules have been published to the [PowerShell Gallery](https://www.powershellgallery.com).

To prevent function name collisions every function has a prefix of `GC` being my initials.

## Installation

To install any of the modules within this repository type the following into a PowerShell console:

```ps

Install-Module -Name <module name> -Force

# Example:

Install-Module -Name GCTest -Force

```

## Module List

Following is a list of the modules within this repository and the functions they contain. For details of what each function does click the hyperlink to read the function help in the source code.

### GCTest

The GCTest module contains `Test-GC*` functions for basic True/False system tests.

#### GCTest Functions

*   [Test-GCAdminShell]('/GCTest/Test-GCAdminShell.ps1): Test the console to see if it is running 'as Administrator'.

