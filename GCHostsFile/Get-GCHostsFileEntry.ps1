<#
.SYNOPSIS
  Returns any hosts file entries in the form of PSCustomObjects.
.DESCRIPTION
  Reads the contents of the %SYSTEMROOT%\System32\drivers\etc\hosts file
  returning the results as an item or array of PS custom objects.

  The returned objects have the following schema:
  [PSCustomObject]@{
    IPAddress=[IPAddress];
    HostNames=[String[]];
    Comment=[String];
  }

  Hosts file single line comments are ignored.

  Type 'Get-Help Get-GCHostsFileEntry -Online' for extra information.
.PARAMETER HostName
  Filters the result by host name. Supports a single
  host name value or an array of host names.
.PARAMETER IPAddress
  Filters the result by host ip address. Supports a single
  ip address or an array of ip addresses.
.EXAMPLE
  The following example gets the list of IP addresses in the hosts file
  and stores them as strings into the $ip variable:

  $entries = Get-GCHostFileEntry
  $ip = $entries.IPAddress.IPAddressToString
#>
function Get-GCHostsFileEntry {
  [CmdletBinding(DefaultParameterSetName='ByName',
                 HelpUri = 'https://github.com/grantcarthew/ps-gcpowershell')]
  [OutputType([PSCustomObject[]])]
  Param (
    [Parameter(Mandatory=$false,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               ParameterSetName='ByName')]
    [String[]]
    $HostName,
    
    [Parameter(Mandatory=$false,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               ParameterSetName='ByIP')]
    [String[]]
    $IPAddress
  )
  
  begin {
    Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"

    $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
    Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

    Write-Verbose -Message "Getting content from hosts file."
    $lines = Get-Content -Path $hostsFilePath
    $entries = New-Object -TypeName System.Collections.ArrayList
    $lineElements = New-Object -TypeName System.Collections.ArrayList
  }
  
  process {
    if ($IPAddress) { Write-Verbose -Message "Filtering with IPAddress: $IPAddress" }
    if ($HostName) { Write-Verbose -Message "Filtering with HostName: $HostName" }
    if (-not $IPAddress -and -not $HostName) { Write-Verbose -Message "Retrieving all hosts file entries"}

    foreach ($line in $lines) {
      if ($line -notmatch '^$|^\s*$|^\s*#') {
        $comment = ''
        $content = $line
        if ($line -match '#') {
          $hashIndex = $line.IndexOf('#')
          $remainder = $line.Length - $hashIndex
          $comment = $line.Substring($hashIndex, $remainder)
          $content = $line.Substring(0, $hashIndex)
        }

        $lineElements.clear()
        $lineElements.AddRange($content.Trim() -split '\s+')
        if ($lineElements.Count -ge 2) {
          $addReturnItem = $false
          if (-not $HostName -and -not $IPAddress) {
            $addReturnItem = $true
          } elseif ($IPAddress -and $IPAddress.Trim() -eq $lineElements[0]) {
            Write-Verbose -Message "IPAddress match: $($lineElements[0])"
            $addReturnItem = $true
          } else {
            for ($i = 1; $i -lt $lineElements.Count; $i++) {
              if ($HostName -and $HostName.Trim().ToUpper() -eq $lineElements[$i].ToUpper()) {
                Write-Verbose -Message "HostName match: $($lineElements[$i])"
                $addReturnItem = $true
              } 
            }
          }
          if ($addReturnItem) {
            $ip = $lineElements[0]
            $lineElements.RemoveAt(0)
            $entries.Add(
              [PSCustomObject]@{
                IPAddress=[IPAddress]$ip;
                HostNames=[String[]]$lineElements.ToArray();
                Comment=[String]$comment;
              }
            ) | Out-Null
          }
        } else {
          Write-Warning -Message "Invalid hosts file line: " + $line
        }
      }
    }
  }
  
  end {
    if ($entries.Count -eq 1) {
      Write-Output -InputObject $entries[0]
    } elseif ($entries.Count -gt 1) {
      Write-Output -InputObject $entries
    } else {
      Write-output -InputObject $null
    }

    Write-Verbose -Message "Total hosts entries: $($entries.Count)"
    Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
  }
}
