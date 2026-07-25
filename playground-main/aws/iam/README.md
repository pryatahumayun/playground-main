# IAM

IAM controls authentication and authorization in AWS.

## Core concepts

- user
- group
- role
- policy
- trust policy

## Common uses

- grant apps permission to call AWS APIs
- allow CI/CD systems to deploy infrastructure
- enable cross-account access
- control human access with least privilege

## Good to remember

- roles are usually preferred over long-lived access keys
- policies answer "what can you do?"
- trust policies answer "who can assume this role?"
