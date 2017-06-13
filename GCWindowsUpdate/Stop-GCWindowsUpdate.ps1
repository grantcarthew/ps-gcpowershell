<#
.SYNOPSIS
  Completes the Windwos Update initiated by Start-GCWindowsUpdate.

.DESCRIPTION
  Due to the latest versions of Microsoft Windows being rather forward about applying
  updates and rebooting machines, this function allows you to install the updates on your own schedule.

  Stop-GCWindowsUpdate performs the following tasks:
  -   Stops the Windows Update service
  -   Sets the Windows Update service, named wuauserv, to a StartType of Disabled

  WARNING: Running this function will prevent your computer from receiving Windows Updates
  until you either enable the Windows Update service or run the Start-GCWindowsUpdate function.
.EXAMPLE
  The following example installs all required updates on the local machine:

  > Start-WindowsUpdate
#>
function Stop-WindowsUpdate {
  [CmdletBinding()]
  [Alias()]
  [OutputType([String])]
  Param() 

  "Stop-GCWindowsUpdate initiated"
  Import-Module -Name GCTest

  if (Test-GCAdminShell -PrintError) {
    "Stopping the Windows Update service"
    $wu = Get-Service -Name wuauserv
    Stop-Service -InputObject $wu
    "Disabling the Windows Update service"
    Set-Service -InputObject $wu -StartupType Disabled
  }

  "Stop-GCWindowsUpdate completed"
}
