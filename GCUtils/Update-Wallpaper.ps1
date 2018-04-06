<#
    .SYNOPSIS
    Downloads a new Wallpaper from GitHub and applies it to the desktop.
#>
$transcribing = $false
try
{
    $externalHost = $host.gettype().getproperty("ExternalHost",[Reflection.BindingFlags]"NonPublic,Instance").getvalue($host, @())
    $transcribing = $externalHost.gettype().getproperty("IsTranscribing",[Reflection.BindingFlags]"NonPublic,Instance").getvalue($externalHost, @())
} catch {}

if ($transcribing -eq $false) { Start-Transcript -Path "C:\Tools\Logs\Update-Wallpaper.log" -Append }

"Begin: " + $MyInvocation.MyCommand.Path

# The following type is added to the PowerShell instance
# to enable applying the new wallpaper to the desktop.
$newType = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace Desktop
{
    public class Wallpaper
    {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern Int32 SystemParametersInfo(UInt32 uiAction, UInt32 uiParam, String pvParam, UInt32 fWinIni);
        private static UInt32 SPI_SETDESKWALLPAPER = 20;
        private static UInt32 SPIF_UPDATEINIFILE = 0x1;

        public static int SetImage(string filename)
        {
           return SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, filename, SPIF_UPDATEINIFILE);
        }
        
    }
}
"@
Add-Type -TypeDefinition $newType

"Get the machines location."
$cityDetails = $null
$cityDetails = Get-City -Detailed
"Location is " + $cityDetails.Name
"Wallpaper location: " + $cityDetails.Wallpaper

$dest = "C:\Tools\Downloads\Wallpaper.jpg"
$localFileSize = $null
$remoteFileDetails = $null

"Checking local wallpaper file attributes..."
if (Test-Path -Path $dest -PathType Leaf)
{
    $localFileSize = Get-Item -Path $dest | Select-Object -ExpandProperty Length
}
else
{
    "No local file exists."
}

try
{
    "Getting remote wallpaper file attributes..."
    $remoteContentLength = Invoke-WebRequest -Uri $cityDetails.Wallpaper -Method Head -UseBasicParsing | Select-Object -ExpandProperty Headers
    $remoteContentLength = $remoteContentLength.'Content-Length'
    "Local wallpaper content length: " + $localFileSize
    "Remote wallpaper content length: " + $remoteContentLength

    if ($localFileSize -ne $remoteContentLength)
    {
        "Local wallpaper file is different to the remote file."
        "Downloading new file from;"
        if (Test-Path -Path $dest -PathType Leaf) { Remove-Item -Path $dest -Force }
        Invoke-WebRequest -Uri $cityDetails.Wallpaper -Method Get -UseBasicParsing -OutFile $dest

        "Setting the new desktop wallpaper."
        $result = [Desktop.Wallpaper]::SetImage($dest)
    }
    else
    {
        "Local and remote wallpaper files are the same size: $localFileSize"
        "Skipping update this time."
    }
}
catch [Exception]
{
    "An error occured while accessing remote file data."
}

"End: " + $MyInvocation.MyCommand.Name
if ($transcribing -eq $false)
{
    Stop-Transcript
}