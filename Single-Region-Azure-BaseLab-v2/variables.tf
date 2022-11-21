variable "environment_tag" {
  type        = string
  description = "Environment tag value"
}
variable "region1" {
  type        = string
  description = "Region 1 Location for this environment"
}
variable "region1code" {
  type        = string
  description = "Region 1 Location code for this environment - used for naming Azure Resources"
}
variable "region1cidr" {
  type        = string
  description = "Region 1 CIDR Range"
}
variable "vmcount" {
  type        = string
  description = "Number of identity VMs to create - default is 2"
}
variable "vmsize" {
  type        = string
  description = "VM size to create"
}
variable "adminuser" {
  type        = string
  description = "admin username for the created VMs"
}