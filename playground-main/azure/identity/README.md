# Identity

Identity in Azure usually means Microsoft Entra ID, RBAC, managed identities, and service-to-service access patterns.

## Main topics

- Microsoft Entra ID
- Azure RBAC
- managed identities
- app registrations
- federated identity and workload identity

## Common uses

- authenticate users into Azure apps
- authorize access to resources
- avoid storing secrets by using managed identities
- connect CI/CD systems to Azure with OIDC

## Good to remember

- authentication and authorization are separate concerns
- RBAC controls access to Azure resources
- app authentication inside your own application may use Entra, but it is not the same thing as Azure resource RBAC
