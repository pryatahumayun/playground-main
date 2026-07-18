# cleanup.ps1
param(
  [string]$resourceGroup = "bugz-dev-rg",
  [switch]$force
)

$ErrorActionPreference = 'Stop'

if (-not $force) {
  $confirm = Read-Host "Type 'DELETE' to confirm deletion of resource group $resourceGroup"
  if ($confirm -ne 'DELETE') {
    Write-Host "Aborting deletion."
    exit 0
  }
}

Write-Host "Deleting resource group $resourceGroup"
az group delete -n $resourceGroup --yes --no-wait
Write-Host "Deletion requested for resource group $resourceGroup"
