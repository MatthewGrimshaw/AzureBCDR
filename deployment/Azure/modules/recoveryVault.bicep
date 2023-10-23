@description('Name of the Vault')
param vaultName string

@description('Enable CRR (Works if vault has not registered any backup instance)')
param enableCRR bool = true

@description('Change Vault Storage Type (Works if vault has not registered any backup instance)')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageType string = 'GeoRedundant'

@description('Location for all resources.')
param location string = resourceGroup().location

param vNetName string
param subnetName string


var privateEndpointName = 'RecoveryVaultPrivateEndpoint'
var privateDNSZoneName  = 'privatelink.we.backup.windowsazure.com'
var pvtEndpointDnsGroupName  = '${privateEndpointName}/privateEndpointDnsGroup'
var skuName = 'RS0'
var skuTier = 'Standard'

resource vNet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vNetName
}

resource resourceSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01'  existing = {
  parent: vNet
  name: subnetName
}

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: vaultName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    monitoringSettings: {
      azureMonitorAlertSettings: {
        alertsForAllJobFailures: 'Enabled'
      }
      classicAlertSettings: {
        alertsForCriticalOperations: 'Disabled'
      }
    }
    publicNetworkAccess: 'Disabled'
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: resourceSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: recoveryServicesVault.id
          groupIds: [
            'AzureBackup'
          ]
        }
      }
    ]
  }
}


resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSZoneName
  location: 'global'
  properties: {}
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateDNSZoneName}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vNet.id
    }
  }
}

resource pvtEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: pvtEndpointDnsGroupName
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoint
  ]
}


resource vaultStorageConfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2022-02-01' = {
  parent: recoveryServicesVault
  name: 'vaultstorageconfig'
  properties: {
    storageModelType: vaultStorageType
    crossRegionRestoreFlag: enableCRR
  }
}

