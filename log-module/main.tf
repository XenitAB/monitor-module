resource "azurerm_monitor_action_group" "this" {
  name                = "ag-log-${var.environment}-${var.location_short}"
  short_name          = "ag-log-${var.environment}-${var.location_short}"
  resource_group_name = var.resource_group_name

  email_receiver {
    name          = "email"
    email_address = var.alert_email_address
  }
}
resource "azurerm_monitor_scheduled_query_rules_alert" "this" {
  for_each = { for alert in var.log_alerts : alert.alert_name => alert }

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = each.value.description
  enabled             = true
  severity            = each.value.severity
  frequency           = each.value.frequency
  time_window         = each.value.time_window

  action {
    action_group = [azurerm_monitor_action_group.this.id]
  }

  query          = each.value.query
  data_source_id = each.value.data_source_id

  trigger {
    operator  = each.value.trigger.operator
    threshold = each.value.trigger.threshold
  }

  depends_on = [azurerm_monitor_action_group.this]
}
