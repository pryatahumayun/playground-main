# 🚀 Deploying Bugz to Azure Kubernetes Service

## Overview

This guide walks through deploying the Bugz API from scratch using Azure.

The goal wasn't just to get an application running. I wanted to understand the full deployment process, from creating the infrastructure to running a containerized application on Kubernetes.

By the end of this guide you'll have:

- An Azure subscription
- Azure Cloud Shell configured
- Azure CLI authenticated
- Infrastructure deployed with Bicep
- A Docker image published to Azure Container Registry (ACR)
- An ASP.NET Core application running on Azure Kubernetes Service (AKS)

---

# Phase 1: Create an Azure Subscription

If you don't already have an Azure subscription, start by creating one through the Azure Portal.

Once your subscription is active, you'll be ready to start deploying resources.

![Azure Subscription](image.png)

---

# Phase 2: Open Azure Cloud Shell

From the Azure Portal:

- Click the **Cloud Shell** icon
- Select **Bash**

The first time Cloud Shell launches you'll be asked to configure storage.

For this project I selected:

- **No Storage Account Required**
- My Azure subscription

Then click **Apply**.

Cloud Shell comes with the Azure CLI already installed, so it's a quick way to start working without configuring your local machine.

---

# Phase 3: Authenticate with Azure

If you're working from your own terminal instead of Cloud Shell:

```bash
az login
```

A browser window will open asking you to sign in.

After authentication, select the Azure subscription you want to use.

---

# Phase 4: Verify Your Subscription

Before deploying anything, it's always worth checking you're connected to the correct subscription.

```bash
az account show
```

![Azure Account](image-1.png)

Verify:

![Subscription Details](image-2.png)

- Subscription Name
- Subscription ID
- Tenant
- Logged in account

It only takes a few seconds and can save you from deploying resources into the wrong subscription.

---

# Phase 5: Clone the Repository

Clone the repository and navigate to the project.

```bash
git clone https://github.com/<username>/playground-main.git

cd playground-main/projects/bugz-azure-aks
```

---

# Phase 6: Validate the Infrastructure

Before deploying the infrastructure, I like to validate that the Bicep templates compile successfully.

```bash
az bicep build --file .\infra\main.bicep
```

If this succeeds, the template is ready to deploy.

---

# Phase 7: Preview the Deployment

One feature I really like in Azure is the **What-If** deployment.

Instead of deploying immediately, Azure shows exactly what resources will be created or updated.

```bash
az deployment group what-if ...
```

![What-If Deployment](image-8.png)

It's a nice sanity check before provisioning infrastructure.

---

# Phase 8: Deploy the Infrastructure

Once everything looks good, deploy the environment.

```bash
az deployment group create ...
```

This project deploys:

- Resource Group
- Virtual Network
- Azure Kubernetes Service
- Azure Container Registry
- Log Analytics Workspace
- Managed Identity

![Infrastructure Deployment](image-9.png)

---

# Phase 9: Connect to AKS

Download the Kubernetes credentials for the cluster.

```bash
az aks get-credentials \
  --resource-group rg-bugz-dev-eastus \
  --name bugz-dev-aks
```

Then verify the cluster is available.

```bash
kubectl get nodes
```

![AKS Nodes](image-10.png)

Seeing a **Ready** node is always a good sign.

---

# Phase 10: Build the Docker Image

Build the application into a Docker image.

```bash
docker build -t bugz-api:local .
```

![Docker Build](image-11.png)

---

# Phase 11: Test Locally

Before pushing anything to Azure, I like to make sure the container actually works.

Run the container:

```bash
docker run --rm -p 8080:8080 bugz-api:local
```

Then test a few endpoints.

```powershell
Invoke-RestMethod http://localhost:8080/
Invoke-RestMethod http://localhost:8080/health
```

![Local Testing](image-4.png)

If it works locally, there's a much better chance it'll work in Kubernetes.

---

# Phase 12: Push the Image to Azure Container Registry

Tag the local image.

```bash
docker tag bugz-api:local <acr-name>.azurecr.io/bugz-api:latest
```

Push it to Azure Container Registry.

```bash
docker push <acr-name>.azurecr.io/bugz-api:latest
```

![Docker Push](image-12.png)

Image uploaded.

Bless up. 🙏

---

# Phase 13: Deploy to Kubernetes

Deploy the Kubernetes manifests.

```bash
kubectl apply -f k8s/
```

Verify the deployment.

```bash
kubectl get pods

kubectl get svc
```

Once the pods are running and the service has an external IP, the application is ready.

---

# Phase 14: Verify the Application

Open the application in your browser.

```
http://135.234.201.251/
```


If everything went well, Bugz is now running on Azure Kubernetes Service.

Mission accomplished. 🐶
