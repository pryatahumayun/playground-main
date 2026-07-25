# Terragrunt

Terragrunt is a wrapper around Terraform that helps reduce repetition and organize environments.

## Common uses

- share provider and backend config
- structure multi-environment deployments
- wire dependencies between Terraform stacks
- keep modules and live config separate

## Why teams use it

- cleaner environment layout
- less duplicated Terraform boilerplate
- easier dependency handling between stacks

## Good to remember

- Terragrunt does not replace Terraform; it orchestrates it
- it is especially useful in multi-account or multi-environment AWS setups
