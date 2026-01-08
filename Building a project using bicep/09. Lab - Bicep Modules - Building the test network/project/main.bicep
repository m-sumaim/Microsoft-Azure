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

// Defining that array of objects for the NSG
// May not the cleanest way, but works for now.
var nsgAttachments = [
  {
    vnetName: vnet.name
    subnetName: vnet.subnets[0].name
    addressPrefix: vnet.subnets[0].prefix
  }
  {
    vnetName: vnet.name
    subnetName: vnet.subnets[1].name
    addressPrefix: vnet.subnets[1].prefix
  }
  {
    vnetName: testvnet.name
    subnetName: testvnet.subnets[0].name
    addressPrefix: testvnet.subnets[0].prefix
  }
]

module ilb 'modules/network/internalLb.bicep' = {
  name: 'ilb'
  params: {
    location: location
    lbName: lbName
    subnetId: net.outputs.subnetIds[0].id 
  }
}

module storage './modules/storage/storageAccount.bicep' = {
  name: 'mod-storage'
  params: {
    name: storageAccountName
    location: location
  }
}

module net './modules/network/vnet.bicep' = {
  name: 'mod-network'
  params: {
    name: vnet.name
    location: location
    addressPrefixes: vnet.addressPrefixes
    subnets: vnet.subnets    
  }
}

module sec './modules/security/nsg.bicep' = {
  name: 'mod-nsg-shared'
  params: {
    name: nsg.name
    location: location
    rules: nsg.rules
    attachments: nsgAttachments
  }
  dependsOn: [ net ]
}

module winWeb './modules/compute/windowsVm.bicep' = {
  name: 'mod-win-web'
  params: {
    location: location
    baseName: winWebConfig.baseName       
    vmSize: winWebConfig.vmSize           
    subnetId: net.outputs.subnetIds[0].id  // Not the ideal way but not able to define a dictionary output              
    count: winWebConfig.count             
    adminUsername: winWebConfig.adminUsername
    adminPassword: winWebAdminPassword
    scriptUri: winWebConfig.scriptUri
    scriptCommand: 'powershell -ExecutionPolicy Bypass -File .\\setup-iis.ps1'
    lbBackendPoolId: ilb.outputs.backendPoolId
  }
  dependsOn: [ sec ]
}


module basPip './modules/network/publicIp.bicep' = {
  name: 'mod-bastion-pip'
  params: {
    name: bastion.pipName
    location: location
    sku: 'Standard'
    allocation: 'Static'
  }
}

module bas './modules/security/bastion.bicep' = {
  name: 'mod-bastion'
  params: {
    name: bastion.name
    location: location
    bastionSubnetId: net.outputs.subnetIds[2].id
    publicIpId: basPip.outputs.id
    scaleUnits: bastion.scaleUnits
  }
  
}


module linWeb './modules/compute/linuxVm.bicep' = {
  name: 'mod-linux-web'
  params: {
    location: location
    baseName: linuxWebConfig.baseName
    vmSize: linuxWebConfig.vmSize
    subnetId: testnet.outputs.subnetIds[0].id
    count: linuxWebConfig.count
    adminUsername: linuxWebConfig.adminUsername
    adminPassword: linuxWebAdminPassword    
  }
  dependsOn: [ sec ]
}

module testnet './modules/network/vnet.bicep' = {
  name: 'test-network'
  params: {
    name: testvnet.name
    location: location
    addressPrefixes: testvnet.addressPrefixes
    subnets: testvnet.subnets    
  }
}
