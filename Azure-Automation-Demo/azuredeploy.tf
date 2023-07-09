resource "azurerm_resource_group" "automation1" {
  name     = "rg-${var.region}-automation-01"
  location = var.region
}

resource "azurerm_automation_account" "automation1" {
  name                = "aut-${var.region}-01"
  location            = azurerm_resource_group.automation1.location
  resource_group_name = azurerm_resource_group.automation1.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

}
data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}

resource "azurerm_automation_variable_string" "subscription1" {
  name                    = "subscription1"
  resource_group_name     = azurerm_resource_group.automation1.name
  automation_account_name = azurerm_automation_account.automation1.name
  value                   = data.azurerm_client_config.current.subscription_id
}

resource "azurerm_automation_runbook" "vm_power_off" {
  name                    = "vm_power_off"
  location                = azurerm_resource_group.automation1.location
  resource_group_name     = azurerm_resource_group.automation1.name
  automation_account_name = azurerm_automation_account.automation1.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Powers Off VMs"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Azure-Automation-Demo/PowerShell/power_off_vm.ps1"
  }

}

resource "azurerm_role_assignment" "automation_managed_identity" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.automation1.identity.0.principal_id
}

resource "azurerm_automation_schedule" "daily_1800" {
  name                    = "daily_1800"
  resource_group_name     = azurerm_resource_group.automation1.name
  automation_account_name = azurerm_automation_account.automation1.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Europe/London"
  start_time              = "2023-07-09T18:00:00+01:00"
  description             = "This is an example schedule"
}

resource "azurerm_automation_job_schedule" "daily_1800_shutdown" {
  resource_group_name     = azurerm_resource_group.automation1.name
  automation_account_name = azurerm_automation_account.automation1.name
  schedule_name           = "daily_1800"
  runbook_name            = "vm_power_off"

  parameters = {
    dailyshutdowntime = "1800"
  }
}