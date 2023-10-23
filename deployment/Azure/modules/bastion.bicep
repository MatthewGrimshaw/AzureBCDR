param location string = resourceGroup().location
param bastionName string = 'bastion'

@description('Virtual network name')
param vnetName string

@description('The name of the Bastion public IP address')
param publicIpName string = 'pip-bastion'

// The Bastion Subnet is required to be named 'AzureBastionSubnet'
var subnetName = 'AzureBastionSubnet'

resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01'  existing = {
  name: '${vnetName}/${subnetName}'
}
resource publicIpAddressForBastion 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2023-04-01' = {
  name: bastionName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    disableCopyPaste: false
    dnsName: 'string'
    enableFileCopy: true
    enableIpConnect: true
    enableKerberos: false
    enableShareableLink: true
    enableTunneling: true
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: bastionSubnet.id
          }
          publicIPAddress: {
            id: publicIpAddressForBastion.id
          }
        }
      }
    ]
  }
}
