# Core Variables
environment_tag                  = "jakewalsh90-virtual-wan-DemoLab"
region1                          = "uksouth"
region2                          = "eastus"
virtual-wan-region1-hub1-prefix1 = "10.10.0.0/21"
virtual-wan-region2-hub1-prefix1 = "10.20.0.0/21"
# Networking
region1-vnet1-address-space      = "10.10.8.0/21"
region1-vnet1-snet1-range        = "10.10.11.0/24"
region1-vnet1-bastion-snet-range = "10.10.12.0/24"
region2-vnet1-address-space      = "10.20.8.0/21"
region2-vnet1-snet1-range        = "10.20.11.0/24"
region2-vnet1-bastion-snet-range = "10.20.12.0/24"
# VMs
vmsize        = "Standard_B4ms"
adminusername = "labadmin"
# Optional - Firewalls
azfw = false