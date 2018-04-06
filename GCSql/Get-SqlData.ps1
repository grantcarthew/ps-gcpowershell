<#
.Synopsis
   Retrieves data from the Gears SQL Server.

.DESCRIPTION
   Connects to the SQL Server and runs the supplied query
   against the supplied Database name.

.PARAMETER DatabaseName
   The name of the Database to run the query against.

.PARAMETER Query
   The SQL Query to run against the Database.

.EXAMPLE
   $query = "SELECT * FROM IPSiteMap"
   Get-SqlData -DatabaseName Location -Query $query
#>

[CmdletBinding()]
[OutputType('System.Data.DataSet')]
param (
    [String]$DatabaseName,
    [string]$Query
)

$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
$connection.ConnectionString = Get-SqlConnectionString -DatabaseName $DatabaseName
$command = $connection.CreateCommand()
$command.CommandText = $query
$adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter $command
$dataset = New-Object -TypeName System.Data.DataSet
$rows = $adapter.Fill($dataset)
$dataset.Tables[0]