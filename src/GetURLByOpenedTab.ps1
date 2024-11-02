Clear-Host

# Carregar o assembly necessário
Add-Type -AssemblyName UIAutomationClient

function Get-BrowserInstance {
    param (
        [string]$ProcessName
    )

    # Retorna a instância do Edge
    return Get-Process -Name $ProcessName -ErrorAction Stop
}
