<#
.Synopsis
   Executes a non-query against the Gears SQL Server.

.DESCRIPTION
   Connects to the SQL Server and runs the supplied query
   against the supplied Database name.

.PARAMETER DatabaseName
   The name of the Database to run the query against.

.PARAMETER Query
   The SQL Query to run against the Database.

.EXAMPLE
   $query = "INSERT INTO [ClassroomInventory].[dbo].[Computer] ('SerialNumber') VALUES ('123abc')"
   Set-SqlData -DatabaseName Location -Query $query
#>
[CmdletBinding()]
PARAM
(
    [Parameter(Mandatory)]
    [String]$DatabaseName,

    [Parameter(Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName)]
    [string]$Query
)

BEGIN
{
    $connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = Get-SqlConnectionString -DatabaseName $DatabaseName
    $command = $connection.CreateCommand()
    $connection.Open()
}

PROCESS
{
    $command.CommandText = $Query
    $command.ExecuteNonQuery()
}

END
{
    $connection.close()
}