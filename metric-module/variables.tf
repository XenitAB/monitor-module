variable "environment" {
  description = "The environment of the Azure resource, prod, test, uat."
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

# variable "metric_alerts" {
#   type = map(object({
#     description = string
#     criteria = object({
#       metric_name            = string
#       metric_namespace       = string
#       threshold              = string
#       operator               = string
#       aggregation            = string
#       severity               = number
#       skip_metric_validation = bool
#     })
#     window_size          = string
#     evaluation_frequency = string
#   }))

#   description = "Metric alert configuration"

# }

variable "metric_alerts_new" {
  type = list(object({
    alert_name  = string
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
}

variable "alert_email_address" {
  type        = string
  description = "The email to which the alert will be sent"
}

variable "resource_group_name" {
  type = string
}

variable "resource_id" {
  type = string
}
