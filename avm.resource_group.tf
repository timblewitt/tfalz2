module "rg_backup" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "~> 0.2"
  name     = local.resource_names.resource_group_backup
  location = var.location
  tags     = var.tags
}
module "rg_monitor" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "~> 0.2"
  name     = local.resource_names.resource_group_monitor
  location = var.location
  tags     = var.tags
}

module "rg_network" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "~> 0.2"
  name     = local.resource_names.resource_group_network
  location = var.location
  tags     = var.tags
}

module "rg_security" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "~> 0.2"
  name     = local.resource_names.resource_group_security
  location = var.location
  tags     = var.tags
}