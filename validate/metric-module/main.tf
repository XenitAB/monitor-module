terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
}

variable "subscription_id" {
  type = string
}

variable "resource_id" {
  type = string
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "this" {
  location = "West Europe"
  name     = "rg-dev-we-alerts"
}

module "metric-module" {
  source = "../../metric-module"

  location_short      = "we"
  environment         = "dev"
  alert_email_address = "magnus.forsman@xenit.se"
  resource_group_name = azurerm_resource_group.this.name
  resource_id         = var.resource_id
  metric_alerts_new = [
    {
      alert_name  = "storage_account_availability"
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
  ]
}
