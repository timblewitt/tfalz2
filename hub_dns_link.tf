resource "azurerm_private_dns_zone_virtual_network_link" "hub_to_spoke" {
  provider              = azurerm.hub

  for_each              = var.enable_hub_integration ? var.hub_private_dns_zones : {}

  name                  = "${var.lz_id}-link-${replace(each.value, ".", "-")}"
  resource_group_name   = var.hub_private_dns_zone_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = module.virtual_network.resource_id

  registration_enabled  = false
  resolution_policy     = "NxDomainRedirect"

  tags                  = var.tags
}
