<#
.SYNOPSIS
  Tests if the PowerShell console is running "As Administrator".

.DESCRIPTION
  When running a PowerShell console you can launch it as a standard user or "as administrator".
  When run "as administrator", the console can make system changes to Windows.

  This function will return True if the PowerShell console is running as administrator. False otherwise.

.PARAMETER PrintError
  If present a console error is reported if the console is not running as administrator.
#>
function Test-GCAdminShell {
  [CmdletBinding()]
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
    Write-Error -Message "Please run this function as administrator"
  }

  Return $isAdmin
}
  