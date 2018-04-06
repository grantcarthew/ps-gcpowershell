<# 
    .SYNOPSIS
    Creates a new shortcut as a .lnk or .url file.

    Platform: Windows 7 32bit, Windows 2008 R2 64bit
    Author: Grant Carthew.
    Date: Nov 2010
    Updated: Jan 2011 - Tested against Windows 2008 R2 64bit.
    Updated: Mar 2011 - Fixed the .url shortcut creation.
    
    .DESCRIPTION
    Platform: Windows 7 32bit, Windows 2008 R2 64bit
    
    Using the FullLinkName, Target and Arguments a new shortcut file
    will be created.

    .PARAMETER FullLinkName
    The full path to the new shortcut file, not the target of the shortcut.
    Do not include the .lnk or .url extention, this will be added automatically.
    Example: C:\Users\Administrator\Desktop\Notepad

    .PARAMETER Target
    The full path for the target of the new shortcut.
    If the target is in a path that has spaces you need to supply the string with
    double quotes around the path.
    
    If the target starts with http then the new shortcut will be created as a
    .url file rather than a .lnk file.

    .PARAMETER Arguments
    A single string containing all the arguments for the new shortcut.
    Not used for a http (.url) target.
    
    .PARAMETER Description
    A short description of the shortcut.
    Not used for a http (.url) target.
    
    .PARAMETER Icon
    The file and index of the icon in the followin format;
    "app.exe,1"
    Not used for a http (.url) target.
    
    .PARAMETER WindowStyle
    The launch window style for the target of the shortcut.
    Following are valid window styles;
    1 = Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position.
    3 = Activates the window and displays it as a maximized window.
    7 = Minimizes the window and activates the next top-level window.
    Not used for a http (.url) target.

    .PARAMETER WorkingDirectory
    The working directory for the application launched by the shortcut.
    Not used for a http (.url) target.
    
    .EXAMPLE
     # Create a new shortcut in the root of C:\.
     New-Shortcut -FullLinkName C:\Test -Target D:\Test.exe -Arguments "/1 /2 /3"
#>

param
(
    [parameter(Mandatory=$true)]
    [String]
    $FullLinkName,
    
    [parameter(Mandatory=$true)]
    [String]
    $Target,
    
    [parameter(Mandatory=$false)]
    [String]
    $WorkingDirectory,
    
    [parameter(Mandatory=$false)]
    [String]
    $Arguments,
    
    [parameter(Mandatory=$false)]
    [String]
    $Description,
    
    [parameter(Mandatory=$false)]
    [String]
    $Icon,
    
    [parameter(Mandatory=$false)]
    [Int]
    $WindowStyle
)

BEGIN
{
    "Begin: " + $MyInvocation.MyCommand.Path
}

PROCESS
{
    if ($FullLinkName -like "*.lnk" -or $FullLinkName -like "*.url")
    {
        $FullLinkName = $FullLinkName.Substring(0,$FullLinkName.LastIndexOf('.'))
    }
    
    if ($Target.StartsWith("http"))
    {
        $FullLinkName += ".url"
    }
    else
    {
        $FullLinkName += ".lnk"
    }
    
    Add-Path -Path (Split-Path -Path $FullLinkName -Parent)
    
    "Creating shortcut with the following settings;"
    "Shortcut: $FullLinkName"
    "Target: $Target"
    $WSHShell = New-Object -ComObject WScript.Shell
    $Link = $WSHShell.CreateShortcut($FullLinkName)
    $Link.TargetPath = $Target
    if ($FullLinkName.EndsWith(".lnk"))
    {
        $Link.Arguments = $Arguments
        "Arguments: $Arguments"
        $Link.DESCRIPTION = $Description
        "Description: $Description"
        $Link.WindowStyle = $WindowStyle
        $Link.WorkingDirectory = $WorkingDirectory
        if ($Icon) { $Link.IconLocation = $Icon }
    }
    $Link.Save()
}

END
{
    "End: " + $MyInvocation.MyCommand.Name
}