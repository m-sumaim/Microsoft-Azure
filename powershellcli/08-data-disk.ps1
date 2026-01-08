$ResourceGroupName = "rg-az104-dev-eus"
$VmName            = "vm-dev-eus-web-01"

$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName

$vm=Add-AzVMDataDisk -VM $vm `
  -Name "disk-web-data-dev-eus-01" `
  -DiskSizeInGB 16 `
  -Lun 0 `
  -CreateOption Empty `
  -StorageAccountType StandardSSD_LRS `
  -Caching ReadWrite   

  Update-AzVM -ResourceGroupName $ResourceGroupName -VM $vm
