$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "eastus"
$PublicIpName      = "pip-web-dev-eus-01"

az network public-ip create `
--resource-group $ResourceGroupName `
--location $Location `
--name $PublicIpName `
--sku Standard `
--allocation-method Static `
  --version IPv4
