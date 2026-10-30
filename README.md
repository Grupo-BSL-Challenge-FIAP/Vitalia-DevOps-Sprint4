# 🐾 Vitalia API — Módulo Comercial

**Sprint 4 · DevOps Tools & Cloud Computing · CI/CD com Azure DevOps**

API REST em **ASP.NET Core / .NET 10** do módulo comercial da plataforma **Vitalia** (categorias, produtos, carrinho, checkout e pedidos), publicada no **Azure Web App** por uma pipeline de **CI/CD no Azure DevOps** e persistindo dados em um **Oracle Database em nuvem (Oracle)**.

> A documentação técnica completa da API (entidades, endpoints, autenticação, HATEOAS, status codes) está em [`docs/README.md`](docs/README.md).

---

## 📑 Índice

- [👥 Integrantes](#-integrantes)
- [🔗 Links da entrega](#-links-da-entrega)
- [📚 Descrição da solução](#-descrição-da-solução)
- [🚀 Stack de tecnologias](#-stack-de-tecnologias)
- [🧭 Diagrama de arquitetura e fluxo CI/CD](#-diagrama-de-arquitetura-e-fluxo-cicd)
- [🗄️ Banco de dados em nuvem](#️-banco-de-dados-em-nuvem)
- [☁️ Infraestrutura no Azure](#️-infraestrutura-no-azure)
- [🧰 Projeto no Azure DevOps](#-projeto-no-azure-devops)
- [⚙️ Pipeline de CI/CD](#️-pipeline-de-cicd)
- [🔐 Variáveis protegidas](#-variáveis-protegidas)
- [✅ Como validar a aplicação](#-como-validar-a-aplicação)
- [🧪 Testes automatizados](#-testes-automatizados)
- [📁 Estrutura do repositório](#-estrutura-do-repositório)

---

## 👥 Integrantes

<table>
  <tr>
    <td width="130">
      <img src="https://github.com/moisesBarsoti.png" width="120" style="border-radius: 50%;"/>
    </td>
    <td>
      <b>Moisés Barsoti Andrade de Oliveira</b><br/>
      <b>RM:</b> 565049 &nbsp;&nbsp;|&nbsp;&nbsp;<b>Turma:</b> 2TDSPO - FIAP <br/>
    </td>
  </tr>
  <tr>
    <td width="130">
      <img src="https://github.com/sSofia-s.png" width="120" style="border-radius: 50%;"/>
    </td>
    <td>
      <b>Sofia Siqueira Fontes</b><br/>
      <b>RM:</b> 563829 &nbsp;&nbsp;|&nbsp;&nbsp;<b>Turma:</b> 2TDSPG - FIAP <br/>
    </td>
  </tr>
  <tr>
    <td width="130">
      <img src="https://github.com/manuelalacerda.png" width="120" style="border-radius: 50%;"/>
    </td>
    <td>
      <b>Manuela de Lacerda Soares</b><br/>
      <b>RM:</b> 564887 &nbsp;&nbsp;|&nbsp;&nbsp;<b>Turma:</b> 2TDSPG - FIAP <br/>
    </td>
  </tr>
</table>


---

## 🔗 Links da entrega

| Item | Link |
|------|------|
| Repositório no GitHub | `<URL GitHub>` |
| Projeto no Azure DevOps | https://dev.azure.com/Grupo-BSL-Vitalia/Sprint%204%20-%20Azure%20DevOps |
| Vídeo no YouTube | `<URL vídeo>` |
| Aplicação em nuvem (Azure Web App) | https://vitalia-sprint4-grupobsl.azurewebsites.net |
| Swagger | https://vitalia-sprint4-grupobsl.azurewebsites.net/swagger/index.html |
| Health check | https://vitalia-sprint4-grupobsl.azurewebsites.net/health/ready |

---

## 📚 Descrição da solução

O **Vitalia** é uma plataforma de saúde e cuidado de pets, com aplicativo mobile, dispositivos de monitoramento e serviços de backend. Esta entrega cobre o **módulo comercial**, uma API .NET responsável por:

- cadastro e consulta de **categorias** e **produtos**;
- **carrinho de compras**, **checkout** e **pedidos**;
- validação de **JWT** emitido pelo backend Java do Vitalia, para identificar o usuário e suas permissões (por exemplo, a role `ADMIN`);
- endpoints de **saúde** (`/health`, `/health/live`, `/health/ready`) e documentação **Swagger**.

O objetivo da Sprint 4 é automatizar o ciclo de entrega: a cada alteração de código na branch `master`, o Azure DevOps compila, executa os testes, gera e publica o artefato e faz o deploy no Azure Web App, sem etapas manuais.

---

## 🚀 Stack de tecnologias

| Camada | Tecnologia |
|--------|------------|
| Linguagem / runtime | C# · .NET 10 · ASP.NET Core Web API |
| Persistência | Entity Framework Core + Oracle.EntityFrameworkCore |
| Banco de dados em nuvem | Oracle Database |
| Autenticação | JWT Bearer (emitido pelo backend Java) |
| Documentação | Swagger |
| Observabilidade | Serilog, Health Checks e OpenTelemetry |
| Testes | xUnit, Moq e Microsoft.AspNetCore.Mvc.Testing |
| Hospedagem | Azure App Service (Web App Windows, plano F1) |
| CI/CD | Azure DevOps Pipelines (YAML) |
| Controle de versão | GitHub e Azure Repos |

---

## 🧭 Diagrama de arquitetura e fluxo CI/CD

<!-- Adicionar png draw.io -->

![Diagrama de arquitetura e fluxo CI/CD](docs/arquitetura-devops-sprint4.png)

**Fluxo numerado (mesma numeração do diagrama):**

| # | Etapa | Onde acontece |
|---|-------|---------------|
| 1 | O desenvolvedor faz commit e push na branch `master` | IDE / Git |
| 2 | O push dispara o gatilho da pipeline | Azure DevOps Pipelines |
| 3 | CI: restauração de dependências e build da API | Agente de pipeline |
| 4 | CI: execução dos testes automatizados (xUnit) | Agente de pipeline |
| 5 | CI: publicação da aplicação e compactação em `.zip` | Agente de pipeline |
| 6 | CI: publicação do artefato `app` no Azure DevOps | Azure DevOps Artifacts |
| 7 | CD: inicia somente após o novo artefato ser gerado | Azure DevOps Pipelines |
| 8 | CD: autenticação no Azure pela service connection | Azure DevOps + Microsoft Entra ID |
| 9 | CD: gravação das App Settings (variáveis protegidas) | Azure App Service |
| 10 | CD: deploy do pacote no Web App (Zip Deploy) | Azure App Service |
| 11 | O usuário final acessa a API por HTTPS | Azure App Service |
| 12 | A API lê e grava dados no Oracle | Oracle FIAP (nuvem) |
| 13 | O JWT é emitido pelo backend Java e validado pela API | Backend Java / API .NET |

**Personas:** desenvolvedor (faz o commit e acompanha a pipeline) e usuário final (consome a API pelo app e pelo Swagger).

---

## 🗄️ Banco de dados em nuvem

- **Serviço:** Oracle Database da FIAP (`oracle.fiap.com.br:1521`, service name `ORCL`).
- **Acesso:** a connection string fica em variável protegida da pipeline e chega ao Web App como App Setting. Ela nunca é versionada.
- **Tabelas** (criadas pelas migrations do Entity Framework Core):
  `TB_VITALIA_PRODUCT_CATEGORY`, `TB_VITALIA_PRODUCT`, `TB_VITALIA_CART`, `TB_VITALIA_CART_ITEM`, `TB_VITALIA_ORDERS` e `TB_VITALIA_ORDER_ITEM`.
- **Script DDL:** [`db/script.sql`](db/script.sql), gerado a partir das migrations:

```powershell
dotnet ef migrations script `
  --project Vitalia.Infrastructure/Vitalia.Infrastructure.csproj `
  --startup-project Vitalia.API/Vitalia.API.csproj `
  --context VitaliaDbContext `
  --output db/script.sql
```

- **Conectividade:** a conexão Azure → Oracle FIAP foi validada pelo console Kudu do Web App (`tcpping oracle.fiap.com.br:1521`).

---

## ☁️ Infraestrutura no Azure

| Recurso | Valor |
|---------|-------|
| Resource group | `rg-vitalia-sprint4` |
| App Service Plan | `plan-vitalia-sprint4` |
| Web App | `vitalia-sprint4-grupobsl` |
| Runtime | .NET 10 |
| Região | `canadacentral` |

Os recursos foram criados a partir do script documentado em [`docs/cria-infra.sh`](db/cria-infra.sh).

---

## 🧰 Projeto no Azure DevOps

| Configuração | Valor |
|--------------|-------|
| Organização | `Grupo-BSL-Vitalia` |
| Project name | Sprint 4 - Azure DevOps |
| Description | Projeto para entrega da Sprint 4 do professor `Antonio Sergio Rodrigues Figueiredo` e `Karlos Miguel Silva Lima`. Integrantes: RM563829 - Sofia Siqueira Fontes - 2TDSPG / RM565049 - Moisés Barsoti Andrade de Oliveira - 2TDSPO / RM564887 - Manuela de Lacerda Soares - 2TDSPG |
| Visibility | Private |
| Version control | Git |
| Work item process | `Scrum` |
| Acesso do professor | Convidado com nível de acesso **Basic** |

---

## ⚙️ Pipeline de CI/CD

A pipeline é definida em YAML, no arquivo [`azure-pipelines.yml`](azure-pipelines.yml) na raiz do repositório, e está conectada ao repositório da aplicação.

**Gatilho:** a cada alteração na branch `master`.

### Estágio 1 - CI: Build e testes

| Ordem | Task | O que faz |
|-------|------|-----------|
| 1 | `DotNetCoreCLI@2 restore` | Restaura as dependências |
| 2 | `DotNetCoreCLI@2 build` | Compila a API em modo Release |
| 3 | `DotNetCoreCLI@2 test` | Executa os testes automatizados e publica os resultados |
| 4 | `DotNetCoreCLI@2 publish` | Gera os arquivos publicados da API |
| 5 | `ArchiveFiles@2` | Compacta a aplicação em `app.zip` |
| 6 | `PublishPipelineArtifact@1` | Publica o artefato `app` no Azure DevOps |

### Estágio 2 - CD: Deploy no Azure Web App

O estágio depende do CI (`dependsOn`) e só executa depois que o artefato foi gerado.

| Ordem | Task | O que faz |
|-------|------|-----------|
| 1 | `DownloadPipelineArtifact@2` | Baixa o artefato `app` |
| 2 | `AzureAppServiceSettings@1` | Grava as App Settings a partir das variáveis protegidas |
| 3 | `AzureWebApp@1` | Faz o deploy do `app.zip` no Web App (Zip Deploy) |

**Autenticação no Azure:** service connection `azure-vitalia-sprint4` (Azure Resource Manager, workload identity federation).

**Agente de execução:** `self-hosted (pool Default)`.

---

## 🔐 Variáveis protegidas

Valores sensíveis ficam como **variáveis secretas** da pipeline (ícone de cadeado) e nunca são versionados. A tabela mostra apenas os nomes.

| Variável | Secreta | Uso |
|----------|---------|-----|
| `OracleConnection` | ✅ Sim | Connection string do Oracle (`ConnectionStrings__OracleConnection`) |
| `JWT_SECRET` | ✅ Sim | Segredo compartilhado para validar o JWT |
| `ASPNETCORE_ENVIRONMENT` | Não | Ambiente da aplicação (`Production`) |
| `NOME_WEBAPP` | Não | Nome do Web App de destino |

---

## ✅ Como validar a aplicação

1. Abra o Swagger: https://vitalia-sprint4-grupobsl.azurewebsites.net/swagger/index.html
2. Confirme a saúde da API e do banco em `/health/ready`.
3. Teste o CRUD de **Category** em `/api/Category` (`POST`, `GET`, `GET /{id}`, `PUT /{id}` e `DELETE /{id}`). Criar, alterar e excluir exigem um JWT com a role `ADMIN`: no Swagger, clique em **Authorize** e informe `Bearer <token>`.
4. Confira cada operação direto no banco:

```sql
SELECT CATEGORY_ID, NAME, DESCRIPTION
FROM TB_VITALIA_PRODUCT_CATEGORY
ORDER BY CATEGORY_ID;
```

**Prova do CI/CD:** a rota `GET /wellcome` foi adicionada em `Program.cs` para demonstrar que uma alteração de código na `master` percorre todo o fluxo (commit → CI → artefato → CD → aplicação atualizada).

---

## 🧪 Testes automatizados

O CI executa os testes a cada alteração na `master`. Para rodar localmente:

```powershell
dotnet test
```

| Projeto | Tipo |
|---------|------|
| `tests/Vitalia.Domain.Tests` | Testes unitários do domínio |
| `tests/Vitalia.Application.Tests` | Testes unitários da camada de aplicação |
| `tests/Vitalia.API.IntegrationTests` | Testes de integração da API |

Os resultados aparecem na aba **Tests** da execução da pipeline.

---

## 📁 Estrutura do repositório

```text
Directory structure:
└── grupo-bsl-challenge-fiap-vitalia-devops-sprint4/
    ├── README.md
    ├── Vitalia.sln
    ├── docs/
    │   ├── arquitetura-vitalia.drawio
    │   └── relacionamentos-vitalia.drawio
    ├── tests/
    │   ├── Vitalia.API.IntegrationTests/
    │   │   ├── ApiIntegrationTests.cs
    │   │   ├── Vitalia.API.IntegrationTests.csproj
    │   │   └── VitaliaWebApplicationFactory.cs
    │   ├── Vitalia.Application.Tests/
    │   │   ├── CartServiceTests.cs
    │   │   ├── OrderServiceTests.cs
    │   │   ├── ProductServiceTests.cs
    │   │   └── Vitalia.Application.Tests.csproj
    │   └── Vitalia.Domain.Tests/
    │       ├── CartItemTests.cs
    │       ├── CartTests.cs
    │       ├── CategoryTests.cs
    │       ├── OrderItemTests.cs
    │       ├── OrderTests.cs
    │       ├── ProductTests.cs
    │       └── Vitalia.Domain.Tests.csproj
    ├── Vitalia.API/
    │   ├── appsettings.Development.json
    │   ├── appsettings.json
    │   ├── Program.cs
    │   ├── Vitalia.API.csproj
    │   ├── Configurations/
    │   │   └── JwtConfiguration.cs
    │   ├── Controllers/
    │   │   ├── CartController.cs
    │   │   ├── CategoryController.cs
    │   │   ├── OrderController.cs
    │   │   └── ProductController.cs
    │   ├── Exceptions/
    │   │   └── GlobalExceptionHandler.cs
    │   ├── Extensions/
    │   │   └── VitaliaServiceCollectionExtensions.cs
    │   ├── Hateoas/
    │   │   ├── HateoasLink.cs
    │   │   └── HateoasResource.cs
    │   ├── Health/
    │   │   └── HealthCheckResponseWriter.cs
    │   ├── Properties/
    │   │   └── launchSettings.json
    │   └── Services/
    │       └── CurrentUser.cs
    ├── Vitalia.Application/
    │   ├── Vitalia.Application.csproj
    │   ├── DTOs/
    │   │   ├── Cart/
    │   │   │   ├── CartItemRequest.cs
    │   │   │   ├── CartItemResponse.cs
    │   │   │   ├── CartRequest.cs
    │   │   │   └── CartResponse.cs
    │   │   ├── Category/
    │   │   │   ├── CategoryRequest.cs
    │   │   │   └── CategoryResponse.cs
    │   │   ├── Order/
    │   │   │   ├── OrderItemResponse.cs
    │   │   │   └── OrderResponse.cs
    │   │   └── Product/
    │   │       ├── ProductPagedResponse.cs
    │   │       ├── ProductRequest.cs
    │   │       └── ProductResponse.cs
    │   ├── Interfaces/
    │   │   ├── Repositories/
    │   │   │   ├── ICartItemRepository.cs
    │   │   │   ├── ICartRepository.cs
    │   │   │   ├── ICategoryRepository.cs
    │   │   │   ├── IOrderItemRepository.cs
    │   │   │   ├── IOrderRepository.cs
    │   │   │   ├── IProductRepository.cs
    │   │   │   └── IUnitOfWork.cs
    │   │   └── Services/
    │   │       ├── ICartService.cs
    │   │       ├── ICategoryService.cs
    │   │       ├── ICurrentUser.cs
    │   │       ├── IOrderService.cs
    │   │       └── IProductService.cs
    │   └── Services/
    │       ├── CartService.cs
    │       ├── CategoryService.cs
    │       ├── OrderService.cs
    │       └── ProductService.cs
    ├── Vitalia.Domain/
    │   ├── Vitalia.Domain.csproj
    │   ├── Common/
    │   │   └── Entity.cs
    │   ├── Entities/
    │   │   ├── Cart.cs
    │   │   ├── CartItem.cs
    │   │   ├── Category.cs
    │   │   ├── Order.cs
    │   │   ├── OrderItem.cs
    │   │   └── Product.cs
    │   └── Enums/
    │       ├── CartStatus.cs
    │       ├── OrderStatus.cs
    │       └── ProductStatus.cs
    └── Vitalia.Infrastructure/
        ├── Vitalia.Infrastructure.csproj
        ├── Configurations/
        │   ├── CartConfiguration.cs
        │   ├── CartItemConfiguration.cs
        │   ├── CategoryConfiguration.cs
        │   ├── OrderConfiguration.cs
        │   ├── OrderItemConfiguration.cs
        │   └── ProductConfiguration.cs
        ├── Data/
        │   ├── UnitOfWork.cs
        │   └── VitaliaDbContext.cs
        ├── Migrations/
        │   ├── 20260907194842_InitialCommercialSchema.cs
        │   ├── 20260907194842_InitialCommercialSchema.Designer.cs
        │   └── VitaliaDbContextModelSnapshot.cs
        └── Repositories/
            ├── CartItemRepository.cs
            ├── CartRepository.cs
            ├── CategoryRepository.cs
            ├── OrderItemRepository.cs
            ├── OrderRepository.cs
            └── ProductRepository.cs

```