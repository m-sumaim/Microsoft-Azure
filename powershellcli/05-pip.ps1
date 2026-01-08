$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "eastus"  
$PublicIpName   =    "pip-web-dev-eus-01"
$NicName           = "nic-web-dev-eus-01"
$IpConfigName=   "ipconfig-web-01"

$Pip = New-AzPublicIpAddress -Name $PublicIpName `
-ResourceGroupName $ResourceGroupName `
-Location $Location `
-Sku Standard `
-AllocationMethod Static

$Nic = Get-AzNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroupName

Set-AzNetworkInterfaceIpConfig -Name $IpConfigName `
-NetworkInterface $Nic `
-PublicIpAddress $Pip | Out-Null

Set-AzNetworkInterface -NetworkInterface $Nic