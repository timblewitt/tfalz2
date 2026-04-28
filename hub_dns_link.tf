resource "azurerm_private_dns_zone_virtual_network_link" "hub_blob_to_spoke" {
  provider = azurerm.hub

  count = var.enable_hub_integration ? 1 : 0

  name                  = "${var.lz_id}-link-${replace(var.hub_private_dns_zone_name, ".", "-")}"
  resource_group_name   = var.hub_private_dns_zone_resource_group_name
  private_dns_zone_name = var.hub_private_dns_zone_name
  virtual_network_id    = module.virtual_network.resource_id

  registration_enabled  = false
  tags                  = var.tags
}