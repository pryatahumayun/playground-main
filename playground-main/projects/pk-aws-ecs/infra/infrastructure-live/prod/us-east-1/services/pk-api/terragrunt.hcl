terraform {
  source = "${get_repo_root()}//playground-main/projects/pk-aws-ecs/infra/infrastructure-modules/modules/services/ecs_fargate"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../shared_infra/vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    vpc_cidr_block     = "10.40.0.0/16"
    private_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002"]
    public_subnet_ids  = ["subnet-00000000000000003", "subnet-00000000000000004"]
  }
}

inputs = {
  service_name = "pk-api-prod"

  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids

  repository_name = "pk-api"
  container_name  = "pk-api"
  container_port  = 8080
  image_tag       = "latest"

  health_check_path    = "/health"
  health_check_command = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]

  lb_internal                   = false
  enable_lb_deletion_protection = true

  task_cpu    = 512
  task_memory = 1024

  desired_count            = 2
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 6

  environment = {
    PET_NAME       = "PK the Presa"
    CLOUD_PROVIDER = "AWS"
    PLATFORM       = "ECS Fargate"
    APP_VERSION    = "latest"
  }

  secrets = {}

  tags = {
    Project     = "pk"
    Service     = "pk-api"
    Environment = "prod"
  }
}
