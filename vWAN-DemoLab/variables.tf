variable "environment_tag" {
  type        = string
  description = "Environment tag value"
}
variable "loc1" {
  type        = string
  description = "location 1 for the lab"
}
variable "loc2" {
  type        = string
  description = "location 2 for the lab"
}
variable "loc3" {
  type        = string
  description = "location 3 for the lab"
}
variable "loc4" {
  type        = string
  description = "location 4 for the lab"
}
variable "lab-name" {
  type        = string
  description = "Name to be used for resources in this lab"
}
variable "vwan-loc1-hub1-prefix1" {
  type        = string
  description = "Address space for vWAN Location 1 Hub 1"
}
variable "vwan-loc2-hub1-prefix1" {
  type        = string
  description = "Address space for vWAN Location 2 Hub 1"
}
variable "local1-vnet1-address-space" {
  type        = string
  description = "VNET address space for local site 1"
}
variable "local1-vnet1-snet1-range" {
  type        = string
  description = "Subnet address space for local site 1"
}
variable "local2-vnet1-address-space" {
  type        = string
  description = "VNET address space for local site 2"
}
variable "local2-vnet1-snet1-range" {
  type        = string
  description = "Subnet address space for local site 2"
}