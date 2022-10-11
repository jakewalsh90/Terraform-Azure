# Overview
This lab demonstrates the use of cidrsubnet Function within Terraform. [https://www.terraform.io/language/functions/cidrsubnet](https://www.terraform.io/language/functions/cidrsubnet)

Within this function you can split a CIDR range up easily use it within VNETs, Subnets, and more - all by referencing a single variable. 

In my example, the following Resources are created:

 - Resource Group
 - 3 VNETs
 - X numbers of Subnets per VNET (Using Count)

## Using cidrsubnet - My Demo Environment

⚠ Note: you'll need to customise this example and calculation for your needs, this is just to demonstrate the concept!

Within my demo environment, I am creating the following, based on a Single Azure Region. IP address spacing is as below:

- In my first Azure Region, the assigned CIDR range is ```10.x.0.0/19``` (for the whole Region)
- For each VNET I am using /21 (2046 addresses per VNET), ```10.x.0.0/21```
- This means I can use /24 for each Subnet, giving simple easy to understand Subnets that provide ample room for Resources. 

✅ Thanks to the cidrsubnet function, I have only 1 variable in my terraform.tfvars file, which specifies a range for the whole region!

## Using cidrsubnet - VNETs

To use CIDR Subnet, we need to add the following line to our VNET:

        address_space       = [cidrsubnet("${var.region1cidr}", 2, 0)]

This is essentially taking a variable (var.region1cidr) which is listed in my tfvars file as ```"10.10.0.0/19"``` - thanks to cidrsubnet, this is the only place the CIDR range is noted. Everything else is split automatically, and we don't need to use lots of additional variables for each range. 

cidrsubnet works by splitting the CIDR range out like this: **```cidrsubnet(prefix, newbits, netnum)```**

So in my case, I am asking for the prefix of ```10.x.0.0/19``` to be updated to ```10.x.0.0/21``` (that's the 2 in the newbits section being added to the Subnet Mask). I am then selecting net number 0. 

This results in the VNET being given the range of ```10.x.0.0/21```

For additional VNETs, we can just select the next netnum, for example:

        address_space       = [cidrsubnet("${var.region1cidr}", 2, 1)]

Would give us 10.x.8.0/21, or

        address_space       = [cidrsubnet("${var.region1cidr}", 2, 2)]

Would give us ```10.x.16.0/21```, and so on...

## Using cidrsubnet - Subnets

Within Subnets, we just need to break down the network further. For example, the below will change my original variable of ```10.x.0.0/19```, to ```10.x.0.0/24``` and select net number 0, which is ```10.x.0.0/24```:

        address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 0)]

However, in my example, I am also using Count, to create multiple Subnets. Like this:

        address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index}")]

Count index is added above so that the CIDR range is incremented with each Subnet created. The full resource block is like this:

        resource "azurerm_subnet" "region1-hub1-subnets" {
            count                = 8
            name                 = "snet-${var.region1}-vnet-hub-01-${count.index}"
            resource_group_name  = azurerm_resource_group.rg1.name
            virtual_network_name = azurerm_virtual_network.region1-hub1.name
            address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index}")]
        }

This will start from ```10.x.0.0/24```, then ```10.x.1.0/24``` etc. 

This works well as you can customise the number of subnets to your requirement, based on the CIDR range initially specified (as a single variable), and count keeps thing neat and to a single block. 

Note - for subsequent VNETs, you will need to increment the count index to take into account the next available Subnets to be used. For example:

        resource "azurerm_subnet" "region1-spoke1-subnets" {
            count                = 8
            name                 = "snet-${var.region1}-vnet-spoke-01-${count.index}"
            resource_group_name  = azurerm_resource_group.rg1.name
            virtual_network_name = azurerm_virtual_network.region1-spoke1.name
            address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 8}")]
        }
