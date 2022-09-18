module "terraform-google-billing-budget" {
  source  = "mineiros-io/billing-budget/google"
  version = "0.0.3"

  display_name    = "global-alert"
  billing_account = var.billing_account
  amount          = var.billing_spend
  currency_code   = "USD"
  threshold_rules = [
    {
      threshold_percent = 1.0 // Send an alert at 100 percent
    },
    {
      threshold_percent = 0.5             // Send an alert at 50 percent
      spend_basis       = "CURRENT_SPEND" // do not predict spend 
    }
  ]
}
