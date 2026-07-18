param acrResourceId string
param principalId string

var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acrRole 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(acrResourceId, principalId, acrPullRoleId)
  scope: acrResourceId
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
