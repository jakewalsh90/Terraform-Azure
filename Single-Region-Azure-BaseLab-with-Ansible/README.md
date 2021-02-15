# Single Region Base Lab Environment for Azure - with Ansible VM

## Overview
This code creates a simple Lab environment within a Single Azure Region, and also includes an Ubuntu Server VM with Ansible installed. For documentation please see [Single-Region-Azure-BaseLab](..//Single-Region-Azure-BaseLab) - this lab is identical, albeit for the Ansible elements. 

*It is not intended for production use!*

## Extra elements

1. Creates "anpassword" in the KeyVault - this is the Password to log into the Ansible VM
2. Creates an Ubuntu Server VM to use for Ansible
3. Creates a Custom Script Extension which runs AnsibleSetup.sh from the Ansible directory in this repo. 

This lab includes everything from the [Single-Region-Azure-BaseLab](..//Single-Region-Azure-BaseLab), but with the additional Ansible VM above. The Domain Setup scripts still need to be run as per the linked Single-Region-Azure-Baselab documentation. 
