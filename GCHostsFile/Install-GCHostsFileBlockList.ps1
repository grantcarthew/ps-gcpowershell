<#
.SYNOPSIS
  Downloads a hosts file block list replacing the current hosts file. 
.DESCRIPTION
  This cmdlet will download a hosts file block list from github
  and replace the current hosts file.

  The source of the block list is maintained by a Steven Black:
  https://github.com/StevenBlack

  The repository for the block list is located here:
  https://github.com/StevenBlack/hosts

  Type 'Get-Help Install-GCHostsFileBlockList -Online' for extra information.
.PARAMETER Extension
  Customizes the default Adware/Malware block list adding extra
  unwanted domains.
.EXAMPLE
  The following example installs the default Adware/Malware block list
  with the addition of the fakenews extension:

  Install-GCHostFileBlockList -Extensions fakenews
#>
function Install-GCHostsFileBlockList {
  [CmdletBinding(DefaultParameterSetName='ByExtension',
                 HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([PSCustomObject[]])]
  Param (
    [Parameter(Mandatory=$false,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               ParameterSetName='ByExtension')]
    [ValidateSet('FakeNews',
                 'Gambling',
                 'Porn',
                 'Social',
                 'FakeNews+Gambling',
                 'FakeNews+Porn',
                 'FakeNews+Social',
                 'Gambling+Porn',
                 'Gambling+Social',
                 'Porn+Social',
                 'FakeNews+Gambling+Porn',
                 'FakeNews+Gambling+Social',
                 'FakeNews+Porn+Social',
                 'Gambling+Porn+Social',
                 'FakeNews+Gambling+Porn+Social')]
    [String]
    $Extension
  )
  
  begin {
    Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"
    $urlRoot = 'https://raw.githubusercontent.com/StevenBlack/hosts/master'
   switch ($Extension) {
     'FakeNews'          { $url = $urlRoot + '/alternates/fakenews/hosts'  }
     'Gambling'          { $url = $urlRoot + '/alternates/gambling/hosts'  }
     'Porn'              { $url = $urlRoot + '/alternates/porn/hosts'  }
     'Social'            { $url = $urlRoot + '/alternates/social/hosts'  }
     'FakeNews+Gambling' { $url = $urlRoot + '/alternates/fakenews-gambling/hosts'  }
     'FakeNews+Porn'     { $url = $urlRoot + '/alternates/fakenews-porn/hosts'  }
     'FakeNews+Social'   { $url = $urlRoot + '/alternates/fakenews-social/hosts'  }
     'Gambling+Porn'     { $url = $urlRoot + '/alternates/gambling-porn/hosts'  }
     'Gambling+Social'   { $url = $urlRoot + '/alternates/gambling-social/hosts'  }
     'Porn+Social'       { $url = $urlRoot + '/alternates/porn-social/hosts'  }
     'FakeNews+Gambling+Porn'        { $url = $urlRoot + '/alternates/fakenews-gambling-porn/hosts'  }
     'FakeNews+Gambling+Social'      { $url = $urlRoot + '/alternates/fakenews-gambling-social/hosts'  }
     'FakeNews+Porn+Social'          { $url = $urlRoot + '/alternates/fakenews-porn-social/hosts'  }
     'Gambling+Porn+Social'          { $url = $urlRoot + '/alternates/gambling-porn-social/hosts'  }
     'FakeNews+Gambling+Porn+Social' { $url = $urlRoot + '/alternates/fakenews-gambling-porn-social/hosts'  }
     Default { $url = $urlRoot + '/hosts' }
   } 

    $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
    Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

    Write-Verbose -Message "Getting content from hosts file."
    $lines = Get-Content -Path $hostsFilePath
    $entries = New-Object -TypeName System.Collections.ArrayList
    $lineElements = New-Object -TypeName System.Collections.ArrayList
  }
  
  process {
    $blockList = Invoke-WebRequest -Uri $url -UseBasicParsing
    $blockList.content.length
  }
  
  end {
    Write-Verbose -Message "Total hosts entries: $($entries.Count)"
    Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
  }
}
