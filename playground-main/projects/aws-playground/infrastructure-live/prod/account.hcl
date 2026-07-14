locals {
  account_name     = "pryata-prod"
  aws_account_id   = "PROD_ACCOUNT_ID_HERE"   # replace with your real 12-digit prod account ID
  env              = "prod"
  state_bucket     = "pryata-terraform-state-prod"
  state_lock_table = "pryata-terraform-locks-prod"
}
