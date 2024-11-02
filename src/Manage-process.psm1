function Get-BrowserInstance {
    param (
        [string]$ProcessName
    )

    # Retorna a instância do Edge
    return Get-Process -Name $ProcessName -ErrorAction Stop
}

Export-ModuleMember -Function Get-BrowserInstance
