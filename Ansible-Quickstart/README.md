# Ansible Azure Quickstart

## Overview
This code creates a Ubuntu Server VM with Ansible installed. Designed to get you up and running quickly with Ansible in Azure. 

*It is not intended for production use!*

## What this code creates

1. Creates a VNET with a Subnet for the Ansible VM
2. Creates a KeyVault 
3. Creates a random password value and stores this inside the KeyVault - this Password is used for the Ansible VM
4. Creates an Ubuntu Server VM
5. Uses a custom script extension to install Ansible & dependencies for Azure on the Ubuntu VM
