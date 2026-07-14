# Architecture

# Legacy AWS Container Architecture

## Docker Hub to EC2

## 1. Purpose

This document describes a legacy AWS deployment pattern where applications were packaged as Docker images, stored in Docker Hub, and deployed directly onto Amazon EC2 virtual machines.

This design introduced containerization without using a managed container orchestration platform.

---

## 2. High-Level Architecture

```text
Developer
    ↓
Git Repository
    ↓
Build Pipeline
    ↓
Docker Build
    ↓
Docker Image
    ↓
Docker Hub
    ↓
Release Pipeline
    ↓
Amazon EC2
    ↓
docker pull
    ↓
docker run
    ↓
Running Application Container
```

---

## 3. Main Components

### Source Repository

Stores:

* Application source code
* Dockerfile
* Build configuration
* Pipeline configuration
* Application tests

Example:

```text
millions-api/
├── Millions.Api/
├── Millions.Api.csproj
├── Dockerfile
└── .dockerignore
```

---

### Build Pipeline

The build pipeline:

1. Checks out the source code.
2. Runs tests.
3. Builds the Docker image.
4. Tags the image.
5. Pushes the image to Docker Hub.

Example:

```bash
docker build -t company/millions-api:v1 .
docker push company/millions-api:v1
```

The Docker image becomes the deployment artifact.

---

### Docker Hub

Docker Hub acts as the container registry.

It stores image versions such as:

```text
company/millions-api:v1
company/millions-api:v2
company/millions-api:latest
```

Docker Hub does not run the application.

Its only responsibility is storing and distributing container images.

---

### Amazon EC2

Amazon EC2 provides the virtual machine that hosts Docker.

The EC2 instance contains:

```text
Linux operating system
Docker runtime
Application configuration
Monitoring agents
Running containers
```

The virtual machine must be created, patched, secured, monitored, and maintained.

---

### Release Pipeline

The release pipeline connects to the EC2 instance and deploys the selected image.

Conceptually, it runs:

```bash
docker pull company/millions-api:v1

docker stop millions-api || true
docker rm millions-api || true

docker run \
  --name millions-api \
  --restart unless-stopped \
  --publish 8080:8080 \
  company/millions-api:v1
```

The pipeline must know which EC2 instance is hosting the application.

---

## 4. Deployment Flow

### Step 1: Developer Pushes Code

```text
Developer
    ↓
Git push
    ↓
Repository
```

---

### Step 2: Build Pipeline Creates the Image

```text
Application source
    ↓
docker build
    ↓
Docker image
```

Example image:

```text
company/millions-api:v1
```

---

### Step 3: Image Is Stored in Docker Hub

```text
Docker image
    ↓
docker push
    ↓
Docker Hub
```

---

### Step 4: Release Pipeline Connects to EC2

```text
Release pipeline
    ↓
SSH connection
    ↓
EC2 virtual machine
```

The pipeline may:

* Pull the latest image
* Stop the old container
* Remove the old container
* Start the new container
* Verify the application health

---

### Step 5: EC2 Runs the Container

```text
EC2
└── Docker
    └── millions-api container
```

Docker starts the application using the image retrieved from Docker Hub.

---

## 5. Networking

A typical network flow is:

```text
Users
    ↓
Load Balancer or EC2 Public Endpoint
    ↓
EC2 Security Group
    ↓
Docker Container Port
    ↓
Application
```

The EC2 security group controls inbound traffic.

Example:

```text
HTTPS 443
    ↓
Load Balancer
    ↓
EC2 port 8080
    ↓
Application container
```

---

## 6. Configuration and Secrets

Configuration may be passed into the container as environment variables:

```bash
docker run \
  --env ASPNETCORE_ENVIRONMENT=Production \
  --env ConnectionStrings__Database="..." \
  company/millions-api:v1
```

Secrets should not be stored inside the Docker image.

They should come from:

* AWS Secrets Manager
* Systems Manager Parameter Store
* Secure pipeline secrets
* Protected environment variables

---

## 7. Infrastructure Provisioning

Terraform or another Infrastructure as Code tool may create:

```text
VPC
Subnets
EC2 instances
Security groups
Load balancer
IAM roles
CloudWatch logging
DNS records
```

The application pipeline separately deploys the Docker image.

```text
Terraform
    ↓
Creates EC2 infrastructure

Application pipeline
    ↓
Deploys image to EC2
```

---

## 8. Benefits

* Introduces consistent application packaging
* Reduces runtime dependency differences
* Makes deployment artifacts versionable
* Allows the same image to run locally and in AWS
* Provides better isolation than installing applications directly on the VM

---

