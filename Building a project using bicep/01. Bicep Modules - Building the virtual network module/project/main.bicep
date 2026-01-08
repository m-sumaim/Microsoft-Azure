param location string
param vnet object

module devnet 'modules/network/vnet.bicep' = { 
   name: 'dev-network'
   params: { 
    name:vnet.name
    location: location
    addressPrefixes:vnet.addressPrefixes
    subnets:vnet.subnets
   }
}

