
param(
    [Parameter(Mandatory = $true)][string]$ResourceGroup,
    [Parameter(Mandatory = $true)][string]$Plan,
    [Parameter(Mandatory = $true)][string]$WebApp,
    [Parameter(Mandatory = $true)][string]$Location
)

$ErrorActionPreference = "Stop"

# Verifica a assinatura selecionada
Write-Host "Verificando assinatura Azure..."
az account show --output table
if ($LASTEXITCODE -ne 0) {
    throw "Não foi possível acessar a assinatura Azure."
}

# Registra o provedor do App Service
Write-Host "Registrando provedor Microsoft.Web..."
az provider register --namespace Microsoft.Web --wait
if ($LASTEXITCODE -ne 0) {
    throw "Falha ao registrar Microsoft.Web."
}

# Cria o Resource Group caso não exista
Write-Host "Grupo de recursos: $ResourceGroup"

az group create `
    --name $ResourceGroup `
    --location $Location `
    --output none

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao criar ou verificar o Resource Group."
}

# Verifica se o App Service Plan existe
Write-Host "Plano de serviço: $Plan"

$existingPlan = az appservice plan list `
    --resource-group $ResourceGroup `
    --query "[?name=='$Plan'] | [0].name" `
    --output tsv

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao consultar os planos de serviço."
}

if ([string]::IsNullOrWhiteSpace($existingPlan)) {

    Write-Host "Plano não encontrado. Criando plano Windows..."

    az appservice plan create `
        --name $Plan `
        --resource-group $ResourceGroup `
        --location $Location `
        --sku F1 `
        --output none

    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao criar o plano de serviço."
    }

    Write-Host "Plano de serviço criado com sucesso."

} else {
    Write-Host "O plano de serviço já existe."
}

# Confirma que o plano utiliza Windows
$linux = az appservice plan show `
    --name $Plan `
    --resource-group $ResourceGroup `
    --query reserved `
    --output tsv

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao verificar o sistema operacional do plano."
}

if ($linux -eq "true") {
    throw "O plano utiliza Linux. A API precisa de Windows."
}

# Verifica se o Web App existe
Write-Host "Web App: $WebApp"

$existingWebApp = az webapp list `
    --resource-group $ResourceGroup `
    --query "[?name=='$WebApp'] | [0].name" `
    --output tsv

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao consultar os Web Apps."
}

if ([string]::IsNullOrWhiteSpace($existingWebApp)) {

    Write-Host "Web App não encontrado. Criando..."

    az webapp create `
        --name $WebApp `
        --resource-group $ResourceGroup `
        --plan $Plan `
        --output none

    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao criar o Web App."
    }

    Write-Host "Web App criado com sucesso."

} else {
    Write-Host "O Web App já existe."
}

# Configura a versão do .NET
Write-Host "Configurando .NET 10..."

az webapp config set `
    --name $WebApp `
    --resource-group $ResourceGroup `
    --net-framework-version v10.0 `
    --output none

if ($LASTEXITCODE -ne 0) {
    throw "Falha ao configurar o .NET 10."
}

Write-Host "Infraestrutura verificada e configurada com sucesso!"
