param(
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$true)][string]$Database,
    [Parameter(Mandatory=$true)][string]$User,
    [Parameter(Mandatory=$true)][SecureString]$Password,
    [string]$WorkloadPath = 'E:\XML\Builds\workload.txt',
    [string]$BuildDataPath = 'E:\XML\Builds\BuildData.xml',
    [string]$SP1 = 'USP_CREATE_JOB_DATA',
    [string]$JenkinsUser,
    [string]$JenkinsToken
)

foreach ($url in Get-Content $WorkloadPath) {
    Write-Host "Fetching build data from: $url" -ForegroundColor Yellow

    $iwrParams = @{
        Uri             = $url
        OutFile         = $BuildDataPath
        UseBasicParsing = $true
    }

    #Add Basic authentication header when Jenkins credentials are supplied (Jenkins 2.x+)
    if ($JenkinsUser -and $JenkinsToken) {
        $pair = "${JenkinsUser}:${JenkinsToken}"
        $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
        $iwrParams['Headers'] = @{ Authorization = "Basic $encodedCreds" }
    }

    try {
        Invoke-WebRequest @iwrParams
    }
    catch {
        Write-Host "Error fetching build data from ${url}: $_" -ForegroundColor Red
        continue
    }

    Write-Host "Processing Build Data..." -ForegroundColor Yellow
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    Write-Host "Done." -NoNewline -ForegroundColor Green

    #Convert SecureString password to plain text for the connection string
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    )

    #Set the connection string
    $SqlConnection.ConnectionString = "Server=$Server;Database=$Database;User ID=$User;Password=$plainPassword;Integrated Security=False"

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
