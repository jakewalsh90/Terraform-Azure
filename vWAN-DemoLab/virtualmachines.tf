#Public IPs
resource "azurerm_public_ip" "region1-vm01-pip" {
  name                = "region1-vm01-pip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.region1
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_public_ip" "region2-vm01-pip" {
  name                = "region2-vm01-pip"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.region2
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment_tag
  }
}
#Create NIC and associate the Public IP
resource "azurerm_network_interface" "region1-vm01-nic" {
  name                = "region1-vm01-nic"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name


  ip_configuration {
    name                          = "region1-vm01-ipconfig"
    subnet_id                     = azurerm_subnet.region1-vnet1-snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.region1-vm01-pip.id
  }

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_network_interface" "region2-vm01-nic" {
  name                = "region2-vm01-nic"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name


  ip_configuration {
    name                          = "region2-vm01-ipconfig"
    subnet_id                     = azurerm_subnet.region2-vnet1-snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.region2-vm01-pip.id
  }

  tags = {
    Environment = var.environment_tag
  }
}
#Create VM
resource "azurerm_windows_virtual_machine" "region1-vm01-vm" {
  name                = "region1-vm01-vm"
  depends_on          = [azurerm_key_vault.kv1]
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.region1
  size                = var.vmsize
  admin_username      = var.adminusername
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.region1-vm01-nic.id,
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
resource "azurerm_windows_virtual_machine" "region2-vm01-vm" {
  name                = "region2-vm01-vm"
  depends_on          = [azurerm_key_vault.kv1]
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.region2
  size                = var.vmsize
  admin_username      = var.adminusername
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.region2-vm01-nic.id,
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