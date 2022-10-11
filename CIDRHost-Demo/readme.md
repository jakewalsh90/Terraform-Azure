# Overview
This lab demonstrates the use of cidrhost Function within Terraform. [https://www.terraform.io/language/functions/cidrhost](https://www.terraform.io/language/functions/cidrhost)

Within this function you can calculate a host IP address from a network prefix. 

In my example, the following Resources are created:

 - VNETs and Subnets (for NICs later on in the lab). I've also used Count in the Spoke Subnets to show how this Function can still be used there too. 
 - DNS entries for the VNETs are also set using cidrhost so you can control these automatically too. 
 - a Network Interface Card in the Hub (using cidrhost)
 - a Network Interface Card in the Hub (using cidrhost and join, along with the each.key option as Count is used here)
 - a Network Security Group that makes use of cidrhost within two example rulesets - so this shows how you can use these dynamically within objects too. (NSGs, DNS entries, Route Tables etc.)
 - a Route Table that has two Routes in. One demonstrates cidrhost in it's pure form, the other is from the Spoke Subnet that makes use of the Count option, so you can see this in use too!

 ## Using cidrhost - My Environment

⚠ Note: you'll need to customise this example and calculation for your needs, this is just to demonstrate the concept!

Within my demo environment, I am creating the following, based on a Single Azure Region. IP address spacing is as below:

- In my first Azure Region, the assigned CIDR range is ```10.x.0.0/19``` (for the whole Region)
- For each VNET I am using /21 (2046 addresses per VNET), ```10.x.0.0/21```
- This means I can use /24 for each Subnet, giving simple easy to understand Subnets that provide ample room for Resources. 

✅ Thanks to the cidrsubnet function, I have only 1 variable in my terraform.tfvars file, which specifies a range for the whole region!

### Setting DNS on the VNET

To set DNS on the VNET I need to provide two IP addresses, which would likely be assigned to NVAs, Load Balancers or Domain Controllers. To do this, I used the cidrhost function to calculate the IPs. This allows the IPs to be set before the NICs are even created. In the case below, my VNET is 10.x.0.0/21 (calculated using cidrsubnet from the Regional Variable of 10.x.0.0/19). 

        dns_servers = [cidrhost("${var.region1cidr}", 4), cidrhost("${var.region1cidr}", 5)]

### Network Interface Card

Network Interface Cards are also set in a similar way to the DNS entries above: 

        private_ip_address            = cidrhost("${var.region1cidr}", 4)

### Network Interface Card - on a Subnet using Count

When Count is used, we can't use the same method as above (for obvious reasons - all NICs would be assigned the same IP). To overcome this we need to add [count.index] into the mix, and use join to add the Subnet Range and the Host element together:

        private_ip_address            = cidrhost(join(", ", "${azurerm_subnet.region1-spoke1-subnets[count.index].address_prefixes}"), 4)

This allows cidrhost (in combination with join) to increment the Private IP for each Resource created by Count (so it will increase the IP by 1 for each Resource created using Count)

### Network Security Group



### Route Table


