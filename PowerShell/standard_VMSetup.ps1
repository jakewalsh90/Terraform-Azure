# Set Execution Policy to allow script to run
Set-ExecutionPolicy Bypass -Scope Process -Force 
# Choco install and Choco Apps
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install googlechrome -y
choco install putty -y
choco install notepadplusplus -y
choco install sysinternals -y
# Disable Firewall for Testing
Set-NetFirewallProfile -All -Enabled False
