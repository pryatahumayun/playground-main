terraform {
  source = "${get_repo_root()}//playground-main/projects/pk-aws-ecs/infra/infrastructure-modules/modules/networking/vpc"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name = "pk-prod"
  vpc_cidr = "10.40.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]

  tags = {
    Project     = "pk"
    Environment = "prod"
  }
}
