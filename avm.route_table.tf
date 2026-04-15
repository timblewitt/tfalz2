module "route_table" {
  source  = "Azure/avm-res-network-routetable/azurerm"
  version = "~> 0.3" 

  name       = "${local.resource_names.route_table_name}"
  location   = var.location
  resource_group_name = "${module.rg_network.name}"

  routes = {
    for route_name, route in var.route_table_routes : route_name => {
      name                   = route_name
      address_prefix         = route.address_prefix
      next_hop_type          = route.next_hop_type
      next_hop_in_ip_address = try(route.next_hop_in_ip_address, null)
    }
  }

  tags = var.tags
}
