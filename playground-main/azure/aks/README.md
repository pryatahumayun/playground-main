# AKS

Azure Kubernetes Service is Azure's managed Kubernetes offering.

For shared Kubernetes concepts, manifests, and debugging examples, start here:

- [Kubernetes](/C:/Users/pryat/Downloads/playground-main/playground-main/kubernetes/README.md)

## Best fit

- teams already comfortable with Kubernetes
- workloads needing Kubernetes-native tooling
- platforms with multiple services, ingress, and cluster-level operations

## Main building blocks

- managed control plane
- system and user node pools
- CNI/networking choice
- ingress and load balancing
- add-ons like monitoring, CSI drivers, and policy

## Reliability notes

- the AKS control plane is zone resilient by default in supported regions
- node pools still need to be designed for zone resiliency
- pod replicas, autoscaling, and topology spread matter just as much as cluster setup

## Good to remember

- AKS reduces control-plane operations, not application architecture work
- zone support and node pool design should be chosen up front
- if you already know Kubernetes, most AKS complexity comes from Azure networking, identity, and surrounding services
- use the shared Kubernetes notes for Deployments, Services, probes, and general cluster patterns; use this file for Azure-specific AKS differences

References:

- AKS reliability: https://learn.microsoft.com/en-us/azure/reliability/reliability-aks
- AKS zone resiliency recommendations: https://learn.microsoft.com/en-us/azure/aks/reliability-zone-resiliency-recommendations
