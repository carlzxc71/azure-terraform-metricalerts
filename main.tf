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
  list_of_stg_accounts = [
    azurerm_storage_account.app.id,
    azurerm_storage_account.backend.id
  ]
}

resource "azurerm_monitor_metric_alert" "this" {
  for_each = var.metric_alerts

  name                = "${each.value.criteria.metric_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  scopes = [
    azurerm_resource_group.this.id
  ]
  description = each.value.description
  severity    = each.value.criteria.severity
  window_size = each.value.window_size
  frequency   = each.value.evaluation_frequency

  criteria {
    metric_name            = each.value.criteria.metric_name
    metric_namespace       = each.value.criteria.metric_namespace
    threshold              = each.value.criteria.threshold
    operator               = each.value.criteria.operator
    aggregation            = each.value.criteria.aggregation
    skip_metric_validation = each.value.criteria.skip_metric_validation
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}

module "stg_alerts" {
  source   = "./stg-alerts"
  for_each = var.metric_alerts

  metric_alert_name   = "${each.value.criteria.metric_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  scopes = [
    local.list_of_stg_accounts
  ]
  description     = each.value.description
  severity        = each.value.criteria.severity
  window_size     = each.value.window_size
  frequency       = each.value.evaluation_frequency
  criteria        = each.value.criteria
  action_group_id = azurerm_monitor_action_group.this.id
}
