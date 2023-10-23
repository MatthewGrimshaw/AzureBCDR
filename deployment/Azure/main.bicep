param location string = resourceGroup().location
param vNetsArray array
param firewallPolicyName string
param vWanName string
param vWanHubAddressPrefix string
param vWanHubName string
param firewallName string
param vaultName string
param recoveryVaultVNetName string
param recoveryVaultSubnetName string
param backupPoliciesArray array

module vNets 'modules/vnet.bicep' = [for vnet in vNetsArray:{
  name: vnet.vnetName
  params: {
    location: location
    vnetName: vnet.vnetName
    vnetAddressPrefixes: vnet.vnetAddressPrefixes
    subnetName: vnet.subnetName
    subnetAddressPrefix: vnet.subnetAddressPrefix
    nsg: vnet.nsg
    }
  }
]


module bastion 'modules/bastion.bicep' = {
  name: 'bastion'
  params: {
    location: location
    vnetName: 'spoke3'
  }
  dependsOn:  [
    vNets
  ]
}

module firewallPolicy 'modules/firewall-policy.bicep' = {
  name: 'firewallPolicy'
  params: {
   name: firewallPolicyName
   location: location
   }
}


module vWanHub 'modules/vwan.bicep' = {
  name: 'vWanHub'
  params: {
    location: location
    vWanName: vWanName
    vWanHubAddressPrefix: vWanHubAddressPrefix
    vWanHubLocation: location
    vWanHubName: vWanHubName
  }
}

module firewall 'modules/firewall.bicep' = {
  name: 'firewall'
  params: {
    firewallName: firewallName
    firewallLocation: location
    firewallPolicy: firewallPolicy.outputs.id
    vWanHubName: vWanHubName
  }
}

module vWanDefaultRoutes 'modules/vWanDefaultRoutes.bicep' = {
  name: 'vWanDefaultRoutes'
  params: {
    vWanHubName:  vWanHubName
    firewallName: firewallName
  }
  dependsOn: [
    vWanHub
  ]
}


module vWanNetConnections 'modules/vWanNetConnections.bicep' = [for vnet in vNetsArray:{
  name: 'connection-${vnet.vnetName}'
  params: {
      vWanHubName:  vWanHubName
      vNetName: vnet.vnetName
    }
    dependsOn: [
      vWanHub
    ]
  }
]

module recoveryVault 'modules/recoveryVault.bicep' = {
  name: vaultName
  params: {
    vaultName: vaultName
    location: location
    vNetName: recoveryVaultVNetName
    subnetName: recoveryVaultSubnetName
  }
}


module backupPolicies 'modules/backupPolicy.bicep' = [for policy in backupPoliciesArray:{
  name: policy.name
  params: {
    vaultName: 'AzRecoveryVault'
    location : location
    backupPolicyName: policy.Name
    service: policy.Service
  }
  dependsOn: [
    recoveryVault
  ]
}
]
