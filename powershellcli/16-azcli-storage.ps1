$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "eastus"
$StorageAccountName = "stappdeveu1020"   
$Kind              = "StorageV2"
$Sku               = "Standard_LRS"

az storage account create `
--name $StorageAccountName `
--resource-group $ResourceGroupName `
--location $Location `
--sku $Sku `
--kind $Kind