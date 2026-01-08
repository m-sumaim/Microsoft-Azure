$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "eastus"
$VNetName          = "vnet-dev-eus-01"
$SubnetName        = "snet-dev-eus-web-01"
$PublicIpName      = "pip-web-dev-eus-01"
$NicName           = "nic-web-dev-eus-01"

az network nic create `
  --resource-group $ResourceGroupName `
  --location $Location `
  --name $NicName `
  --vnet-name $VNetName `
  --subnet $SubnetName `
    --public-ip-address $PublicIpName