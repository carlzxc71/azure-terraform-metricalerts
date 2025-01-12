azure_subscription_id = "your-sub-id"
environment           = "dev"
location              = "swedencentral"
location_short        = "sc"

metric_alerts = {
  storage_account_availability = {
    description = "The percentage of availability for the storage service or the specified API operation."
    criteria = {
      metric_name            = "Availability"
      metric_namespace       = "Microsoft.Storage/storageAccounts"
      threshold              = "100"
      operator               = "LessThan"
      aggregation            = "Average"
      severity               = 1
      skip_metric_validation = false
    }
    window_size          = "PT5M" // Five minutes
    evaluation_frequency = "PT5M" // Five minutes
  },
  storage_account_latency = {
    description = "The average time used to process a successful request by Azure Storage"
    criteria = {
      metric_name            = "SuccessServerLatency"
      metric_namespace       = "Microsoft.Storage/storageAccounts"
      threshold              = "1000"
      operator               = "GreaterThan"
      aggregation            = "Average"
      severity               = 2
      skip_metric_validation = false
    }
    window_size          = "PT5M" // Five minutes
    evaluation_frequency = "PT1M" // One minute
  }
}
