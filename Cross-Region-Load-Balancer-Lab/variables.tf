variable "regions" {
  description = "Regional variables"
  type        = map(any)
  default = {
    region1 = {
      location = "uksouth"
      cidr     = "10.10.0.0/21"
    }
    region2 = {
      location = "eastus"
      cidr     = "10.20.0.0/21"
    }
    region3 = {
      location = "westus"
      cidr     = "10.30.0.0/21"
    }
  }
}
variable "adminuser" {
  description = "Admin username"
  type        = string
  default     = "azureadmin"
}