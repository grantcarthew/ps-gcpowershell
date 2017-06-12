# Get module script files
Write-Host -Object "PSM1: $PSScriptRoot"
$scripts = @( Get-ChildItem -Path $PSScriptRoot\S*.ps1 -ErrorAction SilentlyContinue )

#Dot source the script files
$scripts
Foreach($import in $scripts)
{
    Try
    {
        $import.Fullname
        . $import.Fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Export the Public modules
Export-ModuleMember -Function $scripts.Basename