## 9. Limitations

### Manual Container Placement

The deployment process must know which EC2 instance should run the application.

### VM Management

The team must manage:

* Operating system updates
* Docker installation
* Security patches
* Disk capacity
* CPU and memory
* Scaling
* Container restarts

### Scaling Complexity

To add capacity, the team may need to:

1. Create another EC2 instance.
2. Install Docker.
3. Configure networking.
4. Pull the image.
5. Run another container.
6. Add the instance to the load balancer.

### Limited Self-Healing

Docker can restart a failed container, but it cannot automatically move the application to another healthy EC2 instance if the VM fails.

### Deployment Risk

A release may involve stopping the old container before starting the new one, potentially causing downtime.

---

## 10. Failure Example

```text
EC2 instance fails
        ↓
All containers on that VM stop
        ↓
Application becomes unavailable
        ↓
Engineer or automation must replace the VM
        ↓
Docker image is pulled again
        ↓
Container is restarted
```

---

## 11. Azure Comparison

| AWS Legacy Architecture   | Azure Equivalent                           |
| ------------------------- | ------------------------------------------ |
| EC2                       | Azure Virtual Machine                      |
| Docker Hub                | Docker Hub or Azure Container Registry     |
| Security Group            | Network Security Group                     |
| Application Load Balancer | Azure Load Balancer or Application Gateway |
| CloudWatch                | Azure Monitor                              |
| Secrets Manager           | Azure Key Vault                            |
| Terraform                 | Bicep                         |

---

## 12. Architecture Summary

```text
Terraform
    ↓
Creates EC2 infrastructure

GitHub Actions or CI pipeline
    ↓
Builds Docker image
    ↓
Pushes image to Docker Hub

Release pipeline
    ↓
Connects to EC2
    ↓
Pulls image
    ↓
Runs container
```

The major characteristic of this design is:

> Docker packages the application, but the team still manages the virtual machines and container deployments directly.

---

## 13. Modernization Opportunity

The next architectural step is to replace direct Docker-on-EC2 management with a managed container orchestration platform.

```text
Docker Hub + EC2
        ↓
Amazon ECR + Amazon ECS
```

This allows AWS to manage container placement, health, restart behaviour, scaling, and deployment updates.
# Modern AWS Container Architecture

## Amazon ECR to Amazon ECS Fargate

## 1. Purpose

This document describes a modern AWS deployment pattern where applications are packaged as Docker images, stored in Amazon Elastic Container Registry, and run using Amazon Elastic Container Service with AWS Fargate.

This design removes the need for application teams to manage individual EC2 virtual machines.

---

## 2. High-Level Architecture

```text
Developer
    ↓
GitHub Repository
    ↓
GitHub Actions
    ↓
Docker Build
    ↓
Docker Image
    ↓
Amazon ECR
    ↓
Amazon ECS Service
    ↓
AWS Fargate Task
    ↓
Running Application Container
```

Infrastructure is provisioned separately:

```text
Terraform Modules
    ↓
Terragrunt Configuration
    ↓
terraform plan
    ↓
terraform apply
    ↓
AWS Infrastructure
```

---

## 3. Main Components

### Application Repository

Stores:

```text
Application source code
Dockerfile
Tests
GitHub Actions workflow
Application configuration
```

Example:

```text
millions-api/
├── Millions.Api/
├── Millions.Api.csproj
├── Dockerfile
├── .dockerignore
└── .github/
    └── workflows/
        └── deploy.yml
```

---

### Docker

Docker packages the application into a portable image.

Example:

```bash
docker build -t millions-api:v1 .
```

The final image contains:

```text
.NET runtime
Published API DLLs
Application dependencies
Startup command
```

It does not contain:

```text
Database
S3 files
AWS infrastructure
Secrets
Terraform
```

---

### Amazon ECR

Amazon ECR is AWS's private container registry.

It stores images such as:

```text
123456789012.dkr.ecr.us-west-2.amazonaws.com/millions-api:v1
123456789012.dkr.ecr.us-west-2.amazonaws.com/millions-api:v2
```

ECR stores the image but does not run it.

---

### Amazon ECS

Amazon ECS is AWS's managed container orchestration service.

ECS manages:

* Container placement
* Desired container count
* Restarts
* Rolling deployments
* Health checks
* Load balancer registration
* Scaling

The application team defines what should run.

ECS ensures that the desired state is maintained.

---

### AWS Fargate

Fargate provides serverless compute for ECS tasks.

With Fargate:

```text
No EC2 instance management
No operating system patching
No Docker installation
No worker node maintenance
```

The team defines:

