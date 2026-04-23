
$subscriptionId = "6ff4f65a-59eb-44d4-8f3a-199f24f2fec2"
$location       = "ukwest"
$rgName         = "RG-UKS-Hub-Networking"
$vnetName       = "ABC-UKS-VNet-Hub"

$vnetCidr       = "10.50.0.0/22"

$fwSubnetName   = "AzureFirewallSubnet"  
$fwSubnetCidr   = "10.50.0.0/27"
$gwSubnetName   = "GatewaySubnet"        
$gwSubnetCidr   = "10.50.0.32/27"    
$bastionName    = "AzureBastionSubnet"    
$bastionCidr    = "10.50.0.64/27"
$publicSubnetName  = "snet-public"
$publicSubnetCidr  = "10.50.1.0/26"
$privateSubnetName = "snet-private"
$privateSubnetCidr = "10.50.1.64/26"

Set-AzContext -SubscriptionId $subscriptionId | Out-Null

if (-not (Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $rgName -Location $location | Out-Null
}

$subnets = @(
    New-AzVirtualNetworkSubnetConfig -Name $fwSubnetName      -AddressPrefix $fwSubnetCidr
    New-AzVirtualNetworkSubnetConfig -Name $gwSubnetName      -AddressPrefix $gwSubnetCidr
    New-AzVirtualNetworkSubnetConfig -Name $bastionName       -AddressPrefix $bastionCidr
    New-AzVirtualNetworkSubnetConfig -Name $publicSubnetName  -AddressPrefix $publicSubnetCidr
    New-AzVirtualNetworkSubnetConfig -Name $privateSubnetName -AddressPrefix $privateSubnetCidr
)

$vnet = New-AzVirtualNetwork `
    -Name $vnetName `
    -ResourceGroupName $rgName `
    -Location $location `
    -AddressPrefix $vnetCidr `
    -Subnet $subnets

    
$privateDnsZoneName = "privatelink.blob.core.windows.net"
$vnetLinkName       = "$($vnetName)-blobdnslink"   

#Import-Module Az.PrivateDns -ErrorAction Stop

$dnsZone = Get-AzPrivateDnsZone -ResourceGroupName $rgName -Name $privateDnsZoneName -ErrorAction SilentlyContinue
if (-not $dnsZone) {
    $dnsZone = New-AzPrivateDnsZone -ResourceGroupName $rgName -Name $privateDnsZoneName
}

$vnetLink = Get-AzPrivateDnsVirtualNetworkLink `
    -ResourceGroupName $rgName `
    -ZoneName $privateDnsZoneName `
    -Name $vnetLinkName `
    -ErrorAction SilentlyContinue

if (-not $vnetLink) {
    New-AzPrivateDnsVirtualNetworkLink `
        -ResourceGroupName $rgName `
        -ZoneName $privateDnsZoneName `
        -Name $vnetLinkName `
        -VirtualNetworkId $vnet.Id `
        -EnableRegistration:$false `
        -ResolutionPolicy NxDomainRedirect | Out-Null
}

