# Set Execution Policy to allow script to run
Set-ExecutionPolicy Bypass -Scope Process -Force
# Allow Ping
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -enabled True
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" -enabled True
# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
# Replace IIS Page with Server Name for Identification Purposes
iex hostname | out-file -filepath c:\inetpub\wwwroot\iisstart.htm -Force
