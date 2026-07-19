# PK - AWS ECS POC

This project is the AWS-native counterpart to `bugz-azure-aks`, now themed around PK the Presa.

It reuses the same ASP.NET Core (.NET 8) application and container packaging approach where possible, but the eventual runtime target is AWS container services rather than Kubernetes. The intended hosting model is Amazon ECR for image storage, Amazon ECS Fargate for compute, an Application Load Balancer for ingress, and CloudWatch for logs and operational visibility.

For this initial setup, nothing is deployed. The goal is to establish a project structure, carry over the application source cleanly, and prepare the `infra` area for a future Terraform implementation.

## Structure

- `src/Bugz.Api`: reused ASP.NET Core application source copied from the Azure project
- `infra/`: Terraform-ready folder scaffold only, with no resources generated yet
- `docs/`: placeholder project documentation for deployment, resources, and architecture
- `screenshots/`: reserved for future walkthrough images and console captures
- `Dockerfile`: container build definition reused from the Azure project

## Planned AWS target services

- Amazon ECR
- Amazon ECS Fargate
- Application Load Balancer
- Amazon CloudWatch

## Notes

- The application code has only been lightly rebranded for PK the Presa and AWS-focused defaults.
- The project still uses the existing `Bugz.Api` application name to maximize reuse and avoid unnecessary changes before infrastructure work begins.
- No Terraform resources, CI/CD pipelines, or AWS deployment scripts have been created yet.

## Local build example

From repository root:

```bash
docker build -t local-pk-aws -f playground-main/projects/pk-aws-ecs/Dockerfile playground-main/projects/pk-aws-ecs
```
