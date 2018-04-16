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
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/ps-gcpowershell')]
  [OutputType([Boolean])]
  Param (
    [Parameter(Mandatory=$false,
               Position=0)]
    [Switch]
    $Force
  )
  Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"
  Import-Module -Name GCTest

  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

  if (-not (Test-GCFileWrite -Path $hostsFilePath)) {
      Write-Error -Message "Can't write to the hosts file. Check it exists and you have write permissions."
      Exit
  } else {
    Write-Verbose -Message "Clearing the hosts file."
    $pleaseConfirm = -not $Force
    Clear-Content -Path $hostsFilePath -Confirm:$pleaseConfirm -Force
  }

  Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
}
