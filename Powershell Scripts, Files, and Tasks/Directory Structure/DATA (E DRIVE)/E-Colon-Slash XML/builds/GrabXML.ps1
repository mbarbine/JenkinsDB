param(
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$true)][string]$Database,
    [Parameter(Mandatory=$true)][string]$User,
    [Parameter(Mandatory=$true)][string]$Password,
    [string]$WorkloadPath = 'E:\XML\Builds\workload.txt',
    [string]$BuildDataPath = 'E:\XML\Builds\BuildData.xml',
    [string]$SP1 = 'USP_CREATE_JOB_DATA'
)

foreach ($url in Get-Content $WorkloadPath) {
    Invoke-WebRequest -Uri $url -OutFile $BuildDataPath

Write-Host "Processing Build Data..." -ForegroundColor Yellow
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
Write-Host "Done." -NoNewline -ForegroundColor Green
 
#Set the connection string
$SqlConnection.ConnectionString = "Server=$Server;Database=$Database;User ID=$User;Password=$Password;Integrated Security=False"
 
#Declare a SqlCommand object
$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
 
try
{
    #Set SqlCommand properties
    $SqlCommand.CommandText = $SP1
    $SqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure
    $SqlCommand.Connection = $SqlConnection
 
    #Open SqlConnection
    $SqlConnection.Open()
 
    Write-Host "SqlConnection opened successfully." -ForegroundColor Green
 
    #Execute stored procedures
    $SqlCommand.ExecuteNonQuery()
 
    Write-Host "Stored procedure executed successfully." -ForegroundColor Green
}
catch
{
    Write-Host "Error executing the stored procedure: $_" -ForegroundColor Red
}
finally
{
    #Close connection always
    $SqlConnection.Close()
}
}
