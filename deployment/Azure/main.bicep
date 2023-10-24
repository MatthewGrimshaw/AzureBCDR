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
param tags object
param alertingEmailAddress string

module vNets 'modules/vnet.bicep' = [for vnet in vNetsArray: {
  name: '${vnet}${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    vnetName: vnet.vnetName
    vnetAddressPrefixes: vnet.vnetAddressPrefixes
    subnetName: vnet.subnetName
    subnetAddressPrefix: vnet.subnetAddressPrefix
    nsg: vnet.nsg
    tags: tags
  }
}]

module bastion 'modules/bastion.bicep' = {
  name: 'bastion'
  params: {
    location: location
    vnetName: 'spoke3'
    tags: tags
  }
  dependsOn: [
    vNets
  ]
}

module firewallPolicy 'modules/firewall-policy.bicep' = {
  name: 'firewallPolicy'
  params: {
    name: firewallPolicyName
    location: location
    tags: tags
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
    tags: tags
  }
}

module firewall 'modules/firewall.bicep' = {
  name: 'firewall'
  params: {
    firewallName: firewallName
    firewallLocation: location
    firewallPolicy: firewallPolicy.outputs.id
    vWanHubName: vWanHubName
    tags: tags
  }
}

module vWanDefaultRoutes 'modules/vWanDefaultRoutes.bicep' = {
  name: 'vWanDefaultRoutes'
  params: {
    vWanHubName: vWanHubName
    firewallName: firewallName
  }
  dependsOn: [
    vWanHub
  ]
}

module vWanNetConnections 'modules/vWanNetConnections.bicep' = [for vnet in vNetsArray: {
  name: 'connection-${vnet}${uniqueString(resourceGroup().id)}'
  params: {
    vWanHubName: vWanHubName
    vNetName: vnet.vnetName
  }
  dependsOn: [
    vWanHub
  ]
}]

module recoveryVault 'modules/recoveryVault.bicep' = {
  name: vaultName
  params: {
    vaultName: vaultName
    location: location
    vNetName: recoveryVaultVNetName
    subnetName: recoveryVaultSubnetName
    tags: tags
    alertingEmailAddress: alertingEmailAddress
  }
}

module backupPolicies 'modules/backupPolicy.bicep' = [for policy in backupPoliciesArray: {
  name: 'policy-${policy}${uniqueString(resourceGroup().id)}'
  params: {
    vaultName: 'AzRecoveryVault'
    location: location
    backupPolicyName: policy.Name
    service: policy.Service
    tags: tags
  }
  dependsOn: [
    recoveryVault
  ]
}]
