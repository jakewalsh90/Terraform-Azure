# Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = "rg-${var.region1}-${var.labname}-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
  }
}
# VNETs
resource "azurerm_virtual_network" "region1-hub1" {
  name                = "vnet-${var.region1}-hub-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 0)]
  tags = {
    Environment = var.environment_tag
  }
}
# Peerings
resource "azurerm_virtual_network_peering" "hub1-to-hub2" {
  name                      = "${var.region1}-hub-to-${var.region2}-hub"
  resource_group_name       = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.region1-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.region2-hub1.id
}
resource "azurerm_virtual_network_peering" "hub2-to-hub1" {
  name                      = "${var.region2}-hub-to-${var.region1}-hub"
  resource_group_name       = azurerm_resource_group.rg2.name
  virtual_network_name      = azurerm_virtual_network.region2-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.region1-hub1.id
}
# Subnets
resource "azurerm_subnet" "region1-hub1-subnet" {
  name                 = "snethost-${var.region1}-vnet-hub-01"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 0)]
}
resource "azurerm_subnet" "region1-hub1-subnetlb" {
  name                 = "snetlb-${var.region1}-vnet-hub-01"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 1)]
}
resource "azurerm_subnet" "region1-hub1-subnetfw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 2)]
}
resource "azurerm_subnet" "region1-hub1-subnetfwman" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 3)]
}
# NSGs
resource "azurerm_network_security_group" "region1-nsg1" {
  name                = "nsg-snet-${var.region1}-vnet-hub-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_subnet_network_security_group_association" "region1-hub" {
  subnet_id                 = azurerm_subnet.region1-hub1-subnet.id
  network_security_group_id = azurerm_network_security_group.region1-nsg1.id
}
# Route Tables
resource "azurerm_route_table" "region1-rt1" {
  name                = "rtb-${var.region1}-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  route {
    name                   = "route1"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.region1-fw1.ip_configuration[0].private_ip_address
  }
}
resource "azurerm_subnet_route_table_association" "region1" {
  subnet_id      = azurerm_subnet.region1-hub1-subnet.id
  route_table_id = azurerm_route_table.region1-rt1.id
}
# Key Vault
resource "random_id" "kvname" {
  byte_length = 5
  prefix      = "keyvault"
}
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  depends_on                  = [azurerm_resource_group.rg1]
  name                        = random_id.kvname.hex
  location                    = var.region1
  resource_group_name         = azurerm_resource_group.rg1.name
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
  }
}
resource "random_password" "vmpassword" {
  length  = 20
  special = true
}
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}
# NICs
resource "azurerm_network_interface" "region1-anics" {
  count               = var.servercounta
  name                = "nic-${var.region1}-a-${count.index}"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "${var.region1}-nic-a-${count.index}-ipconfig"
    subnet_id                     = azurerm_subnet.region1-hub1-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_network_interface" "region1-bnics" {
  count               = var.servercountb
  name                = "nic-${var.region1}-b-${count.index}"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "${var.region1}-nic-b-${count.index}-ipconfig"
    subnet_id                     = azurerm_subnet.region1-hub1-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    Environment = var.environment_tag
  }
}
# Availability Sets
resource "azurerm_availability_set" "region1-asa" {
  name                        = "as-${var.region1}-a"
  location                    = var.region1
  resource_group_name         = azurerm_resource_group.rg1.name
  platform_fault_domain_count = 2

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_availability_set" "region1-asb" {
  name                        = "as-${var.region1}-b"
  location                    = var.region1
  resource_group_name         = azurerm_resource_group.rg1.name
  platform_fault_domain_count = 2

  tags = {
    Environment = var.environment_tag
  }
}
# Virtual Machines 
resource "azurerm_windows_virtual_machine" "region1-avms" {
  count               = var.servercounta
  name                = "vm-${var.region1code}-a-${count.index}"
  depends_on          = [azurerm_key_vault.kv1]
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.region1
  size                = "Standard_D2s_v4"
  admin_username      = "azureadmin"
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  availability_set_id = azurerm_availability_set.region1-asa.id
  network_interface_ids = [
    azurerm_network_interface.region1-anics[count.index].id,
  ]

  tags = {
    Environment = var.environment_tag
  }

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
}
resource "azurerm_windows_virtual_machine" "region1-bvms" {
  count               = var.servercountb
  name                = "vm-${var.region1code}-b-${count.index}"
  depends_on          = [azurerm_key_vault.kv1]
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.region1
  size                = "Standard_D2s_v4"
  admin_username      = "azureadmin"
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  availability_set_id = azurerm_availability_set.region1-asb.id
  network_interface_ids = [
    azurerm_network_interface.region1-bnics[count.index].id,
  ]

  tags = {
    Environment = var.environment_tag
  }

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
}
# Setup Scripts on VMs
resource "azurerm_virtual_machine_extension" "region1-acse" {
  count                = var.servercounta
  name                 = "${var.region1code}-acse-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.region1-avms[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on = [
    azurerm_firewall_network_rule_collection.region1-outbound, azurerm_subnet_route_table_association.region1
  ]

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./webserver_VMSetup.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/PowerShell/webserver_VMSetup.ps1"
        ]
    }
  SETTINGS
}
resource "azurerm_virtual_machine_extension" "region1-bcse" {
  count                = var.servercountb
  name                 = "${var.region1}-bcse-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.region1-bvms[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on = [
    azurerm_firewall_network_rule_collection.region1-outbound, azurerm_subnet_route_table_association.region1
  ]

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./webserver_VMSetup.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/PowerShell/webserver_VMSetup.ps1"
        ]
    }
  SETTINGS
}