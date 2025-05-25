terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.environment}-${var.location_short}-app"
  location = var.location
}

resource "azurerm_storage_account" "app" {
  name                     = "st${var.environment}${var.location_short}app"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "backend" {
  name                     = "st${var.environment}${var.location_short}backend"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "frontend" {
  name                     = "st${var.environment}${var.location_short}frontend"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_action_group" "this" {
  name                = "ag-${var.environment}-${var.location_short}"
  short_name          = "ag-${var.environment}-${var.location_short}"
  resource_group_name = azurerm_resource_group.this.name

  email_receiver {
    name          = "email"
    email_address = "help@support.com"
  }
}

locals {
  storage_account_ids_to_monitor = {
    app      = azurerm_storage_account.app.id
    backend  = azurerm_storage_account.backend.id
    frontend = azurerm_storage_account.frontend.id
  }
}

module "stg_alerts" {
  source   = "./stg-alerts"
  for_each = var.metric_alerts

  environment              = var.environment
  resource_group_name      = azurerm_resource_group.this.name
  list_of_storage_accounts = local.storage_account_ids_to_monitor

  description     = each.value.description
  severity        = each.value.criteria.severity
  window_size     = each.value.window_size
  frequency       = each.value.evaluation_frequency
  criteria        = each.value.criteria
  action_group_id = azurerm_monitor_action_group.this.id
}
