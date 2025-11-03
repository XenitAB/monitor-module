variable "environment" {
  description = "The environment of the Azure resource, prod, test, uat."
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "log_alerts" {
  description = "List of log-based alerts"
  type = list(object({
    alert_name     = string
    description    = string
    query          = string
    data_source_id = string
    frequency      = number
    time_window    = number
    severity       = number
    trigger = object({
      operator  = string
      threshold = number
    })
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
