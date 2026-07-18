# Azure Playground with Bicep

This example now includes a fuller Azure architecture with:
- a hub-style virtual network with two subnets
- a Linux App Service Plan and Web App
- a private endpoint for Azure SQL
- an Azure Key Vault
- a SQL server and database
- a storage account

## Structure

- main.settings.bicep: top-level deployment entry point
- main.bicepparam: Bicep-native parameter file
- modules/networking: creates the VNet and subnets
- modules/app: creates the App Service Plan and Web App
- modules/database: creates the SQL server, database, and private endpoint
- modules/security: creates the Key Vault

## Deploy

```bash
az group create --name rg-azure-playground --location eastus
az deployment group create \
  --resource-group rg-azure-playground \
  --template-file main.settings.bicep \
  --parameters main.bicepparam
```

## Notes

Replace the placeholder object ID in main.bicepparam with your own Azure AD object ID before deployment.
