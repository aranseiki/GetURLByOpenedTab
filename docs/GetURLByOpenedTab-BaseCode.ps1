Clear-Host

# Carregar o assembly necessário
# Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName UIAutomationClient

# Encontrar a instância do Edge
$edgeProcess = Get-Process -Name "msedge" | Where-Object { $_.MainWindowHandle -ne 0 }

if ($edgeProcess) {
    # Usar UI Automation para interagir com a janela do Edge
    $window = [System.Windows.Automation.AutomationElement]::FromHandle($edgeProcess.MainWindowHandle)

    # Obter a árvore de controle
    $children = $window.FindAll([System.Windows.Automation.TreeScope]::Descendants, [System.Windows.Automation.Condition]::TrueCondition)

    Write-Output "Controles encontrados na janela do Edge:"

    # Listar controles para inspeção
    foreach ($child in $children) {
        $controlType = $child.Current.ControlType.ProgrammaticName
        $url = "" # Inicializa a variável URL como vazia

        if ($controlType -eq 'ControlType.TabItem') {
            # Exibir propriedades relevantes para depuração
            $name = $child.Current.Name
            $child.SetFocus()
            Start-Sleep 1

            # Encontrar a barra de endereços com base no nome
            $addressBar = $window.FindFirst(
                [System.Windows.Automation.TreeScope]::Descendants,
                (New-Object System.Windows.Automation.AndCondition(
                    (New-Object System.Windows.Automation.PropertyCondition(
                        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
                        [System.Windows.Automation.ControlType]::Edit
                    )),
                    (New-Object System.Windows.Automation.PropertyCondition(
                        [System.Windows.Automation.AutomationElement]::NameProperty,
                        "Address and search bar" # Filtrar pelo nome exato da barra de endereços
                    ))
                ))
            )

            if ($addressBar) {
                # Tentar obter o ValuePattern para acessar a URL
                $valuePattern = $addressBar.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern)

                if ($valuePattern) {
                    # Capturar a URL
                    $url = $valuePattern.Current.Value
                } else {
                    Write-Output "Não foi possível obter ValuePattern para a aba: $name"
                }
            } else {
                Write-Output "Controle de endereço não encontrado para a aba: $name"
            }

            # Mostrar informações 
            Write-Output "`nName: $name" 
            Write-Output "URL: $url"
        }
    }
} else {
    Write-Output "Nenhuma janela ativa do Edge encontrada."
}
