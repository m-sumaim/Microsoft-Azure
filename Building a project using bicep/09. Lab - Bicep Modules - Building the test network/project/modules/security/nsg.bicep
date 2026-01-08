param name string
param location string
@description('Array of security rules, each like the ARM schema')
param rules array

@description('Subnets to attach this NSG to. Each item needs: vnetName, subnetName, addressPrefix')
param attachments array = []

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: name
  location: location
  properties: {
    securityRules: [ for r in rules: r ]
  }
}

// For each requested subnet, update it to reference this NSG.
// Note: we must include the existing addressPrefix when patching a subnet.
resource subnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = [
  for a in attachments: {
    name: '${a.vnetName}/${a.subnetName}'
    properties: {
      addressPrefix: a.addressPrefix
      networkSecurityGroup: { id: nsg.id }
    }
    
  }
]
