
A self-contained template for deploying a containerised API to AWS ECS Fargate across two separate environments (staging and prod), each living in its own AWS account.

This folder is intended as a **starting point** — clone it, swap in your application code and AWS account IDs, and you have a production-grade ECS deployment pipeline ready to go.

---

## What is in this folder

```
pryata/
  infrastructure-modules/    Reusable Terraform building blocks (the blueprints)
  infrastructure-live/       Terragrunt configuration that deploys those blueprints (the houses)
  sample-api/                A working ASP.NET Core 8 API with GitHub Actions workflows
  scripts/                   One-time bootstrap helpers
  README.md                  This file
```

### infrastructure-modules

Pure Terraform code. Contains two modules:

| Module | What it creates |
|--------|----------------|
| `modules/networking/vpc` | VPC, public + private subnets across 2 AZs, NAT gateways, route tables |
| `modules/services/ecs_fargate` | ECS cluster, Fargate service, Application Load Balancer, ECR repository, IAM roles, CloudWatch log group, CPU auto-scaling |

You never run Terraform directly against these files. They are consumed by `infrastructure-live` via a source reference. Think of them as a library.

### infrastructure-live

Terragrunt configuration files — no Terraform resource code, only `.hcl` files that say "deploy this module with these inputs into this account". Organised in a 4-level hierarchy that eliminates repetition:

```
staging/
  account.hcl               → staging AWS account ID, state bucket name
  terragrunt.hcl            → generates provider.tf, wires up remote state, passes env/region to all children
  us-east-1/
    region.hcl              → region = us-east-1
    shared_infra/vpc/       → deploy the VPC first (other services depend on it)
    services/sample-api/    → deploy the ECS service (depends on vpc)
prod/
  (same structure, different values)
```

Each environment is a completely separate AWS account with its own state bucket, its own VPC, and its own ECS cluster.

### sample-api

A minimal but real ASP.NET Core 8 API that you can replace with your own application. It includes:

- `src/` — application source code with `/healthz` and `/livez` health check endpoints
- `Dockerfile` — multi-stage build, produces a lean runtime image
- `Makefile` — build, test, docker-build, docker-push, ECR tagging targets
- `.github/workflows/` — four GitHub Actions workflows that handle the full CI/CD pipeline
- `.github/actions/` — the `aws-auth-with-egress-audit` composite action (bundled locally so no external repo dependency)

### scripts

`bootstrap-state-backend.sh` — run this **once per environment** before the first `terragrunt apply`. It creates the S3 bucket and DynamoDB table that Terraform uses to store and lock state.

---

## How the pieces connect

```
 Pull Request
      │
      ▼
 ci.yml ──────────────────────────────────────────────────────────────────────
   Build app → Build Docker image → Push versioned image to ECR
   (image tag: 2024.07.15.1045-abc1234)

 Merge to main
      │
      ▼
 deploy.yml ──────────────────────────────────────────────────────────────────
   Build app → Build Docker image → Push versioned image to ECR
   → Create GitHub pre-release
   → Call template_deploy.yml with environment=staging
         │
         ▼
     template_deploy.yml
       Re-tag versioned image as :staging in ECR
       → Force new ECS deployment in staging account
       → ECS pulls :staging image → service is live

 Manual promote (or re-deploy)
      │
      ▼
 promote.yml (workflow_dispatch) ─────────────────────────────────────────────
   Choose a version tag + target environment (staging or prod)
   → Call template_deploy.yml
         │
         ▼
     template_deploy.yml
       Re-tag versioned image as :latest in ECR   (if prod)
       → Force new ECS deployment in prod account
       → Mark GitHub pre-release as stable release  (if prod)
```

Every AWS authentication step uses the bundled `aws-auth-with-egress-audit` action, which records the runner's public IP and ships an audit log to Datadog before configuring credentials.

---

## Prerequisites

Before running anything, you need:

- **Two AWS accounts** — one for staging, one for prod
- **AWS CLI** installed and configured with a profile per account
- **Terraform >= 1.5** and **Terragrunt** installed
- **Docker** installed (for building and pushing images)
- A **GitHub repository** with Actions enabled (for the CI/CD workflows)

---

## First-time setup

### Step 1 — Fill in your AWS account IDs

Open these two files and replace the placeholder values:

```
infrastructure-live/staging/account.hcl   ← set aws_account_id to your staging account ID
infrastructure-live/prod/account.hcl      ← set aws_account_id to your prod account ID
```

### Step 2 — Configure AWS CLI profiles

The root `terragrunt.hcl` files reference profiles named `pryata-staging-tf` and `pryata-prod-tf`. Create them:

```bash
aws configure --profile pryata-staging-tf
aws configure --profile pryata-prod-tf
```

If you use AWS SSO instead of long-term keys, set up SSO profiles with the same names.

### Step 3 — Bootstrap the remote state backends

Run once per environment. This creates the S3 bucket and DynamoDB lock table that Terraform needs before it can store any state:

```bash
chmod +x scripts/bootstrap-state-backend.sh

./scripts/bootstrap-state-backend.sh staging us-east-1 pryata-staging-tf
./scripts/bootstrap-state-backend.sh prod    us-east-1 pryata-prod-tf
```

