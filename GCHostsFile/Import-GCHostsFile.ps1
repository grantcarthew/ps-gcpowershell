<#
.SYNOPSIS
  Overwrites the hosts file with the source file.
.DESCRIPTION
  If the source file exists it will clobber the hosts file
  by being coppied over the top of it.

  Type 'Get-Help Import-GCHostsFile -Online' for extra information.
.PARAMETER Path
  The source path including file name to replace the
  existing hosts file.
.PARAMETER Force
  Prevents the confirmation dialog from being displayed.
#>
function Import-GCHostsFile {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([Int])]
  Param (
    [Parameter(Mandatory=$true,
               Position=0)]
    [String]
    $Path,

    [Parameter(Mandatory=$false,
               Position=1)]
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
  }

  if (-not (Test-Path -Path $Path)) {
    Write-Warning -Message "The source file does not exists."
  } else {
    Write-Verbose -Message "Importing hosts file from: $Path"
    $pleaseConfirm = -not $Force
    Copy-Item -Path $Path -Destination $hostsFilePath -Force -Confirm:$pleaseConfirm
  }

  Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
}
