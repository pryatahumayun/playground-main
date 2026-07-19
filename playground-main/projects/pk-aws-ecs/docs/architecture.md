# Architecture

This document is a placeholder for the future `pk-aws-ecs` architecture description.

## Target direction

The project is intended to demonstrate a native AWS container deployment model for the reused `.NET 8` application:

- source code packaged into a Docker image
- image stored in Amazon ECR
- service deployed to Amazon ECS using Fargate launch type
- inbound traffic routed through an Application Load Balancer
- logs and operational telemetry captured in CloudWatch

## Design goals

- mirror the learning value of `bugz-azure-aks` while using AWS-native services
- avoid Kubernetes and Amazon EKS
- keep the application largely unchanged so infrastructure differences stay easy to compare
- maintain a clear separation between application code, infrastructure, and documentation

Detailed diagrams and deployment flow notes will be added once the Terraform infrastructure is introduced.
