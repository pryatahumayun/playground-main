# Architecture

# ☁️ Azure Resources

Deploying this project creates **two** resource groups.

One contains the infrastructure deployed by my Bicep templates, while the other is automatically created by Azure Kubernetes Service (AKS) to manage the underlying cluster infrastructure.

Understanding what each resource does makes it much easier to understand how the entire platform fits together.

---

# 📦 Resource Group

## `rg-bugz-dev-eastus`

This is the primary resource group for the project.

Everything in this resource group is deployed through Infrastructure as Code using Bicep.

Resources include:

- Azure Kubernetes Service
- Azure Container Registry
- Virtual Network
- Log Analytics Workspace
- Container Insights

If I wanted to recreate this environment from scratch, these are the resources my Bicep templates would deploy.

---

# 🤖 Managed Resource Group

## `MC_rg-bugz-dev-eastus_bugz-dev-aks_eastus`

When an AKS cluster is created, Azure automatically provisions a managed resource group.

This resource group contains the infrastructure Azure needs to operate the Kubernetes cluster.

Resources include:

- Virtual Machine Scale Set
- Azure Load Balancer
- Public IP Addresses
- Network Security Group
- Managed Identities

Although these are Azure resources, they are managed through AKS rather than individually.

---

# ☸️ Azure Kubernetes Service (AKS)

## `bugz-dev-aks`

Azure Kubernetes Service is the core of this project.

It is responsible for orchestrating containers by:

- Scheduling workloads
- Monitoring pod health
- Restarting failed containers
- Performing rolling deployments
- Scaling applications

Azure manages the Kubernetes control plane, allowing me to focus on deploying applications rather than maintaining the cluster itself.

---

# 📦 Azure Container Registry (ACR)

## `bugzdevacrcoqm5xd77sduc`

Azure Container Registry stores the Docker images used by the Kubernetes cluster.

After building the application locally, the image is pushed to ACR, where AKS can securely pull it during deployment.

```text
Docker Build
      │
Docker Image
      │
Push
      │
Azure Container Registry
      │
Pull
      │
Azure Kubernetes Service
```

Think of it as a private Docker registry hosted inside Azure.

---

# 🌐 Virtual Network

## `bugz-dev-vnet`

The Virtual Network provides networking for the Kubernetes cluster.

It allows Azure resources to communicate securely while controlling how traffic enters and leaves the environment.

Even in a small project, networking plays an important role because every deployed resource needs a secure way to communicate.

---

# 📊 Log Analytics Workspace

## `bugz-dev-law`

The Log Analytics Workspace collects telemetry from the environment.

It stores:

- Application logs
- Kubernetes logs
- Performance metrics
- Diagnostic events

These logs become invaluable when troubleshooting issues or monitoring application health.

---

# 👀 Container Insights

## `ContainerInsights (bugz-dev-law)`

Container Insights builds on top of Log Analytics and provides monitoring specifically for AKS.

It allows me to quickly monitor:

- CPU usage
- Memory usage
- Node health
- Pod health
- Container restarts

Rather than searching through raw logs, Container Insights provides a centralized view of the cluster's health.

---

# ⚖️ Azure Load Balancer

The Azure Load Balancer is created inside the managed resource group.

Its job is to receive incoming traffic from the Internet and forward requests to the Kubernetes Service, which then routes traffic to one of the running application pods.

```text
Internet
    │
Azure Load Balancer
    │
Kubernetes Service
    │
Pod 1
Pod 2
```

Without the Load Balancer, the application would not be publicly accessible.

---

# 🖥️ Virtual Machine Scale Set (VMSS)

Containers still need virtual machines to run on.

AKS creates a Virtual Machine Scale Set to host the Kubernetes worker nodes.

Azure manages these virtual machines automatically by:

- Provisioning new nodes
- Replacing unhealthy nodes
- Scaling the cluster
- Applying updates

This means I never need to manually manage the underlying virtual machines.

---

# 🔐 Managed Identity

AKS uses Managed Identity to securely authenticate with Azure services.

For this project, the managed identity has the **AcrPull** role assigned, allowing the Kubernetes cluster to pull container images directly from Azure Container Registry.

This removes the need to store usernames, passwords, or registry credentials within the application.

---

# 🏗️ Putting It All Together

Each resource has a specific responsibility, but they work together as a single platform.

```text
                    Azure
                      │
        ┌─────────────┴─────────────┐
        │                           │
 Azure Container Registry      Azure Kubernetes Service
        │                           │
        │                     Virtual Machine Scale Set
        │                           │
        └──────────────┬────────────┘
                       │
              Azure Load Balancer
                       │
                  Bugz Application
```

Building this project helped me understand that deploying an application to AKS involves much more than just Kubernetes. Networking, monitoring, identity, container storage, and compute all work together to create a production-ready environment.
