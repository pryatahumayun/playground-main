# Containers

Azure has several ways to run containers, and the right choice depends on how much orchestration you need.

## Main Azure container options

- Azure Container Instances
  Fastest path for single containers or small burst workloads.
- Azure Container Apps
  Managed container platform with HTTP scale, revisions, and simpler ops.
- Azure Kubernetes Service
  Managed Kubernetes when you want full cluster-level control.
- Azure Container Registry
  Image storage close to Azure workloads.

## Good fit by scenario

- choose `ACI` for quick one-off or simple runtime needs
- choose `Container Apps` for app workloads without wanting Kubernetes overhead
- choose `AKS` when Kubernetes itself is a requirement

## Good to remember

- "containers on Azure" is not one service
- the operational model matters as much as the runtime itself
