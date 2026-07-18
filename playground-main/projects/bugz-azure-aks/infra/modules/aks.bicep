param clusterName string
param location string = resourceGroup().location
param subnetId string
param workspaceId string
param nodeVmSize string = 'Standard_D2s_v7'

@minValue(1)
param nodeCount int = 1

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    enableRBAC: true

    agentPoolProfiles: [
      {
        name: 'systempool'
        count: nodeCount
        vmSize: nodeVmSize
        osType: 'Linux'
        osSKU: 'Ubuntu'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
        vnetSubnetID: subnetId
      }
    ]

    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
      serviceCidr: '10.2.0.0/16'
      dnsServiceIP: '10.2.0.10'
    }

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: workspaceId
        }
      }
    }
  }
}

output clusterName string = aks.name
output aksResourceGroup string = resourceGroup().name
output kubeletPrincipalId string = aks.properties.identityProfile.kubeletidentity.objectId
