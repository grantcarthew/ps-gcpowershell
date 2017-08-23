<#
.SYNOPSIS
  Adds an entry to the hosts file.
.DESCRIPTION
  Adds an entry to the bottom of the hosts file based
  on the supplied host IP address, name(s), and comment.

  If an entry that matches both the host name and
  IP address already exists, the change will be ignored.

  Type 'Get-Help Add-GCHostsFileEntry -Online' for extra information.
.PARAMETER InputObject
  A PSCustomObject with the details of the hosts file entry.
  The schema of the object will be as follows:
  
  [PSCustomObject]@{
    IPAddress=[IPAddress];
    HostNames=[String[]];
    Comment=[String];
  }

  A single PSCustomObject or an array of PSCustomObjects can be
  passed in for addition to the hosts file.
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
.PARAMETER LineComment
  Inserts a full line comment into the bottom of the hosts file.

  There is no need to supply the '#' character.
.EXAMPLE
  The following example adds a host entry to the hosts file:

  Add-GCHostsFileEntry -IPAddress 1.2.3.4 -HostName 'server1.company.com'
  #>
function Add-GCHostsFileEntry {
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
    $Comment,

    [Parameter(Mandatory=$true,
              ValueFromPipeline=$false,
              ParameterSetName='LineComment')]
    [String]
    $LineComment
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

    if ((Get-Content -Path $hostsFilePath -Raw) -notmatch "`r`n$") {
      Write-Verbose -Message "Adding CR-LF to the end of the hosts file."
      Add-Content -Path $hostsFilePath -Value '' -Encoding Ascii -Force
    }

    $hostsFileEntries = Get-GCHostsFileEntry 
    $newEntries = New-Object -TypeName System.Collections.ArrayList
    $allHostNames = New-Object -TypeName System.Collections.ArrayList
    foreach ($entry in $hostsFileEntries) {
      foreach ($n in $entry.HostNames) {
        $allHostNames.Add($n.ToUpper().Trim()) | Out-Null
      }
    }
    function TestNewHostsIP ($NewIP) {
      # The following will cause an error if the IPAddress is invalid.
      # The error will be reported to the console.
      Write-Verbose -Message "Type casting IPAddress: $NewIP"
      [IPAddress]$NewIP | Out-Null
    }
    function TestDuplicateHostName ($NewHostName) {
      Write-Verbose -Message "Testing for duplicate entry: $NewHostName" 
      $duplicate = $false
      foreach ($eachName in $NewHostName) {
        if ($eachName.ToUpper().Trim() -in $allHostNames) {
          $duplicate = $true 
          break
        }  
      }
      Write-Output -InputObject $duplicate
    }
    function QueueNewHostsEntry ($NewIp, $NewNames, $NewComment) {
      Write-Verbose -Message "Adding new entry: $NewIp,$NewNames,$NewComment"
      $tab1 = 17
      $newEntry = $NewIp.PadRight($tab1)
      foreach ($NewName in $NewNames) {
        $newEntry += " $NewName"
      }
      if ($NewComment) {
        $commentString = $NewComment.TrimStart('# ').Insert(0, '# ')
        $newEntry += " $commentString" 
      }
      $newEntries.Add($newEntry) | Out-Null
    }
  }

  process {
    if ($LineComment) {
      Write-Verbose -Message "Inserting line comment."
      $commentString = $LineComment.TrimStart('#').Insert(0, '# ')
      $newEntries.Add($commentString) | Out-Null
    } elseif ($InputObject) {
      foreach ($obj in $InputObject) {
        TestNewHostsIP -NewIP $obj.IPAddress.IPAddressToString
        $obj
        if (TestDuplicateHostName -NewHostName $obj.HostNames) {
          Write-Warning -Message "Host name already exists: $($obj.HostNames)"
        } else {
          QueueNewHostsEntry -NewIp $obj.IPAddress.IPAddressToString `
                             -NewNames $obj.HostNames `
                             -NewComment $obj.$Comment
        }
      }
    } else {
      TestNewHostsIP -NewIP $IPAddress

      if (TestDuplicateHostName -NewHostName $HostName) {
        Write-Warning -Message "Host name already exists: $HostName"
      } else {
        QueueNewHostsEntry -NewIp $IPAddress -NewNames $HostName -NewComment $Comment
      }
    }
  }

  end {
    if ($newEntries.Count -gt 0) {
      Add-Content -Path $hostsFilePath -Value $newEntries -Encoding Ascii -Force
    } else {
      Write-Warning -Message 'No host entries to add.'
    }
    Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
  }


}
