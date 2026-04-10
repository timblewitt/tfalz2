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

variable "resource_name_location_short" {
  type        = string
  description = "The short name segment for the location"
  default     = ""
  validation {
    condition     = length(var.resource_name_location_short) == 0 || can(regex("^[A-Za-z]+$", var.resource_name_location_short))
    error_message = "The short name segment for the location must only contain uppercase or lowercase letters"
  }
  validation {
    condition     = length(var.resource_name_location_short) <= 3
    error_message = "The short name segment for the location must be 3 characters or less"
  }
}
/*
variable "resource_name_workload" {
  type        = string
  description = "The name segment for the workload"
  default     = "demo"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_workload))
    error_message = "The name segment for the workload must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.resource_name_workload) <= 4
    error_message = "The name segment for the workload must be 4 characters or less"
  }
}
*/
variable "resource_name_environment" {
  type        = string
  description = "The name segment for the environment"
  default     = "dev"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_environment))
    error_message = "The name segment for the environment must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.resource_name_environment) <= 4
    error_message = "The name segment for the environment must be 4 characters or less"
  }
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
  type        = map(string)
  description = "Enterprise naming templates"

  default = {
    # Resource groups
    resource_group_backup  = "RG-$${location_short}-$${sub_id}-Backup"
    resource_group_monitor  = "RG-$${location_short}-$${sub_id}-Monitor"
    resource_group_network  = "RG-$${location_short}-$${sub_id}-Networking"
    resource_group_security = "RG-$${location_short}-$${sub_id}-Security"

    # Resources
    virtual_network_name         = "$${org_id}-$${location_short}-VNET-$${sub_id}"
    network_security_group_name  = "$${org_id}-$${location_short}-NSG-$${sub_id}"
    log_analytics_workspace_name = "$${org_id}-$${location_short}-LAW-$${sub_id}"
    key_vault_name               = "$${org_id}-$${location_short}-KV-$${sub_id}"
    storage_account_name         = "sto$${lower(org_id)}$${lower(location_short)}$${lower(sub_id)}$${uniqueness}"
    user_assigned_managed_identity_name = "$${org_id}-$${location_short}-UAMI-$${sub_id}"
  }
}

variable "address_space" {
  type        = string
  description = "The address space that is used the virtual network"
}

variable "org_id" {
  description = "Organisation identifier, e.g. ABC"
  type        = string
  default = "ABC"
}

variable "sub_id" {
  description = "Subscription / Landing Zone identifier, e.g. LZ01"
  type        = string
  default = "LZ01"
}
/*
variable "workload" {
  description = "Workload name, e.g. Network"
  type        = string
}
*/
variable "location_short" {
  description = "Azure region short code, e.g. UKS"
  type        = string
  default = "UKS"
}

variable "subnets" {
  type = map(object({
    size                       = number
    has_nat_gateway            = bool
    has_network_security_group = bool
  }))
  description = "The subnets"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}
