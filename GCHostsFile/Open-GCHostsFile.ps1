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
  if (-not (Test-GCAdminShell) -and -not $Force) {
    Write-Warning -Message "The PowerShell console is not running As Administrator. Changes to the hosts file will not be saved."
    Pause
  } 
  $hostFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  Start-Process -FilePath 'notepad.exe' -ArgumentList $hostFilePath
}