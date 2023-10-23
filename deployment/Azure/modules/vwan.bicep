param vWanName string
param location string = resourceGroup().location
param vWanHubName string
param vWanHubLocation string
param vWanHubAddressPrefix string

resource vWan 'Microsoft.Network/virtualWans@2021-02-01' = {
  name: vWanName
  location: location
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
  }
}

resource vWanHub 'Microsoft.Network/virtualHubs@2021-02-01' = {
  name: vWanHubName
  location: vWanHubLocation
  properties: {
    virtualWan: {
      id: vWan.id
    }
    addressPrefix: vWanHubAddressPrefix
  }
}
