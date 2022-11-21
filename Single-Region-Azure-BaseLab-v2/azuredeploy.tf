# Resource Groups
resource "azurerm_resource_group" "rg-ide" {
  name     = "rg-baselabv2-${var.region1code}-ide-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "baselabv2-identity"
  }
}
resource "azurerm_resource_group" "rg-con" {
  name     = "rg-baselabv2-${var.region1code}-con-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "baselabv2-connectivity"
  }
}
resource "azurerm_resource_group" "rg-sec" {
  name     = "rg-baselabv2-${var.region1code}-sec-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "baselabv2-security"
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
    Function    = "baselabv2-security"
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
resource "azurerm_virtual_network" "region1-hub1" {
  name                = "vnet-${var.region1code}-hub-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-con.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 0)]
  tags = {
    Environment = var.environment_tag
    Function    = "baselabv2-connectivity"
  }
}
resource "azurerm_virtual_network" "region1-spoke1" {
  name                = "vnet-${var.region1code}-spoke-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-con.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 1)]
  tags = {
    Environment = var.environment_tag
    Function    = "baselabv2-connectivity"
  }
}
resource "azurerm_virtual_network" "region1-spoke2" {
  name                = "vnet-${var.region1code}-spoke-02"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-con.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 2)]
  tags = {
    Environment = var.environment_tag
    Function    = "baselabv2-connectivity"
  }
}
# Subnets
resource "azurerm_subnet" "region1-hub1-GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 0)]
}
resource "azurerm_subnet" "region1-hub1-AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 1)]
}
resource "azurerm_subnet" "region1-hub1-AzureFirewallManagementSubnet" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 2)]
}
resource "azurerm_subnet" "region1-hub1-AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 3)]
}
resource "azurerm_subnet" "region1-hub1-subnets" {
  count                = 4
  name                 = "snet-${count.index}-${var.region1code}-vnet-hub-01"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 4}")]
}
resource "azurerm_subnet" "region1-spoke1-subnets" {
  count                = 8
  name                 = "snet-${count.index}-${var.region1code}-vnet-spoke-01"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-spoke1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 8}")]
}
resource "azurerm_subnet" "region1-spoke2-subnets" {
  count                = 8
  name                 = "snet-${count.index}-${var.region1code}-vnet-spoke-02"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-spoke2.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 16}")]
}
# Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}
# NSGs
resource "azurerm_network_security_group" "nsg-hub" {
  name                = "nsg-${var.region1code}-hub-01"
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
    Function    = "baselabv2-connectivity"
  }
}
resource "azurerm_network_security_group" "nsg-spoke01" {
  name                = "nsg-${var.region1code}-spoke-01"
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
    Function    = "baselabv2-connectivity"
  }
}
resource "azurerm_network_security_group" "nsg-spoke02" {
  name                = "nsg-${var.region1code}-spoke-02"
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
    Function    = "baselabv2-connectivity"
  }
}
# NSG Association
resource "azurerm_subnet_network_security_group_association" "nsg-hub-subnets" {
  count                     = length(azurerm_subnet.region1-hub1-subnets)
  subnet_id                 = azurerm_subnet.region1-hub1-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-hub.id
}
resource "azurerm_subnet_network_security_group_association" "nsg-spoke1-subnets" {
  count                     = length(azurerm_subnet.region1-spoke1-subnets)
  subnet_id                 = azurerm_subnet.region1-spoke1-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-spoke01.id
}
resource "azurerm_subnet_network_security_group_association" "nsg-spoke2-subnets" {
  count                     = length(azurerm_subnet.region1-spoke2-subnets)
  subnet_id                 = azurerm_subnet.region1-spoke2-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-spoke02.id
}
# Public IPs

# NICs

# Disks

# Availability Set
resource "azurerm_availability_set" "as1" {
  name                        = "as-${var.region1code}-ide"
  location                    = var.region1
  resource_group_name         = azurerm_resource_group.rg-ide.name
  platform_fault_domain_count = 2

  tags = {
    Environment = var.environment_tag
        Function    = "baselabv2-identity"
  }
}
# VMs
