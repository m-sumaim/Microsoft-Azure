
param name string
param location string
@description('Array of security rules, each like the ARM schema')
param rules array

@description('Subnets to attach this NSG to')
param attachments array

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-10-01'={ 
  name: name
  location: location
  properties: { 
    securityRules: [ 
      for r in rules: r
    ]
  }
}

resource subnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2024-10-01' = [
  for a in attachments: {
    name: '${a.vnetName}/${a.subnetName}'
    properties: {
      addressPrefix:a.addressPrefix
      networkSecurityGroup: { 
       id: nsg.id
    }
    }
  }
]

