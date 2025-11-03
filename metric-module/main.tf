resource "azurerm_monitor_action_group" "this" {
  name                = "ag-m-${var.environment}-${var.location_short}"
  short_name          = "ag-m-${var.environment}-${var.location_short}"
  resource_group_name = var.resource_group_name

  email_receiver {
    name          = "email"
    email_address = var.alert_email_address
  }
}

resource "azurerm_monitor_metric_alert" "this" {
  for_each = { for alert in var.metric_alerts_new : alert.alert_name => alert }

  name                = each.key
  resource_group_name = var.resource_group_name
  scopes = [
    var.resource_id
  ]
  description = each.value.description
  severity    = each.value.criteria.severity
  window_size = each.value.window_size
  frequency   = each.value.evaluation_frequency

  criteria {
    metric_name            = each.value.criteria.metric_name
    metric_namespace       = each.value.criteria.metric_namespace
    threshold              = each.value.criteria.threshold
    operator               = each.value.criteria.operator
    aggregation            = each.value.criteria.aggregation
    skip_metric_validation = each.value.criteria.skip_metric_validation
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}
