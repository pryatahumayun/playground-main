# Deployment

Example deployment from repository root:

pwsh ./playground-main/projects/bugz-azure-aks/scripts/deploy-infra.ps1 -projectName bugz -environment dev -location eastus -aksSku Standard_D2s_v7 -nodeCount 1 -resourceGroupName bugz-dev-rg

After infra deploy, build and push image:

pwsh ./playground-main/projects/bugz-azure-aks/scripts/build-and-push.ps1 -acrName <acrName> -imageTag v1

Then deploy to the cluster:

pwsh ./playground-main/projects/bugz-azure-aks/scripts/deploy-k8s.ps1 -resourceGroup bugz-dev-rg -aksName bugz-dev-aks -image <acrLoginServer>/bugz:v1
![alt text](image.png)
run az account show
az login 
![alt text](image-1.png)
az account show 
![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-5.png)
![alt text](image-6.png)
![alt text](image-4.png)
![alt text](image-7.png)
![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)
![Bless up](image-12.png)
![alt text](image-13.png)
http://135.234.201.251/