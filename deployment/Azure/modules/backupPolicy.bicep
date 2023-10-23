@description('Name of the Vault')
param vaultName string

@description('Location for all resources.')
param location string = resourceGroup().location

param backupPolicyName string

@allowed([
  'Gold'
  'Silver'
  'Bronze'
])
param service string


var scheduleRunTimes = [
  '2023-10-16T05:30:00Z'
]

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2023-01-01' existing = {
  name: vaultName
}

resource GoldBackupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-01-01' = if (service == 'Gold') {
  parent: recoveryServicesVault
  name: backupPolicyName
  location: location
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    protectedItemsCount: 0
    instantRPDetails: {}
    instantRpRetentionRangeInDays:2
    schedulePolicy: {
      scheduleRunFrequency: 'Hourly'
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      hourlySchedule: {
        interval: 4
        scheduleWindowDuration: 24
        scheduleWindowStartTime: '2023-10-16T05:30:00Z'
      }
    }
    retentionPolicy: {
      dailySchedule: {
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 180
          durationType: 'Days'
        }
      }
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
          'Tuesday'
          'Thursday'
        ]
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 24
          durationType: 'Weeks'
        }
      }
      monthlySchedule: {
        retentionScheduleFormatType: 'Daily'
        retentionScheduleDaily: {
          daysOfTheMonth: [
            {
              date: 1
              isLast: false
            }
          ]
        }
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 60
          durationType: 'Months'
        }
      }
      yearlySchedule: {
        retentionScheduleFormatType: 'Daily'
        monthsOfYear: [
          'January'
          'March'
          'August'
        ]
        retentionScheduleDaily: {
          daysOfTheMonth: [
            {
              date: 1
              isLast: false
            }
          ]
        }
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 10
          durationType: 'Years'
        }
      }
      retentionPolicyType: 'LongTermRetentionPolicy'
    }
    timeZone: 'UTC'
    tieringPolicy: {
       archivedRP:{
        tieringMode: 'DoNotTier'
        duration: 0
        durationType: 'Invalid'
       }
    }
  }
}

resource SilverBackupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-01-01' = if (service == 'Silver') {
  parent: recoveryServicesVault
  name: backupPolicyName
  location: location
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays:2
    schedulePolicy: {
      scheduleRunFrequency: 'Daily'
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunTimes:scheduleRunTimes
    }
    retentionPolicy: {
      dailySchedule: {
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 180
          durationType: 'Days'
        }
      }
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
          'Tuesday'
          'Thursday'
        ]
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 21
          durationType: 'Weeks'
        }
      }
      monthlySchedule: {
        retentionScheduleFormatType: 'Daily'
        retentionScheduleDaily: {
          daysOfTheMonth: [
            {
              date: 1
              isLast: false
            }
          ]
        }
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 2
          durationType: 'Months'
        }
      }
      yearlySchedule: {
        retentionScheduleFormatType: 'Daily'
        monthsOfYear: [
          'January'
          'March'
          'August'
        ]
        retentionScheduleDaily: {
          daysOfTheMonth: [
            {
              date: 1
              isLast: false
            }
          ]
        }
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 4
          durationType: 'Years'
        }
      }
      retentionPolicyType: 'LongTermRetentionPolicy'
    }
    timeZone: 'UTC'
  }
}

resource BronzeBackupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-01-01' = if (service == 'Bronze') {
  parent: recoveryServicesVault
  name: backupPolicyName
  location: location
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays: 5
    schedulePolicy: {
      scheduleRunFrequency: 'Weekly'
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunTimes: scheduleRunTimes
      scheduleRunDays: [
        'Sunday'
        'Tuesday'
        'Thursday'
      ]
    }
    retentionPolicy: {
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
          'Tuesday'
          'Thursday'
        ]
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 21
          durationType: 'Weeks'
        }
      }
      monthlySchedule: {
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleDaily: {
          daysOfTheMonth: [
            {
              date: 1
              isLast: false
            }
          ]
        }
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
            'Tuesday'
          ]
          weeksOfTheMonth:[
            'First'
            'Third'
          ]
        }
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 60
          durationType: 'Months'
        }
      }
      yearlySchedule: {
        retentionScheduleFormatType: 'Weekly'
        monthsOfYear: [
          'January'
          'March'
          'August'
        ]
        retentionScheduleDaily: {
          daysOfTheMonth: [
            {
              date: 1
              isLast: false
            }
          ]
        }
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
            'Tuesday'
          ]
          weeksOfTheMonth:[
            'First'
            'Third'
          ]
        }
        retentionTimes: scheduleRunTimes
        retentionDuration: {
          count: 10
          durationType: 'Years'
        }
      }
      retentionPolicyType: 'LongTermRetentionPolicy'
    }
    timeZone: 'UTC'
  }
}
