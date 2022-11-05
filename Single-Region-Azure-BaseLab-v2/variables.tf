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