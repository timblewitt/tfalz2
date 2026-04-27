resource "azurerm_consumption_budget_subscription" "monthly" {
  name            = "${var.lz_id}-Budget"
  subscription_id = "/subscriptions/${var.subscription_id}"

  amount     = var.monthly_budget_amount
  time_grain = "Monthly"

  time_period {
    start_date = local.current_month_start
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    contact_emails = var.budget_contact_emails
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    contact_emails = var.budget_contact_emails
  }

  lifecycle {
    ignore_changes  = [notification]
  }
}