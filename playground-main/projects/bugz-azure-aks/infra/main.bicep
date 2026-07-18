targetScope = 'resourceGroup'

@description('Short project name used in Azure resource names.')
param projectName string

@description('Deployment environment, for example dev, test, or prod.')
param environment string

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('AKS node VM size.')
param aksSku string = 'Standard_D2s_v7'

@minValue(1)
@description('AKS system node count.')
param nodeCount int = 1

var namePrefix = toLower('${projectName}${environment}')
var acrName = take(
  toLower('${namePrefix}acr${uniqueString(subscription().id, resourceGroup().id)}'),
  50
)
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
    acrName: acr.outputs.acrName
    principalId: aks.outputs.kubeletPrincipalId
  }
}

output acrName string = acr.outputs.acrName
output acrLoginServer string = acr.outputs.acrLoginServer
output aksClusterName string = aks.outputs.clusterName
output aksResourceGroup string = aks.outputs.aksResourceGroup
output subnetId string = network.outputs.subnetId
output logAnalyticsWorkspaceId string = loganalytics.outputs.workspaceId

output kubeConfigCommand string = 'az aks get-credentials -g ${resourceGroup().name} -n ${aks.outputs.clusterName} --overwrite-existing'

output kubectlServiceCommand string = 'kubectl get svc bugz-api -n bugz -o jsonpath="{.status.loadBalancer.ingress[0].ip}"'

output applicationUrlHint string = 'After deployment, run the kubectl service command and open http://<external-ip>.'
