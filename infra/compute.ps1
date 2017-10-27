[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    $VMName = "charlie_vnet",

    [Parameter(Mandatory=$false)]
    $ResourceGroupName = "charlie_monitoring_poc",

    [Parameter(Mandatory=$false)]
    $Location = "centralus",

    [Parameter(Mandatory=$false)]
    $BackendName = "FrontEnd",

    [Parameter(Mandatory=$false)]
    $FrontEndName = "BackEnd",

    [System.Management.Automation.PSCredential]
    [Parameter(Mandatory=$false)]
    $Credential = (New-Object `
      -TypeName "System.Management.Automation.PSCredential" `
      -ArgumentList "username", (ConvertTo-SecureString `
      -String "password" `
      -AsPlainText `
      -Force))
)

# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site

$vnet = Get-AzureRmVirtualNetwork -Name $VMName -ResourceGroupName $ResourceGroupName
$front_end_subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $FrontEndName -VirtualNetwork $vnet

# $pip = New-AzureRmPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location `
# -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name "mypublicdns$(Get-Random)"

# $nic = New-AzureRmNetworkInterface -Name myNic -ResourceGroupName $ResourceGroupName -Location $Location `
# -SubnetId $front_end_subnet.Id -PublicIpAddressId $pip.Id
# #-NetworkSecurityGroupId $nsg.Id

# $vmConfig = New-AzureRmVMConfig -VMName myVM -VMSize Standard_DS2 | `
# Set-AzureRmVMOperatingSystem -Linux -ComputerName myVM -Credential $Credential | `
# Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 14.04.2-LTS -Version latest | `
# Add-AzureRmVMNetworkInterface -Id $nic.Id

# New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $vmConfig


################# VM2 #################

$nic = New-AzureRmNetworkInterface -Name myNic2 -ResourceGroupName $ResourceGroupName -Location $Location `
-SubnetId $front_end_subnet.Id
#-PublicIpAddressId $pip.Id
#-NetworkSecurityGroupId $nsg.Id

$vmConfig = New-AzureRmVMConfig -VMName myVM2 -VMSize Standard_DS2 | `
Set-AzureRmVMOperatingSystem -Linux -ComputerName myVM2 -Credential $Credential | `
Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 14.04.2-LTS -Version latest | `
Add-AzureRmVMNetworkInterface -Id $nic.Id

New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $vmConfig

################# VM3 #################

$nic = New-AzureRmNetworkInterface -Name myNic3 -ResourceGroupName $ResourceGroupName -Location $Location `
-SubnetId $front_end_subnet.Id
#-PublicIpAddressId $pip.Id
#-NetworkSecurityGroupId $nsg.Id

$vmConfig = New-AzureRmVMConfig -VMName myVM3 -VMSize Standard_DS2 | `
Set-AzureRmVMOperatingSystem -Linux -ComputerName myV3 -Credential $Credential | `
Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 14.04.2-LTS -Version latest | `
Add-AzureRmVMNetworkInterface -Id $nic.Id

New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $vmConfig