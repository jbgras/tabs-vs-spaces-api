// Create Azure Container App Environment
@description('Name of the Container App Environment')
param name string

@description('Provide a location for the Container App Environment.')
param location string =  resourceGroup().location

@description('Provide the id for the log analytics workspace.d')
param logAnalyticsId string

// Managed container environment
// https://learn.microsoft.com/en-us/azure/templates/microsoft.app/2023-11-02-preview/managedenvironments?pivots=deployment-language-bicep
resource environment 'Microsoft.App/managedEnvironments@2023-11-02-preview' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalyticsId, '2022-10-01').customerId
        sharedKey: listKeys(logAnalyticsId, '2022-10-01').primarySharedKey
      }
    }
  }
}

output appEnvironmentId string = environment.id
