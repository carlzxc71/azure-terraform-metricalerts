variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "location_short" {
  type        = string
  description = "Azure Region Short"
}

variable "metric_alerts" {
  type = map(object({
    description = string
    criteria = object({
      metric_name            = string
      metric_namespace       = string
      threshold              = string
      operator               = string
      aggregation            = string
      severity               = number
      skip_metric_validation = bool
    })
    window_size          = string
    evaluation_frequency = string
  }))
  description = "Metric alert configuration"
}
