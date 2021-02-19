#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install python3-pip -y
sudo pip3 install 'ansible[azure]'
ansible-galaxy collection install azure.azcollection