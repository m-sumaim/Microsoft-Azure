$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "eastus"

$AvSetName         = "as-dev-eus-01"
$DataDiskName      = "md-web-data-dev-eus-01"

$VmName            = "vm-dev-eus-web-01"
$VmSize            = "Standard_B1s"
$NicName           = "nic-web-dev-eus-01"          
$StorageAccountName= "stappdeveu1020"   

az vm availability-set create `
--resource-group $ResourceGroupName `
--name $AvSetName `
--location $Location `
--platform-fault-domain-count 2 `
 --platform-update-domain-count 5

az disk create `
--resource-group $ResourceGroupName `
--location $Location `
--name $DataDiskName `
--size-gb 16 `
--sku StandardSSD_LRS

az vm create `
--resource-group $ResourceGroupName `
--location $Location `
--name $VmName `
--nics $NicName `
 --size $VmSize `
--availability-set $AvSetName `
--admin-username linuxadmin `
--authentication-type ssh `
--generate-ssh-keys `
  --image "Canonical:ubuntu-24_04-lts:server:latest"

az vm disk attach `
--resource-group $ResourceGroupName `
--vm-name $VmName `
--name $DataDiskName `
--lun 0 `
--caching ReadWrite

az vm boot-diagnostics enable `
--resource-group $ResourceGroupName `
--name $VmName `
--storage "https://$StorageAccountName.blob.core.windows.net/"