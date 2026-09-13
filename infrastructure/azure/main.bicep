targetScope = 'resourceGroup'

@description('Azure region for the platform resources.')
param location string = 'eastus2'

@description('Name of the platform VNet.')
param vnetName string = 'eduhamuy-platform-vnet'

@description('Address space for the platform VNet. Must not overlap the existing AKS VNet during migration.')
param vnetAddressSpace string = '10.240.0.0/16'

@description('Name of the new AKS cluster.')
param aksName string = 'aks-eduhamuy-platform'

@description('Name of the PostgreSQL server for DEV and TEST.')
param postgresDevTestName string = 'eduhamuy-pg-devtest'

@description('Name of the PostgreSQL server for PROD.')
param postgresProdName string = 'eduhamuy-pg-prod'

@description('Kubernetes version for the new AKS cluster. Verify availability with az aks get-versions before deployment.')
param kubernetesVersion string = '1.36.3'

@description('Initial AKS node count. Three nodes currently provide capacity for Argo CD, Gateway/Istio and the three web environments.')
param aksNodeCount int = 3

@description('Initial AKS node VM size.')
param aksNodeVmSize string = 'Standard_D2s_v7'

@secure()
@description('Administrator password for the DEV/TEST PostgreSQL server. Supply it at deployment time; never commit it.')
param postgresDevTestAdminPassword string

@secure()
@description('Administrator password for the PROD PostgreSQL server. Supply it at deployment time; never commit it.')
param postgresProdAdminPassword string

module network './modules/vnet.bicep' = {
  name: 'platform-network'
  params: {
    location: location
    vnetName: vnetName
    addressSpace: vnetAddressSpace
  }
}

module privateDns './modules/private-dns.bicep' = {
  name: 'postgres-private-dns'
  params: {
    vnetId: network.outputs.vnetId
  }
}

module aks './modules/aks.bicep' = {
  name: 'platform-aks'
  params: {
    location: location
    aksName: aksName
    aksSubnetId: network.outputs.aksSubnetId
    kubernetesVersion: kubernetesVersion
    nodeCount: aksNodeCount
    nodeVmSize: aksNodeVmSize
  }
}

module postgresDevTest './modules/postgres.bicep' = {
  name: 'postgres-devtest'
  params: {
    location: location
    serverName: postgresDevTestName
    administratorLoginPassword: postgresDevTestAdminPassword
    delegatedSubnetId: network.outputs.postgresDevTestSubnetId
    privateDnsZoneId: privateDns.outputs.zoneId
    databaseNames: [
      'keycloak_dev'
      'keycloak_test'
    ]
  }
}

module postgresProd './modules/postgres.bicep' = {
  name: 'postgres-prod'
  params: {
    location: location
    serverName: postgresProdName
    administratorLoginPassword: postgresProdAdminPassword
    delegatedSubnetId: network.outputs.postgresProdSubnetId
    privateDnsZoneId: privateDns.outputs.zoneId
    databaseNames: [
      'keycloak_prod'
    ]
  }
}

output platformVnetId string = network.outputs.vnetId
output aksId string = aks.outputs.aksId
output postgresDevTestFqdn string = postgresDevTest.outputs.fullyQualifiedDomainName
output postgresProdFqdn string = postgresProd.outputs.fullyQualifiedDomainName
