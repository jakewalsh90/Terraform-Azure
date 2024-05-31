# random string
resource "random_id" "vaultid2" {
  byte_length = 5
  prefix      = "rsv"
}
resource "random_id" "storage2" {
  byte_length = 5
  prefix      = "str"
}
# Resource Group
resource "azurerm_resource_group" "rg2" {
 name = "rg-backup-02"
 location = var.location
}
# Recovery Services Vault
resource "azurerm_recovery_services_vault" "rsv2" {
  name                = random_id.vaultid2.hex
  location            = var.location
  resource_group_name = azurerm_resource_group.rg2.name
  sku                 = "Standard"

  soft_delete_enabled = true
}
# Storage Account and Share
resource "azurerm_storage_account" "storage2" {
  name                     = random_id.storage2.hex
  location            = var.location
  resource_group_name = azurerm_resource_group.rg2.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_share" "share2" {
  name                 = "tf-demo2"
  storage_account_name = azurerm_storage_account.storage2.name
  quota                = 1
}
# Azure Backup Configuration
resource "azurerm_backup_container_storage_account" "storage2" {
  resource_group_name = azurerm_resource_group.rg2.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv2.name
  storage_account_id  = azurerm_storage_account.storage2.id
}
# Backup Policy
resource "azurerm_backup_policy_file_share" "backup-pol2" {
  name                = "terraform-example-backup-02"
  resource_group_name = azurerm_resource_group.rg2.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv2.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }
}