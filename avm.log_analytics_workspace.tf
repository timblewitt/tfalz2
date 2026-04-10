module "log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"

  name                = local.resource_names.log_analytics_workspace_name
  location            = var.location
  resource_group_name = module.rg_monitor.name
  tags                = var.tags
}