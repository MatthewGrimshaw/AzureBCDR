param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource vnetRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  name: 'On-premises'
  parent: parentFirewall
  properties: {
    priority: 300
    ruleCollections: [
      {
        name: 'Allow-onprem-Network-Rules'
        priority: 301
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
              '192.168.0.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
              '192.168.0.0/24'
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
            name: 'ICMP'
            description: 'ICMP'
            ipProtocols: [
              'ICMP'
            ]
            sourceAddresses: [
              '192.168.0.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
              '192.168.0.0/24'
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
              '192.168.0.0/24'
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
            name: 'IPsecISAKMP'
            description: 'IPsec ISAKMP'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              '192.168.0.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
              '192.168.0.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
              '192.168.0.0/24'
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
              '192.168.0.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
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
              '192.168.0.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.4.0.0/22'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '445'
            ]
          }
        ]
      }
      {
        name: 'Allow-onprem-Application-Rules'
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        priority: 302
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'On-premises to spoke001 ACI using http'
            description: 'Allow on-premises network to connect to Azure Container Instance deployed to spoke001 using http on port 80'
            sourceAddresses: [
              '192.168.0.0/24'
            ]
            protocols: [
              {
                port: 80
                protocolType: 'Http'
              }
            ]
            targetFqdns: [
              '10.1.0.4'
            ]
          }
        ]
      }
    ]
  }
}