```text
Container image
CPU
Memory
Port
Environment variables
Secrets
Desired task count
```

AWS provides the underlying compute.

---

### ECS Task Definition

The task definition describes how the container runs.

Conceptually:

```text
Task Definition
├── Image
├── CPU
├── Memory
├── Port
├── Environment variables
├── Secrets
├── Logging
└── Health check
```

Example values:

```text
Image: millions-api:v1
Port: 8080
CPU: 512
Memory: 1024 MB
Environment: Production
```

---

### ECS Service

The ECS service keeps the application running.

Example:

```text
Desired task count: 3
```

ECS maintains:

```text
Task 1
Task 2
Task 3
```

If one task fails:

```text
Task 1 ✅
Task 2 ❌
Task 3 ✅
```

ECS launches a replacement task.

---

### Application Load Balancer

The Application Load Balancer receives traffic and distributes it across healthy ECS tasks.

```text
Users
    ↓
Application Load Balancer
    ├── Task 1
    ├── Task 2
    └── Task 3
```

The ALB provides:

* HTTPS termination
* Health checks
* Routing
* Load distribution
* Internal or public endpoints

---

### AWS Secrets Manager

Secrets are stored outside the Docker image.

Examples:

```text
Database connection strings
API keys
Redis connection strings
Authentication secrets
```

ECS injects approved secrets into the running container as environment variables.

---

### CloudWatch

CloudWatch stores:

* Container logs
* ECS events
* CPU metrics
* Memory metrics
* Load balancer metrics
* Alarms

Applications typically write logs to standard output:

```text
Console output
    ↓
CloudWatch Log Group
```

---

## 4. Infrastructure Repository Design

A typical design separates reusable Terraform modules from deployed environment configuration.

```text
infrastructure-modules/
└── modules/
    └── services/
        └── ecs_fargate/

infrastructure-live/
└── staging/
    └── us-west-2/
        └── services/
            └── millions-api/
                └── terragrunt.hcl
```

---

## 5. Terraform Responsibilities

Terraform creates the infrastructure required to host the application.

Example resources:

```text
ECR repository
ECS cluster
ECS task definition
ECS service
Application Load Balancer
Target group
Security groups
CloudWatch log group
IAM roles
Secrets permissions
DNS records
```

Terraform does not compile the API or build the Docker image.

---

## 6. Terragrunt Responsibilities

Terragrunt manages:

* Environment configuration
* Account IDs
* AWS regions
* Remote Terraform state
* Shared tags
* Module versions
* Dependencies
* Inputs

Example:

```hcl
terraform {
  source = "git@github.com:org/infrastructure-modules.git//modules/services/ecs_fargate?ref=v1.0.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  service_name      = "millions-api"
  container_name    = "millions-api"
  container_version = "v1"
  container_port    = 8080
}
```

---

## 7. Application Build and Deployment Flow

### Step 1: Developer Pushes Code

```text
Developer
    ↓
Git push
    ↓
GitHub
```

---

### Step 2: GitHub Actions Builds the Image

```text
Checkout source
    ↓
Run tests
    ↓
docker build
    ↓
millions-api:v1
```

---

### Step 3: Authenticate to ECR

The workflow authenticates to AWS using an IAM role or federated identity.

Example:

```bash
aws ecr get-login-password \
  --region us-west-2 \
  | docker login \
      --username AWS \
      --password-stdin \
      123456789012.dkr.ecr.us-west-2.amazonaws.com
```

---

### Step 4: Tag the Image

```bash
docker tag \
  millions-api:v1 \
  123456789012.dkr.ecr.us-west-2.amazonaws.com/millions-api:v1
```

---

### Step 5: Push the Image to ECR

```bash
docker push \
  123456789012.dkr.ecr.us-west-2.amazonaws.com/millions-api:v1
```

---

### Step 6: Update ECS

The deployment workflow updates the ECS task definition or service to use the new image version.

```text
Old version: millions-api:v1
New version: millions-api:v2
```

ECS then performs a rolling deployment.

```text
v1
v1
v1

↓

v2
v1
v1

↓

v2
v2
v1

↓

v2
v2
v2
```

---

## 8. Complete Deployment Architecture

```text
GitHub Repository
        ↓
GitHub Actions
        ↓
docker build
        ↓
Docker Image
        ↓
Amazon ECR
        ↓
ECS Task Definition
        ↓
ECS Service
        ↓
Fargate Tasks
        ↓
Application Load Balancer
        ↓
Users
```

Infrastructure path:

```text
Terraform Modules
        ↓
Terragrunt Environment Configuration
        ↓
terraform plan
        ↓
Review
        ↓
terraform apply
        ↓
AWS Resources
```

