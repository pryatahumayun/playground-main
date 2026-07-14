param location string
param keyVaultName string
param tenantId string = subscription().tenantId
param objectId string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: objectId
        permissions: {
          secrets: [
            'get'
            'list'
            'set'
            'delete'
          ]
        }
      }
    ]
    publicNetworkAccess: 'Enabled'
  }
}

output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
