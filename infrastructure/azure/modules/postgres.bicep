param location string
param serverName string

@secure()
param administratorLoginPassword string

param delegatedSubnetId string
param privateDnsZoneId string
param databaseNames array

resource server 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' = {
  name: serverName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: 'eduhamuyadmin'
    administratorLoginPassword: administratorLoginPassword
    version: '16'
    storage: {
      storageSizeGB: 32
      autoGrow: 'Enabled'
    }
    network: {
      delegatedSubnetResourceId: delegatedSubnetId
      privateDnsZoneArmResourceId: privateDnsZoneId
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
  }
}

resource databases 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2024-08-01' = [for databaseName in databaseNames: {
  parent: server
  name: databaseName
  properties: {}
}]

output fullyQualifiedDomainName string = server.properties.fullyQualifiedDomainName
