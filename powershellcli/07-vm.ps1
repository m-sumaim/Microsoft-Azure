$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "eastus"  
$VmName            = "vm-dev-eus-web-01"
$VmSize            = "Standard_B1s"
$NicName = "nic-web-dev-eus-01"

$VmConfig = New-AzVMConfig -Name $VmName -VMSize $VmSize

$Credential = Get-Credential 
$VmConfig   = Set-AzVMOperatingSystem -VM $VmConfig `
              -Linux -ComputerName $VmName -Credential $Credential

$VmConfig = Set-AzVMSourceImage -VM $VmConfig `
            -PublisherName "Canonical" -Offer "ubuntu-24_04-lts" `
            -Skus "server" -Version "latest"

$Nic     = Get-AzNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroupName

$VmConfig = Add-AzVMNetworkInterface -VM $VmConfig -Id $Nic.Id

New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VmConfig