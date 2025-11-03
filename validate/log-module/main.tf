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

variable "email_address" {
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
  name     = "rg-dev-we-log-alerts"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-dev-we-alerts"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "log_alert_module" {
  source = "../../log-module"

  environment         = "dev"
  location            = azurerm_resource_group.this.location
  location_short      = "we"
  resource_group_name = azurerm_resource_group.this.name
  alert_email_address = var.email_address
  resource_id         = var.resource_id

  log_alerts = [
    {
      alert_name     = "test-failed-logins"
      description    = "Test alert for failed login events"
      query          = "Heartbeat | take 1"
      data_source_id = azurerm_log_analytics_workspace.this.id
      frequency      = 5
      time_window    = 5
      severity       = 2
      trigger = {
        operator  = "GreaterThan"
        threshold = 0
      }
    }
  ]

}
