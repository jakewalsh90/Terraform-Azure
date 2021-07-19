# Dual Region Base Lab Environment for Azure NetApp Files Cross Region Replication

## For a lab overview, please visit my blog: [here](https://jakewalsh.co.uk/uk-windows-virtual-desktop-user-group-azure-netapp-files-cross-region-replication/). If you are familiar with the Dual Region Base Lab - you can skip to the Azure NetApp Files section at the bottom of this page! 

## Overview
This code creates a simple Lab environment within two Azure Regions. It is a copy of the Dual-Region-Azure-BaseLab](../Dual-Region-Azure-BaseLab), but includes Azure NetApp Files Accounts and Capacity Pools.

*It is not intended for production use!*

## Actions
The following resources are deployed:

1. Three Resource Groups, one for the Lab infrastructure in each Region, and another for Security related items.
2. Four VNETs, a Hub and a Spoke in each region, which are peered. There is also a Global peering between the two Hub VNETS. DNS is set on the VNETs to the Domain Controller IP, Azure DNS, and finally, Google DNS. 
3. Three Subnets in each VNET, with a Subnet delegated to Azure NetApp Files in the Spoke VNET. 
4. Uses the [Automatic-ClientIP-NSG](../Automatic-ClientIP-NSG) to setup a Network Security Group that allows RDP access in - this NSG rule uses the external IP of the machine that runs Terraform. 
5. Associates the created NSG to all Lab Subnets.
6. Creates a Key Vault with a randomised name, using [Azure-KeyVault-with-Secret](../Azure-KeyVault-with-Secret), and then creates a password as a Secret within the Key Vault that is used later to setup two VMs.
7. Creates Public IPs for the Domain Controller VMs.
8. Creates a Network Interface Card and associates the above Public IP.
9. Creates a Data Disk for NTDS Storage on the Domain Controller VM.
10. Creates a Windows 2019 VM to act as a Domain Controller. The Username for this VM is a Variable, and the Password is saved as a Secret in the Key Vault. (It was automatically generated in Step 6).
11. Attaches the Data Disk created in step 9, with caching Turned off. 
12. Sets up Azure NetApp Files Accounts and Capacity Pools in Region 1 and Region 2. 
13. Runs a Setup script on the Domain Controller VM (baselab_DCSetup.ps1 within this repos PowerShell folder), as a Custom Script Extension - that carries out the following actions:

  - Uses Chocolatey to install Google Chrome, Putty, Notepad++, WinSCP, Sysinternals, and bginfo.
  - Creates a directory - c:\BaselabSetup.
  - Downloads two further PowerShell scripts (found within this repos PowerShell folder) which will be used to setup the Domain Controller, and create a Lab OU Structure after deployment. 
  - Sets a Windows Firewall Rule to allow File/Printer sharing.
  - Installs the Windows Features required for Active Directory and DNS. 

## Manual Steps to complete Lab Environment
#### The 4 powershell scripts should be run to complete the setup process on the created Virtual Machines. Follow the instructions below to complete the Lab Setup.  

#### First Region 

The setup scripts are in C:\baselabSetup of the region1-dc01-vm after deployment, and should be run in this order:

1. baselab_DomainSetup.ps1 - the machine will reboot after this.
2. baselab_LabStructure.ps1 - this will setup a basic OU structure.

The AD Domain is now created and you can move onto the Second Region Active Directory setup steps. 

#### Second Region 

After the first DC has been promoted, and has come back online, <b>reboot region2-dc01-vm</b> (After region1-dc01-vm has been setup and DNS is functional a reboot clears any stale DNS records on the 2nd DC).

The next setup scripts are in C:\baselabSetup of the region2-dc01-vm after deployment, and should be run in this order:

1. baselab_DC2JoinDomain.ps1 - joins the VM to the Domain.
2. baselab_DC2Promote.ps1 - promotes the VM to a Domain Controller.

The lab is now deployed and ready to use!

#### Azure NetApp Files

To start using Azure NetApp files, you will need to create the Active Directory Connections, and then create any shares/replication. This lab just creates all the supporting elements. For setup videos/guides, please see this post on by blog [https://jakewalsh.co.uk/uk-windows-virtual-desktop-user-group-azure-netapp-files-cross-region-replication/](https://jakewalsh.co.uk/uk-windows-virtual-desktop-user-group-azure-netapp-files-cross-region-replication/).
