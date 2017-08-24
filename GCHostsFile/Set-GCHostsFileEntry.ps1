<#
.SYNOPSIS
  Updates an existing hosts file IP address if the host name exists.
  If the host name does not exist in the hosts file it will be added.
.DESCRIPTION
  The hosts file is search to find the host name.
  If the host name is found the IP address is updated.
  If the host name is not found a new entry will be added
  at the bottom of the hosts file.  

  This cmdlet does not search IP addresses, only host names.
  If you wish to update the host name for an IP address use
  Remove-GCHostsFileEntry followed by Add-GCHostsFileEntry.

  WARNING: If you pipe many thousands of InputObjects into this cmdlet
  it will take a long time to process the changes. Be patient.

  Type 'Get-Help Set-GCHostsFileEntry -Online' for extra information.
.PARAMETER IPAddress
  The IP address to assign to the host name.
  This can be an IPv4 or IPv6 address.
.PARAMETER HostName
  The name of the host to assign the IP address to.
  This can be a fully qualified name such as server1.domain.com, or a flat name.
  An array of names is supported.
.PARAMETER Comment
  Adds a comment on the same line as the IPAddress and HostName pair.

  There is no need to supply the '#' character.
.EXAMPLE
  The following example updates the hosts file entry with a
  host name of 'server1.company.com' to have a new IP address
  of '5.6.7.8'. If the host name 'server1.company.com' does not
  exist in the hosts file it will be added:

  Set-GCHostsFileEntry -IPAddress 5.6.7.8 -HostName 'server1.company.com'
  #>
function Set-GCHostsFileEntry {
  [CmdletBinding(DefaultParameterSetName='HostEntry',
                HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([String])]
  Param (
    [Parameter(Mandatory=$false,
              Position=0,
              ValueFromPipeline=$true,
              ValueFromPipelineByPropertyName=$true,
              ParameterSetName='HostObject')]
    [PSCustomObject[]]
    $InputObject,

    [Parameter(Mandatory=$true,
              Position=0,
              ValueFromPipeline=$false,
              ParameterSetName='HostEntry')]
    [String]
    $IPAddress,

    [Parameter(Mandatory=$true,
              Position=1,
              ValueFromPipeline=$false,
              ParameterSetName='HostEntry')]
    [String[]]
    $HostName,

    [Parameter(Mandatory=$false,
              Position=2,
              ValueFromPipeline=$false,
              ParameterSetName='HostEntry')]
    [String]
    $Comment
  )

  begin {
    Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"
    Import-Module -Name GCTest

    $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
    Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

    if (-not (Test-GCFileWrite -Path $hostsFilePath)) {
      Write-Error -Message "Can't write to the hosts file. Check it exists and you have write permissions."
      Exit
    }

    $hostsFileEntries = Get-GCHostsFileEntry 
    $newEntries = New-Object -TypeName System.Collections.ArrayList
    $updateEntries = New-Object -TypeName System.Collections.ArrayList
    
    $allHostNames = New-Object -TypeName System.Collections.ArrayList
    foreach ($entry in $hostsFileEntries) {
      foreach ($name in $entry.HostNames) {
        $allHostNames.Add($name.ToUpper().Trim()) | Out-Null
      }
    }
    function TestNewHostsIP ($NewIP) {
      # The following will cause an error if the IPAddress is invalid.
      # The error will be reported to the console.
      Write-Verbose -Message "Type casting IPAddress: $NewIP"
      [IPAddress]$NewIP | Out-Null
    }
    function TestHostNameExists ($TestHostName) {
      Write-Verbose -Message "Testing for existing entry: $TestHostName" 
      $exists = $false
      foreach ($eachName in $TestHostName) {
        if ($eachName.ToUpper().Trim() -in $allHostNames) {
          $exists = $true 
          break
        }  
      }
      Write-Output -InputObject $exists
    }
    function QueueHostsEntry ($IP, $Names, $Comment, [Switch]$Update) {
      Write-Verbose -Message "Queuing entry: $IP,$Names,$Comment,$Update"
      $tab1 = 17
      $entry = $IP.PadRight($tab1)
      foreach ($qname in $Names) {
        $entry += " $qname"
      }
      if ($Comment) {
        $commentString = $Comment.TrimStart('# ').Insert(0, '# ')
        $entry += " $commentString" 
      }
      if ($Update) {
        $queueItem = [PSCustomObject]@{
          HostNames=$Names;
          NewLine=$entry;
        }
        $updateEntries.Add($queueItem) | Out-Null
      } else {
        $newEntries.Add($entry) | Out-Null
      }
    }
  }

  process {
    if ($InputObject) {
      foreach ($obj in $InputObject) {
        TestNewHostsIP -NewIP $obj.IPAddress.IPAddressToString
        if (TestHostNameExists -TestHostName $obj.HostNames) {
          Write-Verbose -Message "Host name exists: $($obj.HostNames)"
          QueueHostsEntry -IP $obj.IPAddress.IPAddressToString `
                          -Names $obj.HostNames `
                          -Comment $obj.Comment `
                          -Update
        } else {
          Write-Verbose -Message "Host name does not exist: $($obj.HostNames)"
          QueueHostsEntry -IP $obj.IPAddress.IPAddressToString `
                             -Names $obj.HostNames `
                             -Comment $obj.$Comment
        }
      }
    } else {
      TestNewHostsIP -NewIP $IPAddress

      if (TestHostNameExists -TestHostName $HostName) {
        Write-Verbose -Message "Host name exists: $HostName"
        QueueHostsEntry -IP $IPAddress `
                        -Names $HostName `
                        -Comment $Comment `
                        -Update
      } else {
        Write-Verbose -Message "Host name does not exist: $HostName"
        QueueHostsEntry -IP $IPAddress `
                        -Names $HostName `
                        -Comment $Comment `
        QueueNewHostsEntry -NewIp $IPAddress -NewNames $HostName -NewComment $Comment
      }
    }
  }

  end {
    Write-Verbose -Message "Getting content from hosts file."
    $lines = Get-Content -Path $hostsFilePath
    $output = New-Object -TypeName System.Collections.ArrayList
    if ($updateEntries.Count -gt 0) {
      Write-Verbose -Message "Prestaging update entries."
      foreach ($updateEntry in $updateEntries) {
        Write-Verbose -Message "Updating host entry: $($updateEntry.HostNames)"
        foreach ($line in $lines) {
          $lineMatch = $false
          foreach ($updateName in $updateEntry.HostNames) {
            if ($line -match $updateName) {
              $lineMatch = $true
            }
          }
          if ($lineMatch) {
            $output.Add($updateEntry.NewLine) | Out-Null
          } else {
            $output.Add($line) | Out-Null
          }
        }
      }
    } else {
      if ($lines) {
        $output.AddRange($lines)
      }
    }
    if ($newEntries.Count -gt 0) {
      Write-Verbose -Message "Prestaging new entries."
      $output.AddRange($newEntries)
    }
    if ($output.Count -lt 1) {
      Write-Verbose -Message "Nothing to write to the hosts file. No change."
    } else {
      Write-Verbose -Message "Writing new hosts file"
      Set-Content -Path $hostsFilePath -Value $output -Force
    }
    Write-Verbose -Message "Total updated entries: $($updateEntries.Count)"
    Write-Verbose -Message "Total new entries    : $($newEntries.Count)"
    Write-Verbose -Message "Total lines changed  : $($updateEntries.Count + $newEntries.Count)"
    Write-Verbose -Message "Total lines written  : $($output.Count)"
    Start-Process -FilePath "notepad.exe" -ArgumentList $hostsFilePath
    Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
  }


}

