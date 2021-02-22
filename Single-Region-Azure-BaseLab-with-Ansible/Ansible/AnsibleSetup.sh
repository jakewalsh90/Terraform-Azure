sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install python3-pip -y
sudo pip3 install 'ansible[azure]'
ansible-galaxy collection install azure.azcollection
wget https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
sudo pip3 install -r requirements-azure.txt