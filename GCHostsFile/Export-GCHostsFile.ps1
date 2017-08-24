<#
.SYNOPSIS
  Copies the hosts file to the path specified.
.DESCRIPTION
  This is nothing more than an easy way of getting a copy
  of the hosts file. Use it to create a backup of the current
  hosts file before making changes.

  Type 'Get-Help Export-GCHostsFile -Online' for extra information.
.PARAMETER Path
  The destination path to export the existing hosts file.
  If the destination is directory then the resulting file will
  be named the 'hosts' file.
.PARAMETER Force
  Prevents the confirmation dialog if the destination file
  already exists.
#>
function Export-GCHostsFile {
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

  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

  $pleaseConfirm = $false
  if ((Test-Path -Path $Path) -and -not $Force) {
    Write-Warning -Message "The destination file exists. Confirm overwrite?"
    $pleaseConfirm = $true
  }
  Write-Verbose -Message "Copying hosts file to: $Path"
  Copy-Item -Path $hostsFilePath -Destination $Path -Force -Confirm:$pleaseConfirm

  Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
}
