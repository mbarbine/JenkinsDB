SUMMARY: 
These files must be stored on E:\XML\Builds\*




CHANGES: 

GrabXML.ps1 now accepts parameters instead of hardcoded values.

Required parameters:
  -Server    : SQL Server hostname or instance name
  -Database  : Target database name (e.g. Jenkins)
  -User      : SQL login with write access
  -Password  : Password for the SQL login (SecureString)

Optional parameters:
  -WorkloadPath  : Path to workload.txt (default: E:\XML\Builds\workload.txt)
  -BuildDataPath : Path to BuildData.xml output (default: E:\XML\Builds\BuildData.xml)
  -SP1           : Stored procedure name (default: USP_CREATE_JOB_DATA)

Example usage:
  $pwd = Read-Host -AsSecureString -Prompt "SQL Password"
  .\GrabXML.ps1 -Server "localhost" -Database "Jenkins" -User "sa" -Password $pwd
