# Virtual Networks
resource "azurerm_virtual_network" "vnet-con" {
  for_each            = var.regions
  name                = "vnet-${each.value.location}-con"
  address_space       = [each.value.cidr]
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
}
# Subnets
resource "azurerm_subnet" "subnet-con" {
  for_each             = var.regions
  name                 = "subnet-${each.value.location}-01"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 2, 0)]
}
# Network Security Groups
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.regions
  name                = "nsg-${each.value.location}-01"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg-con[each.key].name

  security_rule {
    name                       = "AllowInternetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
# Network Security Group Associations
resource "azurerm_subnet_network_security_group_association" "nsg-assocation" {
  for_each                  = var.regions
  subnet_id                 = azurerm_subnet.subnet-con[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}