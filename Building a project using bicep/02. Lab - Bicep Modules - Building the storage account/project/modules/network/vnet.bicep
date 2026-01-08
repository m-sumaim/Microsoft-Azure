@description('Virtual network name')
param name string

@description('Deployment location, e.g. eastus')
param location string

@description('Address prefixes for the VNet')
param addressPrefixes array

@description('Subnets to create')
param subnets array


resource vnet 'Microsoft.Network/virtualNetworks@2024-10-01' ={
  name: name
  location: location
  properties: {
    addressSpace: {addressPrefixes: addressPrefixes}
    subnets:[      
      for s in subnets : {
        name: s.name
        properties: { 
          addressPrefix:s.prefix
        }
      }
    ]
  }
}
