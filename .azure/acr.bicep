param acrName string
param location string

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
    name: acrName
    location: location
    sku: {
        name: 'Basic'
    }
    properties: {
        adminUserEnabled: true
    }
}

output loginServer string = acrResource.properties.loginServer
