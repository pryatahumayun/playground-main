locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  account_name   = local.account_vars.locals.account_name
  aws_account_id = local.account_vars.locals.aws_account_id
  env            = local.account_vars.locals.env
  region         = local.region_vars.locals.region
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.region}"

      # Replace with your AWS CLI profile name, or remove and use environment variables / IAM roles
      profile = "pryata-prod-tf"

      default_tags {
        tags = {
          Environment = "${local.env}"
          ManagedBy   = "Terraform"
          Account     = "${local.account_name}"
        }
      }
    }
  EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.account_vars.locals.state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = local.account_vars.locals.state_lock_table
  }
}

inputs = {
  env            = local.env
  region         = local.region
  aws_account_id = local.aws_account_id
}
