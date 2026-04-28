variable "subscription_id" {
  description = "Azure subscription ID to deploy resources into"
  type        = string
}

variable "org_id" {
  description = "Organisation identifier for use in resource names, e.g. ABC"
  type        = string
  default     = "ABC"
  validation {
    condition     = can(regex("^[A-Za-z0-9]+$", var.org_id))
    error_message = "The organisation identifier must only contain letters and numbers"
  }
  validation {
    condition     = length(var.org_id) <= 4
    error_message = "The organisation identifier must be 4 characters or less"
  }
}

variable "location" {
  type        = string
  description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uksouth')"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.location))
    error_message = "The location must only contain lowercase letters, numbers, and hyphens"
  }
  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or less"
  }
}

variable "location_id" {
  type        = string
  description = "The short name segment for the location"
  default     = ""
  validation {
    condition     = length(var.location_id) == 0 || can(regex("^[A-Za-z]+$", var.location_id))
    error_message = "The short name segment for the location must only contain letters"
  }
  validation {
    condition     = length(var.location_id) <= 3
    error_message = "The short name segment for the location must be 3 characters or less"
  }
}

variable "environment_id" {
  type        = string
  description = "The name segment for the environment e.g. dev, tst, qas, prd"
  default     = "dev"
  validation {
    condition     = can(regex("^[A-Za-z]+$", var.environment_id))
    error_message = "The name segment for the environment must only contain letters"
  }
  validation {
    condition     = length(var.environment_id) <= 4
    error_message = "The name segment for the environment must be 4 characters or less"
  }
}

variable "lz_id" {
  description = "Subscription / Landing Zone identifier, e.g. lz01 for use in resource names"
  type        = string
  default = "lz01"
}

variable "resource_name_sequence_start" {
  type        = number
  description = "The number to use for the resource names"
  default     = 1
  validation {
    condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
    error_message = "The number must be between 1 and 999"
  }
}

variable "resource_name_templates" {
  description = "Enterprise naming templates for resource groups and resources"
  type        = map(string)

  default = {
    # Backup
    resource_group_backup               = "RG-$${location_id}-$${sub_id}-Backup"
    recovery_services_vault_name        = "$${org_id}-$${location_id}-RSV-$${sub_id}"

    # Monitoring
    resource_group_monitor              = "RG-$${location_id}-$${sub_id}-Monitor"
    storage_account_name                = "sto$${lower(org_id)}$${lower(location_id)}$${lower(sub_id)}$${uniqueness}"
    log_analytics_workspace_name        = "$${org_id}-$${location_id}-LAW-$${sub_id}"

    # Networking
    resource_group_network              = "RG-$${location_id}-$${sub_id}-Networking"
    virtual_network_name                = "$${org_id}-$${location_id}-VNET-$${sub_id}"
    network_security_group_name         = "$${org_id}-$${location_id}-NSG-$${sub_id}"
    route_table_name                    = "$${org_id}-$${location_id}-RT-$${sub_id}"

    # Security
    resource_group_security             = "RG-$${location_id}-$${sub_id}-Security"
    key_vault_name                      = "$${org_id}-$${location_id}-KV-$${sub_id}"
  }
}

variable "address_space" {
  type        = string
  description = "The address space that is used for the virtual network"
}

variable "subnets" {
  type = map(object({
    size                       = number
    has_nat_gateway            = bool
    has_network_security_group = bool
  }))
  description = "The subnets"
}

variable "route_table_routes" {
  description = "Routes to create in the route table"
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
}

variable "vnet_dns_servers" {
  description = "Optional list of custom DNS servers for the virtual network"
  type        = list(string)
  default     = []
}

variable "enable_hub_integration" {
  description = "Toggle hub peering + hub private DNS zone link (true/false)"
  type        = bool
  default     = false
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet (e.g. ABC-UKS-VNet-Hub)"
  type        = string
  default     = null
}

variable "hub_vnet_resource_group_name" {
  description = "Resource group name of the hub VNet"
  type        = string
  default     = null
}

variable "hub_private_dns_zone_name" {
  description = "Hub Private DNS zone name (e.g. privatelink.blob.core.windows.net)"
  type        = string
  default     = null
}

variable "hub_private_dns_zone_resource_group_name" {
  description = "Resource group name where the hub Private DNS zone is hosted"
  type        = string
  default     = null
}

variable "use_hub_gateway" {
  description = "If true, spoke uses remote (hub) gateway (use_remote_gateways / allow_gateway_transit)"
  type        = bool
  default     = false
}

variable "hub_subscription_id" {
  description = "Subscription ID (GUID) of the hub/connectivity subscription"
  type        = string
  default     = null
}

variable "monthly_budget_amount" {
  description = "Monthly subscription budget amount"
  type        = number
}

variable "budget_contact_emails" {
  description = "Email addresses to notify for budget alerts"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}
