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
    description = "The location for this Lab environment"
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
variable "region1-vnet1-address-space" {
  description = "VNET address space"
  type = string
}
variable "region1-vnet2-address-space" {
  description = "VNET address space"
  type = string
}
variable "region1-vnet1-snet1-name" {
  description = "subnet name"
  type = string
}
variable "region1-vnet1-snet2-name" {
  description = "subnet name"
  type = string
}
variable "region1-vnet1-snet3-name" {
  description = "subnet name"
  type = string
}
variable "region1-vnet2-snet1-name" {
  description = "subnet name"
  type = string
}
variable "region1-vnet2-snet2-name" {
  description = "subnet name"
  type = string
}
variable "region1-vnet2-snet3-name" {
  description = "subnet name"
  type = string
}
variable "region1-vnet1-snet1-range" {
  description = "subnet range"
  type = string
}
variable "region1-vnet1-snet2-range" {
  description = "subnet range"
  type = string
}
variable "region1-vnet1-snet3-range" {
  description = "subnet range"
  type = string
}
variable "region1-vnet2-snet1-range" {
  description = "subnet range"
  type = string
}
variable "region1-vnet2-snet2-range" {
  description = "subnet range"
  type = string
}
variable "region1-vnet2-snet3-range" {
  description = "subnet range"
  type = string
}
variable "vmsize-domaincontroller" {
  description = "size of vm for domain controller"
  type = string
}
variable "adminusername" {
  description = "administrator username for virtual machines"
  type = string
}
variable "keyvault" {
  description = "name of the azure keyvault"
  type = string
}