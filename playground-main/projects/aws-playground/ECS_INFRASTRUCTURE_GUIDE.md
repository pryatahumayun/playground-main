# ECS Infrastructure Guide
## For Engineers Familiar with Azure but New to Terraform and AWS

---

## Table of Contents

1. [The Big Picture — Two Repos, One System](#1-the-big-picture)
2. [Azure-to-AWS Concept Map](#2-azure-to-aws-concept-map)
3. [Repository Structure Walk-through](#3-repository-structure-walk-through)
4. [The DRY Configuration Hierarchy](#4-the-dry-configuration-hierarchy)
5. [How a Service Gets Deployed — mfa-api-ecs-prodstage Explained](#5-how-a-service-gets-deployed)
6. [Key AWS Concepts Used Here](#6-key-aws-concepts-used-here)
7. [Creating a New Company's Infrastructure from Scratch](#7-creating-a-new-companys-infrastructure-from-scratch)
8. [Deploying a New ECS Service Step by Step](#8-deploying-a-new-ecs-service-step-by-step)
9. [Common Operations Cheatsheet](#9-common-operations-cheatsheet)
10. [Troubleshooting](#10-troubleshooting)

---

## 1. The Big Picture

This system is split into **two Git repositories** that work together:

```
infrastructure-modules/          ← The blueprints (Terraform code)
infrastructure-live/             ← The houses (what is actually deployed)
```

**Why two repos?**

Think of it like Azure Bicep modules stored in a shared template library vs. the parameter files that say "deploy *this* module into *this* subscription with *these* settings." The modules repo contains reusable building blocks. The live repo is purely configuration — it says *what* to deploy, *where*, and *with which values*. No Terraform resource code lives in the live repo.

### Tools involved

| Tool | Purpose | Azure equivalent |
|------|----------|-----------------|
| **Terraform** | Declares AWS infrastructure as code | ARM templates / Bicep |
| **Terragrunt** | A thin wrapper around Terraform that adds DRY config, dependency management, and remote state | Azure Deployment Stacks / parameter inheritance |
| **AWS CLI** | Authenticates and talks to AWS | Azure CLI (`az`) |

---

## 2. Azure-to-AWS Concept Map

Before diving in, here is a mental model for concepts you already know:

| Azure | AWS equivalent in this project |
|-------|-------------------------------|
| Subscription | AWS Account (each folder in `infrastructure-live/` is one account) |
| Resource Group | No direct equivalent — resources are tagged and organised by Terraform state file path |
| Azure Container Registry (ACR) | Amazon ECR (Elastic Container Registry) — lives in a dedicated `datacenter` account |
| Azure Kubernetes Service (AKS) | Amazon ECS on Fargate (the focus of this guide) |
| Azure Container Instances | ECS Fargate tasks |
| Azure Load Balancer / App Gateway | AWS Application Load Balancer (ALB) |
| Virtual Network (VNet) | VPC (Virtual Private Cloud) |
| Subnet | Subnet (same concept, same CIDR notation) |
| Azure Key Vault | AWS Secrets Manager |
| Azure Monitor | CloudWatch + Datadog (both used here) |
| Azure DevOps Pipelines / GitHub Actions | GitHub Actions (in `.github/workflows/`) |
| Bicep module registry | `infrastructure-modules` Git repo, pinned by git tag (`?ref=v5.370.0`) |
| Deployment parameter file | Leaf `terragrunt.hcl` file |
| Management Group | AWS Organizations (the `_payer` account is the organization root) |

---

## 3. Repository Structure Walk-through

### 3.1 infrastructure-modules

```
infrastructure-modules/
  modules/
    services/
      ecs_fargate/        ← Used by mfa-api and similar services (one service = own cluster + ALB)
      ecs_multi_service/  ← Shared cluster pattern (multiple services on one ALB)
      ecs_service/        ← Older pattern, do not use for new services
      ecs_cluster/        ← Standalone cluster (used as a dependency by ecs_multi_service)
      eks_cluster/
      ...
    networking/
      vpc/                ← Full VPC with subnets, NAT gateways, route tables
      alb/                ← Standalone Application Load Balancer
      security_group/
      ...
    data-stores/
      rds/
      elasticache/
      ...
    cloud-providers/
      aws/
      azure/              ← Yes, Azure modules exist too
    ...
  examples/               ← Working examples showing how to call each module
```

Each folder under `modules/` is a self-contained Terraform module with `main.tf`, `variables.tf`, and `outputs.tf`. You never edit these files when deploying — you only consume them from the live repo.

### 3.2 infrastructure-live

```
infrastructure-live/
  _payer/                 ← AWS Organizations root account (billing)
  mgmt/                   ← Management account (shared tools, flow logs)
  security/               ← Security/audit account
  datacenter/             ← ECR container image repositories (all accounts pull from here)
  prod/                   ← Production workloads
  staging_refresh/        ← Staging environment (mirrors prod config)
  dev/                    ← Developer environment
  sandbox/
    jwilliams/            ← Per-engineer sandbox accounts
    esmith/
    itops/
```

**Each top-level folder is a separate AWS account.** This is multi-account architecture — the Azure equivalent would be separate Azure subscriptions under a Management Group.

Inside each account folder, the structure is:

```
staging_refresh/
  account.hcl             ← Account identity (account ID, state bucket, environment name)
  terragrunt.hcl          ← Root config engine (generates providers, configures remote state)
  _global/                ← IAM roles (not region-specific)
  us-west-2/              ← A region
    region.hcl            ← Region identity
    shared_infra/
      vpc/                ← The VPC for this region
      security_groups/    ← Security groups
      vpc_endpoints/
      ...
    certificates/         ← ACM TLS certificates
    services/
      mfa-api-ecs-prodstage/    ← ← ← A specific service deployment
      commflow-ecs-prodstage/
      ecs_clusters/             ← Shared ECS clusters (for ecs_multi_service pattern)
      ...
    data-stores/
    lambda/
    ...
```

---

## 4. The DRY Configuration Hierarchy

**DRY = Don't Repeat Yourself.** Terragrunt's main job is to prevent you from copy-pasting your account ID, region, and provider config into every single service file.

There are four levels. Each level inherits everything from the level above it automatically.

```
Level 1: account.hcl          "I am the staging-refresh account (ID: <STAGING_ACCOUNT_ID>)"
             ↓
Level 2: region.hcl           "I am in us-west-2"
             ↓
Level 3: terragrunt.hcl       "Here is the AWS provider config, here is the S3 remote state bucket"
(account root)                 "Auto-attach these shared inputs to every service: env, region, account_id, tags"
             ↓
Level 4: services/mfa-api-ecs-prodstage/terragrunt.hcl
                               "Use module ecs_fargate@v5.370.0, here are my specific inputs"
```

When you run `terragrunt apply` inside `mfa-api-ecs-prodstage/`, Terragrunt walks up the directory tree, finds the root `terragrunt.hcl`, which in turn reads `account.hcl` and `region.hcl`. All that data flows down automatically to your service — you never have to repeat the account ID.

### 4.1 account.hcl — What it contains

```hcl
# staging_refresh/account.hcl
locals {
  account_name   = "staging-refresh"
  aws_account_id = "<STAGING_ACCOUNT_ID>"
  env            = "staging-refresh"
  state_bucket   = "<YOUR_COMPANY>-terraform-state-staging-refresh"   # Where Terraform state is stored
  state_lock_table = "<YOUR_COMPANY>-terraform-locks-staging-refresh" # Prevents concurrent applies
}
```

This is pure data — just local variables. Think of it as a parameter file for the subscription level.

### 4.2 region.hcl — What it contains

```hcl
# staging_refresh/us-west-2/region.hcl
locals {
  region             = "us-west-2"
  availability_zone  = "us-west-2a"
  replication_region = "us-east-2"
}
```

Again, pure data. The Azure equivalent is your `location` parameter.

### 4.3 The root terragrunt.hcl — The engine

This is the most important file. It does three things:

**Thing 1 — Reads account.hcl and region.hcl:**
```hcl
locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Now locals.account_vars.locals.aws_account_id etc. are available
}
```

**Thing 2 — Configures remote state (where Terraform state is stored):**
```hcl
remote_state {
  backend = "s3"
  config = {
    bucket         = local.account_vars.locals.state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region_vars.locals.region
    dynamodb_table = local.account_vars.locals.state_lock_table
  }
}
```
`path_relative_to_include()` evaluates to the service's path relative to this file — e.g. `us-west-2/services/mfa-api-ecs-prodstage`. So each service's Terraform state is stored at a unique S3 path. This is equivalent to a separate Azure deployment scope per service.

**Thing 3 — Generates the AWS provider and exports shared inputs:**
```hcl
generate "provider" {
  # Creates provider.tf on the fly with the right AWS account, region, and profiles
}

inputs = {
  env            = local.account_vars.locals.env
  region         = local.region_vars.locals.region
  aws_account_id = local.account_vars.locals.aws_account_id
  default_tags   = { ... }
}
```
Every module in this account automatically receives `env`, `region`, `aws_account_id`, and `default_tags` without you having to set them.

### 4.4 How modules reference each other (dependencies)

Services often need outputs from other services. For example, `mfa-api-ecs-prodstage` needs the VPC ID from the `vpc` module. This is done with `dependency` blocks:

```hcl
dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-west-2/shared_infra/vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id   # reads the vpc module's output
}
```

Terragrunt reads the remote state of the `vpc` module and makes its outputs available. You never hardcode a VPC ID — it is always fetched live from state. The Azure equivalent would be referencing the output of a previous deployment in a Deployment Stack.

---

## 5. How a Service Gets Deployed

Let us trace exactly what `staging_refresh/us-west-2/services/mfa-api-ecs-prodstage/terragrunt.hcl` does.

### 5.1 The file, annotated

```hcl
terraform {
  # Pin to a specific version of the ecs_fargate module.
  # git@github.com:org/infrastructure-modules.git  ← the repo
  # //modules/services/ecs_fargate                  ← subdirectory within the repo
  # ?ref=v5.370.0                                   ← exact git tag (like a Bicep module version)
  source = "git@github.com:<YOUR_ORG>/infrastructure-modules.git//modules/services/ecs_fargate?ref=v5.370.0"
}

include {
  # This triggers the 4-level hierarchy described above.
  # "Walk up until you find a terragrunt.hcl" — finds the account root one.
  path = find_in_parent_folders()
}

# Declare what this service depends on and which outputs it needs
dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-west-2/shared_infra/vpc"
}
dependency "cert" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-west-2/certificates/internal-staging-mfa-api.<YOUR_DOMAIN>"
}
dependency "lb_security_group" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-west-2/shared_infra/security_groups/mfa-api-staging-lb"
}
dependency "vpn_security_group" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-west-2/shared_infra/security_groups/vpn-web-traffic"
}

inputs = {
  # ---- Identity (auto-inherited, but shown for clarity) ----
  # env, region, aws_account_id come from root terragrunt.hcl automatically

  # ---- Networking (from VPC dependency outputs) ----
  vpc_id             = dependency.vpc.outputs.vpc_id
  vpc_cidr           = dependency.vpc.outputs.vpc_cidr_block
  private_subnet_ids = [
    dependency.vpc.outputs.primary_private_main_subnet_id,
    dependency.vpc.outputs.secondary_private_main_subnet_id,
  ]
  public_subnet_ids = [
    dependency.vpc.outputs.primary_public_main_subnet_id,
    dependency.vpc.outputs.secondary_public_main_subnet_id,
  ]

  # ---- Container image ----
  service_name      = basename(get_terragrunt_dir())   # = "mfa-api-ecs-prodstage"
  container_name    = "mfa-api"                        # ECR repository name in datacenter account
  container_port    = 8080
  container_version = "prodstage"                      # Docker image tag to pull

  container_health_check_command = ["CMD-SHELL", "curl --fail http://localhost:8080/healthz || exit 1"]

  # ---- Load balancer ----
  acm_certificate_arn       = dependency.cert.outputs.certificate_arn
  lb_is_internal            = true    # Not internet-facing — only reachable via VPN
  lb_security_group         = dependency.lb_security_group.outputs.security_group_id
  lb_security_group_ingress = dependency.vpn_security_group.outputs.security_group_id
  health_check_path         = "/livez"
  enable_lb_deletion_protection = false

  enable_ecs_exec = true  # Allows "exec into" running container for debugging (like kubectl exec)

  # ---- Plaintext environment variables ----
  environment = {
    ASPNETCORE_ENVIRONMENT            = "ProdStage"
    OTEL_EXPORTER_OTLP_ENDPOINT       = "https://staging-otel-eks.<YOUR_DOMAIN>"
    OTEL_LOGS_EXPORTER                = "otlp"
    OTEL_SERVICE_NAME                 = "mfa-api"
    OTEL_EXPORTER_OTLP_PROTOCOL       = "http/protobuf"
  }

  # ---- Secrets from AWS Secrets Manager (like Azure Key Vault references) ----
  # Format: "ENV_VAR_NAME" = "full ARN of the secret:json-key::"
  secrets = {
    "ConnectionStrings__Redis" = "arn:aws:secretsmanager:us-west-2:<STAGING_ACCOUNT_ID>:secret:/<YOUR_COMPANY>/mfa-api/connection-strings-XXXXXX:redis::"
  }

  # ---- Datadog monitoring sidecar (always present — injected automatically by the module) ----
  datadog_environment = {
    "DD_OTLP_CONFIG_RECEIVER_PROTOCOLS_HTTP_ENDPOINT" = "0.0.0.0:4318"
  }
  datadog_secrets = {
    "DD_API_KEY" = "arn:aws:secretsmanager:us-west-2:<STAGING_ACCOUNT_ID>:secret:/<YOUR_COMPANY>/datadog/api-key-XXXXXX::"
  }

  # ---- Cost allocation tags ----
  tags = {
    pci      = false
    dmz      = false
    function = "api"
    app      = "mfa-api"
  }
}
```

### 5.2 What the ecs_fargate module creates

When you run `terragrunt apply` on that file, the `ecs_fargate` module creates **4 AWS resources** automatically:

```
1. CloudWatch Log Group      → /<YOUR_COMPANY>/mfa-api
                               (stores container stdout/stderr — like Azure Log Analytics)

2. ECS Cluster               → mfa-api-ecs-prodstage
                               (the compute plane — like an AKS node pool, but serverless)

3. ECS Service               → mfa-api-ecs-prodstage
   ├── App container         → pulled from ECR: <DATACENTER_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com/mfa-api:prodstage
   └── Datadog sidecar       → always injected automatically

4. Application Load Balancer → mfa-api-ecs-prodstage
   ├── HTTP listener (80)    → redirects to HTTPS
   └── HTTPS listener (443)  → forwards to ECS target group, enforces TLS 1.3
```

The container image URI is constructed inside the module using the `datacenter` AWS provider alias — it calls `data "aws_caller_identity" "datacenter"` to get the datacenter account ID at plan time, so you never hardcode it.

### 5.3 prod vs staging_refresh — what actually differs

These two environments run the same module. The differences are minimal:

| Field | staging_refresh | prod |
|-------|----------------|------|
| `container_version` | `"prodstage"` | `"latest"` |
| `ASPNETCORE_ENVIRONMENT` | `"ProdStage"` | `"Production"` |
| Module version (`?ref=`) | `v5.370.0` | `v5.282.0` |
| Certificate domain | `internal-staging-mfa-api.<YOUR_DOMAIN>` | `internal-mfa-api.<YOUR_DOMAIN>` |
| Account ID in secret ARNs | `<STAGING_ACCOUNT_ID>` | `<PROD_ACCOUNT_ID>` |

Everything else — the module code, the networking pattern, the variable names — is identical. This is the power of the DRY pattern.

---

## 6. Key AWS Concepts Used Here

### 6.1 ECS Fargate (the compute layer)

ECS = Elastic Container Service. Fargate is the serverless launch type — you do not manage EC2 instances. You define a **Task Definition** (container image, CPU, memory, env vars, secrets, ports) and a **Service** (desired count, auto-scaling rules, load balancer attachment). AWS handles placing and running the containers.

Azure equivalent: Azure Container Apps or ACI (Azure Container Instances). Very similar concept.

### 6.2 ECR (Elastic Container Registry)

AWS's private Docker registry. All container images in this project live in the **datacenter account**. Every other account's ECS services pull from there using cross-account IAM permissions. One ECR repository per application (e.g. `mfa-api`, `commflow`, etc.).

To push a new image: `docker push <DATACENTER_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com/my-app:my-tag`

### 6.3 VPC and Subnets

The VPC is a private network. Each environment has one VPC with two types of subnets:

- **Public subnets** — have a route to the internet via an Internet Gateway. Only used for load balancers that need to be internet-facing.
- **Private subnets** — no direct internet route. ECS tasks run here. They reach the internet via a NAT Gateway (outbound only). Most services in this project are internal-only, so the ALB is also in private subnets.

The `main` vs `pci` subnet distinction in the VPC module: `main` subnets are for regular workloads; `pci` subnets are for payment card industry (PCI-DSS compliant) workloads with stricter access controls.

### 6.4 Security Groups

Security groups are stateful firewalls attached to resources (like Azure NSGs but per-resource, not per-subnet). In this project:

- The **ALB security group** controls what can send traffic to the load balancer (ingress from VPN CIDR on port 443).
- The **ECS task security group** (auto-created by the module) allows ingress from the ALB security group on the container port.

### 6.5 AWS Secrets Manager

Like Azure Key Vault. Secrets are stored as JSON documents at a path like `/<YOUR_COMPANY>/mfa-api/connection-strings`. ECS injects them as environment variables at task startup — the application sees them as plain env vars and never needs SDK code to fetch them.

The ARN format with the trailing `:key::` suffix extracts a specific JSON key:
```
arn:aws:secretsmanager:us-west-2:<STAGING_ACCOUNT_ID>:secret:/<YOUR_COMPANY>/mfa-api/connection-strings-XXXXXX:redis::
                                                                                                                 ^^^^^ this key
```

### 6.6 ACM (AWS Certificate Manager)

Like Azure App Service Managed Certificates or Let's Encrypt on Azure. ACM issues and auto-renews TLS certificates. You request a cert for a domain, validate via DNS, and then reference the ARN in your load balancer config.

---

## 7. Creating a New Company's Infrastructure from Scratch

This section walks through setting up a completely new company using the same pattern. We'll call the new company **"acme"**.

### 7.1 Prerequisites

Before writing any Terraform:

1. **AWS account(s) created** — at minimum one account for the workloads. Ideally follow the multi-account pattern: `acme-prod`, `acme-staging`, `acme-dev`, `acme-datacenter` (for ECR).
2. **AWS CLI configured** — run `aws configure --profile acme-staging-tf` and set up credentials for each account.
3. **S3 bucket for Terraform state** — create manually (or via CloudFormation): `acme-terraform-state-staging`. Must have versioning enabled.
4. **DynamoDB table for state locking** — create manually: `acme-terraform-locks-staging`. Primary key: `LockID` (String).
5. **SSH key or GitHub token** — to pull from `infrastructure-modules` via `git@github.com:...`.

### 7.2 Fork or copy infrastructure-modules

Option A (same org, new modules repo): Fork `infrastructure-modules` into the new company's GitHub org. Modules are generic enough to reuse — you may only need to change default tags or naming conventions.

Option B (reference the existing repo): If the modules are designed to be shared, reference the existing repo with `?ref=` tags as-is.

### 7.3 Set up the infrastructure-live structure for acme

Create the following files:

#### Step 1 — Account-level files

```
acme-staging/
  account.hcl
  terragrunt.hcl
```

**`acme-staging/account.hcl`:**
```hcl
locals {
  account_name     = "acme-staging"
  aws_account_id   = "123456789012"      # your real account ID
  env              = "staging"
  state_bucket     = "acme-terraform-state-staging"
  state_lock_table = "acme-terraform-locks-staging"
}
```

**`acme-staging/terragrunt.hcl`** — copy from `staging_refresh/terragrunt.hcl` and change:
- The AWS CLI profile name (e.g. `<ENV>-developer-tf` → `acme-staging-tf`)
- The account ID references if hardcoded
- The `default_tags` to reflect your company name and tagging standards
- Remove the `datacenter` provider alias if you are not using a separate ECR account

#### Step 2 — Region files

```
acme-staging/us-east-1/
  region.hcl
```

**`acme-staging/us-east-1/region.hcl`:**
```hcl
locals {
  region             = "us-east-1"
  availability_zone  = "us-east-1a"
  replication_region = "us-west-2"
}
```

#### Step 3 — Deploy the VPC

```
acme-staging/us-east-1/shared_infra/vpc/
  terragrunt.hcl
```

```hcl
terraform {
  source = "git@github.com:YourOrg/infrastructure-modules.git//modules/networking/vpc?ref=v5.370.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name = "acme-staging"
  vpc_cidr = "10.50.0.0/19"

  vpc_subnets = {
    az1 = {
      availability_zone = "us-east-1a"
      public_subnets    = { main = "10.50.1.0/24" }
      private_subnets   = { main = "10.50.8.0/21" }
    }
    az2 = {
      availability_zone = "us-east-1b"
      public_subnets    = { main = "10.50.2.0/24" }
      private_subnets   = { main = "10.50.16.0/21" }
    }
  }
}
```

Deploy it:
```bash
cd acme-staging/us-east-1/shared_infra/vpc
terragrunt apply
```

#### Step 4 — Add your ECR repository

In your datacenter (or same) account, add the new app's ECR repo:

```
acme-datacenter/us-east-1/ecr/
  terragrunt.hcl
```

Add `"my-new-api"` to the `private_repositories` list in that module's inputs.

#### Step 5 — Request a TLS certificate

```
acme-staging/us-east-1/certificates/api.acme-staging.internal/
  terragrunt.hcl
```

```hcl
terraform {
  source = "git@github.com:YourOrg/infrastructure-modules.git//modules/certificates/acm?ref=v5.370.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  domain_name = "api.acme-staging.internal"
  # validation_method = "DNS" — you'll need to add the CNAME record to your DNS
}
```

#### Step 6 — Create security groups for the load balancer

```
acme-staging/us-east-1/shared_infra/security_groups/my-api-lb/
  terragrunt.hcl
```

---

## 8. Deploying a New ECS Service Step by Step

This section shows exactly how to add a new service (e.g. `my-new-api`) to an existing account, modelled on `mfa-api-ecs-prodstage`.

### Prerequisites checklist

Before creating the service directory, confirm these resources already exist:

- [ ] VPC deployed at `shared_infra/vpc` — outputs `vpc_id`, subnet IDs
- [ ] Security group for the ALB at `shared_infra/security_groups/my-new-api-lb`
- [ ] Security group controlling who reaches the LB (e.g. `shared_infra/security_groups/vpn-web-traffic`)
- [ ] ACM certificate at `certificates/api.acme-staging.internal`
- [ ] ECR repository `my-new-api` in the datacenter account with an image pushed to it
- [ ] Secret(s) created in AWS Secrets Manager (if the app needs them)

### Step 1 — Create the service directory

```
acme-staging/us-east-1/services/my-new-api/
  terragrunt.hcl
```

### Step 2 — Write the terragrunt.hcl

```hcl
terraform {
  source = "git@github.com:YourOrg/infrastructure-modules.git//modules/services/ecs_fargate?ref=v5.370.0"
}

include {
  path = find_in_parent_folders()
}

# ---- Declare dependencies ----

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-east-1/shared_infra/vpc"
}

dependency "cert" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-east-1/certificates/api.acme-staging.internal"
}

dependency "lb_security_group" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-east-1/shared_infra/security_groups/my-new-api-lb"
}

dependency "vpn_security_group" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-east-1/shared_infra/security_groups/vpn-web-traffic"
}

# ---- Module inputs ----

inputs = {
  # service_name uses the directory name automatically — keep the directory name meaningful
  service_name = basename(get_terragrunt_dir())

  # Container image — ECR repo name and image tag
  container_name    = "my-new-api"
  container_port    = 8080
  container_version = "staging"    # the Docker image tag you pushed to ECR

  # Health checks
  health_check_path              = "/healthz"
  container_health_check_command = ["CMD-SHELL", "curl --fail http://localhost:8080/healthz || exit 1"]

  # Networking (wired from VPC dependency — never hardcode these)
  vpc_id             = dependency.vpc.outputs.vpc_id
  vpc_cidr           = dependency.vpc.outputs.vpc_cidr_block
  private_subnet_ids = [
    dependency.vpc.outputs.primary_private_main_subnet_id,
    dependency.vpc.outputs.secondary_private_main_subnet_id,
  ]
  public_subnet_ids = [
    dependency.vpc.outputs.primary_public_main_subnet_id,
    dependency.vpc.outputs.secondary_public_main_subnet_id,
  ]

  # Load balancer
  acm_certificate_arn           = dependency.cert.outputs.certificate_arn
  lb_is_internal                = true   # true = only reachable via VPN; false = internet-facing
  lb_security_group             = dependency.lb_security_group.outputs.security_group_id
  lb_security_group_ingress     = dependency.vpn_security_group.outputs.security_group_id
  enable_lb_deletion_protection = false  # set true in production

  # Optional: allow exec into running containers (useful for debugging; disable in prod)
  enable_ecs_exec = true

  # Compute sizing (these are the defaults — only override if needed)
  task_cpu    = 1024   # 1 vCPU
  task_memory = 2048   # 2 GB RAM

  # Auto-scaling
  desired_task_count       = 1
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 5

  # Plaintext environment variables
  environment = {
    MY_APP_ENV    = "staging"
    LOG_LEVEL     = "info"
    SERVICE_NAME  = "my-new-api"
  }

  # Secrets from AWS Secrets Manager
  # Format: "ENV_VAR_NAME" = "full ARN:json-key::"
  secrets = {
    "DB_PASSWORD" = "arn:aws:secretsmanager:us-east-1:<YOUR_ACCOUNT_ID>:secret:/acme/my-new-api/db-XXXXXX:password::"
  }

  # Datadog sidecar (always required if your org uses Datadog)
  datadog_environment = {
    "DD_OTLP_CONFIG_RECEIVER_PROTOCOLS_HTTP_ENDPOINT" = "0.0.0.0:4318"
  }
  datadog_secrets = {
    "DD_API_KEY" = "arn:aws:secretsmanager:us-east-1:<YOUR_ACCOUNT_ID>:secret:/acme/datadog/api-key-XXXXXX::"
  }

  # Cost allocation tags
  tags = {
    function = "api"
    app      = "my-new-api"
    pci      = false
    dmz      = false
  }
}
```

### Step 3 — Run plan to see what will be created

```bash
cd acme-staging/us-east-1/services/my-new-api
terragrunt plan
```

You will see a plan showing the creation of:
- `aws_cloudwatch_log_group.this`
- `module.ecs_cluster.*` (ECS cluster)
- `module.ecs_service.*` (ECS service, task definition, security group, auto-scaling)
- `module.alb.*` (ALB, listeners, target group)
- Various IAM roles

Review the plan and verify the resource names, VPC IDs, and subnet IDs look correct.

### Step 4 — Apply

```bash
terragrunt apply
```

Type `yes` when prompted. The first apply typically takes 3–5 minutes (ALB provisioning takes the longest).

### Step 5 — Verify the deployment

```bash
# Get the ALB DNS name from Terraform outputs
terragrunt output alb_dns_name

# Test health check (replace with actual DNS name)
curl https://api.acme-staging.internal/healthz

# Check ECS service status in AWS console or CLI
aws ecs describe-services \
  --cluster my-new-api \
  --services my-new-api \
  --region us-east-1 \
  --profile acme-staging-tf
```

If `enable_ecs_exec = true`, you can shell into a running container:
```bash
aws ecs execute-command \
  --cluster my-new-api \
  --task <task-id> \
  --container my-new-api \
  --interactive \
  --command "/bin/sh" \
  --region us-east-1 \
  --profile acme-staging-tf
```
This is the equivalent of `kubectl exec -it <pod> -- /bin/sh`.

---

## 9. Common Operations Cheatsheet

### Deploying / updating a service

```bash
# Always run from the service directory
cd infrastructure-live/staging_refresh/us-west-2/services/mfa-api-ecs-prodstage

# Preview changes
terragrunt plan

# Apply changes
terragrunt apply

# Destroy (DANGEROUS — prompts for confirmation)
terragrunt destroy
```

### Upgrading the module version

1. Open the service's `terragrunt.hcl`
2. Change `?ref=v5.370.0` to the new version (e.g. `?ref=v5.400.0`)
3. Run `terragrunt init` to download the new module version
4. Run `terragrunt plan` to see what changes
5. Run `terragrunt apply`

### Deploying multiple services at once

```bash
# Run apply for all services under a path
cd infrastructure-live/staging_refresh/us-west-2/services
terragrunt run-all apply

# Preview all
terragrunt run-all plan
```

`run-all` respects `dependency` blocks — it deploys in the correct order automatically.

### Viewing outputs of a module

```bash
cd infrastructure-live/staging_refresh/us-west-2/shared_infra/vpc
terragrunt output
```

### Clearing the module cache

If you get errors about stale cached modules:
```bash
find . -name ".terragrunt-cache" -type d -exec rm -rf {} +
```

### Checking remote state (where is my state file?)

The S3 key follows `path_relative_to_include()` — so for `staging_refresh/us-west-2/services/mfa-api-ecs-prodstage/`, the state file is at:

```
s3://<YOUR_COMPANY>-terraform-state-staging-refresh/us-west-2/services/mfa-api-ecs-prodstage/terraform.tfstate
```

---

## 10. Troubleshooting

### "Error acquiring the state lock"

Another `terragrunt apply` is running (or a previous one crashed). Check the DynamoDB table for your environment (the `state_lock_table` value in `account.hcl`) and delete the stale lock item if you are sure no other process is running.

### "No valid credential sources found"

Your AWS CLI profile is not configured or has expired credentials. Run:
```bash
aws sts get-caller-identity --profile <YOUR_ENV>-developer-tf
```
If it fails, refresh your credentials (usually via SSO: `aws sso login --profile <YOUR_ENV>-developer-tf`).

### "Error: Could not load module"

The `?ref=` version tag does not exist in the modules repo, or you do not have SSH access. Check:
1. `git ls-remote git@github.com:<YOUR_ORG>/infrastructure-modules.git refs/tags/v5.370.0` — does the tag exist?
2. Is your SSH key authorised for the org?

### "dependency output not found"

The dependency module (e.g. `vpc`) has not been applied yet, or it was applied with a different version of the module that did not produce that output. Apply the dependency first:
```bash
cd infrastructure-live/staging_refresh/us-west-2/shared_infra/vpc
terragrunt apply
```

### ECS task keeps failing to start

Check CloudWatch Logs first:
```bash
aws logs get-log-events \
  --log-group-name /<YOUR_COMPANY>/mfa-api \
  --log-stream-name <stream-name> \
  --region us-west-2 \
  --profile <YOUR_ENV>-developer-tf
```

Common causes:
- Wrong image tag (`container_version`) — image does not exist in ECR
- Missing or wrong secret ARN — ECS cannot pull the secret at task start
- Health check failing — app starts but `/healthz` returns non-200; check container logs
- Insufficient CPU/memory — increase `task_cpu` and `task_memory`

### "Error: AccessDeniedException" on secrets

The ECS task execution role does not have permission to read the secret. The module auto-grants access to secrets listed in the `secrets` input, but only if the ARN is correct. Verify:
1. The secret path exists in Secrets Manager (check the AWS console)
2. The account ID in the ARN matches the account you are deploying into
3. The secret ARN suffix (`-XXXXXX`) matches — Secrets Manager appends a random suffix to secret names

---

## Quick Reference: File Types

| File | What it is | When you edit it |
|------|-----------|------------------|
| `account.hcl` | Account identity data | When setting up a new account |
| `region.hcl` | Region identity data | When adding a new region |
| `<account>/terragrunt.hcl` | Root engine (providers, state, shared inputs) | When setting up a new account |
| `services/<name>/terragrunt.hcl` | Service deployment config | When deploying or changing a service |
| `modules/services/ecs_fargate/*.tf` | Module resource code | When changing shared module behaviour (affects all consumers) |
| `modules/services/ecs_fargate/variables.tf` | Module input definitions | When adding new configurable options to the module |

---

*This guide covers the state of the infrastructure as of July 2026. Module versions referenced are examples — always check the latest tag in `infrastructure-modules` before deploying new services.*
