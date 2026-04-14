# Calculate resource names
locals {
  name_replacements = {
    org_id         = var.org_id
    location       = var.location
    location_id    = var.location_id == "" ? module.regions.regions_by_name[var.location].geo_code : var.location_id
    environment_id = var.environment_id
    sub_id         = var.sub_id
    uniqueness     = random_string.unique_name.id
    sequence       = format("%02d", var.resource_name_sequence_start)
  }

  resource_names = { for key, value in var.resource_name_templates : key => templatestring(value, local.name_replacements) }
}

# Calculate the CIDR for the subnets
locals {
  subnets = { for key, value in var.subnets : key => {
    name             = key
    address_prefixes = [module.ip_addresses.address_prefixes[key]]
    network_security_group = value.has_network_security_group ? {
      id = module.network_security_group.resource_id
    } : null
    route_table = key == "default" ? {
      id = module.route_table.resource_id
    } : null
  }
  }
}

# Diagnostic settings
locals {
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                  = "custom"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }
}

# My IP address
locals {
  my_ip_address_split = split(".", data.http.ip.response_body)
  my_cidr_slash_24    = "${join(".", slice(local.my_ip_address_split, 0, 3))}.0/24"
}
