# Service Principal
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "vpn_app_id" {}
# Admin Account (For Key Vault Access Policy)
variable "admin_id" {}
# Naming
variable "lab_name" {
  default = "lab"
}
# Sizing
variable "vmsize" {
  default = "Standard_B8ms"
}
# Regional 
variable "regions" {
  type = map(any)
  default = {
    region1 = {
      region = "uksouth"
      code   = "uks"
      cidr   = ["10.10.0.0/16"]
    }
  }
}