### Step 4 — Deploy the VPC

The ECS service depends on the VPC, so deploy the VPC first:

```bash
cd infrastructure-live/staging/us-east-1/shared_infra/vpc
terragrunt apply
```

### Step 5 — Request a TLS certificate

In the AWS Console, go to Certificate Manager (ACM) and request a public certificate for your service domain (e.g. `api.pryata-staging.example.com`). Validate it via DNS by adding the CNAME record it gives you.

Once issued, copy the certificate ARN and paste it into:

```
infrastructure-live/staging/us-east-1/services/sample-api/terragrunt.hcl
```

Replace the `REPLACE_WITH_STAGING_ACM_CERT_ARN` placeholder.

### Step 6 — Deploy the ECS service

```bash
cd infrastructure-live/staging/us-east-1/services/sample-api
terragrunt apply
```

This creates the ECS cluster, ALB, ECR repository, IAM roles, and CloudWatch log group. The ECR repository URL is printed in the outputs.

### Step 7 — Push your Docker image

The ECS service cannot start until there is an image in ECR. Push one:

```bash
# Get the ECR URL from Terraform outputs
REPO_URL=$(terragrunt output -raw ecr_repository_url)

# Authenticate Docker to ECR
aws ecr get-login-password --region us-east-1 --profile pryata-staging-tf \
  | docker login --username AWS --password-stdin "${REPO_URL}"

# Build and push from the sample-api directory
cd ../../../../sample-api
docker build -t sample-api .
docker tag sample-api:latest "${REPO_URL}:staging"
docker push "${REPO_URL}:staging"
```

Force ECS to pick up the new image:

```bash
aws ecs update-service \
  --cluster sample-api-staging \
  --service sample-api-staging \
  --force-new-deployment \
  --region us-east-1 \
  --profile pryata-staging-tf
```

Repeat steps 4–7 for `prod` (substituting `prod` and the prod profile throughout).

### Step 8 — Set up GitHub Actions

See `sample-api/GITHUB_SETUP.md` for the full list of secrets, variables, and IAM roles needed to run the CI/CD workflows. The short version:

1. Add repository secrets: `SECURITY_AWS_ACCESS_KEY_ID`, `SECURITY_AWS_SECRET_ACCESS_KEY`, `DATADOG_API_KEY`
2. Create two GitHub Environments (`staging` and `prod`) and set the per-environment variables listed in that file
3. Optionally add required reviewers to the `prod` environment to gate production deploys

Once set up, the pipeline is fully automated: push to `main` → staging deploys automatically → run the `Promote` workflow to deploy to prod.

---

## Replacing sample-api with your own application

1. Replace the contents of `sample-api/src/` with your application code
2. Update `sample-api/Dockerfile` if your app uses a different runtime or build process
3. Ensure your app exposes a `/healthz` endpoint — the ECS health check and ALB target group both call it
4. Update the `container_port` in the service `terragrunt.hcl` files if your app listens on a port other than `8080`
5. Update the `environment` and `secrets` blocks in both service `terragrunt.hcl` files with your app's config values

---

## Day-to-day operations

### Preview infrastructure changes before applying
```bash
cd infrastructure-live/staging/us-east-1/services/sample-api
terragrunt plan
```

### Apply infrastructure changes
```bash
terragrunt apply
```

### View all outputs (ALB URL, ECR repository URL, cluster name, etc.)
```bash
terragrunt output
```

### View live container logs
```bash
aws logs tail /ecs/sample-api-staging --follow \
  --region us-east-1 \
  --profile pryata-staging-tf
```

### Shell into a running container (staging — exec is enabled there)
```bash
TASK_ID=$(aws ecs list-tasks \
  --cluster sample-api-staging \
  --service-name sample-api-staging \
  --region us-east-1 \
  --profile pryata-staging-tf \
  --query 'taskArns[0]' --output text | awk -F/ '{print $NF}')

aws ecs execute-command \
  --cluster sample-api-staging \
  --task "${TASK_ID}" \
  --container sample-api-staging \
  --interactive \
  --command "/bin/sh" \
  --region us-east-1 \
  --profile pryata-staging-tf
```

### Tear down staging (prod has deletion protection enabled)
```bash
cd infrastructure-live/staging/us-east-1/services/sample-api
terragrunt destroy
```

### Promote a specific version to prod manually
Go to **Actions → Promote → Run workflow** in GitHub, enter the version tag (e.g. `2024.07.15.1045-abc1234`), and select `prod`.

---

## Environment differences at a glance

| Setting | staging | prod |
|---------|---------|------|
| AWS account | separate | separate |
| VPC CIDR | 10.10.0.0/16 | 10.20.0.0/16 |
| ALB | internet-facing | internal (VPN only) |
| ECR image tag watched | `staging` | `latest` |
| CPU | 256 units (0.25 vCPU) | 1024 units (1 vCPU) |
| Memory | 512 MiB | 2048 MiB |
| Running tasks | 1 | 2 (high availability) |
| Max tasks (auto-scaling) | 3 | 10 |
| Log retention | 30 days | 90 days |
| ALB deletion protection | off | on |
| ECS exec (shell access) | enabled | disabled |
