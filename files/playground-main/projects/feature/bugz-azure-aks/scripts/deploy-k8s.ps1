# deploy-k8s.ps1
param(
  [string]$resourceGroup = "bugz-dev-rg",
  [string]$aksName = "bugz-dev-aks",
  [string]$image = ""
)

$ErrorActionPreference = 'Stop'

if (-not $image) { throw "image parameter is required" }

Write-Host "Fetching AKS credentials"
az aks get-credentials -g $resourceGroup -n $aksName --overwrite-existing

Write-Host "Applying namespace, deployment and service"
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

Write-Host "Updating deployment image"
kubectl -n bugz set image deployment/bugz-api bugz-api=$image

Write-Host "Waiting for rollout to complete"
kubectl -n bugz rollout status deployment/bugz-api --timeout=180s

Write-Host "Fetching external IP"
$svc = kubectl -n bugz get svc bugz-api -o json | ConvertFrom-Json
$external = $svc.status.loadBalancer.ingress[0].ip
if (-not $external) { $external = $svc.status.loadBalancer.ingress[0].hostname }
Write-Host "External address: $external"
