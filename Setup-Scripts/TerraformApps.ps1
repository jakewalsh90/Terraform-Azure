# Chocolatey setup and installation script for using Terraform
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Chocolatey apps
choco install vscode -y -no-desktopshortcuts
choco install terraform -y -no-desktopshortcuts
choco install azure-cli -y -no-desktopshortcuts
choco install az.powershell -y -no-desktopshortcuts
choco install github-desktop -y -no-desktopshortcuts
