# Identity Resources
resource "azurerm_availability_set" "ide-as" {
  for_each                    = var.regions
  name                        = "as-${each.value.code}-ide"
  location                    = each.value.region
  resource_group_name         = azurerm_resource_group.rg-ide[each.key].name
  platform_fault_domain_count = 2
  tags                        = { environment = "identity", region = each.value.code, tfcreated = "true" }
}
# NICs
resource "azurerm_network_interface" "idenic1" {
  for_each            = var.regions
  name                = "nic-${each.value.code}-ide-1"
  location            = each.value.region
  resource_group_name = azurerm_resource_group.rg-ide[each.key].name
  ip_configuration {
    name                          = "ipconfig-ide-${each.value.code}"
    subnet_id                     = azurerm_subnet.identity1[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
  tags = { environment = "identity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_network_interface" "idenic2" {
  for_each            = var.regions
  name                = "nic-${each.value.code}-ide-2"
  location            = each.value.region
  resource_group_name = azurerm_resource_group.rg-ide[each.key].name
  ip_configuration {
    name                          = "ipconfig-ide-${each.value.code}"
    subnet_id                     = azurerm_subnet.identity2[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
  tags = { environment = "identity", region = each.value.code, tfcreated = "true" }
}
# Virtual Machines
resource "azurerm_virtual_machine" "idevm1" {
  for_each                         = var.regions
  name                             = "vm-${each.value.code}-ide-01"
  location                         = each.value.region
  resource_group_name              = azurerm_resource_group.rg-ide[each.key].name
  network_interface_ids            = [azurerm_network_interface.idenic1[each.key].id]
  vm_size                          = var.vmsize
  availability_set_id              = azurerm_availability_set.ide-as[each.key].id
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk-${each.value.code}-ide-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  storage_data_disk {
    name              = "disk-${each.value.code}-ide-01-data-01"
    managed_disk_type = "StandardSSD_LRS"
    create_option     = "Empty"
    disk_size_gb      = 32
    lun               = 10
    caching           = "None"
  }
  os_profile {
    computer_name  = "vm${each.value.code}ide01"
    admin_username = "azureadmin22"
    admin_password = azurerm_key_vault_secret.vmpassword.value
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  tags = { environment = "identity", region = each.value.code, tfcreated = "true", dailyshutdowntime = "1800" }
}
resource "azurerm_virtual_machine" "idevm2" {
  for_each                         = var.regions
  name                             = "vm-${each.value.code}-ide-02"
  location                         = each.value.region
  resource_group_name              = azurerm_resource_group.rg-ide[each.key].name
  network_interface_ids            = [azurerm_network_interface.idenic2[each.key].id]
  vm_size                          = var.vmsize
  availability_set_id              = azurerm_availability_set.ide-as[each.key].id
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk-${each.value.code}-ide-02"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  storage_data_disk {
    name              = "disk-${each.value.code}-ide-02-data-01"
    managed_disk_type = "StandardSSD_LRS"
    create_option     = "Empty"
    disk_size_gb      = 32
    lun               = 10
    caching           = "None"
  }
  os_profile {
    computer_name  = "vm${each.value.code}ide02"
    admin_username = "azureadmin22"
    admin_password = azurerm_key_vault_secret.vmpassword.value
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  tags = { environment = "identity", region = each.value.code, tfcreated = "true", dailyshutdowntime = "1800" }
}