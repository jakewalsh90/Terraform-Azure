# Core Variables
variable "region" {
  type    = string
  default = "uk south"
}
# Optional Variables
variable "privatenetworking" {
  type    = bool
  default = true
  
}
variable "region1-cidr" {
  type    = string
  default = "10.10.0.0/16"
}
variable "region1-subnet" {
  type    = string
  default = "10.10.1.0/24"
}