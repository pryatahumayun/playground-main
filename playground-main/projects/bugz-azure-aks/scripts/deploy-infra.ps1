# deploy-infra.ps1
param(
    [string]$projectName = "bugz",
    [string]$environment = "dev",
    [string]$location = "eastus",
    [string]$aksSku = "Standard_D2s_v7",
    [int]$nodeCount = 1,
    [string]$resourceGroupName = "bugz-dev-rg"
)

$ErrorActionPreference = 'Stop'

Write-Host "Creating resource group $resourceGroupName in $location"
az group create -n $resourceGroupName -l $location | Out-Null

Write-Host "Deploying Bicep templates to resource group $resourceGroupName"
az deployment group create --resource-group $resourceGroupName --parameters playground-main/projects/bugz-azure-aks/infra/main.bicepparam projectName=$projectName environment=$environment location=$location aksSku=$aksSku nodeCount=$nodeCount

Write-Host "Deployment submitted. Use az deployment group show to inspect outputs."
