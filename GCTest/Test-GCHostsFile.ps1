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

  Type 'Get-Help Test-GCHostsFile -Online' for extra information.
.EXAMPLE
  This example returns True if the hosts file is in good condition.

  Test-GCHostsFile
#>
function Test-GCHostsFile {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [Alias()]
  [OutputType([Boolean])]
  Param ()
  
  $hostsFilePath = Join-Path -Path $env:SystemRoot -ChildPath 'System32\drivers\etc\hosts'
  $hostsFileExists = $false
  $hostsFileOk = $true
  $regexString = '^$|^\s*$|^(\s*#.*)$|^((\s*[\d.:a-fA-F]+\s+[\w.]+\s*[\w.]*\s*)(#+.*)*)$'

  if (Test-Path -Path $hostsFilePath) {
    $hostsFileExists = $true
  }

  $hostsFileContent = Get-Content -Path $hostsFilePath
  foreach ($line in $hostsFileContent) {
    if ($line -notmatch $regexString) {
      $hostsFileOk = $false
    }
  }
  return $hostsFileExists -and $hostsFileOk
}
Test-GCHostsFile
