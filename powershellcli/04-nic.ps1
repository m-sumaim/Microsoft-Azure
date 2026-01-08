$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "eastus"  
$NicName           = "nic-web-dev-eus-01"
$VNetName          = "vnet-dev-eus-01"
$SubnetName         = "snet-dev-eus-web-01"

$VNet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VNetName
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet

New-AzNetworkInterface -Name $NicName `
-ResourceGroupName $ResourceGroupName `
-Location $Location `
-Subnet $Subnet `
-IpConfigurationName "ipconfig-web-01"