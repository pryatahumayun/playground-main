# Secrets Manager

AWS Secrets Manager stores and manages application secrets.

## Common uses

- database passwords
- API keys
- tokens and credentials
- app config values that should not live in code

## Why teams use it

- central secret storage
- IAM-based access control
- optional rotation workflows
- easy integration with ECS, Lambda, and apps

## Good to remember

- secrets should be referenced at runtime, not copied into repos
- IAM permissions are a big part of the design
- it is different from Parameter Store, which is often used for simpler config values
