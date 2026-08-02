# Bugz - Azure AKS POC

This folder contains a small ASP.NET Core (.NET 8) minimal API deployed to AKS for a proof-of-concept.

## Architecture At A Glance

This project packages a .NET 8 API into a Docker image, pushes that image into Azure Container Registry, and runs it on Azure Kubernetes Service. The infrastructure is provisioned with Bicep, the application is deployed with Kubernetes manifests, and public traffic reaches the API through an Azure load balancer created from a Kubernetes `LoadBalancer` service.

## Deployment Flow

1. Build the ASP.NET Core application and validate it locally.
2. Build a Docker image from the project Dockerfile.
3. Push the image to Azure Container Registry.
4. Deploy Azure infrastructure with Bicep.
5. Connect to the AKS cluster with `kubectl`.
6. Apply the Kubernetes manifests into the `bugz` namespace.
7. Reach the application through the public IP exposed by the Azure load balancer.

## Why These Azure Resources Exist

- `AKS` runs the Kubernetes control plane and worker node platform for the application.
- `ACR` stores private container images so AKS can pull trusted builds.
- `VNet` and `aks-subnet` provide the private network boundary for cluster infrastructure.
- `Log Analytics` collects logs and metrics from the deployment.
- `Container Insights` adds AKS-focused monitoring on top of Log Analytics.
- the AKS managed resource group holds the load balancer, public IPs, VM scale set, and other resources Azure manages for the cluster.

## Networking Path

The public request flow for this project is:

`Browser -> Azure Public IP -> Azure Load Balancer -> Kubernetes Service -> Bugz Pods`

At the Azure layer, the load balancer is created automatically when the Kubernetes service is defined as type `LoadBalancer`. Inside the cluster, Kubernetes then forwards traffic from the service to the healthy `bugz-api` pods.

## Scaling Notes

There are two different scaling concepts in this project:

- `pod scaling`: Kubernetes can run multiple replicas of the `bugz-api` deployment.
- `node scaling`: Azure can add or remove worker nodes through the VM scale set behind AKS.

Those are related but not the same. More pods improve app-level redundancy, while more nodes increase cluster capacity.

## Security Notes

- The application image is stored in a private Azure Container Registry.
- AKS uses Azure-managed identity and role assignment for image pull access instead of embedding registry credentials in manifests.
- The AKS-managed network security group limits inbound access and preserves Azure default allow and deny behavior.
- The API is publicly reachable through the load balancer, so production hardening would typically add tighter ingress controls, TLS, and restricted API server access.

## Cost Awareness

Even a small AKS proof of concept can continue generating charges when left running. The main cost drivers are usually:

- the AKS worker nodes
- the public load balancer
- public IP addresses
- Log Analytics ingestion and retention
- container registry storage

For interview prep or demos, it is worth capturing screenshots and then tearing the environment down when it is no longer needed.

## Documentation

- [Deployment guide](./docs/deployment.md)
- [Architecture overview](./docs/architecture.md)
- [Screenshot gallery](./docs/screenshots.md)

## Cleanup

If everything for this deployment lives in the Bugz resource groups, the simplest cleanup path is deleting the application resource group and the AKS-managed resource group.

Example Azure CLI commands:

```bash
az group delete --name rg-bugz-dev-eastus --yes --no-wait
az group delete --name MC_rg-bugz-dev-eastus_bugz-dev-aks_eastus --yes --no-wait
```

You can also delete the primary resource group from the Azure Portal, and Azure will typically remove the managed AKS resource group as part of the cluster cleanup. It is still worth verifying both groups are gone afterward.

## Lessons Learned

- AKS deployments create more Azure resources than just the cluster object shown in the first deployment command.
- Azure networking matters even for a small Kubernetes proof of concept because the load balancer, subnet, public IP, and NSG all affect reachability.
- A private registry and managed identity make the container delivery path cleaner and safer than passing raw credentials around.
- The Azure Portal is useful not just for management, but for explaining the architecture visually during interviews and project walkthroughs.

## Interview Talking Points

- Why does AKS create a second resource group
  - Azure uses it to manage the cluster infrastructure it owns, including the VM scale set, load balancer, public IPs, and supporting identities.
- Why use ACR
  - It gives the cluster a private, Azure-native image source with controlled access.
- How does the app become public
  - The Kubernetes service is exposed as type `LoadBalancer`, which causes Azure to provision a public IP and load balancer path to the service.
- What would improve this in production
  - HTTPS, ingress controller, autoscaling, tighter NSG and API server restrictions, secrets management, and CI/CD-driven deployments.

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
