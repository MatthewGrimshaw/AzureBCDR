param firewallName string
param firewallLocation string
@allowed([
  'Premium'
  'Standard'
])
param tier string = 'Standard'
param firewallPolicy string
param vWanHubName string

resource vWanHub 'Microsoft.Network/virtualHubs@2021-02-01' existing = {
  name: vWanHubName
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2020-05-01' = {
  name: firewallName
  location: firewallLocation
  properties: {
    sku: {
      name: 'AZFW_Hub'
      tier: tier
    }
    firewallPolicy: {
      id: firewallPolicy
    }
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    virtualHub: {
      id: vWanHub.id
    }
  }

}
