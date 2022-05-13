#Chocolatey setup and installation script for the apps I use.
#Set Execution Policy to allow script to run
Set-ExecutionPolicy Bypass -Scope Process -Force 
#Chocolatey install
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#Chocolatey apps
choco install putty -y -no-desktopshortcuts
choco install notepadplusplus -y -no-desktopshortcuts
choco install winscp -y -no-desktopshortcuts
choco install 7zip -y -no-desktopshortcuts
choco install firefox -y -no-desktopshortcuts
choco install foxitreader -y -no-desktopshortcuts
choco install paint.net -y -no-desktopshortcuts
choco install vlc -y -no-desktopshortcuts
choco install keepass -y -no-desktopshortcuts
choco install vscode -y -no-desktopshortcuts
choco install citrix-workspace -y -no-desktopshortcuts
choco install microsoft-teams -y -no-desktopshortcuts
choco install packer -y -no-desktopshortcuts
choco install terraform -y -no-desktopshortcuts
choco install office365business -y -no-desktopshortcuts
choco install azure-cli -y -no-desktopshortcuts
choco install microsoftazurestorageexplorer -y -no-desktopshortcuts
choco install az.powershell -y -no-desktopshortcuts
choco install bicep -y -no-desktopshortcuts
choco install graphviz -y -no-desktopshortcuts
choco install tfsec -y -no-desktopshortcuts
choco install github-desktop -y -no-desktopshortcuts
choco install gh -y -no-desktopshortcuts