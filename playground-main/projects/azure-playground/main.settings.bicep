param location string = resourceGroup().location
param vnetName string = 'vnet-azure-playground'
param addressPrefix string = '10.0.0.0/16'
param appSubnetName string = 'app-subnet'
param appSubnetPrefix string = '10.0.1.0/24'
param privateEndpointSubnetName string = 'private-endpoint-subnet'
param privateEndpointSubnetPrefix string = '10.0.2.0/24'
param appServicePlanName string = 'asp-azure-playground'
param webAppName string = 'app-azure-playground-${uniqueString(resourceGroup().id)}'
param skuName string = 'B1'
param skuTier string = 'Basic'
param storageAccountName string = toLower('st${uniqueString(resourceGroup().id)}')
param keyVaultName string = 'kv-${uniqueString(resourceGroup().id)}'
param sqlServerName string = 'sql-${uniqueString(resourceGroup().id)}'
param sqlAdminLogin string = 'sqladminuser'
@secure()
param sqlAdminPassword string
param sqlDatabaseName string = 'sqldb-azure-playground'
param objectId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

module networking './modules/networking/network.settings.bicep' = {
  name: 'networkingDeployment'
  params: {
    location: location
    vnetName: vnetName
    addressPrefix: addressPrefix
    appSubnetName: appSubnetName
    appSubnetPrefix: appSubnetPrefix
    privateEndpointSubnetName: privateEndpointSubnetName
    privateEndpointSubnetPrefix: privateEndpointSubnetPrefix
  }
}

module security './modules/security/security.settings.bicep' = {
  name: 'securityDeployment'
  params: {
    location: location
    keyVaultName: keyVaultName
    objectId: objectId
  }
}

module database './modules/database/database.settings.bicep' = {
  name: 'databaseDeployment'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
    databaseName: sqlDatabaseName
    privateEndpointSubnetId: networking.outputs.privateEndpointSubnetId
  }
}

module app './modules/app/app.settings.bicep' = {
  name: 'appDeployment'
  params: {
    location: location
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    skuName: skuName
    skuTier: skuTier
    subnetId: networking.outputs.appSubnetId
    keyVaultName: security.outputs.keyVaultName
  }
}

output storageAccountName string = storageAccount.name
output webAppName string = app.outputs.webAppName
output webAppUrl string = app.outputs.webAppUrl
output vnetName string = vnetName
output appSubnetName string = appSubnetName
output privateEndpointSubnetName string = privateEndpointSubnetName
output keyVaultName string = security.outputs.keyVaultName
output sqlServerName string = database.outputs.sqlServerName
output sqlDatabaseName string = database.outputs.sqlDatabaseName
