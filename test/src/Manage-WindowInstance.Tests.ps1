# Import the Pester module for unit testing in PowerShell
Import-Module Pester -RequiredVersion 5.6.1

# Load the custom module containing the function under test
Import-Module .\src\Manage-WindowInstance.psm1

# BeforeAll block: sets up the environment required for all tests in the Describe block
BeforeAll {
    # Start the Edge browser process without waiting, and with a new environment to isolate the process
    Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -NoNewWindow -UseNewEnvironment -ErrorAction Stop

    # Initialize the variable to null; will store the active browser process
    $BrowserProcess = $null

    # Continuously try to capture an active Edge process until one with a MainWindowHandle is found
    while (-not $BrowserProcess) {
        # Retrieve an active Edge process with a non-zero MainWindowHandle, if available
        $BrowserProcess = Get-Process -Name 'msedge' | Where-Object { $_.MainWindowHandle -ne 0 }
    }
}

# Describe block: defines the suite of tests for the function Get-AutomatedBrowserWindowInstance
Describe "Testing Get-AutomatedBrowserWindowInstance function" {

    # Context block for testing with a valid browser process instance
    Context "With a valid browser process instance" {
        
        # Test: checks if the function can return an automated window associated with the browser process
        It "Should return an automated window linked to this browser process" {
            # Run the function with a valid browser process and store the result
            $result = Get-AutomatedBrowserWindowInstance -BrowserProcess $BrowserProcess
            # Assert that the result is not null or empty
            $result | Should -Not -BeNullOrEmpty
            # Verify the result is of type 'AutomationElement'
            $result.GetType().Name | Should -Be 'AutomationElement'
            # Check if the ProcessId of the result matches the ProcessId of the browser process
            $result.Current.ProcessId | Should -Be $BrowserProcess.Id
        }
    }

    # Context block for testing with an invalid or inactive browser process instance
    Context "With an invalid or inactive browser process instance" {

        # Test: checks if the function throws the expected exception for an invalid process
        It "Should throw an exception" {

            # Create a mock object to simulate an invalid process instance:
                # Id =  Arbitrary process ID
                # Handles = Mock value for Handles
                # HandleCount = Mock value for HandleCount
                # MainWindowHandle = Mock value for MainWindowHandle
            $invalidProcess = New-Object PSObject -Property @{
                Id = 1234
                Handles = 123
                HandleCount = 12315
                MainWindowHandle = [System.IntPtr]::new(1234)
            }

            # Ensure the invalid process mock object is not null or empty
            $invalidProcess | Should -Not -BeNullOrEmpty
            # Assert that calling the function with an invalid process throws an exception containing "FromHandle"
            { Get-AutomatedBrowserWindowInstance -BrowserProcess $invalidProcess } | Should -Throw "*FromHandle*"
            # Assert that calling the function throws an exception with a message containing "Unrecognized error"
            { Get-AutomatedBrowserWindowInstance -BrowserProcess $invalidProcess } | Should -Throw "*Unrecognized error*"
        }
    }
}

# AfterAll block: clean-up actions to run after all tests have executed
AfterAll {
    # Re-fetch the active browser process to ensure the instance is still valid for termination
    $BrowserProcess = $BrowserProcess | Where-Object { $_.MainWindowHandle -ne 0 }
    # Stop the Edge browser process to clean up resources used by the tests
    Stop-Process -Id $BrowserProcess.Id
}
