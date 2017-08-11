<# 
    .SYNOPSIS
    Changes the C:\Windows\System32\Drivers\etc\hosts file for DDLS name mappings.
    
    Platform: Windows 7 32bit, Windows 2008 R2 64bit
    Author: Grant Carthew.
    Date: Nov 2010
    Updated: Jan 2011 - Tested against Windows 2008 R2 64bit.
    
    .DESCRIPTION
    Platform: Windows 7 32bit, Windows 2008 R2 64bit
#>

param
(
    [parameter(Mandatory=$false)]
    [switch]
    $SetToDefault
)

BEGIN
{
    "Begin: " + $MyInvocation.MyCommand.Path
    $HostFilePath = "C:\Windows\System32\Drivers\etc\hosts"
}

PROCESS
{
    if ($SetToDefault)
    {
        "Setting the Hosts file to the Default hosts file."
        Get-Content -Path C:\Tools\Set-HostsFileDefault.txt | Set-Content -Path $HostFilePath -Force
    }
    else
    {
        "Setting the Hosts file to the DDLS hosts file."
        Get-Content -Path C:\Tools\Set-HostsFileDDLS.txt | Set-Content -Path $HostFilePath -Force
    }
    
    "Hosts file content updated."
}

END
{
    "End: " + $MyInvocation.MyCommand.Name
}

