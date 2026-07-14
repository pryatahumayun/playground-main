terraform {
  source = "${get_repo_root()}//infrastructure-modules/modules/networking/vpc"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name = "pryata-staging"
  vpc_cidr = "10.10.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]

  tags = {
    Project = "pryata"
  }
}
