output "resource_names" {
  value = local.resource_names
}

output "resource_ids" {
  value = {
    resource_group_backup          = module.rg_backup.resource_id
    resource_group_monitor         = module.rg_monitor.resource_id
    resource_group_network         = module.rg_network.resource_id
    resource_group_security        = module.rg_security.resource_id
    log_analytics_workspace        = module.log_analytics_workspace.resource_id
    virtual_network                = module.virtual_network.resource_id
    network_security_group         = module.network_security_group.resource_id
    route_table                    = module.route_table.resource_id
    key_vault                      = module.key_vault.resource_id
    storage_account                = module.storage_account.resource_id
    recovery_services_vault        = module.recovery_services_vault.resource_id
//    user_assigned_managed_identity = module.user_assigned_managed_identity.resource_id
  }
}

output "subnets" {
  value = local.subnets
}
