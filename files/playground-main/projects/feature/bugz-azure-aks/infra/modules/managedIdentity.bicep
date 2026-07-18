// managedIdentity.bicep - optional user-assigned identity example
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'bugz-identity'
}

output identityId string = identity.id
