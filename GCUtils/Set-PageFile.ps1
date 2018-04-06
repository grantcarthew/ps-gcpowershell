<#
.Synopsis
   Sets the page file for the DDLS classroom machines.
.DESCRIPTION
   This is a simple script to set the page file
   on the C Drive and disable on the D Drive.
.PARAMETER Reboot
   Include the reboot switch if you wish to reboot the local machine.
#>
[CmdletBinding()]
Param(
        [Switch]$Reboot = $false
)

"Begin: " + $MyInvocation.MyCommand.Path

$newSizeC = 4096
$newSizeD = 0

"Disabling the Automatic Managed PageFile property."
Get-CimInstance -ClassName Win32_ComputerSystem | Set-CimInstance -Property @{ AutomaticManagedPageFile = $false } -ErrorAction Stop

"Getting the current PageFile WMI objects."
$PageFileC = Get-CimInstance -ClassName Win32_PageFileSetting -Filter "SettingID='pagefile.sys @ C:'" -ErrorAction Stop
$PageFileD = Get-CimInstance -ClassName Win32_PageFileSetting -Filter "SettingID='pagefile.sys @ D:'" -ErrorAction Stop

"Setting the new PageFile values."
# http://msdn.microsoft.com/en-us/library/windows/desktop/aa394245%28v=vs.85%29.aspx           
$PageFileC | Set-CimInstance -Property @{ InitialSize = $newSizeC ; MaximumSize = $newSizeC ; } -ErrorAction Stop
$PageFileD | Set-CimInstance -Property @{ InitialSize = $newSizeD ; MaximumSize = $newSizeD ; } -ErrorAction Stop
         
"Successfully configured the PageFile."

if ($Reboot)
{
    "Rebooting the local machine."
    Restart-Computer -Force
}
else
{
    Write-Warning -Message "The local machine will need rebooting for the new settings to apply."
}
""
"End: " + $MyInvocation.MyCommand.Name
