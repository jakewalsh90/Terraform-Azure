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
  description = "location 1 for the lab"
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