---

## 9. Networking

A typical ECS Fargate design is:

```text
VPC
├── Public Subnets
│   └── Public Application Load Balancer
│
└── Private Subnets
    ├── ECS Task 1
    ├── ECS Task 2
    └── ECS Task 3
```

For internal applications:

```text
VPC
└── Private Subnets
    ├── Internal Application Load Balancer
    ├── ECS Task 1
    └── ECS Task 2
```

The ECS tasks are not exposed directly to users.

Traffic enters through the load balancer.

---

## 10. Security Groups

Typical security group flow:

```text
User or VPN
    ↓
ALB Security Group
    ↓
ECS Task Security Group
    ↓
Container Port 8080
```

The task security group should only allow traffic from the load balancer security group.

---

## 11. IAM Roles

Common roles include:

### ECS Task Execution Role

Allows ECS to:

* Pull images from ECR
* Read secrets
* Write logs to CloudWatch

### ECS Task Role

Allows the application itself to:

* Read S3 objects
* Query DynamoDB
* Call Bedrock
* Access Secrets Manager
* Publish to SQS or SNS

The task role should follow the principle of least privilege.

---

## 12. Environment Configuration

Plain configuration:

```hcl
environment = {
  ASPNETCORE_ENVIRONMENT = "Production"
  AWS_REGION              = "us-west-2"
}
```

Secrets:

```hcl
secrets = {
  ConnectionStrings__Database = "arn:aws:secretsmanager:..."
}
```

The application reads both as normal environment variables.

---

## 13. Scaling

ECS services can scale based on:

* CPU
* Memory
* Request count
* Queue depth
* Custom CloudWatch metrics

Example:

```text
Minimum tasks: 2
Maximum tasks: 10
Scale out when CPU > 70%
```

---

## 14. Health Checks

Container health check:

```text
GET /healthz
```

Load balancer health check:

```text
GET /livez
```

If a task fails health checks:

```text
Task marked unhealthy
        ↓
Removed from load balancer
        ↓
ECS launches replacement
```

---

## 15. Benefits Over Direct Docker on EC2

### Managed Container Placement

ECS decides where containers run.

### Self-Healing

Failed tasks are replaced automatically.

### Easier Scaling

Desired task count can be changed without manually preparing another VM.

### Rolling Deployments

New image versions can be deployed gradually.

### Reduced VM Management

Fargate removes the need to manage EC2 worker machines.

### Better AWS Integration

ECS integrates directly with:

* ECR
* IAM
* Secrets Manager
* CloudWatch
* Application Load Balancer
* Auto Scaling

---

## 16. Azure Comparison

| AWS                       | Azure Equivalent                                                |
| ------------------------- | --------------------------------------------------------------- |
| Amazon ECR                | Azure Container Registry                                        |
| Amazon ECS                | Azure Container Apps           |
| AWS Fargate               | Azure Container Apps serverless compute                         |
| Application Load Balancer | Application Gateway or Azure Load Balancer                      |
| ECS Task Definition       | Container App revision/template or Kubernetes pod specification |
| ECS Service               | Container App or Kubernetes deployment                          |
| Secrets Manager           | Key Vault                                                       |
| CloudWatch                | Azure Monitor and Log Analytics                                 |
| IAM Task Role             | Managed Identity                                                |
| VPC                       | VNet                                                            |
| Security Group            | NSG                                                             |

---

## 17. Legacy vs Modern Comparison

| Legacy Docker on EC2            | ECR and ECS Fargate            |
| ------------------------------- | ------------------------------ |
| Docker Hub stores images        | ECR stores images              |
| Release pipeline connects to VM | ECS pulls image automatically  |
| Team manages EC2                | AWS manages Fargate compute    |
| Manual container placement      | ECS schedules tasks            |
| Scaling requires more VMs       | ECS changes desired task count |
| VM failure affects containers   | ECS replaces failed tasks      |
| Manual deployment scripts       | Managed rolling deployment     |
| Docker restart policy           | ECS health and desired state   |
| More operational overhead       | More managed orchestration     |

---

## 18. Architecture Summary

```text
Terraform and Terragrunt
        ↓
Create AWS infrastructure

GitHub Actions
        ↓
Build Docker image
        ↓
Push image to ECR

ECS
        ↓
Pull image from ECR
        ↓
Run image as Fargate task
        ↓
Maintain desired number of healthy tasks

Application Load Balancer
        ↓
Route traffic to healthy containers
```

The major characteristic of this design is:

> The application remains containerized, but AWS now manages container scheduling, health, scaling, deployment, and compute through ECS Fargate.

