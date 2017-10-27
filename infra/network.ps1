[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    $VNetName = "charlie_vnet",

    [Parameter(Mandatory=$false)]
    $ResourceGroupName = "charlie_monitoring_poc",

    [Parameter(Mandatory=$false)]
    $Location = "centralus",

    [Parameter(Mandatory=$false)]
    $BackendName = "BackEnd",

    [Parameter(Mandatory=$false)]
    $FrontEndName = "FrontEnd",

    [System.Management.Automation.PSCredential]
    [Parameter(Mandatory=$false)]
    $Credential
)

$ErrorActionPreference = "Stop"

# VPN Gateway
# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-rm-ps

# Common parameters https://technet.microsoft.com/en-us/library/dd315352.aspx
#-ea error action - what to do when it fails
#-ev error variable - where to store the error
Get-AzureRmResourceGroup -Name $ResourceGroupName -ev rgNotPresent -ea SilentlyContinue

if ($rgNotPresent){
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location
}

$GatewaySubnetName = "GatewaySubnet"
$VNetPrefix1 = "192.168.0.0/16"
$VNetPrefix2 = "10.254.0.0/16"
$FESubPrefix = "192.168.1.0/24"
$BESubPrefix = "10.254.1.0/24"
$GWSubPrefix = "192.168.200.0/26"
$VPNClientAddressPool = "172.16.201.0/24"
$GWName = "CharlieGateway"
$GWIPName = "GatewayPublicIP"
$GWIPconfName = "GatewayConfigName"

$frontend_subnet_conf = New-AzureRmVirtualNetworkSubnetConfig -Name $FrontEndName -AddressPrefix $FESubPrefix
$backend_subnet_conf = New-AzureRmVirtualNetworkSubnetConfig -Name $BackendName -AddressPrefix $BESubPrefix
$gateway_subnet_conf = New-AzureRmVirtualNetworkSubnetConfig -Name $GatewaySubnetName -AddressPrefix $GWSubPrefix

$vnet = New-AzureRmVirtualNetwork -Name $VNetName `
-ResourceGroupName $ResourceGroupName `
-Location $Location `
-AddressPrefix $VNetPrefix1,$VNetPrefix2 `
-Subnet $frontend_subnet_conf, $backend_subnet_conf, $gateway_subnet_conf 

$gateway_subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $GatewaySubnetName -VirtualNetwork $vnet

$pip = New-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $gateway_subnet -PublicIpAddress $pip

$Gateway = Get-AzureRmVirtualNetworkGateway -ResourceGroupName $ResourceGroupName -Name $GWName  -ev gatewayPresent -ea SilentlyContinue

if($gatewayPresent){
$Gateway = New-AzureRmVirtualNetworkGateway `
    -Name $GWName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -IpConfigurations $ipconf `
    -GatewayType Vpn `
    -VpnType RouteBased `
    -EnableBgp $false `
    -GatewaySku VpnGw1 `
    -VpnClientProtocol "IKEv2"
}

Set-AzureRmVirtualNetworkGateway -VirtualNetworkGateway $Gateway -VpnClientAddressPool $VPNClientAddressPool


#############################################################################

########### Info about commands

##### Although you create subnets, they currently only exist in the local variable $vnet above.
##### To save the changes to Azure, run the following command:
# Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

# Remove the resource group
# Remove-AzureRmResourceGroup -Name $rg_name