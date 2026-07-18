# build-and-push.ps1
param(
  [string]$acrName,
  [string]$imageTag = "v1"
)

$ErrorActionPreference = 'Stop'

if (-not $acrName) { throw "acrName parameter is required" }

Write-Host "Fetching ACR login server"
$acrLoginServer = az acr show -n $acrName --query loginServer -o tsv
if (-not $acrLoginServer) { throw "Unable to find ACR login server for $acrName" }

Write-Host "Building Docker image"
docker build -t $acrLoginServer/bugz:$imageTag -f docker/Dockerfile ..\

Write-Host "Logging into ACR"
az acr login -n $acrName

Write-Host "Pushing image to ACR"
docker push $acrLoginServer/bugz:$imageTag

Write-Host "Image pushed: $acrLoginServer/bugz:$imageTag"
