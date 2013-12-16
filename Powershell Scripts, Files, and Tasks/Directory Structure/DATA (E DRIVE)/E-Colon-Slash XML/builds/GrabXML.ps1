$User='sa'
$Password=''
$Server=''
$Database=''
$Security='False'
$SP1='USP_CREATE_JOB_DATA'




foreach ($url in get-content E:\XML\Builds\workload.txt) {invoke-webrequest -uri $url -outfile E:\XML\Builds\BuildData.xml

Write-Host "Processing Build Data..." -ForegroundColor Yellow
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
Write-Host "Done." -NoNewline -ForegroundColor Green
 
#Set the connection string
$SqlConnection.ConnectionString = "UID=$User;PWD=$Password;Server=$Server;Database=$Database;Integrated Security=$Security"
 
#Declare a SqlCommand object
$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
 
try
{
    #Set SqlCommand properties
    $SqlCommand.CommandText = "$SP1"
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
    Write-Host "Error executing the stored procedure" -ForegroundColor Red
}
finally
{
    #Close connection always
    $SqlConnection.Close()
}
}


