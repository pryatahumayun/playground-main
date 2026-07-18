# Cloud Architecture Playground - Bugz AKS POC

This folder contains a small ASP.NET Core (.NET 8) minimal API deployed to AKS for a proof-of-concept.

Quick commands (from repository root)

1) Build & validate locally
- cd files/playground-main/projects/feature/bugz-azure-aks/src/Bugz.Api
- dotnet restore
- dotnet build -c Release

2) Build Docker image locally
- docker build -t local-bugz -f files/playground-main/projects/feature/bugz-azure-aks/docker/Dockerfile files/playground-main/projects/feature/bugz-azure-aks
- docker run -e ASPNETCORE_HTTP_PORTS=8080 -p 8080:8080 local-bugz
- curl http://localhost:8080/health

3) Deploy infra (example)
- pwsh ./files/playground-main/projects/feature/bugz-azure-aks/scripts/deploy-infra.ps1 -projectName bugz -environment dev -location eastus -aksSku Standard_DS2_v2 -nodeCount 1 -resourceGroupName bugz-dev-rg

4) Build & push image
- pwsh ./files/playground-main/projects/feature/bugz-azure-aks/scripts/build-and-push.ps1 -acrName <acrName> -imageTag v1

5) Deploy to AKS
- pwsh ./files/playground-main/projects/feature/bugz-azure-aks/scripts/deploy-k8s.ps1 -resourceGroup bugz-dev-rg -aksName bugz-dev-aks -image <acrLoginServer>/bugz:v1

Note: This project uses a system-assigned managed identity for the AKS cluster by default. A user-assigned identity module exists as an example but is not enabled by default.
