###########################
# Core Features - Variables 
###########################

# Tags
environment_tag = "jakewalsh90-baselab-v2"
# Regional
region1     = "uksouth"
region1code = "uks"
# Networking 
# Note - changing to anything other than /19 will require checking IP ranges/addressing within the Code. 
region1cidr = "10.10.0.0/19"
# Identity VMs
# Note - 1 VM is the minimum
vmcount   = "1"
vmsize    = "Standard_D2s_v4"
adminuser = "labadmin"

###############################
# Optional Features - Variables 
###############################

# Azure Bastion
bastion = true
# AVD Supporting Elements
avd = true
# Virtual Network Gateway
vng = true
# Firewall
azfw = true