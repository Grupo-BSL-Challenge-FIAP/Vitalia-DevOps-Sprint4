param(
    [Parameter(Mandatory = $true)][string]$ResourceGroup,
    [Parameter(Mandatory = $true)][string]$Plan,
    [Parameter(Mandatory = $true)][string]$WebApp,
    [Parameter(Mandatory = $true)][string]$Location
)

az provider register --namespace Microsoft.Web | Out-Null

Write-Host "Grupo de recursos: $ResourceGroup"
az group create --name $ResourceGroup --location $Location | Out-Null

Write-Host "Plano de serviço: $Plan"
az appservice plan show --name $Plan --resource-group $ResourceGroup --query name -o tsv 2>$null
if ($LASTEXITCODE -ne 0) {
    az appservice plan create --name $Plan --resource-group $ResourceGroup --location $Location --is-linux false --sku F1
    if ($LASTEXITCODE -ne 0) { throw "Falha ao criar o plano de serviço" }
}

$linux = az appservice plan show --name $Plan --resource-group $ResourceGroup --query reserved -o tsv
if ($linux -eq "true") { throw "O plano foi criado como Linux. A API precisa de Windows." }

Write-Host "Web App: $WebApp"
az webapp show --name $WebApp --resource-group $ResourceGroup --query name -o tsv 2>$null
if ($LASTEXITCODE -ne 0) {
    az webapp create --name $WebApp --resource-group $ResourceGroup --plan $Plan --runtime "dotnet:10"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Tentando criar sem --runtime e configurar a versão do .NET..."
        az webapp create --name $WebApp --resource-group $ResourceGroup --plan $Plan
        if ($LASTEXITCODE -ne 0) { throw "Falha ao criar o Web App" }
        az webapp config set --name $WebApp --resource-group $ResourceGroup --net-framework-version v10.0
    }
} else {
    Write-Host "O Web App já existe."
}
