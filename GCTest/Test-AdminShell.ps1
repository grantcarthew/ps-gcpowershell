<#
.SYNOPSIS
  Tests if the PowerShell console is running "As Administrator".
.DESCRIPTION
  When running a PowerShell console you can launch it as a standard user or "as administrator".
  When run "as administrator", the console can make system changes to Windows.

  This function will return True if the PowerShell console is running as administrator. False otherwise.
.PARAMETER PrintError
  If set to True a console error is reported if the console is not running as administrator.
#>
function Test-AdminShell {
  [CmdletBinding()]
  [Alias()]
  [OutputType([Boolean])]
  Param(
    [Switch]
    $PrintError = $false
  ) 
  
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  Write-Host -Object ("Identity Name: " + $identity.Name)
  $principal = New-Object Security.Principal.WindowsPrincipal $identity
  $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
  Write-Host -Object ("Running as Administrator: " + $isAdmin)

  if ($PrintError) {
    Write-Error -Message "Please run this function as administrator"
  }

  Return $isAdmin
}
  