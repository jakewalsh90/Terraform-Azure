# Bastion
resource "azurerm_public_ip" "bastion-pip" {
  for_each            = var.regions
  name                = "pip-${each.value.code}-bst-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = { environment = "management", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_bastion_host" "bastion" {
  for_each            = var.regions
  name                = "bst-${each.value.code}-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  ip_configuration {
    name                 = "bst-${each.value.code}-01"
    subnet_id            = azurerm_subnet.management1[each.key].id
    public_ip_address_id = azurerm_public_ip.bastion-pip[each.key].id
  }
  tags = { environment = "management", region = each.value.code, tfcreated = "true" }
}