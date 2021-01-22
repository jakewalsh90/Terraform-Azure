variable "environment_tag" {
    type = string
    description = "Environment tag value"
}
variable "azure-rg-1" {
    type = string
    description = "resource group 1"
}
variable "azure-rg-2" {
    description = "resource group 2"
    type = string
}
variable "azure-rg-3" {
    description = "resource group 3"
    type = string
}
variable "loc1" {
    description = "Location 1 for this Lab environment"
    type= string
}
variable "loc2" {
    description = "Location 2 for this Lab environment"
    type= string
}
variable "region1-vnet1-name" {
    description = "VNET1 Name"
    type= string
}
variable "region1-vnet2-name" {
    description = "VNET1 Name"
    type= string
}
variable "region2-vnet1-name" {
    description = "VNET1 Name"
    type= string
}
variable "region2-vnet2-name" {
    description = "VNET1 Name"
    type= string
}
variable "region1-vnet1-address-space" {
  description = "VNET address space"
  type = string
}
variable "region1-vnet2-address-space" {
  description = "VNET address space"
  type = string
}
variable "region2-vnet1-address-space" {
  description = "VNET address space"
  type = string
}
variable "region2-vnet2-address-space" {
  description = "VNET address space"
  type = string
}