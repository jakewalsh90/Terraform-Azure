output "_1_Access-URL-via-Cross-Region-Load-Balancer" {
  value = "Use this URL to access via the Cross-Region (Global) Load Balancer: http://${azurerm_public_ip.pip-cr-lb.fqdn} "
}
data "azurerm_public_ip" "example" {
  for_each            = var.regions
  name                = azurerm_public_ip.pip-lb[each.key].name
  resource_group_name = azurerm_public_ip.pip-lb[each.key].resource_group_name
}
output "_2_Region1-Access-URL-via-Regional-Load-Balancer" {
  value = "Use this URL to access via the ${var.regions.region1.location} Load Balancer: http://${data.azurerm_public_ip.example["region1"].fqdn}"
}
output "_3_Region2-Access-URL-via-Regional-Load-Balancer" {
  value = "Use this URL to access via the ${var.regions.region2.location} Load Balancer: http://${data.azurerm_public_ip.example["region2"].fqdn}"
}
output "_4_Region3-Access-URL-via-Regional-Load-Balancer" {
  value = "Use this URL to access via the ${var.regions.region3.location} Load Balancer: http://${data.azurerm_public_ip.example["region3"].fqdn}"
}