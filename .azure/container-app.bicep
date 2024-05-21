@minLength(5)
@maxLength(50)
@description('Provide a name for your Azure Container App')
param name string

@description('Provide a location for the Container App.')
param location string = resourceGroup().location

@description('Port to expose')
param port int = 80

@description('Default image to deploy to container app')
param containerImage string = 'mcr.microsoft.com/k8se/quickstart:latest'

@description('Id for Container App Environment resource')
param appEnvironmentId string

// Container app
// https://learn.microsoft.com/en-us/azure/templates/microsoft.app/2023-11-02-preview/containerapps?pivots=deployment-language-bicep
resource containerApp 'Microsoft.App/containerApps@2023-11-02-preview' = {
  name: name
  location: location
  properties: {
    managedEnvironmentId: appEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: port
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
    }
    template: {
      containers: [
        {
          name: name
          image: containerImage
          env: [
            {
              name: 'PORT'
              value: string(port)
            }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1.0Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 2
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
output containerAppId string = containerApp.id
