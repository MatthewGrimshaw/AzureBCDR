param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource vnetRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'Spoke3'
  parent: parentFirewall
  properties: {
    priority: 600
    ruleCollections: [
      {
        name: 'Allow-Spoke3-Network-Rules'
        priority: 601
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Spoke003 to Spoke001'
            description: 'Allow spoke001 to connect to spoke002'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '10.3.0.0/22'
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
        name: 'Allow-Spoke3-Application-Rules'
        priority: 602
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'Spoke003 to github.com'
            description: 'Allow spoke001 to connect to github.com'
            sourceAddresses: [
              '10.3.0.0/22' // spoke003
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
