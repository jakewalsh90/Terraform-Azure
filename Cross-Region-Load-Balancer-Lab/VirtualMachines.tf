# NICs
resource "azurerm_network_interface" "nics" {
  for_each            = var.regions
  name                = "nic-${each.value.location}-vm"
  resource_group_name = azurerm_resource_group.rg-host[each.key].name
  location            = each.value.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-con[each.key].id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(cidrsubnet("${each.value.cidr}", 2, 0), 4)
  }
}
# Virtual Machines
resource "azurerm_windows_virtual_machine" "vms" {
  for_each                 = var.regions
  name                     = "vm-${each.value.location}"
  resource_group_name      = azurerm_resource_group.rg-host[each.key].name
  location                 = each.value.location
  size                     = "Standard_B4ms"
  admin_username           = var.adminuser
  admin_password           = azurerm_key_vault_secret.vmpassword.value
  enable_automatic_updates = "true"
  network_interface_ids = [
    azurerm_network_interface.nics[each.key].id,
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
}
# Setup script to install IIS
resource "azurerm_virtual_machine_extension" "vmsetup" {
  for_each             = var.regions
  name                 = "cse-${each.value.location}-01"
  virtual_machine_id   = azurerm_windows_virtual_machine.vms[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

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