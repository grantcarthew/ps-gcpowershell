<#
.SYNOPSIS
  Tests that the hosts file exists and is formatted correctly.
.DESCRIPTION
  This test cmdlet performs two tasks:
  - Tests that the hosts file exists.
  - Checks the format of the hosts file.

  If both of these checks pass then True is returned.
  If either of these checks fail then False is returned.

  The format checks are performed using the following
  regular expression:
  '^$|^\s*$|^(\s*#.*)$|^((\s*[\d.:a-fA-F]+\s+[\w.]+\s*[\w.]*\s*)(#+.*)*)$'

  For a detailed report in the console use -Verbose.

  Type 'Get-Help Test-GCHostsFile -Online' for extra information.
.EXAMPLE
  This example returns True if the hosts file is in good condition.

  Test-GCHostsFile
#>
function Test-GCHostsFile {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([Boolean])]
  Param ()
  
  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath 'System32\drivers\etc\hosts'
  $hostsFileExists = $false
  $hostsFileOk = $true
  $regexString = '^$|^\s*$|^(\s*#.*)$|^((\s*[\d.:a-fA-F]+\s+[\w.]+\s*[\w.]*\s*)(#+.*)*)$'

  Write-Verbose -Message 'Checking Hosts file exists.'

  if (Test-Path -Path $hostsFilePath) {
    $hostsFileExists = $true
  } else {
    Write-Host -Object "Hosts file is missing." -ForegroundColor Red
  }

  Write-Verbose -Message 'Reading Hosts file for inspection.'

  $hostsFileContent = Get-Content -Path $hostsFilePath
  foreach ($line in $hostsFileContent) {
    Write-Verbose -Message "Inspecting Line: $line"

    if ($line -notmatch $regexString) {
      Write-Verbose -Message "Invalid line in Hosts file: $line"
      $hostsFileOk = $false
    }
  }

  if (-not $hostsFileOk) {
    Write-Host -Object "Hosts file format is invalid." -ForegroundColor Red
  }
  Write-Verbose -Message "Hosts file exists: $hostsFileExists"
  Write-Verbose -Message "Hosts file formatted correctly: $hostsFileOk"

  $result = $hostsFileExists -and $hostsFileOk
  Write-Output -InputObject $result
}
