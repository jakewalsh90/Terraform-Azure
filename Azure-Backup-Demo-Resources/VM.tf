# random string
resource "random_id" "vaultid1" {
  byte_length = 5
  prefix      = "rsv"
}
# Resource Group
resource "azurerm_resource_group" "rg1" {
 name = "rg-backup-01"
 location = var.location
}
# Recovery Services Vault
resource "azurerm_recovery_services_vault" "rsv1" {
  name                = random_id.vaultid1.hex
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "Standard"

  soft_delete_enabled = true
}
# Backup Policy
resource "azurerm_backup_policy_vm" "backup-pol1" {
  name                = "terraform-example-backup-01"
  resource_group_name = azurerm_resource_group.rg1.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv1.name
  policy_type = "V2"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  retention_daily {
    count = 10
  }
}