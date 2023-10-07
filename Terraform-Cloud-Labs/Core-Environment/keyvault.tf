# Key Vault
resource "random_id" "kvname" {
  byte_length = 5
  prefix      = "kv-"
}
resource "azurerm_key_vault" "keyvault" {
  name                        = random_id.kvname.hex
  resource_group_name         = azurerm_resource_group.rg-sec["region1"].name
  location                    = var.regions.region1.region
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = ["Get", ]

    secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set", ]

    storage_permissions = ["Get", ]
  }
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.admin_id

    key_permissions = ["Get", ]

    secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set", ]

    storage_permissions = ["Get", ]
  }
  tags = { environment = "security", region = var.regions.region1.code, tfcreated = "true" }
}
# Secret for VM Passwords
resource "random_password" "vmpassword" {
  length  = 20
  special = true
}
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}
# Secret for VPN Pre-Shared Key
resource "random_password" "vpnpsk" {
  length  = 20
  special = true
}
resource "azurerm_key_vault_secret" "vpnpsk" {
  name         = "vpnpsk"
  value        = random_password.vpnpsk.result
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on   = [azurerm_key_vault.keyvault]
}