# Bicep

Bicep is Azure's infrastructure-as-code language for declaring ARM resources in a cleaner format than raw JSON templates.

## Common uses

- define Azure infrastructure in code
- create reusable modules
- parameterize environments like dev, test, and prod
- deploy resource groups, networking, compute, and data services consistently

## Main ideas

- `param`
- `var`
- `resource`
- `module`
- `output`
- `.bicepparam` files for deployment values

## Good to remember

- Bicep compiles to ARM, so it still uses the Azure Resource Manager deployment model
