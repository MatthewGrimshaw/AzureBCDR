param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource vnetRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'spoke4'
  parent: parentFirewall
  properties: {
    priority: 700
    ruleCollections: [
      {
        name: 'Allow-spoke4-Network-Rules'
        priority: 701
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        // Active Directory Web Services (ADWS)
        rules: [
          // Justification
          // Active Directory Web Services (ADWS)
          // https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/service-overview-and-network-port-requirements
          {
            ruleType: 'NetworkRule'
            name: 'ActiveDirectoryWebServices'
            description: 'Active Directory Web Services (ADWS)'
            ipProtocols: [
              'Tcp'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '9389'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'GlobalCatalog'
            description: 'Global Catalog'
            ipProtocols: [
              'Tcp'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '3268'
              '3269'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'ICMP'
            description: 'ICMP'
            ipProtocols: [
              'ICMP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'LDAPServer'
            description: 'LDAP Server'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '389'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'LDAPSSL'
            description: 'LDAP SSL'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '636'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'IPsecISAKMP'
            description: 'IPsec ISAKMP'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '500'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'NAT-T'
            description: 'NAT-T'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '4500'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'RPC'
            description: 'RPC'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '135'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'RPC-DynamicPort'
            description: 'RPC Dynamic Ports'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '49152 - 65535'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'SMB'
            description: 'SMB'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '192.168.0.1'
              '192.168.0.2'
              '192.168.0.3'
              '192.168.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '445'
            ]
          }
        ]
      }
    ]
  }
}
