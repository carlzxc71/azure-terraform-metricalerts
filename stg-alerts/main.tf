resource "azurerm_monitor_metric_alert" "this" {
  for_each = var.list_of_storage_accounts

  name                = "${var.criteria.metric_name}-${var.environment}-${element(split("/", each.value), length(split("/", each.value)) - 1)}" // Gets the end of the resource id
  resource_group_name = var.resource_group_name
  scopes = [
    each.value
  ]
  description = var.description
  severity    = var.severity
  window_size = var.window_size
  frequency   = var.frequency

  criteria {
    metric_name            = var.criteria.metric_name
    metric_namespace       = var.criteria.metric_namespace
    threshold              = var.criteria.threshold
    operator               = var.criteria.operator
    aggregation            = var.criteria.aggregation
    skip_metric_validation = var.criteria.skip_metric_validation
  }

  action {
    action_group_id = var.action_group_id
  }
}
