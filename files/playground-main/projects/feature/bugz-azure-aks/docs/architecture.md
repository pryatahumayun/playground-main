# Architecture

High-level architecture:

Internet -> Azure Load Balancer -> AKS Cluster -> Bugz API Container

Components:
- Azure Container Registry (ACR) for images
- AKS cluster with system-assigned managed identity
- Log Analytics Workspace for monitoring
- Virtual Network with AKS subnet
