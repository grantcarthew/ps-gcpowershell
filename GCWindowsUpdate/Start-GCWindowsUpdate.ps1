[CmdletBinding()]
Param()
  
Import-Module -Name "D:\Pool\GDCSync\bin\PSWindowsUpdate"

$wu = Get-Service -Name wuauserv
Set-Service -StartupType Automatic -InputObject $wu
Start-Service -InputObject $wu

Get-WUInstall -AcceptAll