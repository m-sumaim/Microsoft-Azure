$ResourceGroupName    = "rg-az104-dev-eus"
$Location             = "eastus"
$VNetName             = "vnet-dev-eus-01"
$AddressSpace         = "10.0.0.0/16"
$SubnetName           = "snet-dev-eus-web-01"
$SubnetAddressPrefix  = "10.0.0.0/24"

az network vnet create `
--resource-group $ResourceGroupName  `
--location $Location  `
--name $VNetName `
--address-prefixes $AddressSpace `
--subnet-name $SubnetName `
--subnet-prefixes $SubnetAddressPrefix
