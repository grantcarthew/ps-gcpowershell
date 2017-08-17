<#
.SYNOPSIS
  Opens the %SYSTEMROOT%\System32\drivers\etc\hosts file in notpade.exe.
.DESCRIPTION
  A warning is displayed requiring you to press enter if the
  PowerShell console is not running As Administrator.

  Type 'Get-Help Open-GCHostsFile -Online' for extra information.
.PARAMETER Force
  Prevents both the display of the As Administrator console warning
  and the requirement to press enter.
#>
function Open-GCHostsFile {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [Alias()]
  [OutputType([String])]
  Param (
    [Parameter(Mandatory=$false,
               Position=0)]
    [Switch]
    $Force
  )
  Import-Module -Name GCTest
  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  if (-not (Test-GCFileWrite $hostsFilePath) -and -not $Force) {
    Write-Warning -Message "The PowerShell session does not have write access to the hosts file. Changes will not be saved."
    Pause
  } 
  Start-Process -FilePath 'notepad.exe' -ArgumentList $hostsFilePath
}
