function Get-AutomatedBrowserWindowInstance {
    param (
        $BrowserProcess
    )
    Add-Type -AssemblyName UIAutomationClient

    # Use UI Automation to interact with the browser window
    return [System.Windows.Automation.AutomationElement]::FromHandle($BrowserProcess.MainWindowHandle)
}
