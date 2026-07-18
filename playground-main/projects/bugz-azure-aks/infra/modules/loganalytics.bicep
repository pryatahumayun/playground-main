param location string = resourceGroup().location
param projectName string
param environment string

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: '${projectName}-${environment}-law'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output workspaceId string = workspace.id
