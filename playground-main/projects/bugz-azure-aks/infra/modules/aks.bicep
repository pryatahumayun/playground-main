param clusterName string
param location string = resourceGroup().location
param subnetId string
param workspaceId string
param nodeVmSize string = 'Standard_DS2_v2'
param nodeCount int = 1

resource aks 'Microsoft.ContainerService/managedClusters@2023-08-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: nodeCount
        vmSize: nodeVmSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetId: subnetId
      }
    ]
    linuxProfile: {
      adminUsername: 'azureuser'
    }
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      networkMode: 'transparent'
      outboundType: 'loadBalancer'
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

// Output kubelet identity principal id for role assignment
output clusterName string = aks.name
output aksResourceGroup string = resourceGroup().name
output kubeletPrincipalId string = aks.identityProfile.kubeletidentity.objectId
