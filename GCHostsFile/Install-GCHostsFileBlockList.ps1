<#
.SYNOPSIS
  Downloads a hosts file block list replacing or appending
  it to the current hosts file. 
.DESCRIPTION
  This cmdlet will download a hosts file block list from github
  and replace or append the block list to the end of the
  current hosts file.

  The source of the block list is maintained by a Steven Black:
  https://github.com/StevenBlack

  The repository for the block list is located here:
  https://github.com/StevenBlack/hosts

  Type 'Get-Help Install-GCHostsFileBlockList -Online' for extra information.
.PARAMETER Extension
  Customizes the default Adware/Malware block list adding extra
  unwanted domains.
.PARAMETER Append
  Adds the block list host entries to the end of the
  existing hosts file.
.EXAMPLE
  The following example installs the default Adware/Malware block list
  with the addition of the FakeNews extension:

  Install-GCHostFileBlockList -Extensions FakeNews
#>
function Install-GCHostsFileBlockList {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([Int])]
  Param (
    [Parameter(Mandatory=$false,
               Position=0,
               ValueFromPipeline=$false)]
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
    $Extension,

    [Parameter(Mandatory=$false)]
    [Switch]
    $Append
  )
  
  Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"
  Import-Module -Name GCTest

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
  Write-Verbose -Message "Download URL set to: $url"

  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath '\System32\drivers\etc\hosts'
  Write-Verbose -Message "Hosts file path set to: $hostsFilePath"

  if (-not (Test-GCFileWrite -Path $hostsFilePath)) {
    Write-Error -Message "Can't write to the hosts file. Check it exists and you have write permissions."
    Exit
  }

  $tempFileName = Get-Date -Format 'yyyy-MM-dd-hh-mm-ss-ffff'
  $tempFilePath = Join-Path -Path $env:TEMP -ChildPath $tempFileName 
  Write-Verbose -Message "Temp file path set to: $tempFilePath"

  # The use of the temp file is to insert CR-LF.
  try {
    Write-Verbose -Message "Downloading block list"
    Invoke-WebRequest -Uri $url -ContentType 'text/plain' -UseBasicParsing -OutFile $tempFilePath
    $blockList = Get-Content -Path $tempFilePath -Force
    if ($Append) {
      if ((Get-Content -Path $hostsFilePath -Raw) -notmatch "`r`n$") {
        Write-Verbose -Message "Adding CR-LF to the end of the hosts file."
        Add-Content -Path $hostsFilePath -Value '' -Encoding Ascii -Force
      }
      Write-Verbose -Message "Appending block list to the end of the hosts file."
      Out-File -FilePath $hostsFilePath -InputObject $blockList -Encoding Ascii -Append -Force
    } else {
      Write-Verbose -Message "Replacing hosts file with the block list."
      Out-File -FilePath $hostsFilePath -InputObject $blockList -Encoding Ascii -Force
    }

    Remove-Item -Path $tempFilePath -Force -ErrorAction SilentlyContinue
    Write-Verbose -Message "Total block list hosts entries added: $($blockList.Length)"
  } catch {
    Write-Error -Exception $Error[0].Exception
  }

  Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
}
