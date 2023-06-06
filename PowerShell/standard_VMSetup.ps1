# Choco install and Choco Apps
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install googlechrome -y
choco install putty -y
choco install notepadplusplus -y
choco install sysinternals -y
# Disable Firewall for Testing
Set-NetFirewallProfile -All -Enabled False
