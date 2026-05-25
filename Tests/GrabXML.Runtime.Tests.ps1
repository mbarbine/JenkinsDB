#Requires -Module Pester

<#
.SYNOPSIS
    Runtime behavior tests for GrabXML.ps1 using mock data.

.DESCRIPTION
    Exercises the script end-to-end with mocked web requests, SQL connections, and
    SQL commands so no real Jenkins server or SQL Server is required.  Each context
    covers a distinct behavioral area: flat-file workloads, error handling, the
    stored-procedure workload path, and connection-string construction.

    Scoping note: mock scriptblocks in Pester 5 run as closures that capture local
    variables from the BeforeEach scope.  State variables are therefore kept as plain
    local variables (no $script: prefix) so they are reliably captured by the mock.
    BeforeAll values (ScriptPath, TempDir, etc.) continue to use $script: as they
    must survive across multiple BeforeEach invocations.
#>

Describe 'GrabXML.ps1 – runtime behavior with mock data' {

    BeforeAll {
        $script:ScriptPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' `
            'Powershell Scripts, Files, and Tasks' `
            'Directory Structure' `
            'DATA (E DRIVE)' `
            'E-Colon-Slash XML' `
            'builds' `
            'GrabXML.ps1'))

        $tmpName              = 'JenkinsDB_' + [System.Guid]::NewGuid().ToString('N')
        $script:TempDir       = New-Item -ItemType Directory -Path (Join-Path ([System.IO.Path]::GetTempPath()) $tmpName)
        $script:WorkloadFile  = Join-Path $script:TempDir 'workload.txt'
        $script:BuildDataFile = Join-Path $script:TempDir 'BuildData.xml'
        $script:SecurePass    = ConvertTo-SecureString 'MockPassword' -AsPlainText -Force

        # Derive the plain-text password the same way the script does (PtrToStringAuto), so
        # assertions are platform-independent (PtrToStringAuto behaves differently on Linux).
        $bstr             = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($script:SecurePass)
        $script:PlainPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

        # Parameters shared by most tests; callers may override WorkloadPath / SP1 / etc.
        $script:BaseParams = @{
            Server        = 'MockServer'
            Database      = 'MockDB'
            User          = 'mockuser'
            Password      = $script:SecurePass
            BuildDataPath = $script:BuildDataFile
        }
    }

    AfterAll {
        Remove-Item $script:TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    # -------------------------------------------------------------------------
    Context 'Workload from flat file – success path' {

        BeforeEach {
            Set-Content -Path $script:WorkloadFile -Value @(
                'http://mock-jenkins/job/Alpha/10/api/xml',
                'http://mock-jenkins/job/Beta/20/api/xml'
            )

            # iwrState is a plain local variable captured by the Invoke-WebRequest mock closure
            $iwrState = @{ calls = [System.Collections.Generic.List[hashtable]]::new() }

            # SQL state tracked via $this._s inside ScriptMethods
            $state    = @{ execCount = 0; closedCount = 0; lastCmdText = '' }

            $mockConn = [PSCustomObject]@{ ConnectionString = ''; _s = $state }
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Open  -Value { }
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Close -Value { $this._s.closedCount++ }

            $mockCmd = [PSCustomObject]@{ CommandText = ''; CommandType = $null; Connection = $null; _s = $state }
            Add-Member -InputObject $mockCmd -MemberType ScriptMethod -Name ExecuteNonQuery -Value {
                $this._s.execCount++
                $this._s.lastCmdText = $this.CommandText
                return 1
            }

            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' } { $mockConn }
            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand'    } { $mockCmd  }

            Mock Invoke-WebRequest {
                param($Uri, $OutFile, $UseBasicParsing, $Headers)
                $iwrState.calls.Add(@{ Uri = $Uri; OutFile = $OutFile; Headers = $Headers })
                Set-Content -Path $OutFile -Value '<freeStyleBuild/>'
            }
        }

        It 'calls Invoke-WebRequest once per URL in the workload file' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $iwrState.calls.Count | Should -Be 2
        }

        It 'passes the correct URL to each Invoke-WebRequest call' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $iwrState.calls[0].Uri.ToString() | Should -Be 'http://mock-jenkins/job/Alpha/10/api/xml'
            $iwrState.calls[1].Uri.ToString() | Should -Be 'http://mock-jenkins/job/Beta/20/api/xml'
        }

        It 'saves the web response to BuildDataPath' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $iwrState.calls[0].OutFile | Should -Be $script:BuildDataFile
        }

        It 'calls the stored procedure once per URL' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $state.execCount | Should -Be 2
        }

        It 'closes the SQL connection once per URL' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $state.closedCount | Should -Be 2
        }

        It 'uses USP_CREATE_JOB_DATA as the default stored procedure name' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $state.lastCmdText | Should -Be 'USP_CREATE_JOB_DATA'
        }

        It 'uses a custom stored procedure name when -SP1 is overridden' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile -SP1 'MY_CUSTOM_SP'
            $state.lastCmdText | Should -Be 'MY_CUSTOM_SP'
        }

        It 'does not send an Authorization header when JenkinsUser is not provided' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $iwrState.calls[0].Headers | Should -BeNullOrEmpty
        }

        It 'sends a Basic Authorization header when JenkinsUser and JenkinsToken are provided' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile `
                -JenkinsUser 'ci_user' -JenkinsToken 'abc123token'
            $expected = 'Basic ' + [System.Convert]::ToBase64String(
                [System.Text.Encoding]::ASCII.GetBytes('ci_user:abc123token'))
            $iwrState.calls[0].Headers['Authorization'] | Should -Be $expected
        }

        It 'sends the same Authorization header for every URL in the workload file' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile `
                -JenkinsUser 'ci_user' -JenkinsToken 'abc123token'
            $iwrState.calls[0].Headers['Authorization'] |
                Should -Be $iwrState.calls[1].Headers['Authorization']
        }
    }

    # -------------------------------------------------------------------------
    Context 'Web request error handling' {

        BeforeEach {
            Set-Content -Path $script:WorkloadFile -Value @(
                'http://mock-jenkins/job/Broken/1/api/xml',
                'http://mock-jenkins/job/Working/2/api/xml'
            )

            $iwrCount = @{ n = 0 }
            $sqlState = @{ execCount = 0 }

            $mockConn = [PSCustomObject]@{ ConnectionString = '' }
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Open  -Value {}
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Close -Value {}

            $mockCmd = [PSCustomObject]@{ CommandText = ''; CommandType = $null; Connection = $null; _s = $sqlState }
            Add-Member -InputObject $mockCmd -MemberType ScriptMethod -Name ExecuteNonQuery -Value {
                $this._s.execCount++
                return 1
            }

            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' } { $mockConn }
            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand'    } { $mockCmd  }

            Mock Invoke-WebRequest {
                param($Uri, $OutFile)
                $iwrCount.n++
                if ($Uri -match 'Broken') { throw 'Simulated network error' }
                Set-Content -Path $OutFile -Value '<freeStyleBuild/>'
            }
        }

        It 'attempts Invoke-WebRequest for every URL even after a failure' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $iwrCount.n | Should -Be 2
        }

        It 'runs the stored procedure only for URLs whose web request succeeded' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $sqlState.execCount | Should -Be 1
        }
    }

    # -------------------------------------------------------------------------
    Context 'SQL execution error handling' {

        BeforeEach {
            Set-Content -Path $script:WorkloadFile -Value 'http://mock-jenkins/job/AnyJob/5/api/xml'

            $closeCount = @{ n = 0 }

            $mockConn = [PSCustomObject]@{ ConnectionString = ''; _c = $closeCount }
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Open  -Value {}
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Close -Value { $this._c.n++ }

            $mockCmd = [PSCustomObject]@{ CommandText = ''; CommandType = $null; Connection = $null }
            Add-Member -InputObject $mockCmd -MemberType ScriptMethod -Name ExecuteNonQuery -Value {
                throw 'Simulated SQL error'
            }

            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' } { $mockConn }
            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand'    } { $mockCmd  }

            Mock Invoke-WebRequest {
                param($OutFile)
                Set-Content -Path $OutFile -Value '<freeStyleBuild/>'
            }
        }

        It 'closes the SQL connection even when the stored procedure throws' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $closeCount.n | Should -Be 1
        }

        It 'does not propagate the SQL exception to the caller' {
            { & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile } |
                Should -Not -Throw
        }
    }

    # -------------------------------------------------------------------------
    Context 'Workload from stored procedure' {

        BeforeEach {
            $wlUrls = @('http://mock-jenkins/job/SPJob/3/api/xml')

            # Reader mock: returns each URL once then signals end-of-stream
            $mockReader = [PSCustomObject]@{ _urls = $wlUrls; _idx = 0 }
            Add-Member -InputObject $mockReader -MemberType ScriptMethod -Name Read -Value {
                if ($this._idx -lt $this._urls.Count) { $this._idx++; return $true }
                return $false
            }
            Add-Member -InputObject $mockReader -MemberType ScriptMethod -Name GetString -Value {
                param([int]$i)
                return $this._urls[$this._idx - 1]
            }
            Add-Member -InputObject $mockReader -MemberType ScriptMethod -Name Close -Value {}

            # Workload connection + command (first New-Object pair created by the script)
            $wlState    = @{ opened = $false; closed = $false }
            $mockWlConn = [PSCustomObject]@{ ConnectionString = ''; _s = $wlState }
            Add-Member -InputObject $mockWlConn -MemberType ScriptMethod -Name Open  -Value { $this._s.opened = $true }
            Add-Member -InputObject $mockWlConn -MemberType ScriptMethod -Name Close -Value { $this._s.closed = $true }

            $mockWlCmd = [PSCustomObject]@{ CommandText = ''; CommandType = $null; Connection = $null; _r = $mockReader }
            Add-Member -InputObject $mockWlCmd -MemberType ScriptMethod -Name ExecuteReader -Value { return $this._r }

            # Job connection + command (subsequent pairs, one per URL in workloadUrls)
            $jobState   = @{ execCount = 0 }
            $mockJobConn = [PSCustomObject]@{ ConnectionString = '' }
            Add-Member -InputObject $mockJobConn -MemberType ScriptMethod -Name Open  -Value {}
            Add-Member -InputObject $mockJobConn -MemberType ScriptMethod -Name Close -Value {}

            $mockJobCmd = [PSCustomObject]@{ CommandText = ''; CommandType = $null; Connection = $null; _s = $jobState }
            Add-Member -InputObject $mockJobCmd -MemberType ScriptMethod -Name ExecuteNonQuery -Value {
                $this._s.execCount++
                return 1
            }

            # Counters for differentiating successive New-Object calls (plain hashtables,
            # captured by the mock closure)
            $connCounts = @{ n = 0 }
            $cmdCounts  = @{ n = 0 }

            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' } {
                $connCounts.n++
                if ($connCounts.n -eq 1) { return $mockWlConn } else { return $mockJobConn }
            }
            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' } {
                $cmdCounts.n++
                if ($cmdCounts.n -eq 1) { return $mockWlCmd } else { return $mockJobCmd }
            }

            $spIwrUris = [System.Collections.Generic.List[string]]::new()
            Mock Invoke-WebRequest {
                param($Uri, $OutFile)
                $spIwrUris.Add($Uri.ToString())
                Set-Content -Path $OutFile -Value '<freeStyleBuild/>'
            }
        }

        It 'opens the workload stored procedure connection' {
            & $script:ScriptPath @script:BaseParams -WorkloadSP 'USP_CREATEWORKLOAD'
            $wlState.opened | Should -Be $true
        }

        It 'closes the workload connection in the finally block' {
            & $script:ScriptPath @script:BaseParams -WorkloadSP 'USP_CREATEWORKLOAD'
            $wlState.closed | Should -Be $true
        }

        It 'calls Invoke-WebRequest for the URL returned by the workload stored procedure' {
            & $script:ScriptPath @script:BaseParams -WorkloadSP 'USP_CREATEWORKLOAD'
            $spIwrUris.Count | Should -Be 1
            $spIwrUris[0]    | Should -Be 'http://mock-jenkins/job/SPJob/3/api/xml'
        }

        It 'executes the job stored procedure for each URL from the workload stored procedure' {
            & $script:ScriptPath @script:BaseParams -WorkloadSP 'USP_CREATEWORKLOAD'
            $jobState.execCount | Should -Be 1
        }
    }

    # -------------------------------------------------------------------------
    Context 'Connection string construction' {

        BeforeEach {
            Set-Content -Path $script:WorkloadFile -Value 'http://mock-jenkins/job/CS/1/api/xml'

            $csState = @{ connStr = '' }

            $mockConn = [PSCustomObject]@{ ConnectionString = ''; _s = $csState }
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Open  -Value {}
            Add-Member -InputObject $mockConn -MemberType ScriptMethod -Name Close -Value {
                $this._s.connStr = $this.ConnectionString
            }

            $mockCmd = [PSCustomObject]@{ CommandText = ''; CommandType = $null; Connection = $null }
            Add-Member -InputObject $mockCmd -MemberType ScriptMethod -Name ExecuteNonQuery -Value { return 1 }

            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' } { $mockConn }
            Mock New-Object -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand'    } { $mockCmd  }

            Mock Invoke-WebRequest {
                param($OutFile)
                Set-Content -Path $OutFile -Value '<freeStyleBuild/>'
            }
        }

        It 'includes the Server parameter value in the connection string' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $csState.connStr | Should -Match 'Server=MockServer'
        }

        It 'includes the Database parameter value in the connection string' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $csState.connStr | Should -Match 'Database=MockDB'
        }

        It 'includes the User ID in the connection string' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $csState.connStr | Should -Match 'User ID=mockuser'
        }

        It 'includes the resolved plain-text password in the connection string' {
            & $script:ScriptPath @script:BaseParams -WorkloadPath $script:WorkloadFile
            $csState.connStr | Should -Match ([regex]::Escape("Password=$script:PlainPass"))
        }
    }
}
