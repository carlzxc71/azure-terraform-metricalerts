variable "environment" {
  type = string
}

variable "metric_alert_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "scopes" {
  type = list(string)
}

variable "description" {
  type = string
}

variable "severity" {
  type = string
}

variable "window_size" {
  type = string
}

variable "frequency" {
  type = string
}

variable "criteria" {
  type = object({
    metric_name            = string
    metric_namespace       = string
    threshold              = string
    operator               = string
    aggregation            = string
    skip_metric_validation = bool
  })
}

variable "action_group_id" {
  type = string
}

