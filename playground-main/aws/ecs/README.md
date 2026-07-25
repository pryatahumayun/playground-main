# ECS

Amazon ECS is AWS's managed container orchestration service.

## Main deployment modes

- Fargate
  Serverless containers with no EC2 hosts to manage.
- EC2 launch type
  Containers run on EC2 instances you manage.

## Common uses

- run APIs and background workers
- deploy Docker workloads without Kubernetes
- pair with ALB, CloudWatch, and ECR

## Good to remember

- ECS is often the simplest AWS container runtime for app teams
- Fargate is usually the easiest starting point
- services keep tasks running; task definitions describe the container setup
