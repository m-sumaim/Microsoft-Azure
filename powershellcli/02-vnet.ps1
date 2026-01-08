$ResourceGroupName ="rg-az104-dev-eus"
$Location = "eastus"
$VNetName          = "vnet-dev-eus-01"
$AddressSpace      = "10.0.0.0/16"

New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName `
-Location $Location -AddressPrefix $AddressSpace