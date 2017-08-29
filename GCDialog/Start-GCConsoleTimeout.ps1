<# 
.SYNOPSIS
  Displays a progress bar and remaining time in the console.
.DESCRIPTION
  Using this function makes it easy to display a timeout
  visually to the user.

  If the timeout completes True is returned.
  If CancelWithEsc is enabled and the user hits the Escape
  key then False is returned.
.PARAMETER Seconds
  The number of seconds to delay processing before continuing.
.PARAMETER Activity
  A short message or title to display on the progress bar.
.PARAMETER Status
  A sub title conveying the status of your processing.
.PARAMETER CancelWithEsc
  Enables the abillity to cancel the timeout process with the
  press of the Escape key.
.PARAMETER Shrink
  Add this parameter to indicate the progress bar should
  shrink as time passes rather than the default which is
  to grow.
.PARAMETER RefreshPeriod
  The time between updating the progress bar in milliseconds.
  The default value is 100ms.
#>
function Start-GCConsoleTimeout {
  [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
  [OutputType([Boolean])]
  Param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [Int]
    $Seconds,

    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [String]
    $Activity,

    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [String]
    $Status,

    [Parameter(Mandatory=$false)]
    [Switch]
    $CancelWithEsc,

    [Parameter(Mandatory=$false)]
    [Switch]
    $Shrink,

    [Parameter(Mandatory=$false)]
    [Int]
    $RefreshPeriod = 100
  )
  Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"

  $stopwatch = New-Object System.Diagnostics.Stopwatch
  $timeout = [TimeSpan]::FromMilliseconds($Seconds * 1000)

  Write-Verbose -Message "Starting the stopwatch."
  $stopwatch.Start()

  Write-Verbose -Message "Starting to loop with $timeout"
  $timedOut = $true
  while ($stopwatch.Elapsed -lt $timeout) {
    if ([Console]::KeyAvailable -and $CancelWithEsc) {
        $keyPress = [System.Console]::ReadKey($true) 
        if ($keyPress.key -eq 'escape') {
          Write-Verbose -Message "Escape key pressed."
          $timedOut = $false
          break
        }
    } 
    $percent = ($stopwatch.ElapsedMilliseconds / $timeout.TotalMilliseconds) * 100
    if ($Shrink) {
      $percent = 100 - $percent
    }
    Write-Verbose -Message "Percent remaining: $percent"

    $snapshot = $timeout - $stopwatch.Elapsed
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $percent -SecondsRemaining $snapshot.TotalSeconds
    
    Start-Sleep -Milliseconds $RefreshPeriod
  }

  Write-Output -InputObject $timedOut
  Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
}