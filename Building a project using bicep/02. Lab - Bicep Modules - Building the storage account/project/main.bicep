param location string
param vnet object
param storageAccountName string

module devnet 'modules/network/vnet.bicep' = { 
   name: 'dev-network'
   params: { 
    name:vnet.name
    location: location
    addressPrefixes:vnet.addressPrefixes
    subnets:vnet.subnets
   }  
}

module storage 'modules/storage/storageAccount.bicep' = { 
    name: 'stcloudhublearningdeveus'
    params: { 
      name:storageAccountName
      location: location
    }
}

