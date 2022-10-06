variable "environment_tag" {
  type        = string
  description = "Environment tag value"
}
variable "region1" {
  description = "The location 1 for this Lab environment"
  type        = string
}
variable "region1cidr" {
  description = "The CIDR range for the whole of Region 1"
  type        = string
}