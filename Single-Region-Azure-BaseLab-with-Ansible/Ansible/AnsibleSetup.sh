#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install python3-pip -y
sudo pip3 install 'ansible[azure]'
ansible-galaxy collection install azure.azcollection
wget https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Single-Region-Azure-BaseLab-with-Ansible/Ansible/requirements-azure.txt
sudo pip3 install -r requirements-azure.txt