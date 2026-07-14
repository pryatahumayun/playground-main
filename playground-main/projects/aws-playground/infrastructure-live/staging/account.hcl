locals {
  account_name     = "pryata-staging"
  aws_account_id   = "STAGING_ACCOUNT_ID_HERE"   # replace with your real 12-digit staging account ID
  env              = "staging"
  state_bucket     = "pryata-terraform-state-staging"
  state_lock_table = "pryata-terraform-locks-staging"
}
