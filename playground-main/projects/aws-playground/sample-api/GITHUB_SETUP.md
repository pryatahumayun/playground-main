# GitHub Repository Setup

Before the workflows will run, configure the following in your GitHub repository settings.

---

## Secrets (Settings → Secrets and variables → Actions → Secrets)

These are org-level or repo-level secrets shared across all environments:

| Secret name | Description |
|-------------|-------------|
| `SECURITY_AWS_ACCESS_KEY_ID` | Access key ID for the CI IAM user (has permission to assume deployer roles) |
| `SECURITY_AWS_SECRET_ACCESS_KEY` | Secret key for the CI IAM user |
| `DATADOG_API_KEY` | Datadog API key — used by the `aws-auth-with-egress-audit` shared action |

---

## Variables (Settings → Secrets and variables → Actions → Variables)

### Repository-level variables (shared across all environments)

| Variable | Example value | Description |
|----------|---------------|-------------|
| `ECR_REPOSITORY` | `sample-api` | ECR repository name (must match the name in your Terraform ECR resource) |

---

## Environments (Settings → Environments)

Create two environments: **`staging`** and **`prod`**.

Each environment has its own set of variables and optional approval rules.

### `staging` environment variables

| Variable | Example value | Description |
|----------|---------------|-------------|
| `ECR_DEPLOYER_ROLE` | `arn:aws:iam::STAGING_ACCOUNT_ID:role/sample-api-ecr-deployer` | Role in the ECR/staging account used to push images |
| `DEPLOYER_ROLE` | `arn:aws:iam::STAGING_ACCOUNT_ID:role/sample-api-ecs-deployer` | Role in the staging account used to force ECS deployments |
| `ECS_CLUSTER_NAME` | `sample-api-staging` | ECS cluster name (matches Terraform output `cluster_name`) |
| `ECS_SERVICE_NAME` | `sample-api-staging` | ECS service name (matches Terraform output `service_name`) |
| `ECS_SERVICE_URL` | `http://sample-api-staging.internal.example.com` | URL shown in the deployment summary (informational only) |

### `prod` environment variables

| Variable | Example value | Description |
|----------|---------------|-------------|
| `ECR_DEPLOYER_ROLE` | `arn:aws:iam::PROD_ACCOUNT_ID:role/sample-api-ecr-deployer` | Role in the ECR/prod account used to push images |
| `DEPLOYER_ROLE` | `arn:aws:iam::PROD_ACCOUNT_ID:role/sample-api-ecs-deployer` | Role in the prod account used to force ECS deployments |
| `ECS_CLUSTER_NAME` | `sample-api-prod` | ECS cluster name |
| `ECS_SERVICE_NAME` | `sample-api-prod` | ECS service name |
| `ECS_SERVICE_URL` | `http://sample-api.internal.example.com` | URL shown in the deployment summary |

### Production approval gate (recommended)

In the `prod` environment settings, add required reviewers. This means the
`promote.yml` workflow will pause and wait for a human to approve before
deploying to production.

---

## IAM roles required in AWS

Two roles per environment must exist and trust the CI IAM user to assume them:

### `sample-api-ecr-deployer` (in the ECR account)
Needs:
- `ecr:GetAuthorizationToken`
- `ecr:BatchCheckLayerAvailability`
- `ecr:PutImage`
- `ecr:InitiateLayerUpload`
- `ecr:UploadLayerPart`
- `ecr:CompleteLayerUpload`
- `ecr:BatchGetImage`

### `sample-api-ecs-deployer` (in the staging / prod account)
Needs:
- `ecs:UpdateService`
- `ecs:DescribeServices`
- `ecs:DescribeTaskDefinition`
- `ecs:RegisterTaskDefinition`
- `iam:PassRole` (scoped to the ECS execution role and task role)

---

## AWS auth action

The `aws-auth-with-egress-audit` composite action is bundled directly in this repo at:
```
.github/actions/aws-auth-with-egress-audit/action.yml
```
All workflows reference it locally (`uses: ./.github/actions/aws-auth-with-egress-audit`),
so no external `sharedActions` repo access is needed to run this project.
