@description('Name of the project - will be the name of all the resources')
param projectName string 

@description('Short name of the project')
param shortName string

@description('The Azure geolocation of the resources ')
param projectLocation string

@description('The name of the container registry')
param acrName string

// Used in deployment names to make strings unique
param unique string = uniqueString(projectName)

module acrModule './acr.bicep' = {
  name: '${unique}-shared-acr'
    params: {
        acrName: acrName
        location: projectLocation
    }
}

output loginServer string = acrModule.outputs.loginServer

module logAnalyticsWorkspace 'br/public:storage/log-analytics-workspace:1.0.3' = {
  name: '${unique}-log-analytics'
  scope: resourceGroup(projectName)
  params: {
    name: projectName
    location: projectLocation
  }
}

// TODO: Submit module to Bicrep registry 
module appInsightsModule 'insights.bicep' = {
  name: '${unique}-app-insights'
  dependsOn: [ logAnalyticsWorkspace ]
  scope: resourceGroup(projectName)
  params: {
    appInsightsName: projectName
    location: projectLocation
    logAnalyticsId: logAnalyticsWorkspace.outputs.id
  }
}

module containerAppEnvironment 'app-env.bicep' = {
  name: '${unique}-container-app-env'
  dependsOn: [ logAnalyticsWorkspace ]
  scope: resourceGroup(projectName)
  params: {
    name: projectName
    location: projectLocation
    logAnalyticsId: logAnalyticsWorkspace.outputs.id
  }
}

module containerAppApi 'container-app.bicep' = {
  name: '${unique}-api'
  dependsOn: [ logAnalyticsWorkspace, containerAppEnvironment ]
  scope: resourceGroup(projectName)
  params: {
    name:  '${shortName}-api'
    location: projectLocation
    appEnvironmentId: containerAppEnvironment.outputs.appEnvironmentId
  }
}

module containerAppWebApp 'container-app.bicep' = {
  name: '${unique}-webapp'
  dependsOn: [ logAnalyticsWorkspace, containerAppEnvironment ]
  scope: resourceGroup(projectName)
  params: {
    name:  '${shortName}-webapp'
    location: projectLocation
    appEnvironmentId: containerAppEnvironment.outputs.appEnvironmentId
  }
}
