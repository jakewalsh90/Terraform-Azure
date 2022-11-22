# Note - for brevity, the NSG block is not included below!

# Create Subnets
resource "azurerm_subnet" "region1-hub1-subnets" {
  count                = 4
  name                 = "snet-${count.index}-vnet-hub-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 4}")]
}
# Associate NSG to all Subnets
resource "azurerm_subnet_network_security_group_association" "nsg-hub-subnets" {
  count                     = length(azurerm_subnet.region1-hub1-subnets)
  subnet_id                 = azurerm_subnet.region1-hub1-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}