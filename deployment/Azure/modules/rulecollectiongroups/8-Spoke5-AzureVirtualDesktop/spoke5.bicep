param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource vnetRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'spoke5-AzureVirtualDesktop'
  parent: parentFirewall
  properties: {
    priority: 800
    ruleCollections: [
      {
        name: 'Allow-spoke5-Network-Rules'
        priority: 801
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        // Active Directory 
        rules: [
          // Justification
          // Active Directory 
          // https://learn.microsoft.com/en-US/troubleshoot/windows-server/identity/config-firewall-for-ad-domains-and-trusts
          {
            ruleType: 'NetworkRule'
            name: 'GlobalCatalog'
            description: 'Global Catalog'
            ipProtocols: [
              'Tcp'
            ]
            sourceAddresses: [
              '10.5.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
            name: 'LDAPServer'
            description: 'LDAP Server'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              '10.5.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
              '10.5.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '636'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'DNS'
            description: 'DNS'
            ipProtocols: [
              'UDP'
              'TCP'
            ]
            sourceAddresses: [
              '10.5.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '53'
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
              '10.5.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
              '10.5.0.0/22'
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
              '10.5.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '445'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Kerberos'
            description: 'Kerberos'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.5.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '88'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'W32Time'
            description: 'W32Time'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              '10.4.0.0/22'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.5.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '123'
            ]
          }
          {
            // Justification:
            // https://learn.microsoft.com/en-us/azure/virtual-network/service-tags-overview#available-service-tags
            ruleType: 'NetworkRule'
            name: 'ServiceTags'
            description: 'Allow traffic from all address spaces to Azure Virtual Desktop'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
            'WindowsVirtualDesktop'
            ]
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
