# Deploying Bugz to Azure Kubernetes Service

## Overview

This guide walks through the Bugz deployment from local source code to a running application on Azure Kubernetes Service.

The goal of the project was not just to get an API online. It was to understand the full delivery path:

- validate infrastructure as code
- provision Azure resources with Bicep
- build and push a container image
- deploy the workload to AKS
- verify the application through the public endpoint

For a portal-first walkthrough of the finished environment, see the [Azure screenshot gallery](./screenshots.md).

## Phase 1: Create or Select an Azure Subscription

If you do not already have an Azure subscription, create one first in the Azure Portal. Once the subscription is active, you can deploy the Bugz infrastructure into it.

![Azure subscription](./image.png)

## Phase 2: Open Azure Cloud Shell

From the Azure Portal:

- click the Cloud Shell icon
- select `Bash`

On first launch, Azure asks you to configure the shell environment. For this project, Cloud Shell was configured without a storage account. Cloud Shell is useful because Azure CLI is already available and authenticated in the browser session.

## Phase 3: Authenticate with Azure

If you are working from your own terminal instead of Cloud Shell, sign in with Azure CLI:

```bash
az login
```

After sign-in, choose the subscription that will host the deployment.

## Phase 4: Verify the Active Subscription

Before deploying anything, confirm that Azure CLI is pointed at the correct subscription:

```bash
az account show
```

These screenshots capture the account and subscription verification step:

![Azure account](./image-1.png)
![Azure subscription details](./image-2.png)

This quick check helps avoid deploying resources into the wrong tenant or subscription.

## Phase 5: Clone the Repository

Clone the repository and move into the Azure AKS project:

```bash
git clone https://github.com/<username>/playground-main.git
cd playground-main/projects/bugz-azure-aks
```

## Phase 6: Validate the Bicep Template

Before deploying infrastructure, validate that the Bicep template compiles successfully:

```bash
az bicep build --file .\infra\main.bicep
```

If the build succeeds, the template is ready to use.

## Phase 7: Preview the Deployment with What-If

Use Azure's `what-if` feature to preview the changes before creating resources:

```bash
az deployment group what-if ...
```

This is a good safety step because it shows what Azure plans to create or update before the deployment runs.

![What-if deployment](./image-8.png)

## Phase 8: Deploy the Infrastructure

Once the preview looks correct, create the infrastructure:

```bash
az deployment group create ...
```

This deployment provisions the core Azure resources for the project:

- AKS
- Azure Container Registry
- virtual network and subnet
- Log Analytics workspace
- supporting Azure-managed identities and monitoring resources

![Infrastructure deployment](./image-9.png)

## Phase 9: Connect to the AKS Cluster

After the infrastructure is ready, pull the Kubernetes credentials for the new cluster:

```bash
az aks get-credentials \
  --resource-group rg-bugz-dev-eastus \
  --name bugz-dev-aks
```

Verify that the node is available:

```bash
kubectl get nodes
```

The `Ready` node confirms that the cluster is available for workload deployment.

![AKS nodes](./image-10.png)

## Phase 10: Build the Docker Image

Build the application into a local Docker image:

```bash
docker build -t bugz-api:local .
```

![Docker build](./image-11.png)

## Phase 11: Test the Container Locally

Before pushing the image to Azure, run it locally and verify the endpoints:

```bash
docker run --rm -p 8080:8080 bugz-api:local
```

```powershell
Invoke-RestMethod http://localhost:8080/
Invoke-RestMethod http://localhost:8080/health
```

If the container works locally, the Kubernetes deployment path is much less likely to fail for application-level reasons.

![Local testing](./image-4.png)

## Phase 12: Push the Image to Azure Container Registry

Tag the local image for ACR:

```bash
docker tag bugz-api:local <acr-name>.azurecr.io/bugz-api:latest
```

Push it to the registry:

```bash
docker push <acr-name>.azurecr.io/bugz-api:latest
```

At this point, AKS can pull the image from the private registry using Azure-managed identity and role assignment.

![Docker push to ACR](./image-12.png)

## Phase 13: Deploy the Kubernetes Manifests

Apply the manifests in the `k8s/` folder:

```bash
kubectl apply -f k8s/
```

Then verify that the deployment and service were created:

```bash
kubectl get pods
kubectl get svc
```

Once the pods are healthy and the service has an external IP, the application is reachable through the Azure load balancer path.

## Phase 14: Verify the Live Application

Open the public endpoint in a browser:

```text
http://135.234.201.251/
```

If everything is working, the Bugz application is now running on Azure Kubernetes Service and exposed through the Azure-managed public endpoint.

## What This Deployment Demonstrates

This project shows a complete Azure container deployment path:

- infrastructure as code with Bicep
- container packaging with Docker
- private image storage in ACR
- workload orchestration with AKS
- public exposure through an Azure load balancer
- Azure-native identity and monitoring around the cluster
