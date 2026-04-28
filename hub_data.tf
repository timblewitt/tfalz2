data "azurerm_virtual_network" "hub" {
  provider            = azurerm.hub
  name                = var.hub_vnet_name
  resource_group_name = var.hub_vnet_resource_group_name
}

data "azurerm_private_dns_zone" "hub_kv" {
  provider            = azurerm.hub
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.hub_private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "hub_blob" {
  provider            = azurerm.hub
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.hub_private_dns_zone_resource_group_name
}
