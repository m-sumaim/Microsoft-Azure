@description('Bastion host name')
param name string
@description('Region')
param location string
@description('Subnet resource ID of AzureBastionSubnet')
param bastionSubnetId string
@description('Public IP resource ID')
param publicIpId string
@description('Standard SKU scale units (min 2)')
param scaleUnits int = 2

resource bas 'Microsoft.Network/bastionHosts@2024-07-01' = {
  name: name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastion-ipconfig'
        properties: {
          subnet: { id: bastionSubnetId }
          publicIPAddress: { id: publicIpId }
        }
      }
    ]
    scaleUnits: scaleUnits
    
  }
  sku: {
    name: 'Standard'
  }
}
