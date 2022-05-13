#Chocolatey setup and installation script for using Terraform
#Set Execution Policy to allow script to run
Set-ExecutionPolicy Bypass -Scope Process -Force 
#Chocolatey install
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#Chocolatey apps
choco install vscode -y -no-desktopshortcuts
choco install terraform -y -no-desktopshortcuts
choco install azure-cli -y -no-desktopshortcuts