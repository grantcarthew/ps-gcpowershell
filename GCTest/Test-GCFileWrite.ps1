<#
.SYNOPSIS
  Test for both file existance and write permissions.
.DESCRIPTION
  Tries to open the specified file with 'Write' access.
  Returns True if writing to the file will be successful.
  Returns False if the file does not exist or the user does
  not have write access to the file.

  Note: This Test cmdlet does not write to the file being tested.

  For a detailed report in the console use -Verbose.

  Type 'Get-Help Test-GCFileWrite -Online' for extra information.
.PARAMETER Path
  The path to the file under test.

  If an array of files is passed into the Path parameter, each
  file will be tested. A successful result will only occur if every
  file exists and the user has write access to every file.
.EXAMPLE
  This example returns True if the specified file exists
  and is writable:

  Test-GCFileWrite -Path 'D:\FileUnderTest.txt'
.EXAMPLE
  This example returns True if the files in the current path
  exists and they are writable:

  Get-ChildItem | Select -ExpandProperty FullName | Test-GCFileWrite
#>
function Test-GCFileWrite {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/ps-gcpowershell')]
  [OutputType([Boolean])]
  Param (
    [Parameter(Mandatory=$true,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)]
    [String[]]
    $Path
  )
  
  begin {
    $result = $true
  }

  process {
    foreach ($file in $Path) {
      Write-Verbose -Message "Checking file exists: $file"
      if (-not (Test-Path -Path $file)) {
        Write-Verbose -Message "File does not exist: $file"
        $result = $false
      }

      Write-Verbose -Message 'Testing open with write permissions.'
      Try {
        [IO.File]::OpenWrite($file).close()
        Write-Verbose -Message "Write success: $file"
      }
      Catch {
        Write-Verbose -Message "Write access denied: $file"
        $result = $false
      }
    }
  }

  end {
      Write-Output -InputObject $result
  }
}
