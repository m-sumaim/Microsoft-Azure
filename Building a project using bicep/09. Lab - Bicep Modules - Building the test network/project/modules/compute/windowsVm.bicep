// --- CSE inputs ---
@description('URI to the script file (e.g., SAS URL from Storage or a raw GitHub URL)')
param scriptUri string

@secure()
@description('Command to execute on the VM after the file is downloaded')
param scriptCommand string = 'powershell -ExecutionPolicy Bypass -File .\\setup.ps1'

@description('Azure region')
param location string

@description('Base name without the numeric suffix, e.g. vm-dev-eus-web')
param baseName string

@description('VM size, e.g. Standard_D2s_v3')
param vmSize string

@description('Target subnet resource ID')
param subnetId string

@description('How many VMs to create')
param count int

@description('Admin username')
param adminUsername string = 'azureadmin'

@secure()
@description('Admin password (or use Key Vault reference in the parameter file)')
param adminPassword string

param lbBackendPoolId string

var indexes = [for i in range(1, count): i]
var vmNames = [for i in indexes: '${baseName}-${i}']
var nicNames = [for n in vmNames: replace(n, 'vm-', 'nic-')]

resource nics 'Microsoft.Network/networkInterfaces@2024-07-01' = [for (n, i) in nicNames: {
  name: n
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-01'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: { id: subnetId }
          loadBalancerBackendAddressPools: [
            { id: lbBackendPoolId }   // <-- attach NIC to ILB backend pool
          ]
        }
      }
    ]
  }
}]

resource vms 'Microsoft.Compute/virtualMachines@2024-07-01' = [for (vmName, i) in vmNames: {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer:     'WindowsServer'
        sku:       '2025-datacenter'
        version:   'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nics[i].id
          properties: { primary: true }
        }
      ]
    }
  }
}]


resource vmCse 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = [
  for i in range(0, length(vmNames)): {
    name: 'cse-init'                      // extension name on the VM
    location: location
    parent: vms[i]                        // binds extension to the ith VM and handles dependsOn
    properties: {
      publisher: 'Microsoft.Compute'
      type: 'CustomScriptExtension'
      typeHandlerVersion: '1.10'
      autoUpgradeMinorVersion: true
      settings: {
        fileUris: [
          scriptUri                       // can include multiple files if needed
        ]
      }
      protectedSettings: {
        commandToExecute: scriptCommand   // runs after files are placed in the CSE working dir
      }
    }
  }
]
