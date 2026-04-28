module "peering_spoke_to_hub" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "~> 0.17"

  count = var.enable_hub_integration ? 1 : 0

  parent_id = module.virtual_network.resource_id
  remote_virtual_network_id = data.azurerm_virtual_network.hub.id

  name = "${local.resource_names.virtual_network_name}-to-${var.hub_vnet_name}"

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = var.use_hub_gateway

  create_reverse_peering = false
}

module "peering_hub_to_spoke" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "~> 0.17"

  providers = {
    azurerm = azurerm.hub
  }

  count = var.enable_hub_integration ? 1 : 0

  parent_id = data.azurerm_virtual_network.hub.id
  remote_virtual_network_id = module.virtual_network.resource_id

  name = "${var.hub_vnet_name}-to-${local.resource_names.virtual_network_name}"

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = var.use_hub_gateway

  create_reverse_peering = false
}