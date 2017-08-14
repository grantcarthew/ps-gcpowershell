<#
.SYNOPSIS
  Tests if the PowerShell console is running as Administrator.

.DESCRIPTION
  When running a PowerShell console you can launch it as a standard user or as Administrator.
  When run as Administrator, the console can make system changes to Windows.

  This function will return True if the PowerShell console is running as Administrator, False otherwise.

  For a detailed report in the console use -Verbose.

  Type 'Get-Help Test-GCAdminShell -Online' for extra information.
.PARAMETER PrintError
  If this parameter is present a console error is reported if the console is not running as Administrator.
#>
function Test-GCAdminShell {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [Alias()]
  [OutputType([Boolean])]
  Param(
    [Switch]
    $PrintError = $false
  ) 
  
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  Write-Verbose -Message ("Identity Name: " + $identity.Name)

  $principal = New-Object Security.Principal.WindowsPrincipal $identity
  $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
  Write-Verbose -Message ("Running as Administrator: " + $isAdmin)

  if ($PrintError -and -not $isAdmin) {
    Write-Error -Message "Please run this console as Administrator"
  }

  Write-Output -InputObject $isAdmin
}
  