targetScope = 'resourceGroup'

param projectName string
param environment string
param location string
param aksSku string = 'Standard_DS2_v2'
param nodeCount int = 1

var namePrefix = toLower('${projectName}${environment}')
var acrName = toLower('${namePrefix}acr${uniqueString(resourceGroup().id)}')
var aksClusterName = '${projectName}-${environment}-aks'

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    location: location
    projectName: projectName
    environment: environment
  }
}

module loganalytics 'modules/loganalytics.bicep' = {
  name: 'loganalytics'
  params: {
    location: location
    projectName: projectName
    environment: environment
  }
}

module acr 'modules/acr.bicep' = {
  name: 'acr'
  params: {
    acrName: acrName
    location: location
  }
}

module managedIdentity 'modules/managedIdentity.bicep' = {
  name: 'managedIdentity'
  params: {}
}

module aks 'modules/aks.bicep' = {
  name: 'aks'
  params: {
    clusterName: aksClusterName
    location: location
    subnetId: network.outputs.subnetId
    workspaceId: loganalytics.outputs.workspaceId
    nodeVmSize: aksSku
    nodeCount: nodeCount
  }
}

module acrRole 'modules/roleAssignment-acrpull.bicep' = {
  name: 'acrRole'
  params: {
    acrResourceId: acr.outputs.acrId
    principalId: aks.outputs.kubeletPrincipalId
  }
}

output acrName string = acr.outputs.acrName
output acrLoginServer string = acr.outputs.acrLoginServer
output aksClusterName string = aks.outputs.clusterName
output aksResourceGroup string = aks.outputs.aksResourceGroup
output subnetId string = network.outputs.subnetId
output logAnalyticsWorkspaceId string = loganalytics.outputs.workspaceId

output kubeConfigCommand string = 'az aks get-credentials -g ' + resourceGroup().name + ' -n ' + aks.outputs.clusterName + ' --overwrite-existing'
output kubectlServiceCommand string = 'kubectl get svc bugz-api -n bugz -o jsonpath="{.status.loadBalancer.ingress[0].ip}" || kubectl get svc bugz-api -n bugz -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"'
output applicationUrlHint string = 'Run the kubectl command above and prepend http:// (e.g. echo http://$(kubectl get svc bugz-api -n bugz -o jsonpath="{.status.loadBalancer.ingress[0].ip}"))'
