# LBs
resource "azurerm_lb" "region1-lb" {
  name                = "lb-int-${var.region1}"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "fip-lb-int-${var.region1}"
    subnet_id                     = azurerm_subnet.region1-hub1-subnetlb.id
    private_ip_address            = cidrhost("${var.region1cidr}", 260)
    private_ip_address_allocation = "static"
  }
}
resource "azurerm_lb" "region2-lb" {
  name                = "lb-int-${var.region2}"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "fip-lb-int-${var.region1}"
    subnet_id                     = azurerm_subnet.region2-hub1-subnetlb.id
    private_ip_address            = cidrhost("${var.region2cidr}", 260)
    private_ip_address_allocation = "static"
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
  count                   = var.servercounta
  network_interface_id    = azurerm_network_interface.region1-anics[count.index].id
  ip_configuration_name   = "${var.region1}-nic-a-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.region1-pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "region1-b" {
  count                   = var.servercountb
  network_interface_id    = azurerm_network_interface.region1-bnics[count.index].id
  ip_configuration_name   = "${var.region1}-nic-b-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.region1-pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "region2-a" {
  count                   = var.servercounta
  network_interface_id    = azurerm_network_interface.region2-anics[count.index].id
  ip_configuration_name   = "${var.region2}-nic-a-${count.index}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.region2-pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "region2-b" {
  count                   = var.servercountb
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
  frontend_ip_configuration_name = azurerm_lb.region1-lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.region1-probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.region1-pool.id]
}
resource "azurerm_lb_rule" "region2-rule" {
  loadbalancer_id                = azurerm_lb.region2-lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.region1-lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.region2-probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.region2-pool.id]
}