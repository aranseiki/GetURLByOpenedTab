# Import the Pester module
Import-Module Pester -RequiredVersion 5.6.1

BeforeAll {
    # Load the code file into the test environment
    . ./../src/GetURLByOpenedTab.ps1
}

Describe "Testing for Get-BrowserInstance function" {

    Context "When the browser process is running" {

        # Mocking a process with a non-zero MainWindowHandle as IntPtr
        Mock -CommandName Get-BrowserInstance -MockWith {
            New-Object PSObject -Property @{
                ProcessName      = 'msedge'
                MainWindowHandle = [System.IntPtr]::new(12345)  # Criando um IntPtr válido
            }
        }

        It "Should return the browser process with the active window" {
            $result = Get-BrowserInstance -ProcessName 'msedge'
            $result | Should -Not -BeNullOrEmpty
            # Comparando diretamente com um IntPtr
            $result[0].MainWindowHandle.GetType() | Should -Be -Not [System.IntPtr]::Zero
        }
    }

    Context "When the browser process is NOT running" {

        It "Throws the exception" {
            { Get-BrowserInstance -ProcessName 'msedgeaaaaaa' } | Should -Throw -ExpectedMessage '*msedgeaaaaaa*'
        }
    }
}
