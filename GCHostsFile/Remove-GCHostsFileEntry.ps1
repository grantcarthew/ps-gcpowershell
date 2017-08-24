<#
.SYNOPSIS
  Remove a hosts file entry from the hosts file.
.DESCRIPTION
  Unlike the other hosts file cmdlets, this function is a
  simple line match and remove.

  Type 'Get-Help Remove-GCHostsFileEntry -Online' for extra information.
.PARAMETER Target
  The search string to remove from the hosts file.
  Regular expressions are supported.
.EXAMPLE
  The following example removes any lines in the hosts file
  that match the target string:

  Remove-GCHostFileEntry -Target "abc.net.au"
.EXAMPLE
  The following example will remove all empty lines from
  the hosts file:

  Remove-GCHostsFileEntry -Target '^$'
#>
function Remove-GCHostsFileEntry {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([Int])]
  Param (
    [Parameter(Mandatory=$true,
               Position=0,
               ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Target
  )
  
  Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"
  Import-Module -Name GCTest
  
  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

  if (-not (Test-GCFileWrite -Path $hostsFilePath)) {
    Write-Error -Message "Can't write to the hosts file. Check it exists and you have write permissions."
  }

  Write-Verbose -Message "Getting content from hosts file."
  $lines = Get-Content -Path $hostsFilePath
  $output = New-Object -TypeName System.Collections.ArrayList

  if ($lines.length -lt 1) {
    Write-Output -InputObject "Hosts file is empty. No change."
    Exit
  } else {
    Write-Verbose -Message "Cleaning Target from hosts: $Target"
    foreach ($line in $lines) {
      if ($line -notmatch $Target) {
        $output.Add($line) | Out-Null
      }
    }
  }

  if ($output.Count -lt 1) {
    Write-Verbose -Message "Nothing to write to the hosts file. No change."
  } else {
    Write-Verbose -Message "Writing new hosts file"
    Set-Content -Path $hostsFilePath -Value $output -Force
  }
  Write-Verbose -Message "Total lines before : $($lines.Length)"
  Write-Verbose -Message "Total lines after  : $($output.Count)"
  Write-Verbose -Message "Total lines removed: $($lines.Length - $output.Count)"
  Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
}
