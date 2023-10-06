# Chocolatey setup and installation script for the apps I use.
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Chocolatey apps
choco install putty -y -no-desktopshortcuts
choco install notepadplusplus -y -no-desktopshortcuts
choco install winscp -y -no-desktopshortcuts
choco install 7zip -y -no-desktopshortcuts
choco install firefox -y -no-desktopshortcuts
choco install vlc -y -no-desktopshortcuts
choco install keepass -y -no-desktopshortcuts
choco install vscode -y -no-desktopshortcuts
choco install packer -y -no-desktopshortcuts
choco install terraform -y -no-desktopshortcuts
choco install azure-cli -y -no-desktopshortcuts
choco install microsoftazurestorageexplorer -y -no-desktopshortcuts
choco install az.powershell -y -no-desktopshortcuts
choco install bicep -y -no-desktopshortcuts
choco install github-desktop -y -no-desktopshortcuts
