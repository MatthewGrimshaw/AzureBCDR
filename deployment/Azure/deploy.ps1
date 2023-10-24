
$resourceGroupName = "AzureBCDR"
$location = "westeurope"

Az login

az group create --name $resourceGroupName --location $location

# create resources
az stack group create --name "BCDR" --resource-group $resourceGroupName --template-file .\deployment\Azure\main.bicep --parameters .\deployment\Azure\parameters.main.json --verbose  --deny-settings-mode None --yes

# delete resources
az stack group delete --name "BCDR" --resource-group $resourceGroupName  --verbose  --yes
