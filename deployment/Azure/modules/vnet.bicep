param location string = resourceGroup().location
param vnetName string
param vnetAddressPrefixes array
param subnetName string
param subnetAddressPrefix string
param nsg bool

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = if (nsg) {
  name: 'nsg-${vnetName}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allowAllRule'
        properties: {
          description: 'Allow all traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vnetNsg 'Microsoft.Network/virtualNetworks@2023-04-01' = if (nsg)  {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [
      {
      name: subnetName
      properties: {
        addressPrefix: subnetAddressPrefix
        networkSecurityGroup: {
          id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = if (!nsg)  {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [
      {
      name: subnetName
      properties: {
        addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}
