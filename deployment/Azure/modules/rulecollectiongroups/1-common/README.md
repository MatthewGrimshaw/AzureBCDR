# Common Management Plane Services

These are top level common rules that apply to all Azure Management Plane traffic.

- Allow use of [Azure KMS server for Windows activation](https://docs.microsoft.com/en-us/troubleshoot/azure/virtual-machines/custom-routes-enable-kms-activation)

- Allow Windows Time Service

- Allow use of Windows Update

- Allow Service Tags for Azure Management Plane Services:

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

- Allow URLs for Azure Site Recovery and Azure Backup
