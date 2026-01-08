@description('Public IP name')
param name string
@description('Region')
param location string
@description('SKU: Standard required for Bastion')
param sku string = 'Standard'
@description('Allocation method: Static required for Bastion')
param allocation string = 'Static'

resource pip 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: name
  location: location
  sku: { name: sku }
  properties: {
    publicIPAllocationMethod: allocation
  }
}

output id string = pip.id
