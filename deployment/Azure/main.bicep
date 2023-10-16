param location string = resourceGroup().location
param vNetsArray array

module vNets 'modules/vnet.bicep' = [for vnet in vNetsArray:{
  name: vnet.vnetName
  params: {
    location: location
    vnetName: vnet.vnetName
    vnetAddressPrefixes: vnet.vnetAddressPrefixes
    subnetName: vnet.subnetName
    subnetAddressPrefix: vnet.subnetAddressPrefix
    nsg: vnet.nsg
    }
  }
]
