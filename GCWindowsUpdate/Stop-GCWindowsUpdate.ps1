
[CmdletBinding()]
Param()
  
$wu = Get-Service -Name wuauserv
Stop-Service -InputObject $wu
Set-Service -InputObject $wu -StartupType Disabled
