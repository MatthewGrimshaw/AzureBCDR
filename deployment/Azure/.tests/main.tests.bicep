param location string = 'westeurope'

module resourceGroup '../modules/resource-group.bicep' = {
  scope: subscription()
  name: 'psrulesResourcegroupName'
  params: {
    resourceGroupName: 'psruleResourceGroupNames'
    location: 'westeurope'
    tags: {
      env: 'dev'
    }
  }
}

module vNets '../modules/vnet.bicep' = {
  name: 'deploy-psrulespoke1-PaaS'
  params: {
    location: location
    vnetName: 'psrulespoke1-PaaS'
    vnetAddressPrefixes: [ '10.1.0.0/24' ]
    subnetName: 'default'
    subnetAddressPrefix: '10.1.0.0/24'
    nsg: true
    tags: {
      env: 'dev'
    }
  }
}

module bastion '../modules/bastion.bicep' = {
  name: 'bastion'
  params: {
    location: location
    vnetName: 'spoke3'
    tags: {
      env: 'dev'
    }
  }
  dependsOn: [
    vNets
  ]
}

module firewallPolicy '../modules/firewall-policy.bicep' = {
  name: 'firewallPolicy'
  params: {
    name: 'psruleFwPolicyName'
    location: location
    tags: {
      env: 'dev'
    }
  }
}

module vWanHub '../modules/vwan.bicep' = {
  name: 'vWanHub'
  params: {
    location: location
    vWanName: 'psruleVWANName'
    vWanHubAddressPrefix: '10.0.0.1'
    vWanHubLocation: location
    vWanHubName: 'psruleVWANHubName'
    tags: {
      env: 'dev'
    }
  }
}

module firewall '../modules/firewall.bicep' = {
  name: 'firewall'
  params: {
    firewallName: 'psruleFirewallName'
    firewallLocation: location
    firewallPolicy: firewallPolicy.outputs.id
    vWanHubName: 'psruleVWANHubName'
    tags: {
      env: 'dev'
    }
  }
}

module vWanDefaultRoutes '../modules/vWanDefaultRoutes.bicep' = {
  name: 'vWanDefaultRoutes'
  params: {
    vWanHubName: 'pasruleVWANHubName'
    firewallName: 'psruleFirewallName'
  }
  dependsOn: [
    vWanHub
  ]
}

module vWanNetConnections '../modules/vWanNetConnections.bicep' = {
  name: 'connection-psruleVNetName'
  params: {
    vWanHubName: 'psruleVWANHubName'
    vNetName: 'psruleVNetName'
  }
  dependsOn: [
    vWanHub
  ]
}

module recoveryVault '../modules/recoveryVault.bicep' = {
  name: 'psruleRecoveryVaultName'
  params: {
    vaultName: 'psruleRecoveryVaultName'
    location: location
    vNetName: 'psruleRecoveryVaultVNetName'
    subnetName: 'psruleRecoveryVaultSubnetName'
    alertingEmailAddress: 'psrulesEmailAddress@email.com'
    tags: {
      env: 'dev'
    }
  }
}

module backupPolicies '../modules/backupPolicy.bicep' = {
  name: 'psruleBackupPolicyName'
  params: {
    vaultName: 'AzRecoveryVault'
    location: location
    backupPolicyName: 'psruleBackupPolicyName'
    service: 'Gold'
    tags: {
      env: 'dev'
    }
  }
  dependsOn: [
    recoveryVault
  ]
}
