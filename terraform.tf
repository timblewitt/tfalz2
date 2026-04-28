terraform {
  required_version = "~> 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.19"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.9"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

# Spoke subscription provider 
provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  resource_provider_registrations = "extended"
  storage_use_azuread             = true
}

# Hub subscription provider 
provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  resource_provider_registrations = "extended"
  storage_use_azuread             = true
}

# AzAPI provider (no subscription_id needed; it operates against the resource IDs provided)
provider "azapi" {}
