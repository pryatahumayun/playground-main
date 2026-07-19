# Bugz - Azure AKS POC

This folder contains a small ASP.NET Core (.NET 8) minimal API deployed to AKS for a proof-of-concept.

Quick commands (from repository root)

1) Build & validate locally
- cd playground-main/projects/bugz-azure-aks/src/Bugz.Api
- dotnet restore
- dotnet build -c Release

2) Build Docker image locally
- docker build -t local-bugz -f playground-main/projects/bugz-azure-aks/docker/Dockerfile playground-main/projects/bugz-azure-aks
- docker run -e ASPNETCORE_HTTP_PORTS=8080 -p 8080:8080 local-bugz
- curl http://localhost:8080/health

3) Deploy infra (example)
- pwsh ./playground-main/projects/bugz-azure-aks/scripts/deploy-infra.ps1 -projectName bugz -environment dev -location eastus -aksSku Standard_D2s_v7 -nodeCount 1 -resourceGroupName bugz-dev-rg

4) Build & push image
- pwsh ./playground-main/projects/bugz-azure-aks/scripts/build-and-push.ps1 -acrName <acrName> -imageTag v1

5) Deploy to AKS
- pwsh ./playground-main/projects/bugz-azure-aks/scripts/deploy-k8s.ps1 -resourceGroup bugz-dev-rg -aksName bugz-dev-aks -image <acrLoginServer>/bugz:v1

Note: This project uses a system-assigned managed identity for the AKS cluster by default. A user-assigned identity module exists as an example but is not enabled by default.

## GitHub Actions OIDC setup

This repo now includes these workflows:

- `.github/workflows/bugz-azure-aks-infra.yml`
- `.github/workflows/bugz-azure-aks-app.yml`

They use `azure/login@v2` with GitHub OIDC, so you do not need to store an Azure client secret in GitHub.

### 1) Create an Entra app and service principal

From a terminal where you are already signed in to Azure:

```bash
APP_NAME="gh-bugz-azure-aks"

APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
az ad sp create --id "$APP_ID" --output none

TENANT_ID=$(az account show --query tenantId -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "APP_ID=$APP_ID"
echo "TENANT_ID=$TENANT_ID"
echo "SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
```

### 2) Assign Azure roles

Replace `YOUR-RESOURCE-GROUP` with the resource group that will host the Bugz deployment.

`Contributor` lets the workflow deploy resources. `User Access Administrator` is also needed because the Bicep creates an ACR pull role assignment for AKS.

```bash
RESOURCE_GROUP="bugz-dev-rg"
RG_SCOPE=$(az group show --name "$RESOURCE_GROUP" --query id -o tsv)

az role assignment create \
  --assignee "$APP_ID" \
  --role "Contributor" \
  --scope "$RG_SCOPE"

az role assignment create \
  --assignee "$APP_ID" \
  --role "User Access Administrator" \
  --scope "$RG_SCOPE"
```

If you want the app workflow to push to an existing ACR outside that resource group, also grant `AcrPush` on that registry.

### 3) Add the federated credential for GitHub Actions

Replace `YOUR_GITHUB_ORG` and `YOUR_GITHUB_REPO`. The subject below trusts workflow runs from the `main` branch:

```bash
cat > credential.json <<'JSON'
{
  "name": "github-main",
  "issuer": "https://token.actions.githubusercontent.com/",
  "subject": "repo:YOUR_GITHUB_ORG/YOUR_GITHUB_REPO:ref:refs/heads/main",
  "description": "GitHub Actions access for bugz-azure-aks workflows on main",
  "audiences": [
    "api://AzureADTokenExchange"
  ]
}
JSON

az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters credential.json
```

If you want `workflow_dispatch` to run from branches other than `main`, add another federated credential for each branch pattern you want to trust.

### 4) Add GitHub repository secrets

In GitHub, add these repository secrets:

- `AZURE_CLIENT_ID`: the Entra application `appId`
- `AZURE_TENANT_ID`: your Azure tenant ID
- `AZURE_SUBSCRIPTION_ID`: your Azure subscription ID

### 5) Optional repository variables

The workflows currently hardcode these defaults:

- resource group: `bugz-dev-rg`
- project name: `bugz`
- environment: `dev`
- location: `eastus`

If you want multiple environments later, move those values into GitHub environment variables or separate workflow files.

### References

- GitHub Docs: Configuring OpenID Connect in Azure
- Microsoft Learn: Use the Azure Login action with OpenID Connect
- Microsoft Learn: `az ad app federated-credential create`
