variable "environment_tag" {
  type        = string
  description = "Environment tag value"
}
variable "labname" {
  type        = string
  description = "Lab name"
}
variable "region1" {
  description = "The location 1 for this Lab environment"
  type        = string
}
variable "region1cidr" {
  description = "The CIDR range for the whole of Region 1"
  type        = string
}
variable "servercounta" {
  description = "Number of Servers in the Lab A"
  type        = string
}
variable "servercountb" {
  description = "Number of Servers in the Lab B"
  type        = string
}