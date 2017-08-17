<#
.SYNOPSIS
  Adds an entry to the hosts file.
.DESCRIPTION
  Adds an entry to the bottom of the hosts file based
  on the supplied host IP address, name(s), and comment.

  If an entry that matches both the host name and
  IP address already exists, the change will be ignored.

  Note: This cmdlet does not support piping. Use 'foreach' to
  apply multiple changes to the hosts file.

  Type 'Get-Help Add-GCHostsFileEntry -Online' for extra information.
.PARAMETER HostName
  The name of the host to assign the IP address to.
  This can be a fully qualified name such as server1.domain.com, or a flat name.
  An array of names is supported.
.PARAMETER IPAddress
  The IP address to assign to the host name.
  This can be an IPv4 or IPv6 address.
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

  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  $tab1 = 17
  Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

  if (-not (Test-GCFileWrite -Path $hostsFilePath)) {
    Write-Error -Message "Can not write to the hosts file. Check it exists and you have write permissions."
    Exit
  }

  if ((Get-Content -Path $hostsFilePath -Raw) -notmatch "`r`n$") {
    Write-Verbose -Message "Adding CR-LF to the end of the hosts file."
    Add-Content -Path $hostsFilePath -Value '' -Encoding Ascii -Force
  }

  if ($LineComment) {
    Write-Verbose -Message "Inserting line comment."
    $commentString = $LineComment.TrimStart('#').Insert(0, '# ')
    Add-Content -Path $hostsFilePath -Value $commentString
  } else {
    # The following will cause an error if the IPAddress is invalid.
    Write-Verbose -Message "Type casting IPAddress."
    [IPAddress]$IPAddress | Out-Null

    Write-Verbose -Message "Testing for duplicate entry"
    $hostsFileEntries = Get-GCHostsFileEntry -HostName $HostName
    $addEntry = $false
    foreach ($entry in $hostsFileEntries) {
        if ($entry.IPAddress.IPAddressToString -eq $IPAddress.Trim()) {
          for ($i = 0; $i -lt $HostName.length; $i++) {
            if ($HostName[$i] -ne $entry.HostName[$i]) {
              Write-Verbose -Message "New entry detected: $IPAddress"
              $addEntry = $true
            }
          }
        }
    } 

    if ($addEntry) {
      Write-Verbose -Message "Adding new entry: $IPAddress"
      $newEntry = $IPAddress.PadRight($tab1)
      foreach ($name in $HostName) {
        $newEntry += " $name"
      }
      if ($Comment) {
        $commentString = $Comment.TrimStart('# ').Insert(0, '# ')
        $newEntry += " $commentString" 
      }
      Add-Content -Path $hostsFilePath -Value $newEntry -Encoding Ascii -Force
    }
  }

}
