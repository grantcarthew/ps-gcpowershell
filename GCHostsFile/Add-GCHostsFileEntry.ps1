<#
.SYNOPSIS
  Adds an entry to the hosts file.
.DESCRIPTION
  Adds an entry to the bottom of the hosts file based
  on the supplied host name, IP address, and comment.

  If an entry that matches both the host name and
  IP address already exists, the change will be ignored.

  Type 'Get-Help Add-GCHostsFileEntry -Online' for extra information.
.PARAMETER HostName
  The name of the host to assign the IP address.
  This can be a fully qualified name such as server1.domain.com, or a flat name.
.PARAMETER IPAddress
  The IP address to assign to the host name.
  This can be an IPv4 or IPv6 address.
.PARAMETER Comment
  The Comment parameter can be used on its own to add
  a line comment to the Hosts file, or with a value assigned
  to the HostName and IPAddress parameters.

  There is no need to supply the '#' character.
.EXAMPLE
  The following example adds a host entry to the hosts file:

  Add-GCHostsFileEntry -HostName 'server1.company.com' -IPAddress 1.2.3.4
  #>
# function Add-GCHostsFileEntry {
[CmdletBinding(DefaultParameterSetName='HostEntry',
               HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
[OutputType([String])]
Param (
  [Parameter(Mandatory=$true,
             Position=0,
             ValueFromPipeline=$true,
             ValueFromPipelineByPropertyName=$true,
             ParameterSetName='HostEntry')]
  [String]
  $HostName,

  [Parameter(Mandatory=$true,
             Position=1,
             ValueFromPipeline=$true,
             ValueFromPipelineByPropertyName=$true,
             ParameterSetName='HostEntry')]
  [String]
  $IPAddress,

  [Parameter(Mandatory=$false,
             Position=2,
             ValueFromPipeline=$true,
             ValueFromPipelineByPropertyName=$true,
             ParameterSetName='HostEntry')]
  [String]
  $Comment,

  [Parameter(Mandatory=$true,
             ValueFromPipeline=$true,
             ValueFromPipelineByPropertyName=$true,
             ParameterSetName='LineComment')]
  [String]
  $LineComment
)

begin {
  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  $tab1 = 17
  $tab2 = 25
}

process {
  if ($LineComment) {
    $commentString = $LineComment.TrimStart('#').Insert(0, '# ')
    Add-Content -Path $hostsFilePath -Value $commentString
  } else {
    # The following will cause an error if the IPAddress is invalid.
    [IPAddress]$IPAddress | Out-Null

    $hostsFileEntries = Get-GCHostsFileEntry -HostName $HostName
    $addEntry = $true
    if ($hostsFileEntries) {
      foreach ($entry in $hostsFileEntries) {
          if ($entry.IPAddress.IPAddressToString -eq $IPAddress.Trim()) {
              $addEntry = $false
          }
      } 
    }

    if ($addEntry) {
      $newEntry = "{0} {1}" -f $IPAddress.PadRight($tab1),$HostName.PadRight($tab2)
      if ($Comment) {
        $commentString = $Comment.TrimStart('#').Insert(0, '# ')
        $newEntry += " {0}" -f $commentString 
      }
      Add-Content -Path $hostsFilePath -Value $newEntry     
    }
  }
}

end {

}
#}
