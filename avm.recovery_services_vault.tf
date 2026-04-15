module "recovery_services_vault" {
  source  = "Azure/avm-res-recoveryservices-vault/azurerm"
  version = "~> 0.3"

  name                = local.resource_names.recovery_services_vault_name
  location            = var.location
  resource_group_name = module.rg_backup.name

  sku                 = "Standard"
  storage_mode_type   = "GeoRedundant"
  soft_delete_enabled = true
  immutability        = "Unlocked"

  tags = var.tags
}
