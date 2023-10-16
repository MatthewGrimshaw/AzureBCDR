
$resourceGroupName  = "AzureBCDR"
$location = "westeurope"

Az login

az group create --name $resourceGroupName --location $location

az deployment group create --resource-group $resourceGroupName --template-file .\deployment\Azure\main.bicep --parameters .\deployment\Azure\parameters.main.json