param location string
param appServicePlanName string
param webAppName string
param skuName string
param skuTier string
param subnetId string
param keyVaultName string
param sqlConnectionStringSecretName string = 'sql-connection-string'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    virtualNetworkSubnetId: subnetId
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      alwaysOn: true
      ftpsState: 'FtpsOnly'
      appSettings: [
        {
          name: 'KEY_VAULT_NAME'
          value: keyVault.name
        }
      ]
    }
  }
}

output webAppName string = webApp.name
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
