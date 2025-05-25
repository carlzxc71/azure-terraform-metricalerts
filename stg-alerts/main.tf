resource "azurerm_monitor_metric_alert" "this" {
  for_each = toset(var.scopes)

  name                = "${var.criteria.metric_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  scopes = [
    each.key
  ]
  description          = var.description
  severity             = var.criteria.severity
  window_size          = var.window_size
  frequency            = var.frequency
  target_resource_type = var.criteria.target_resource_type

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
