<#
.SYNOPSIS
  Deletes all content from the hosts file.
.DESCRIPTION
  After running 'Clear-GCHostsFile' the local hosts file will be
  empty including all ip/host and comment values.

  An exception will be thrown if the current console session does not
  have write access to the hosts file.

  Type 'Get-Help Clear-GCHostsFile -Online' for extra information.
.PARAMETER Force
  Prevents display of the confirmation dialog
  which is displayed by default.
#>
function Clear-GCHostsFile {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([Boolean])]
  Param (
    [Parameter(Mandatory=$false,
               Position=0)]
    [Switch]
    $Force
  )
  Import-Module -Name GCTest
  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'

  if (-not (Test-GCFileWrite -Path $hostsFilePath)) {
    throw "PowerShell session does not have write access to the hosts file."
  } else {
    Clear-Content -Path $hostsFilePath -Confirm:(-not $Force) -Force
  }
}
