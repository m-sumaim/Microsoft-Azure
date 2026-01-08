param location string
param vnet object
param storageAccountName string
param nsg object
param winWebConfig object
@secure()
param winWebAdminPassword string
param bastion object
param lbName string

param linuxWebConfig object
@secure()
param linuxWebAdminPassword string
param testvnet object

var nsgAttachments = [
{
      vnetName:vnet.name
      subnetName:vnet.subnets[0].name
      addressPrefix:vnet.subnets[0].prefix
}
{
      vnetName:vnet.name
      subnetName:vnet.subnets[1].name
      addressPrefix:vnet.subnets[1].prefix
}
{
    vnetName: testvnet.name
    subnetName: testvnet.subnets[0].name
    addressPrefix: testvnet.subnets[0].prefix
}
]

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


module sharednsg 'modules/security/nsg.bicep' = { 
   name: 'nsg-az104-shared-eus-01'
   params: { 
      location:location
      name:nsg.name
      rules:nsg.rules
      attachments:nsgAttachments
   }
   dependsOn:[devnet]
}



module winWeb 'modules/compute/windowsVm.bicep'= { 
   name:'win-web-dev'
   params: { 
      location:location
      baseName:winWebConfig.baseName
      vmSize:winWebConfig.vmSize
      count:winWebConfig.count
      adminUserName:winWebConfig.adminUserName
      subnetId: devnet.outputs.subnetIds[0].id
      adminPassword:winWebAdminPassword 
      scriptUri:winWebConfig.scriptUri
      scriptCommand: 'powershell -ExecutionPolicy Bypass -File .\\setup-iis.ps1'
      lbBackendPoolId:ilb.outputs.backendPoolId
   }

   dependsOn:[sharednsg]
}

module ilb 'modules/network/internalLB.bicep' = { 
   name: 'ilb'
   params: { 
      location:location
      lbName:lbName
      subnetId:devnet.outputs.subnetIds[0].id
   }
}

module basPip 'modules/network/publicIp.bicep' =  { 
   name: 'bastion-ip'
   params: { 
      name:bastion.pipName
      location:location
      sku:'Standard'
      allocation:'Static'
   }
}

module bastionhost 'modules/security/bastion.bicep'= { 
   name: 'bastion'
   params:{ 
      name:bastion.name
      location:location
      subnetId:devnet.outputs.subnetIds[2].id
      publicIPId:basPip.outputs.PublicIPid
   }
}

module testnet 'modules/network/vnet.bicep' = { 
   name: 'test-network'
  params: {
    name: testvnet.name
    location: location
    addressPrefixes: testvnet.addressPrefixes
    subnets: testvnet.subnets    
  }
}

module linuxVm 'modules/compute/linuxVm.bicep' = { 
   params: {
    location: location
    baseName: linuxWebConfig.baseName
    vmSize: linuxWebConfig.vmSize
    subnetId: testnet.outputs.subnetIds[0].id
    count: linuxWebConfig.count
    adminUserName: linuxWebConfig.adminUsername
    adminPassword: linuxWebAdminPassword    
  }
  
}

module vnetpeering 'modules/network/vnetpeering.bicep'= { 
   name: 'vnet-peering-dev-test'
   params:{ 
      localVnetName:vnet.name
      remoteVnetName:testvnet.name
      localVnetId:devnet.outputs.vnetId
      remoteVnetId:testnet.outputs.vnetId
   }
}
