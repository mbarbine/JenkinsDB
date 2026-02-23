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
        BeforeAll {
            $script:ast = [System.Management.Automation.Language.Parser]::ParseFile(
                $script:ScriptPath, [ref]$null, [ref]$null
            )
            $script:params = $script:ast.ParamBlock.Parameters
        }

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
    }

    Context 'Connection string' {
        It 'does not contain hardcoded empty credentials' {
            $content = Get-Content $script:ScriptPath -Raw
            $content | Should -Not -Match '\$User\s*=\s*[''"]sa[''"]'
            $content | Should -Not -Match '\$Password\s*=\s*[''"][''"]'
        }

        It 'uses parameterized connection string values' {
            $content = Get-Content $script:ScriptPath -Raw
            $content | Should -Match 'Server=\$Server'
            $content | Should -Match 'Database=\$Database'
        }
    }
}
