<#
.SYNOPSIS
  Starts the Windwos Update service (wuauserv) and downloads all available updates.

.DESCRIPTION
  Due to the latest versions of Microsoft Windows being rather forward about applying
  updates and rebooting machines, this function allows you to install the updates on your own schedule.

  Start-GCWindowsUpdate performs the following tasks:
  -   Sets the Windows Update service, named wuauserv, to a StartupType of Automatic
  -   Starts the Windows Update service
  -   Downloads and installs all required Windows updates

  Rebooting after the updates is not forced.

.EXAMPLE
  The following example installs all required updates on the local machine:

  > Start-GCWindowsUpdate
#>
function Start-GCWindowsUpdate {
  [CmdletBinding()]
  [Alias()]
  [OutputType([String])]
  Param() 
  
  "Start-GCWindowsUpdate initiated"
  Import-Module -Name GCTest

  if (Test-GCAdminShell -ShowError) {
    "Importing the PSWindowsUpdate module"
    Import-Module -Name PSWindowsUpdate

    $wu = Get-Service -Name wuauserv
    "Starting the Windows Update service"
    Set-Service -StartupType Automatic -InputObject $wu
    Start-Service -InputObject $wu

    "Installing Windows Updates"
    Get-WUInstall -AcceptAll
  }

  "Start-GCWindowsUpdate completed"
}
