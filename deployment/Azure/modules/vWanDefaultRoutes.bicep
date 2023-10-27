param vWanHubName string
param firewallName string

resource vWanHub 'Microsoft.Network/virtualHubs@2021-02-01' existing = {
  name: vWanHubName
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2020-05-01' existing = {
  name: firewallName
}

/*
resource vWanHubDefaultRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2020-05-01' = {
  parent: vWanHub
  name: 'defaultRouteTable'
  properties: {
    routes: [
      {
        name: 'all_traffic'
        destinationType: 'CIDR'
        destinations: [
          '10.0.0.0/8'
          '172.16.0.0/12'
          '192.168.0.0/16'
          '0.0.0.0/0'
        ]
        nextHopType: 'ResourceId'
        nextHop: azureFirewall.id
      }
    ]
    labels: [
      'default'
    ]
  }
}
*/

resource routingIntent 'Microsoft.Network/virtualHubs/routingIntent@2023-04-01' = {
  name: 'routingIntent'
  parent: vWanHub
  properties: {
    routingPolicies: [
      {
        destinations: [
          'Internet'
        ]
        name: 'Internet'
        nextHop: azureFirewall.id
      }
      {
        destinations: [
          'PrivateTraffic'
        ]
        name: 'PrivateTraffic'
        nextHop: azureFirewall.id
      }
    ]
  }
}
