resource random_id "tm-name" {
  byte_length = 8  
}
resource "azurerm_traffic_manager_profile" "tm1" {
  name                   = random_id.tm-name.hex
  resource_group_name    = azurerm_resource_group.rg1.name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "${var.labname}-tm1"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = var.environment_tag
  }
}
resource "azurerm_traffic_manager_azure_endpoint" "region1-tme1" {
  name               = "${var.region1}-endpoint"
  profile_id         = azurerm_traffic_manager_profile.tm1.id
  weight             = 100
  target_resource_id = azurerm_public_ip.region1-fwpip.id
}
resource "azurerm_traffic_manager_azure_endpoint" "region2-tme1" {
  name               = "${var.region2}-endpoint"
  profile_id         = azurerm_traffic_manager_profile.tm1.id
  weight             = 100
  target_resource_id = azurerm_public_ip.region2-fwpip.id
}