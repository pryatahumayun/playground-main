# EKS

Amazon EKS is AWS's managed Kubernetes service. It runs the Kubernetes control plane for you and integrates the cluster with AWS networking, IAM, and load balancing.

For shared Kubernetes concepts, manifests, and debugging examples, start here:

- [Kubernetes](/C:/Users/pryat/Downloads/playground-main/playground-main/kubernetes/README.md)

If you already know Kubernetes well, the main EKS learning curve is usually not Kubernetes itself. It is the AWS-specific plumbing around:

- VPC networking
- IAM
- load balancers
- managed node groups or Fargate
- cluster upgrades

## What EKS manages vs what you manage

AWS manages:

- the Kubernetes control plane
- etcd and control plane availability
- control plane patching and operations

You still manage:

- workloads
- cluster add-ons
- node groups or Fargate profiles
- networking design
- RBAC
- cost and scaling decisions

So EKS reduces Kubernetes operations, but it does not remove platform engineering work.

## Core EKS building blocks

### Cluster

The EKS cluster is the managed Kubernetes control plane.

Important decisions:

- Kubernetes version
- VPC and subnet placement
- public vs private endpoint access
- add-on strategy

### Compute

Your main choices are:

- managed node groups
- self-managed nodes
- Fargate profiles

In practice:

- managed node groups are the common default
- self-managed nodes give more control but more operational work
- Fargate profiles can reduce node management, but not every workload pattern fits well

### Add-ons

Common EKS add-ons include:

- VPC CNI
- CoreDNS
- kube-proxy
- AWS Load Balancer Controller
- EBS CSI driver

These are usually where EKS stops feeling like "just Kubernetes" and starts feeling like "Kubernetes on AWS."

Reference:

- EKS networking add-ons: https://docs.aws.amazon.com/eks/latest/userguide/eks-networking-add-ons.html

## EKS networking

Networking is one of the most important EKS topics.

Pods and services are still Kubernetes concepts, but EKS maps them into AWS VPC behavior.

Main things to understand:

- which subnets the cluster uses
- pod IP allocation
- security groups
- how Services and Ingresses create AWS load balancers

Typical layout:

- public subnets for internet-facing load balancers
- private subnets for nodes and workloads
- NAT or other egress strategy for private workloads

If the networking model is wrong, the cluster may be technically healthy but still painful to operate.

## Ingress and load balancing

In EKS, Kubernetes resources often lead to AWS load balancers being created.

The most common pattern is:

- `Ingress` -> ALB through AWS Load Balancer Controller
- `Service type: LoadBalancer` -> usually NLB through AWS Load Balancer Controller

This is a key EKS mental model:

- Kubernetes object declares intent
- AWS controller creates the cloud resource

AWS recommends using the AWS Load Balancer Controller rather than relying on older legacy controller behavior.

References:

- AWS Load Balancer Controller for ALB: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
- NLB with EKS: https://docs.aws.amazon.com/eks/latest/userguide/network-load-balancing.html

## IAM in EKS

IAM is a major EKS-specific concern.

There are two separate areas to think about:

- human/admin access to the cluster
- workload access to AWS services

For workloads, the classic EKS pattern is:

- IAM Roles for Service Accounts, often called IRSA

This lets a Kubernetes service account assume a specific IAM role so a pod can call AWS APIs without using static credentials.

That matters for controllers and apps that need access to:

- S3
- DynamoDB
- Secrets Manager
- Route 53
- CloudWatch

Reference:

- IRSA / service account roles: https://docs.aws.amazon.com/eks/latest/eksctl/iamserviceaccounts.html

## EKS Auto Mode

AWS now has EKS Auto Mode, which pushes more infrastructure management into AWS, especially around networking and load balancing behavior.

That can simplify operations, but it also changes the usual mental model a bit because AWS is managing more of the lower-level cluster mechanics for you.

Reference:

- EKS Auto Mode networking and load balancing: https://docs.aws.amazon.com/eks/latest/userguide/auto-networking.html

## Common architecture pattern

A common production-style EKS shape looks like:

1. create the cluster in a VPC
2. place worker nodes in private subnets
3. install core add-ons
4. install AWS Load Balancer Controller
5. deploy workloads with Kubernetes manifests or Helm
6. expose selected services through ALB or NLB
7. ship logs and metrics to CloudWatch or another observability stack

## Upgrade strategy

EKS upgrades are not just "click upgrade."

You usually need to think about:

- control plane version
- node group version
- add-on compatibility
- Kubernetes API deprecations
- ingress/controller compatibility

A safe upgrade flow is often:

1. review supported versions
2. upgrade the control plane
3. upgrade managed add-ons
4. roll node groups
5. verify workloads and ingress behavior

Reference:

- EKS doc history and version changes: https://docs.aws.amazon.com/eks/latest/userguide/doc-history.html

## When to choose EKS

EKS is a good fit when:

- you want portability across clusters or clouds
- you need advanced scheduling, operators, or ecosystem integrations

EKS is often not the best fit when:

- you just need to run a few containers
- you do not want cluster operations overhead
- ECS Fargate would meet the need with less complexity

## EKS vs ECS

Short version:

- choose `EKS` when you want Kubernetes
- choose `ECS` when you want containers on AWS with less platform complexity

EKS gives more ecosystem flexibility.
ECS is usually simpler to operate.

## Good to remember

- EKS is managed Kubernetes, not managed applications
- most real EKS complexity comes from AWS integration, not from `kubectl`
- use the shared Kubernetes notes for Deployments, Services, probes, and general cluster behavior; use this file for the AWS-specific parts
