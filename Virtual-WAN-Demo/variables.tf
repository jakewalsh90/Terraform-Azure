# Variables
variable "lab-name" {
  type        = string
  description = "Name to be used for resources in this lab"
}
variable "environment_tag" {
  type        = string
  description = "Environment tag value"
}
variable "region1" {
  type        = string
  description = "location 1 for the lab"
}
variable "region2" {
  type        = string
  description = "location 2 for the lab"
}
variable "Virtual-WAN-region1-hub1-prefix1" {
  type        = string
  description = "Address space for Virtual-WAN Location 1 Hub 1"
}
variable "Virtual-WAN-region2-hub1-prefix1" {
  type        = string
  description = "Address space for Virtual-WAN Location 2 Hub 1"
}
variable "region1-vnet1-address-space" {
  type        = string
  description = "VNET address space for region 1 vnet"
}
variable "region1-vnet1-snet1-range" {
  type        = string
  description = "Subnet address space for region 1 subnet"
}
variable "region2-vnet1-address-space" {
  type        = string
  description = "VNET address space for region 2 vnet"
}
variable "region2-vnet1-snet1-range" {
  type        = string
  description = "Subnet address space for region 2 subnet"
}
variable "vmsize" {
  type        = string
  description = "vm size"
}
variable "adminusername" {
  type        = string
  description = "admin username"
}