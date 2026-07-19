# PK AWS Infra

This folder follows the same high-level approach used in `projects/aws-playground`:

- `infrastructure-modules/` for reusable Terraform modules
- `infrastructure-live/` for Terragrunt environment and deployment configuration

Unlike the initial scaffold, this folder now contains real Terraform module code for:

- a reusable VPC module
- a reusable ECS Fargate service module that includes ECR, ALB, ECS, IAM, and CloudWatch

The live Terragrunt configuration is now simplified for a single `prod` environment and uses local state by default. It does not require an S3 state bucket or an ACM certificate. You still need to replace the placeholder AWS account ID and, if needed, the AWS CLI profile name before deployment.
