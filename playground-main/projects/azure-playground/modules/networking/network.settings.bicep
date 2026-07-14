param location string
param vnetName string
param addressPrefix string
param appSubnetName string
param appSubnetPrefix string
param privateEndpointSubnetName string
param privateEndpointSubnetPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: appSubnetName
        properties: {
          addressPrefix: appSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: privateEndpointSubnetName
        properties: {
          addressPrefix: privateEndpointSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

output vnetId string = virtualNetwork.id
output appSubnetId string = virtualNetwork.properties.subnets[0].id
output privateEndpointSubnetId string = virtualNetwork.properties.subnets[1].id
