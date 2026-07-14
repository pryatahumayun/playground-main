terraform {
  source = "${get_repo_root()}//infrastructure-modules/modules/services/ecs_fargate"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../shared_infra/vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    vpc_cidr_block     = "10.20.0.0/16"
    private_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002"]
    public_subnet_ids  = ["subnet-00000000000000003", "subnet-00000000000000004"]
  }
}

inputs = {
  service_name = "sample-api-prod"

  # Networking
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids

  # Container image
  container_port = 8080
  image_tag      = "latest"

  # Health check
  health_check_path    = "/healthz"
  health_check_command = ["CMD-SHELL", "curl -f http://localhost:8080/healthz || exit 1"]

  # TLS certificate ARN for production domain
  # Example: arn:aws:acm:us-east-1:PROD_ACCOUNT_ID_HERE:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  acm_certificate_arn = "REPLACE_WITH_PROD_ACM_CERT_ARN"

  # ALB is internal in prod — access via VPN or private network only
  lb_internal                   = true
  enable_lb_deletion_protection = true

  # Compute (larger than staging for real traffic)
  task_cpu    = 1024
  task_memory = 2048

  # Auto-scaling
  desired_count            = 2    # run two tasks by default for HA
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 10

  # Plaintext environment variables
  environment = {
    APP_ENV      = "prod"
    LOG_LEVEL    = "info"
    SERVICE_NAME = "sample-api"
  }

  # Secrets from AWS Secrets Manager
  secrets = {
    # "DB_PASSWORD" = "arn:aws:secretsmanager:us-east-1:PROD_ACCOUNT_ID_HERE:secret:/pryata/sample-api/db-XXXXXX:password::"
  }

  # Log retention longer in prod
  log_retention_days = 90

  tags = {
    Project     = "pryata"
    Service     = "sample-api"
    Environment = "prod"
  }
}
