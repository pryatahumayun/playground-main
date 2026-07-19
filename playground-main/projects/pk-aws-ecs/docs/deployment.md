# Deployment

This document captures the exact first successful deployment flow used for `pk-aws-ecs` on Windows with:

- Terraform `v1.15.8`
- Terragrunt `v1.1.1`
- AWS profile `default`
- AWS account `181194339047`
- region `us-east-1`

The current implementation uses:

- local Terraform state
- a public HTTP Application Load Balancer
- Amazon ECR for the container image
- Amazon ECS Fargate for runtime

No ACM certificate or S3 remote state bucket is required for this version of the project.

## Deployment order

1. Verify AWS access
2. Deploy the VPC
3. Deploy the ECS/ECR/ALB service infrastructure
4. Log Docker into ECR
5. Build and push the container image
6. Force ECS to pull the new image
7. Open the ALB DNS name

## 1. Verify AWS access

From PowerShell:

```powershell
aws sts get-caller-identity --profile default
```

Expected account:

```text
181194339047
```

## 2. Terragrunt Windows cache workaround

On Windows, Terragrunt can hit path-length issues in deep `.terragrunt-cache` folders. Set a short cache directory before running `terragrunt`.

```powershell
New-Item -ItemType Directory -Force -Path C:\tgcache | Out-Null
$env:TG_DOWNLOAD_DIR = 'C:\tgcache'
$env:TG_TF_PATH = 'C:\Users\pryat\AppData\Local\Microsoft\WinGet\Packages\Hashicorp.Terraform_Microsoft.Winget.Source_8wekyb3d8bbwe\terraform.exe'
```

## 3. Deploy the VPC

```powershell
Set-Location 'C:\Users\pryat\Downloads\playground-main\playground-main\projects\pk-aws-ecs\infra\infrastructure-live\prod\us-east-1\shared_infra\vpc'
terragrunt init
terragrunt plan
terragrunt apply
```

Notes:

- This VPC creates public and private subnets in `us-east-1a` and `us-east-1b`
- It also creates `2` NAT Gateways, which adds baseline AWS cost

## 4. Deploy the ECS service stack

```powershell
Set-Location 'C:\Users\pryat\Downloads\playground-main\playground-main\projects\pk-aws-ecs\infra\infrastructure-live\prod\us-east-1\services\pk-api'
terragrunt init
terragrunt plan
terragrunt apply
```

This step creates:

- Amazon ECR repository `pk-api`
- ECS cluster `pk-api-prod`
- ECS service `pk-api-prod`
- Application Load Balancer
- CloudWatch log group
- IAM roles and policies

## 5. Get the ECR repository URL

```powershell
terragrunt output -raw ecr_repository_url
```

Expected value:

```text
181194339047.dkr.ecr.us-east-1.amazonaws.com/pk-api
```

## 6. Log Docker into ECR

The standard `--password-stdin` approach returned `400 Bad Request` in PowerShell on this machine. The working PowerShell login was:

```powershell
$password = aws ecr get-login-password --region us-east-1 --profile default
docker login --username AWS --password $password 181194339047.dkr.ecr.us-east-1.amazonaws.com
```

Expected result:

```text
Login Succeeded
```

## 7. Build and push the image

```powershell
Set-Location 'C:\Users\pryat\Downloads\playground-main'
docker build -t pk-api:latest -f 'playground-main\projects\pk-aws-ecs\Dockerfile' 'playground-main\projects\pk-aws-ecs'
docker tag pk-api:latest 181194339047.dkr.ecr.us-east-1.amazonaws.com/pk-api:latest
docker push 181194339047.dkr.ecr.us-east-1.amazonaws.com/pk-api:latest
```

## 8. Force ECS to pull the new image

```powershell
aws ecs update-service --cluster pk-api-prod --service pk-api-prod --force-new-deployment --region us-east-1 --profile default
```

## 9. Get the live application URL

From the `pk-api` Terragrunt folder:

```powershell
terragrunt output -raw alb_dns_name
```

The first successful deployment returned:

```text
pk-api-prod-110081664.us-east-1.elb.amazonaws.com
```

Open:

```text
http://pk-api-prod-110081664.us-east-1.elb.amazonaws.com
```

## Validation commands

Check ECS service state:

```powershell
aws ecs describe-services --cluster pk-api-prod --services pk-api-prod --region us-east-1 --profile default
```

List running tasks:

```powershell
aws ecs list-tasks --cluster pk-api-prod --service-name pk-api-prod --region us-east-1 --profile default
```

Verify the repository exists:

```powershell
aws ecr describe-repositories --repository-names pk-api --region us-east-1 --profile default
```

## Troubleshooting notes

### Terragrunt not found

Install Terragrunt and reopen PowerShell:

```powershell
winget install --id Gruntwork.Terragrunt -e
```

### Terraform path issues in Terragrunt

If Terragrunt fails to execute Terraform from a deep cache path, use the short-cache environment variables shown earlier in this document.

### PowerShell ECR login returns `400 Bad Request`

If this command fails:

```powershell
aws ecr get-login-password --region us-east-1 --profile default | docker login --username AWS --password-stdin 181194339047.dkr.ecr.us-east-1.amazonaws.com
```

use this instead:

```powershell
$password = aws ecr get-login-password --region us-east-1 --profile default
docker login --username AWS --password $password 181194339047.dkr.ecr.us-east-1.amazonaws.com
```

### `no basic auth credentials` during `docker push`

This usually means:

- Docker login to ECR did not succeed
- the image was tagged for the wrong repository URI
- the ECR repository was not created yet

### App URL does not load immediately

The ALB can exist before the ECS tasks are healthy. If the URL does not load:

1. check ECS service status
2. confirm the image push succeeded
3. force a new ECS deployment again

## Screenshots

Deployment screenshots are stored in this folder and can be used to expand the walkthrough:

- [image.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image.png)
- [image-1.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-1.png)
- [image-2.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-2.png)
- [image-3.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-3.png)
- [image-4.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-4.png)
- [image-5.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-5.png)
- [image-6.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-6.png)
- [image-7.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-7.png)
- [image-8.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-8.png)
- [image-9.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-9.png)
- [image-10.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-10.png)
- [image-11.png](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/pk-aws-ecs/docs/image-11.png)
