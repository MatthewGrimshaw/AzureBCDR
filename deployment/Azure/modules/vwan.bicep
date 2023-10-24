param vWanName string
param location string = resourceGroup().location
param vWanHubName string
param vWanHubLocation string
param vWanHubAddressPrefix string
param tags object

resource vWan 'Microsoft.Network/virtualWans@2021-02-01' = {
  name: vWanName
  location: location
  tags: tags
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
  }
}

resource vWanHub 'Microsoft.Network/virtualHubs@2021-02-01' = {
  name: vWanHubName
  location: vWanHubLocation
  tags: tags
  properties: {
    virtualWan: {
      id: vWan.id
    }
    addressPrefix: vWanHubAddressPrefix
  }
}
