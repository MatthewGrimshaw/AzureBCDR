param vWanHubName string
param vNetName string

resource vWanHub 'Microsoft.Network/virtualHubs@2021-02-01' existing = {
  name: vWanHubName
}

resource vWanHubDefaultRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2020-05-01' existing  = {
  parent: vWanHub
  name: 'defaultRouteTable'
 }


resource vNet 'Microsoft.Network/virtualNetworks@2023-04-01' existing =   {
 name: vNetName
}

resource vWanNetConnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2020-05-01' = {
  parent: vWanHub
  name:  'connection-${vNetName}'
  properties: {
    routingConfiguration: {
      associatedRouteTable: {
        id: vWanHubDefaultRouteTable.id
      }
      propagatedRouteTables: {
        labels: [
          'none'
        ]
        ids: [
          {
            id: resourceId('Microsoft.Network/virtualHubs/hubRouteTables', vWanHubName, 'noneRouteTable')
          }
        ]
      }
    }
    remoteVirtualNetwork: {
      id: vNet.id
    }
    allowHubToRemoteVnetTransit: true
    allowRemoteVnetToUseHubVnetGateways: true
    enableInternetSecurity: true
  }
}
