terraform {
  source = "${get_repo_root()}//infrastructure-modules/modules/services/ecs_fargate"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../shared_infra/vpc"

  # Allows `terragrunt plan` to work before the VPC has been applied (returns empty mock values)
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    vpc_cidr_block     = "10.10.0.0/16"
    private_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002"]
    public_subnet_ids  = ["subnet-00000000000000003", "subnet-00000000000000004"]
  }
}

inputs = {
  service_name = "sample-api-staging"

  # Networking (wired from the VPC module — never hardcoded)
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids

  # Container image
  # The ECR repo is created by this module on first apply.
  # Push your image to ecr_repository_url output before running the ECS service.
  container_port = 8080
  image_tag      = "staging"

  # Health check
  health_check_path    = "/healthz"
  health_check_command = ["CMD-SHELL", "curl -f http://localhost:8080/healthz || exit 1"]

  # TLS certificate — request one in ACM for your domain and paste the ARN here
  # Example: arn:aws:acm:us-east-1:STAGING_ACCOUNT_ID_HERE:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  acm_certificate_arn = "REPLACE_WITH_STAGING_ACM_CERT_ARN"

  # ALB is internet-facing in staging so developers can test directly
  lb_internal                   = false
  enable_lb_deletion_protection = false

  # Compute (small in staging to keep costs low)
  task_cpu    = 256
  task_memory = 512

  # Auto-scaling
  desired_count            = 1
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 3

  # Plaintext environment variables
  environment = {
    APP_ENV      = "staging"
    LOG_LEVEL    = "debug"
    SERVICE_NAME = "sample-api"
  }

  # Secrets from AWS Secrets Manager
  # Create the secret first, then reference its ARN here.
  # Format: "ENV_VAR_NAME" = "arn:aws:secretsmanager:us-east-1:ACCOUNT_ID:secret:PATH-SUFFIX"
  secrets = {
    # "DB_PASSWORD" = "arn:aws:secretsmanager:us-east-1:STAGING_ACCOUNT_ID_HERE:secret:/pryata/sample-api/db-XXXXXX:password::"
  }

  tags = {
    Project     = "pryata"
    Service     = "sample-api"
    Environment = "staging"
  }
}
