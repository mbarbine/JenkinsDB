#Requires -Module Pester

Describe 'GrabXML.ps1' {

    BeforeAll {
        $script:ScriptPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' `
            'Powershell Scripts, Files, and Tasks' `
            'Directory Structure' `
            'DATA (E DRIVE)' `
            'E-Colon-Slash XML' `
            'builds' `
            'GrabXML.ps1'))
        $script:Content = Get-Content $script:ScriptPath -Raw
        $script:ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $script:ScriptPath, [ref]$null, [ref]$null
        )
        $script:params = $script:ast.ParamBlock.Parameters
    }

    Context 'Script file' {
        It 'exists' {
            $script:ScriptPath | Should -Exist
        }

        It 'is valid PowerShell syntax' {
            $errors = $null
            $null = [System.Management.Automation.Language.Parser]::ParseFile(
                $script:ScriptPath, [ref]$null, [ref]$errors
            )
            $errors | Should -BeNullOrEmpty
        }
    }

    Context 'Parameters' {
        It 'has a mandatory -Server parameter' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'Server' }
            $p | Should -Not -BeNullOrEmpty
            $isMandatory = $p.Attributes |
                Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] -and $_.TypeName.Name -eq 'Parameter' } |
                ForEach-Object { $_.NamedArguments | Where-Object { $_.ArgumentName -eq 'Mandatory' -and $_.Argument.ToString() -eq '$true' } } |
                Select-Object -First 1
            $isMandatory | Should -Not -BeNullOrEmpty
        }

        It 'has a mandatory -Database parameter' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'Database' }
            $p | Should -Not -BeNullOrEmpty
            $isMandatory = $p.Attributes |
                Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] -and $_.TypeName.Name -eq 'Parameter' } |
                ForEach-Object { $_.NamedArguments | Where-Object { $_.ArgumentName -eq 'Mandatory' -and $_.Argument.ToString() -eq '$true' } } |
                Select-Object -First 1
            $isMandatory | Should -Not -BeNullOrEmpty
        }

        It 'has a mandatory -User parameter' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'User' }
            $p | Should -Not -BeNullOrEmpty
            $isMandatory = $p.Attributes |
                Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] -and $_.TypeName.Name -eq 'Parameter' } |
                ForEach-Object { $_.NamedArguments | Where-Object { $_.ArgumentName -eq 'Mandatory' -and $_.Argument.ToString() -eq '$true' } } |
                Select-Object -First 1
            $isMandatory | Should -Not -BeNullOrEmpty
        }

        It 'has a mandatory -Password parameter of type SecureString' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'Password' }
            $p | Should -Not -BeNullOrEmpty
            $isMandatory = $p.Attributes |
                Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] -and $_.TypeName.Name -eq 'Parameter' } |
                ForEach-Object { $_.NamedArguments | Where-Object { $_.ArgumentName -eq 'Mandatory' -and $_.Argument.ToString() -eq '$true' } } |
                Select-Object -First 1
            $isMandatory | Should -Not -BeNullOrEmpty
            $typeAttr = $p.Attributes | Where-Object { $_ -is [System.Management.Automation.Language.TypeConstraintAst] }
            $typeAttr.TypeName.Name | Should -Be 'SecureString'
        }

        It 'has an optional -WorkloadPath parameter with a default' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'WorkloadPath' }
            $p | Should -Not -BeNullOrEmpty
            $p.DefaultValue | Should -Not -BeNullOrEmpty
        }

        It 'has an optional -BuildDataPath parameter with a default' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'BuildDataPath' }
            $p | Should -Not -BeNullOrEmpty
            $p.DefaultValue | Should -Not -BeNullOrEmpty
        }

        It 'has an optional -SP1 parameter defaulting to USP_CREATE_JOB_DATA' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'SP1' }
            $p | Should -Not -BeNullOrEmpty
            $p.DefaultValue.Value | Should -Be 'USP_CREATE_JOB_DATA'
        }

        It 'has an optional -JenkinsUser parameter' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'JenkinsUser' }
            $p | Should -Not -BeNullOrEmpty
        }

        It 'has an optional -JenkinsToken parameter' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'JenkinsToken' }
            $p | Should -Not -BeNullOrEmpty
        }

        It 'has an optional -WorkloadSP parameter' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'WorkloadSP' }
            $p | Should -Not -BeNullOrEmpty
        }

        It '-WorkloadSP is not mandatory' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'WorkloadSP' }
            $isMandatory = $p.Attributes |
                Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] -and $_.TypeName.Name -eq 'Parameter' } |
                ForEach-Object { $_.NamedArguments | Where-Object { $_.ArgumentName -eq 'Mandatory' -and $_.Argument.ToString() -eq '$true' } } |
                Select-Object -First 1
            $isMandatory | Should -BeNullOrEmpty
        }

        It '-JenkinsUser is not mandatory' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'JenkinsUser' }
            $isMandatory = $p.Attributes |
                Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] -and $_.TypeName.Name -eq 'Parameter' } |
                ForEach-Object { $_.NamedArguments | Where-Object { $_.ArgumentName -eq 'Mandatory' -and $_.Argument.ToString() -eq '$true' } } |
                Select-Object -First 1
            $isMandatory | Should -BeNullOrEmpty
        }

        It '-JenkinsToken is not mandatory' {
            $p = $script:params | Where-Object { $_.Name.VariablePath.UserPath -eq 'JenkinsToken' }
            $isMandatory = $p.Attributes |
                Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] -and $_.TypeName.Name -eq 'Parameter' } |
                ForEach-Object { $_.NamedArguments | Where-Object { $_.ArgumentName -eq 'Mandatory' -and $_.Argument.ToString() -eq '$true' } } |
                Select-Object -First 1
            $isMandatory | Should -BeNullOrEmpty
        }
    }

    Context 'Connection string' {
        It 'does not contain hardcoded empty credentials' {
            $script:Content | Should -Not -Match '\$User\s*=\s*[''"]sa[''"]'
            $script:Content | Should -Not -Match '\$Password\s*=\s*[''"][''"]'
        }

        It 'uses parameterized connection string values' {
            $script:Content | Should -Match 'Server=\$Server'
            $script:Content | Should -Match 'Database=\$Database'
        }

        It 'uses User ID in the connection string' {
            $script:Content | Should -Match 'User ID=\$User'
        }

        It 'sets Integrated Security to False' {
            $script:Content | Should -Match 'Integrated Security=False'
        }
    }

    Context 'Web request' {
        It 'uses -UseBasicParsing with Invoke-WebRequest' {
            $script:Content | Should -Match 'UseBasicParsing'
        }

        It 'wraps Invoke-WebRequest in a try/catch block' {
            $script:Content | Should -Match '\btry\b'
            $script:Content | Should -Match '\bcatch\b'
        }

        It 'continues to next URL on web request failure' {
            $script:Content | Should -Match '\bcontinue\b'
        }

        It 'supports Jenkins Basic authentication headers' {
            $script:Content | Should -Match 'Authorization'
        }

        It 'encodes Jenkins credentials as Base64 for the Authorization header' {
            $script:Content | Should -Match 'Base64'
        }

        It 'guards authentication header behind a JenkinsUser/JenkinsToken check' {
            $script:Content | Should -Match '\$JenkinsUser.*\$JenkinsToken|\$JenkinsToken.*\$JenkinsUser'
        }

        It 'passes -OutFile to Invoke-WebRequest using BuildDataPath' {
            $script:Content | Should -Match '\$BuildDataPath'
        }
    }

    Context 'SQL execution' {
        It 'sets CommandType to StoredProcedure' {
            $script:Content | Should -Match 'StoredProcedure'
        }

        It 'closes the SqlConnection in a finally block' {
            $script:Content | Should -Match '\bfinally\b'
            $script:Content | Should -Match '\.Close\(\)'
        }

        It 'handles SQL errors with a descriptive catch message' {
            $script:Content | Should -Match 'Error executing the stored procedure'
        }

        It 'converts SecureString password to plain text via SecureStringToBSTR' {
            $script:Content | Should -Match 'SecureStringToBSTR'
            $script:Content | Should -Match 'PtrToStringAuto'
        }

        It 'assigns the stored procedure name to CommandText' {
            $script:Content | Should -Match 'CommandText\s*=\s*\$SP1'
        }

        It 'assigns the SqlConnection to the SqlCommand' {
            $script:Content | Should -Match 'SqlCommand\.Connection\s*=\s*\$SqlConnection'
        }
    }

    Context 'Loop structure' {
        It 'reads workload entries from WorkloadPath file when WorkloadSP is not set' {
            $script:Content | Should -Match 'Get-Content.*\$WorkloadPath'
        }

        It 'reads workload entries from the database when WorkloadSP is set' {
            $script:Content | Should -Match '\$WorkloadSP'
            $script:Content | Should -Match 'workloadCommand'
        }

        It 'fetches each URL and saves the result to BuildDataPath' {
            $script:Content | Should -Match 'Invoke-WebRequest'
            $script:Content | Should -Match '\$BuildDataPath'
        }

        It 'reports progress for each URL being fetched' {
            $script:Content | Should -Match 'Fetching build data'
        }

        It 'reports progress when processing SQL data' {
            $script:Content | Should -Match 'Processing Build Data'
        }
    }
}
