param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource vnetRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'Spoke1'
  parent: parentFirewall
  properties: {
    priority: 400
    ruleCollections: [
      {
        name: 'Allow-Spoke1-Network-Rules'
        priority: 401
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Spoke001 to on-premises'
            description: 'Allow spoke001 to connect to on-premises network'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '10.1.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.0/24'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Spoke001 to Spoke002'
            description: 'Allow spoke001 to connect to spoke002'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '10.1.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.2.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Spoke001 to Spoke003 on port 80'
            description: 'Allow spoke001 to connect to spoke002'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '10.1.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.3.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '80'
            ]
          }
        ]
      }
      {
        name: 'Allow-Spoke1-Application-Rules'
        priority: 402
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'Spoke001 to www.bing.com'
            description: 'Allow spoke001 to connect to www.bing.com'
            sourceAddresses: [
              '10.1.0.0/22' // spoke001
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            targetFqdns: [
              'www.bing.com'
            ]
          }
          {
            ruleType: 'ApplicationRule'
            name: 'Spoke001 to docs.microsoft.com'
            description: 'Allow spoke001 to connect to docs.microsoft.com'
            sourceAddresses: [
              '10.1.0.0/22' // spoke001
            ]
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            targetFqdns: [
              'docs.microsoft.com'
            ]
          }
          {
            ruleType: 'ApplicationRule'
            name: 'Spoke001 to github.com'
            description: 'Allow spoke001 to connect to github.com'
            sourceAddresses: [
              '10.1.0.0/22' // spoke001
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
