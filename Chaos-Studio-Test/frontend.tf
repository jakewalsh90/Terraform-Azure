# LB PIPs
resource "azurerm_public_ip" "region1-lbpip" {
  name                = "${var.region1}-lb-pip"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "region2-lbpip" {
  name                = "${var.region2}-lb-pip"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# LBs
resource "azurerm_lb" "region1-lb" {
  name                = "${var.region1}-lb"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "Standard"
  depends_on = [
    azurerm_public_ip.region1-lbpip
  ]

  frontend_ip_configuration {
    name                 = "${var.region1}-lb-pip"
    public_ip_address_id = azurerm_public_ip.region1-lbpip.id
  }
}
resource "azurerm_lb" "region2-lb" {
  name                = "${var.region2}-lb"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  sku                 = "Standard"
  depends_on = [
    azurerm_public_ip.region1-lbpip
  ]

  frontend_ip_configuration {
    name                 = "${var.region2}-lb-pip"
    public_ip_address_id = azurerm_public_ip.region2-lbpip.id
  }
}
# Probes
resource "azurerm_lb_probe" "region1-probe" {
  loadbalancer_id     = azurerm_lb.region1-lb.id
  name                = "http-probe"
  port                = 80
  protocol            = "Http"
  interval_in_seconds = 60
  request_path        = "/"
}
resource "azurerm_lb_probe" "region2-probe" {
  loadbalancer_id     = azurerm_lb.region2-lb.id
  name                = "http-probe"
  port                = 80
  protocol            = "Http"
  interval_in_seconds = 60
  request_path        = "/"
}
# Backend Pool
resource "azurerm_lb_backend_address_pool" "region1-pool" {
  loadbalancer_id = azurerm_lb.region1-lb.id
  name            = "BackEndAddressPool"
}
resource "azurerm_lb_backend_address_pool" "region2-pool" {
  loadbalancer_id = azurerm_lb.region2-lb.id
  name            = "BackEndAddressPool"
}
# NIC Association
resource "azurerm_network_interface_backend_address_pool_association" "region1-a" {
    count = var.servercounta
  network_interface_id    = azurerm_network_interface.region1-anics[count.index].id
  ip_configuration_name   = "${var.region1}-nic-a-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.region1-pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "region1-b" {
    count = var.servercountb
  network_interface_id    = azurerm_network_interface.region1-bnics[count.index].id
  ip_configuration_name   = "${var.region1}-nic-b-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.region1-pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "region2-a" {
    count = var.servercounta
  network_interface_id    = azurerm_network_interface.region2-anics[count.index].id
  ip_configuration_name   = "${var.region2}-nic-a-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.region2-pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "region2-b" {
    count = var.servercountb
  network_interface_id    = azurerm_network_interface.region2-bnics[count.index].id
  ip_configuration_name   = "${var.region2}-nic-b-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.region2-pool.id
}
# Rules
resource "azurerm_lb_rule" "region1-rule" {
  loadbalancer_id                = azurerm_lb.region1-lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.region1}-lb-pip"
  probe_id                       = azurerm_lb_probe.region1-probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.region1-pool.id]
}
resource "azurerm_lb_rule" "region2-rule" {
  loadbalancer_id                = azurerm_lb.region2-lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.region2}-lb-pip"
  probe_id                       = azurerm_lb_probe.region2-probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.region2-pool.id]
}
# Traffic Manager
