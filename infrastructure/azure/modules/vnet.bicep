param location string
param vnetName string
param addressSpace string

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [addressSpace]
    }
    subnets: [
      {
        name: 'subnet-aks'
        properties: {
          addressPrefix: '10.240.0.0/20'
        }
      }
      {
        name: 'subnet-appgateway'
        properties: {
          addressPrefix: '10.240.16.0/24'
        }
      }
      {
        name: 'subnet-postgres-devtest'
        properties: {
          addressPrefix: '10.240.17.0/24'
          delegations: [
            {
              name: 'postgres-flexible-server'
              properties: {
                serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
              }
            }
          ]
        }
      }
      {
        name: 'subnet-postgres-prod'
        properties: {
          addressPrefix: '10.240.18.0/24'
          delegations: [
            {
              name: 'postgres-flexible-server'
              properties: {
                serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
              }
            }
          ]
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output aksSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'subnet-aks')
output postgresDevTestSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'subnet-postgres-devtest')
output postgresProdSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'subnet-postgres-prod')
