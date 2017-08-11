<#
.SYNOPSIS
  Returns any hosts file entries in the form of PSCustomObjects.
.DESCRIPTION
  Reads the contents of the %SYSTEMROOT%\System32\drivers\etc\hosts file
  returning the results as an item or array of PSCustom objects.

  The returned objects have the following schema:
  [PSCustomObject]@{
    IPAddress=[IPAddress];
    HostName=[String]
  }

  Hosts file comments are ignored.

  Type 'Get-Help Get-GCHostsFileEntry -Online' for extra information.
.PARAMETER HostName
  Filters the result by host name.
.PARAMETER IPAddress
  Filters the result by host ip address.
.EXAMPLE
  The following example gets the list of IP addresses in the hosts file
  and stores them as strings into the $ip variable:

  $entries = Get-GCHostFileEntry
  $ip = $entries.IPAddress.IPAddressToString
#>
function Get-GCHostsFileEntry {
  [CmdletBinding(DefaultParameterSetName='ByName',
                 HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([PSCustomObject[]])]
  Param (
    [Parameter(Mandatory=$false,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               ParameterSetName='ByName')]
    [String]
    $HostName,
    
    [Parameter(Mandatory=$false,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               ParameterSetName='ByIP')]
    [String]
    $IPAddress
  )
  
  begin {
    Import-Module -Name GCTest
    $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
    $entries = New-Object -TypeName System.Collections.ArrayList
    if (-not (Test-GCHostsFile)) {
      Write-Error -Message "Hosts file missing or the format is invalid. Please inspect the hosts file."
    }
  }
  
  process {
    $rawContent = Get-Content -Path $hostsFilePath
    foreach ($line in $rawContent) {
      if ($line -notmatch '^$|^\s*$|^\s*#') {
        $lineElements = $line.Trim() -split '\s+'
        if ($lineElements.length -ge 2) {
          $add = $false
          if ($IPAddress -and $IPAddress.Trim() -eq $lineElements[0]) { $add = $true }
          if ($HostName -and $HostName.Trim().ToUpper() -eq $lineElements[1].ToUpper()) { $add = $true } 
          if (-not $HostName -and -not $IPAddress) { $add = $true }
          if ($add) {
            $entries.Add(
              [PSCustomObject]@{
                IPAddress=[IPAddress]$lineElements[0];
                HostName=[String]$lineElements[1]
              }
            ) | Out-Null
          }
        }
      }
    }
    if ($entries.Count -eq 1) {
      Return $entries[0]
    } elseif ($entries.Count -gt 1) {
      Return $entries
    } else {
      Return $null
    }
  }
  
  end {
  }
}
