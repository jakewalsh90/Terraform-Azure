# Resource Groups
resource "azurerm_resource_group" "rg-ide" {
  name     = "rg-baselabv2-${var.region1code}-identity-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
resource "azurerm_resource_group" "rg-con" {
  name     = "rg-baselabv2-${var.region1code}-connectivity-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-connectivity"
  }
}
resource "azurerm_resource_group" "rg-sec" {
  name     = "rg-baselabv2-${var.region1code}-security-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-security"
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
    Function    = "BaseLabv2-security"
  }
}
# Create VM password
resource "random_password" "vmpassword" {
  length  = 20
  special = true
}
# Create Key Vault Secret
resource "azurerm_key_vault_secret" "vmpassword" {
  name            = "vmpassword"
  value           = random_password.vmpassword.result
  key_vault_id    = azurerm_key_vault.kv1.id
  expiration_date = timeadd(timestamp(), "8760h")
  content_type    = "Password"
}
# Virtual Networks
resource "azurerm_virtual_network" "region1-hub1" {
  name                = "vnet-${var.region1code}-hub-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-con.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 0)]
  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-connectivity"
  }
}
resource "azurerm_virtual_network" "region1-spoke1" {
  name                = "vnet-${var.region1code}-spoke-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-con.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 1)]
  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-connectivity"
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
resource "azurerm_subnet" "region1-hub1-AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 2)]
}
resource "azurerm_subnet" "region1-hub1-subnets" {
  count                = 2
  name                 = "snet-${count.index}-${var.region1code}-vnet-hub-01"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 3}")]
}
resource "azurerm_subnet" "region1-spoke1-subnets" {
  count                = 4
  name                 = "snet-${count.index}-${var.region1code}-vnet-spoke-01"
  resource_group_name  = azurerm_resource_group.rg-con.name
  virtual_network_name = azurerm_virtual_network.region1-spoke1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 8}")]
}
# VNET Peering
resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                      = "hub-to-spoke-${var.region1code}"
  resource_group_name       = azurerm_resource_group.rg-con.name
  virtual_network_name      = azurerm_virtual_network.region1-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.region1-spoke1.id
}
resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                      = "spoke-to-hub-${var.region1code}"
  resource_group_name       = azurerm_resource_group.rg-con.name
  virtual_network_name      = azurerm_virtual_network.region1-spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.region1-hub1.id
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
    Function    = "BaseLabv2-connectivity"
  }
}
resource "azurerm_network_security_group" "nsg-spoke" {
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
    Function    = "BaseLabv2-connectivity"
  }
}
# NSG Association
resource "azurerm_subnet_network_security_group_association" "nsg-hub1-subnets" {
  count                     = length(azurerm_subnet.region1-hub1-subnets)
  subnet_id                 = azurerm_subnet.region1-hub1-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-hub.id
  depends_on = [
    azurerm_subnet.region1-spoke1-subnets,
    azurerm_subnet.region1-hub1-GatewaySubnet,
    azurerm_subnet.region1-hub1-AzureFirewallSubnet,
    azurerm_subnet.region1-hub1-AzureBastionSubnet
  ]
}
resource "azurerm_subnet_network_security_group_association" "nsg-spoke1-subnets" {
  count                     = length(azurerm_subnet.region1-spoke1-subnets)
  subnet_id                 = azurerm_subnet.region1-spoke1-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg-spoke.id
  depends_on = [
    azurerm_subnet.region1-spoke1-subnets,
    azurerm_subnet.region1-hub1-GatewaySubnet,
    azurerm_subnet.region1-hub1-AzureFirewallSubnet,
    azurerm_subnet.region1-hub1-AzureBastionSubnet
  ]
}
# DNS
resource "random_id" "dns-name" {
  byte_length = 3
}
# Public IPs
resource "azurerm_public_ip" "pips" {
  count               = var.vmcount
  name                = "pip-${var.region1code}-${count.index}"
  resource_group_name = azurerm_resource_group.rg-ide.name
  location            = var.region1
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-vm-${count.index}-${random_id.dns-name.hex}"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
# NICs
resource "azurerm_network_interface" "nics" {
  count               = var.vmcount
  name                = "nic-${var.region1code}-vm${count.index}"
  resource_group_name = azurerm_resource_group.rg-ide.name
  location            = var.region1

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region1-spoke1-subnets[0].id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(join(", ", "${azurerm_subnet.region1-spoke1-subnets[0].address_prefixes}"), "${count.index + 4}")
    public_ip_address_id          = azurerm_public_ip.pips[count.index].id
  }

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
# Disks
resource "azurerm_managed_disk" "data-disks" {
  count                = var.vmcount
  name                 = "disk-${var.region1code}-vm-${count.index}"
  location             = var.region1
  resource_group_name  = azurerm_resource_group.rg-ide.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "32"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
#Extra Disks - Unused
resource "azurerm_managed_disk" "data-disks2" {
  count                = 4
  name                 = "disk-${var.region1code}-vm-${count.index}-extra"
  location             = var.region1
  resource_group_name  = azurerm_resource_group.rg-ide.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "32"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
# Availability Set
resource "azurerm_availability_set" "as1" {
  name                        = "as-${var.region1code}-vms"
  location                    = var.region1
  resource_group_name         = azurerm_resource_group.rg-ide.name
  platform_fault_domain_count = 2

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
# VMs
resource "azurerm_windows_virtual_machine" "vms" {
  count                    = var.vmcount
  name                     = "vm-${var.region1code}-${count.index}"
  availability_set_id      = azurerm_availability_set.as1.id
  resource_group_name      = azurerm_resource_group.rg-ide.name
  location                 = var.region1
  size                     = var.vmsize
  admin_username           = var.adminuser
  admin_password           = azurerm_key_vault_secret.vmpassword.value
  enable_automatic_updates = "true"
  network_interface_ids = [
    azurerm_network_interface.nics[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
#Attach Data Disks to Virtual Machines
resource "azurerm_virtual_machine_data_disk_attachment" "disks" {
  count              = var.vmcount
  managed_disk_id    = azurerm_managed_disk.data-disks[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.vms[count.index].id
  lun                = "10"
  caching            = "None"
}
# Run setup script on VMs
resource "azurerm_virtual_machine_extension" "basesetup" {
  count                = var.vmcount
  name                 = "cse-${var.region1code}-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vms[count.index].id
  depends_on           = [azurerm_virtual_machine_data_disk_attachment.disks]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./baselabv2_VMSetup.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/PowerShell/baselabv2_VMSetup.ps1"
        ]
    }
  SETTINGS
}
# Storage Accounts - V1
resource "random_id" "str-name" {
  byte_length = 5
}
resource "azurerm_storage_account" "sa1" {
  name                     = "str1${random_id.str-name.hex}v1"
  resource_group_name      = azurerm_resource_group.rg-ide.name
  location                 = var.region1
  account_kind             = "Storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
resource "azurerm_storage_account" "sa2" {
  name                     = "str2${random_id.str-name.hex}v1"
  resource_group_name      = azurerm_resource_group.rg-ide.name
  location                 = var.region1
  account_kind             = "Storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-identity"
  }
}
