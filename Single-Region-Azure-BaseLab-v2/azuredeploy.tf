# Resource Groups
resource "azurerm_resource_group" "rg-ide" {
  name     = "rg-${var.region1code}-identity-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_resource_group" "rg-con" {
  name     = "rg-${var.region1code}-connectivity-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_resource_group" "rg-sec" {
  name     = "rg-${var.region1code}-security-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
  }
}
# Key Vault
resource "random_id" "kv-name" {
  byte_length = 6
  prefix      = "kv"
}
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  name                        = random_id.kv-name.hex
  location                    = var.region1
  resource_group_name         = azurerm_resource_group.rg-sec.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get",
    ]
  }
  tags = {
    Environment = var.environment_tag
    Function    = "baselabv1-security"
  }
}
# Create VM password
resource "random_password" "vmpassword" {
  length  = 20
  special = true
}
# Create Key Vault Secret
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
}
# Virtual Networks

# Subnets

# Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}
# NSGs
resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg-${var.region1code}--01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-con.name

  security_rule {
    name                       = "RDP-In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }
  tags = {
    Environment = var.environment_tag
  }
}
# Public IPs

# NICs

# Disks

# Availability Set
resource "azurerm_availability_set" "as1" {
  name                        = "as-${var.region1code}-identity"
  location                    = var.region1
  resource_group_name         = azurerm_resource_group.rg-ide.name
  platform_fault_domain_count = 2

  tags = {
    Environment = var.environment_tag
  }
}
# VMs
