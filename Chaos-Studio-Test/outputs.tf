output "_1_Access-URL-via-TrafficManager" {
  value = "Use this URL to access via Traffic Manager: http://${azurerm_traffic_manager_profile.tm1.fqdn} "
}
output "_2_Access-URL-via-Region1-Firewall" {
  value = "Use this URL to access directly to the ${var.region1} Firewall: http://${azurerm_public_ip.region1-fwpip.fqdn} "
}
output "_3_Access-URL-via-Region2-Firewall" {
  value = "Use this URL to access directly to the ${var.region2} Firewall: http://${azurerm_public_ip.region2-fwpip.fqdn} "
}