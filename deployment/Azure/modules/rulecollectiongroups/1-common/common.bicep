param parentName string

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource commonRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: 'ManagementPlane'
  parent: parentFirewall
  properties: {
    priority: 100
    ruleCollections: [
      {
        name: 'Allow-ManagementPlane-Network-Rules'
        priority: 101
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          // KMS Activation
          {
            // Justification:
            // https://docs.microsoft.com/en-us/troubleshoot/azure/virtual-machines/custom-routes-enable-kms-activation
            ruleType: 'NetworkRule'
            name: 'Azure-KMS-Service'
            description: 'Allow traffic from all address spaces to Azure platform KMS Service'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: []
            destinationIpGroups: []
            destinationFqdns: [
              'kms.${environment().suffixes.storage}'
            ]
            destinationPorts: [
              '1688'
            ]
          }
          // Time Services
          {
            ruleType: 'NetworkRule'
            name: 'time-windows'
            ipProtocols: [
              'UDP'
            ]
            destinationAddresses: [
              '13.86.101.172'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationPorts: [
              '123'
            ]
          }
          // Azure Management Plane Service Tags
          {
            // Justification:
            // https://learn.microsoft.com/en-us/azure/virtual-network/service-tags-overview#available-service-tags
            ruleType: 'NetworkRule'
            name: 'ServiceTags'
            description: 'Allow traffic from all address spaces to Azure Management Plane services'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
            'ApplicationInsightsAvailability'
            'AppService'
            'AzureAdvancedThreatProtection'
            'AzureArcInfrastructure'
            'AzureAttestation'
            'AzureBackup'
            'AzureContainerRegistry'
            'AzureDevOps'
            'AzureMonitor'
            'AzurePlatformDNS'
            'AzurePlatformLKM'
            'AzureSiteRecovery'
            'AzureUpdateDelivery'
            'EventHub'
            'Sql'
            'SqlManagement'
            'Storage'
            'WindowsAdminCenter'
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
        name: 'Allow-ManagementPlane-Application-Rules'
        priority: 102
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          //Windows Update
          {
            ruleType: 'ApplicationRule'
            name: 'Http'
            description: 'Allow traffic from all sources to Windows Update (http)'
            protocols: [
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            fqdnTags: [
              'WindowsUpdate'
            ]
            webCategories: []
            targetFqdns: []
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
          }
          //Windows Update
          {
            ruleType: 'ApplicationRule'
            name: 'Https'
            description: 'Allow traffic from all sources to Windows Update (https)'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: [
              'WindowsUpdate'
            ]
            webCategories: []
            targetFqdns: []
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
          }
          // Azure Site Recovery
          {
            // Justification
            // Required for Azure Site Recovery
            // Required so that data can be written to the cache storage account in the source region from the VM. 
            // If you know all the cache storage accounts for your VMs, you can allow access to the specific storage account URLs 
            // (Ex: cache1.blob.core.windows.net and cache2.blob.core.windows.net) instead of *.blob.core.windows.net
            // https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-about-networking
            ruleType: 'ApplicationRule'
            name: 'Azure-Storage'
            description: 'Allow traffic from all sources to Azure-Storage'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            webCategories: []
            targetFqdns: [
              '*.blob.${environment().suffixes.storage}'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
          }
          // Azure Site Recovery
          {
            // Justification
            // Required for Azure Site Recovery
            // Required for authorization and authentication to the Site Recovery service URLs.
            // https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-about-networking
            ruleType: 'ApplicationRule'
            name: 'Authentication'
            description: 'Allow traffic from all sources to ${environment().authentication.loginEndpoint}'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            webCategories: []
            targetFqdns: [
              '${environment().authentication.loginEndpoint}'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
          }
          // Azure Site Recovery
          {
            // Justification
            // Required for Azure Site Recovery
            // Required so that the Site Recovery service communication can occur from the VM..
            // https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-about-networking
            ruleType: 'ApplicationRule'
            name: 'AzureSiteRecovery'
            description: 'Allow traffic from all sources to *.hypervrecoverymanager.windowsazure.com'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            webCategories: []
            targetFqdns: [
              '*.hypervrecoverymanager.windowsazure.com'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
          }
          //Azure Site Recovery
          {
            // Justification
            // Required for Azure Site Recovery
            // Required so that the Site Recovery monitoring and diagnostics data can be written from the VM..
            // https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-about-networking
            ruleType: 'ApplicationRule'
            name: 'AzureServiceBus'
            description: 'Allow traffic from all sources to *.servicebus.windows.net'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            webCategories: []
            targetFqdns: [
              '*.servicebus.windows.net'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
          }
          //Azure Site Recovery
          {
            // Justification
            // Required for Azure Site Recovery
            // Required so that the Site Recovery monitoring and diagnostics data can be written from the VM..
            // https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-about-networking
            ruleType: 'ApplicationRule'
            name: 'AzureRecoveryVault'
            description: 'Allow traffic from all sources to *.${environment().suffixes.keyvaultDns}'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            webCategories: []
            targetFqdns: [
              '*.${environment().suffixes.keyvaultDns}'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
          }
          //Azure Site Recovery
          {
            // Justification
            // Required for Azure Site Recovery
            // Allows enabling auto-upgrade of mobility agent for a replicated item via portal.
            // https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-about-networking
            ruleType: 'ApplicationRule'
            name: 'AzureMobilityAgent'
            description: 'Allow traffic from all sources to *.automation.ext.azure.com'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            webCategories: []
            targetFqdns: [
              '*.automation.ext.azure.com'
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
          }
          //Azure Backup
          {
            // Justification
            // Required for Azure Backup
            // https://azure.microsoft.com/en-gb/blog/azure-backup-for-virtual-machines-behind-an-azure-firewall/
            ruleType: 'ApplicationRule'
            name: 'AzureBackup'
            description: 'Allow traffic from all sources to Azure Backup'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            fqdnTags: [
              'AzureBackup'
            ]
            webCategories: []
            targetFqdns: []
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
          }
          //Windows Diagnostics
          {
            // Justification
            // Allow Windows Diagnostics
            // https://learn.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization#endpoints
            ruleType: 'ApplicationRule'
            name: 'Windows Diagnostics'
            description: 'Allow traffic from all sources to Windows Diagnostics'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            fqdnTags: [
              'WindowsDiagnostics'
            ]
            webCategories: []
            targetFqdns: []
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
          }
          //MicrosoftActiveProtectionService (MAPS)
          {
            // Justification
            // Allow MicrosoftActiveProtectionService (MAPS)
            // https://techcommunity.microsoft.com/t5/configuration-manager-archive/important-changes-to-microsoft-active-protection-service-maps/ba-p/274006
            ruleType: 'ApplicationRule'
            name: 'MAPS'
            description: 'Allow traffic from all sources to Microsoft Active Protection Service'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            fqdnTags: [
              'MicrosoftActiveProtectionService'
            ]
            webCategories: []
            targetFqdns: []
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: []
            sourceIpGroups: []
          }
        ]
      }
    ]
  }
}
