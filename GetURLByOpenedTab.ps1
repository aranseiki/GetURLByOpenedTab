# Clear terminal
Clear-Host

# Load required dependencies
Add-Type -AssemblyName UIAutomationClient
Import-Module "$PSScriptRoot\src\Manage-process.psm1" -Force
Import-Module "$PSScriptRoot\src\Manage-WindowInstance" -Force

# Find Edge instances
$EdgeProcesses = Get-BrowserInstance -ProcessName "msedge" | Where-Object { $_.MainWindowHandle -ne 0 }

Get-AutomatedBrowserWindowInstance -BrowserProcess $EdgeProcesses
