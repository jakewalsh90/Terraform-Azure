# Resource Groups
resource "azurerm_resource_group" "rg2" {
  name     = "rg-${var.region2}-${var.labname}-01"
  location = var.region2
  tags = {
    Environment = var.environment_tag
  }
}
# VNETs
resource "azurerm_virtual_network" "region2-hub1" {
  name                = "vnet-${var.region2}-hub-01"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  address_space       = [cidrsubnet("${var.region2cidr}", 2, 0)]
  tags = {
    Environment = var.environment_tag
  }
}
# Subnets
resource "azurerm_subnet" "region2-hub1-subnet" {
  name                 = "snet-${var.region2}-vnet-hub-01"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.region2-hub1.name
  address_prefixes     = [cidrsubnet("${var.region2cidr}", 5, 0)]
}
# NSGs
resource "azurerm_network_security_group" "region2-nsg1" {
  name                = "nsg-snet-${var.region2}-vnet-hub-01"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name

  security_rule {
    name                       = "RDP Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP Inbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_subnet_network_security_group_association" "region2-hub" {
  subnet_id                 = azurerm_subnet.region2-hub1-subnet.id
  network_security_group_id = azurerm_network_security_group.region2-nsg1.id
}
# Public IPs
resource "azurerm_public_ip" "region2-apips" {
  count               = var.servercounta
  name                = "${var.region2}-pip-a-${count.index}"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.region2
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_public_ip" "region2-bpips" {
  count               = var.servercountb
  name                = "${var.region2}-pip-b-${count.index}"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.region2
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment_tag
  }
}
# NICs
resource "azurerm_network_interface" "region2-anics" {
  count               = var.servercounta
  name                = "${var.region2}-nic-a-${count.index}"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "${var.region2}-nic-a-${count.index}-ipconfig"
    subnet_id                     = azurerm_subnet.region2-hub1-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.region2-apips[count.index].id
  }
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_network_interface" "region2-bnics" {
  count               = var.servercountb
  name                = "${var.region2}-nic-b-${count.index}"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "${var.region2}-nic-ab-${count.index}-ipconfig"
    subnet_id                     = azurerm_subnet.region2-hub1-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.region2-bpips[count.index].id
  }
  tags = {
    Environment = var.environment_tag
  }
}
# Availability Sets
resource "azurerm_availability_set" "region2-asa" {
  name                        = "${var.region2}-asa-a"
  location                    = var.region2
  resource_group_name         = azurerm_resource_group.rg2.name
  platform_fault_domain_count = 2

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_availability_set" "region2-asb" {
  name                        = "${var.region2}-asa-b"
  location                    = var.region2
  resource_group_name         = azurerm_resource_group.rg2.name
  platform_fault_domain_count = 2

  tags = {
    Environment = var.environment_tag
  }
}
# VMs
resource "azurerm_windows_virtual_machine" "region2-avms" {
  count               = var.servercounta
  name                = "${var.region2}-vm-a-${count.index}"
  depends_on          = [azurerm_key_vault.kv1]
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.region2
  size                = "Standard_D2s_v4"
  admin_username      = "azureadmin"
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  availability_set_id = azurerm_availability_set.region2-asa.id
  network_interface_ids = [
    azurerm_network_interface.region2-anics[count.index].id,
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
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "region2-bvms" {
  count               = var.servercountb
  name                = "${var.region2}-vm-b-${count.index}"
  depends_on          = [azurerm_key_vault.kv1]
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.region2
  size                = "Standard_D2s_v4"
  admin_username      = "azureadmin"
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  availability_set_id = azurerm_availability_set.region2-asb.id
  network_interface_ids = [
    azurerm_network_interface.region2-bnics[count.index].id,
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
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
# Setup Scripts
resource "azurerm_virtual_machine_extension" "region2-acse" {
  count                = var.servercounta
  name                 = "${var.region2}-acse-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.region2-avms[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./webdemo_VMSetup1.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/PowerShell/webdemo_VMSetup1.ps1"
        ]
    }
  SETTINGS
}
resource "azurerm_virtual_machine_extension" "region2-bcse" {
  count                = var.servercountb
  name                 = "${var.region2}-bcse-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.region2-bvms[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./webdemo_VMSetup1.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/PowerShell/webdemo_VMSetup1.ps1"
        ]
    }
  SETTINGS
}