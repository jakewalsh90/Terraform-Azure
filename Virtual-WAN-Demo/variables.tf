# Variables
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
variable "virtual-wan-region1-hub1-prefix1" {
  type        = string
  description = "Address space for virtual-wan Location 1 Hub 1"
}
variable "virtual-wan-region2-hub1-prefix1" {
  type        = string
  description = "Address space for virtual-wan Location 2 Hub 1"
}
variable "region1-vnet1-address-space" {
  type        = string
  description = "VNET address space for region 1 vnet"
}
variable "region1-vnet1-snet1-range" {
  type        = string
  description = "Subnet address space for region 1 subnet"
}
variable "region1-vnet1-bastion-snet-range" {
  type        = string
  description = "Subnet address space for region 1 Bastion subnet"
}
variable "region2-vnet1-address-space" {
  type        = string
  description = "VNET address space for region 2 vnet"
}
variable "region2-vnet1-snet1-range" {
  type        = string
  description = "Subnet address space for region 2 subnet"
}
variable "region2-vnet1-bastion-snet-range" {
  type        = string
  description = "Subnet address space for region 2 Bastion subnet"
}
variable "vmsize" {
  type        = string
  description = "vm size"
}
variable "adminusername" {
  type        = string
  description = "admin username"
}
# Optional Resources
variable "azfw" {
  type        = bool
  description = "Sets if Azure Firewalls and Policy are created or not"
}