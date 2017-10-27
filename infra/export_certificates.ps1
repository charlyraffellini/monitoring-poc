# To export the certificate follow the intructions here
# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
# Export the public key (.cer)

$P2SRootCertName = "P2SRootCert.cer"

$filePathForCert = "D:\projects\monitoring_ansible_vagrant\infra\RootCert.cer"
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2($filePathForCert)
$rawData = $cert.RawData
$CertBase64 = [system.convert]::ToBase64String($rawData)
$p2srootcert = New-AzureRmVpnClientRootCertificate -Name $P2SRootCertName -PublicCertData $CertBase64

$P2SRootCertName

Add-AzureRmVpnClientRootCertificate `
-VpnClientRootCertificateName $P2SRootCertName `
-VirtualNetworkGatewayname "CharlieGateway" `
-ResourceGroupName "charlie_monitoring_poc" `
-PublicCertData $CertBase64


# Now get the vpn installer for windows 
# https://docs.microsoft.com/en-us/azure/vpn-gateway/point-to-site-vpn-client-configuration-azure-cert

$profile=New-AzureRmVpnClientConfiguration -ResourceGroupName "charlie_monitoring_poc" -Name "CharlieGateway" -AuthenticationMethod "EapTls"
$profile.VPNProfileSASUrl