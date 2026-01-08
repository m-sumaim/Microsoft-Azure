// modules/network/vnet.bicep
@description('Virtual network name')
param name string

@description('Deployment location, e.g. eastus')
param location string

@description('Address prefixes for the VNet (e.g., ["10.0.0.0/16"])')
param addressPrefixes array

@description('Subnets to create: array of { name: string, prefix: string }')
param subnets array

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      for s in subnets: {
        name: s.name
        properties: {
          addressPrefix: s.prefix
        }
      }
    ]
  }
}

output subnetIds array = [
  for s in subnets: {
    name: s.name
    id: resourceId('Microsoft.Network/virtualNetworks/subnets', name, s.name)
  }
]
