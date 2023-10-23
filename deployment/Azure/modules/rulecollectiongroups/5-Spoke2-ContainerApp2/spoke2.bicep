param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource vnetRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'Spoke2'
  parent: parentFirewall
  properties: {
    priority: 500
    ruleCollections: [
      {
        name: 'Allow-Spoke2-Network-Rules'
        priority: 501
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Spoke002 to Spoke001'
            description: 'Allow spoke001 to connect to spoke002'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '10.2.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.1.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
        ]
      }
      {
        name: 'Allow-Spoke2-Application-Rules'
        priority: 502
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'Spoke002 to github.com'
            description: 'Allow spoke001 to connect to github.com'
            sourceAddresses: [
              '10.2.0.0/22' // spoke001
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            targetFqdns: [
              'github.com'
            ]
          }
        ]
      }
    ]
  }
}
