# AWS Resources

This document is a placeholder inventory for the AWS resources planned for `pk-aws-ecs`.

## Intended services

- Amazon ECR
  Container image registry for the ASP.NET Core application.

- Amazon ECS Fargate
  Serverless container runtime for the application service.

- Application Load Balancer
  Public entry point for HTTP traffic and health routing.

- Amazon CloudWatch
  Central destination for container logs, metrics, and operational visibility.

## Likely supporting resources

- VPC networking components
- Public and private subnets
- Security groups
- IAM roles for ECS task execution
- CloudWatch log groups

Final resource choices, naming conventions, and environment boundaries will be documented once the Terraform implementation begins.
