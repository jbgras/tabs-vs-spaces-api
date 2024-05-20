@description('Cosmos DB account name max length 44 characters lowercase')
param accountName string = 'sql-${uniqueString(resourceGroup().id)}'

@description('Location for the Cosmos DB account.')
param location string = resourceGroup().location

@description('The primary region for the Cosmos DB account.')
param primaryRegion string = location

@description('Database name')
param databaseName string

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: accountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    enableMultipleWriteLocations: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: primaryRegion
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  name: databaseName
  parent: account
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource scoresContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  name: 'scores'
  parent: database
  properties: {
    resource: {
      id: 'scores'
      partitionKey: {
        paths: [
          '/type'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        automatic: true
        indexingMode: 'Consistent'
        includedPaths: [
          {
            path: '/*'
            indexes: [
              {
                kind: 'Range'
                dataType: 'Number'
                precision: -1
              }
              {
                kind: 'Range'
                dataType: 'String'
                precision: -1
              }
              {
                kind: 'Spatial'
                dataType: 'Point'
              }
            ]
          }
        ]
      }
    }
  }
}
