#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}
#VNET and Subnet
resource "azurerm_virtual_network" "region1-vnet1-hub1" {
  name                = var.region1-vnet1-name
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.region1-vnet1-address-space]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_subnet" "region1-vnet1-snet1" {
  name                 = var.region1-vnet1-snet1-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet1-hub1.name
  address_prefixes     = [var.region1-vnet1-snet1-range]
}
#NSG Access Rules for Lab
#Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}
#Lab NSG
resource "azurerm_network_security_group" "region1-nsg" {
  name                = "ansible-nsg"
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "SSH-In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.clientip.body)}/32"
    destination_address_prefix = "*"
  }
  tags = {
    Environment = var.environment_tag
  }
}
#NSG Association to all Lab Subnets
resource "azurerm_subnet_network_security_group_association" "vnet1-snet1" {
  subnet_id                 = azurerm_subnet.region1-vnet1-snet1.id
  network_security_group_id = azurerm_network_security_group.region1-nsg.id
}
#Create KeyVault ID
resource "random_id" "kvname" {
  byte_length = 5
  prefix      = "ansible"
}
#Keyvault Creation
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  depends_on                  = [azurerm_resource_group.rg1]
  name                        = random_id.kvname.hex
  location                    = var.loc1
  resource_group_name         = var.azure-rg-1
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]

    storage_permissions = [
      "get",
    ]
  }
  tags = {
    Environment = var.environment_tag
  }
}
#Create KeyVault VM password - Ansible VM
resource "random_password" "anpassword" {
  length  = 20
  special = true
}
#Create Key Vault Secret - Ansible VM
resource "azurerm_key_vault_secret" "anpassword" {
  name         = "anpassword"
  value        = random_password.anpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}
#Public IP - Ansible VM
resource "azurerm_public_ip" "ansible01-pip" {
  name                = "ansible01-pip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment_tag

  }
}
#Create NIC and associate the Public IP - Ansible VM
resource "azurerm_network_interface" "ansible01-nic" {
  name                = "ansible01-nic"
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name


  ip_configuration {
    name                          = "ansible01-ipconfig"
    subnet_id                     = azurerm_subnet.region1-vnet1-snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansible01-pip.id
  }

  tags = {
    Environment = var.environment_tag
  }
}
#Create Ansible VM
resource "azurerm_linux_virtual_machine" "ansible01-vm" {
  name                            = "ansible01-vm"
  resource_group_name             = azurerm_resource_group.rg1.name
  location                        = var.loc1
  size                            = var.vmsize
  admin_username                  = var.adminusername
  admin_password                  = azurerm_key_vault_secret.anpassword.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.ansible01-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  tags = {
    Environment = var.environment_tag
  }
}
#Run setup script on an01-vm
resource "azurerm_virtual_machine_extension" "ansible01-basesetup" {
  name                 = "ansible01-basesetup"
  virtual_machine_id   = azurerm_linux_virtual_machine.ansible01-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "bash AnsibleSetup.sh",
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Ansible-Quickstart/Ansible/AnsibleSetup.sh"
        ]
    }
  SETTINGS
}
