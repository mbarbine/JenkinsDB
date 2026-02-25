param(
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$true)][string]$Database,
    [Parameter(Mandatory=$true)][string]$User,
    [Parameter(Mandatory=$true)][SecureString]$Password,
    [string]$WorkloadPath = 'E:\XML\Builds\workload.txt',
    [string]$WorkloadSP = '',
    [string]$BuildDataPath = 'E:\XML\Builds\BuildData.xml',
    [string]$SP1 = 'USP_CREATE_JOB_DATA',
    [string]$JenkinsUser,
    [string]$JenkinsToken
)

#Convert SecureString password to plain text for the connection string
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
)

$connectionString = "Server=$Server;Database=$Database;User ID=$User;Password=$plainPassword;Integrated Security=False"

#Resolve workload URLs from the database stored procedure or a flat file
if ($WorkloadSP) {
    $workloadUrls = [System.Collections.Generic.List[string]]::new()
    $workloadConnection = New-Object System.Data.SqlClient.SqlConnection
    $workloadConnection.ConnectionString = $connectionString
    $workloadCommand = New-Object System.Data.SqlClient.SqlCommand
    $workloadCommand.CommandText = $WorkloadSP
    $workloadCommand.CommandType = [System.Data.CommandType]::StoredProcedure
    $workloadCommand.Connection = $workloadConnection
    try {
        $workloadConnection.Open()
        $reader = $workloadCommand.ExecuteReader()
        while ($reader.Read()) { $workloadUrls.Add($reader.GetString(0)) }
        $reader.Close()
        Write-Host "Loaded $($workloadUrls.Count) URL(s) from stored procedure '$WorkloadSP'." -ForegroundColor Green
    }
    catch {
        Write-Host "Error loading workload from stored procedure '$WorkloadSP': $_" -ForegroundColor Red
    }
    finally {
        $workloadConnection.Close()
    }
} else {
    $workloadUrls = Get-Content $WorkloadPath
}

foreach ($url in $workloadUrls) {
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

    #Set the connection string
    $SqlConnection.ConnectionString = $connectionString

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
