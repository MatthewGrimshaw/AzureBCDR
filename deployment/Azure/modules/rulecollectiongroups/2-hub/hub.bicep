param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource hubRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'Hub-specific'
  parent: parentFirewall
  properties: {
    priority: 200
    ruleCollections: [
      {
        name: 'Allow-Hub-Network-Rules'
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        priority: 201
        action: {
          type: 'Allow'
        }
        rules: [
          // Allow P2S to communicate with OnPremise SQL
          {
            // Justification:
            // On Premises Database
            ruleType: 'NetworkRule'
            name: 'P2S-OnPrem-SQL'
            description: 'Allow traffic from P2S VPN address spaces to a specific OnPrem IP'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '172.168.0.0/16'
            ]
            sourceIpGroups: []
            destinationAddresses: [ '192.168.0.10' ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '1433'
            ]
          }
          // Allow P2S to communicate with OnPremise WebApp
          {
            // Justification:
            // On Premises WebApp
            ruleType: 'NetworkRule'
            name: 'P2S-OnPrem-WebApp'
            description: 'Allow traffic from P2S VPN address spaces to a specific OnPrem IP'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '172.168.0.0/16'
            ]
            sourceIpGroups: []
            destinationAddresses: [ '192.168.0.11' ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '433'
            ]
          }
          // Allow P2S to communicate with Spoke 1
          {
            // Justification:
            // P2S to Spoke 1
            ruleType: 'NetworkRule'
            name: 'P2S-Spoke 1'
            description: 'Allow traffic from P2S VPN address spaces to Spoke 1'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '172.168.0.0/16'
            ]
            sourceIpGroups: []
            destinationAddresses: [ '10.1.0.0/22' ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
        ]
      }
    ]
  }
}
