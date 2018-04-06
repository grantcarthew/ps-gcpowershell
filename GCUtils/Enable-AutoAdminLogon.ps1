<#
.Synopsis
   Sets the auto logon admin registry keys for the DDLS base image.
#>
[CmdletBinding()]
[OutputType([int])]
Param
()

"Begin: " + $MyInvocation.MyCommand.Path

$WinLogonKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
"Setting the default UserName, DomainName, and Password registry key values."
$WinLogonKey
New-ItemProperty -Path $WinLogonKey -Name "DefaultUserName" -PropertyType String -Value "Administrator" -Force | Out-Null
New-ItemProperty -Path $WinLogonKey -Name "DefaultDomainName" -PropertyType String -Value "." -Force | Out-Null
New-ItemProperty -Path $WinLogonKey -Name "DefaultPassword" -PropertyType String -Value "password" -Force | Out-Null
New-ItemProperty -Path $WinLogonKey -Name "AutoAdminLogon" -PropertyType String -Value "1" -Force | Out-Null

"End: " + $MyInvocation.MyCommand.Name
