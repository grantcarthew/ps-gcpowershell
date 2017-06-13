<#
.SYNOPSIS
  Completes the Windwos Update initiated by Start-WindowsUpdate.
.DESCRIPTION
  Due to the latest versions of Microsoft Windows being rather forward about applying
  updates and rebooting machines, this function allows you to install the updates on your own schedule.

  Start-WindowsUpdate performs the following tasks:
  -   Sets the Windows Update service, named wuauserv, to a StartType of Automatic
  -   Starts the Windows Update Service
  -   Downloads and installs all required Windows updates

  Rebooting after the updates is not forced and will most likely be required.

.EXAMPLE
  The following example installs all required updates on the local machine:

  PS> Start-WindowsUpdate
#>
function Stop-WindowsUpdate {
  [CmdletBinding()]
  [Alias()]
  [OutputType([String])]
  Param() 

  Import-Module -Name GCTest

  if (Test-GCAdminShell -PrintError) {
    $wu = Get-Service -Name wuauserv
    Stop-Service -InputObject $wu
    Set-Service -InputObject $wu -StartupType Disabled
  }
}
