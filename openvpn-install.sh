#!/usr/bin/env bash

# Script: OpenVPN Setup Script
# Description: Sets up OpenVPN Access Server and provides instructions for accessing it
# Prerequisites: Assumes administrative privileges and a Debian-based Linux distribution

log_file="/var/log/openvpncredentials.log"
client_connect_vpn_for_windows="https://openvpn.net/client-connect-vpn-for-windows/"

# Update the package index files and install ca-certificates, wget, net-tools, gnupg
sudo apt-get update -y && sudo apt-get -y install ca-certificates wget net-tools gnupg
wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc

# Add OpenVPN repository to the sources list
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main" >/etc/apt/sources.list.d/openvpn-as-repo.list

# If ufw exists, allow specific ports required by OpenVPN
if command -v "ufw"; then
	sudo ufw allow 443,80/tcp
	sudo ufw allow 943,1194/udp
fi

# Update the package index files
sudo apt-get update -y

# Install OpenVPN Access Server and log installation output
sudo apt-get -y install openvpn-as | sudo tee "$log_file"

# Extract the URLs for the admin and client interfaces
admin_ui="$(grep "admin" "$log_file" | awk '{ print $3 }')"
client_ui="$(grep "Client" "$log_file" | awk '{ print $3 }')"

# Extract the default OpenVPN credentials
username="$(grep "account with" "$log_file" | awk '{ print $6 }' | sed 's/"//g')"
password="$(grep "account with" "$log_file" | awk '{ print $9 }' | sed 's/"//g')"

# Output instructions on how to set up OpenVPN and save it in a guide file
clear
echo "To access the OpenVPN:
1. Type in Google Chrome: $admin_ui

2. Login with
      username: $username
      password: $password

3. Install OpenVPN Connect on Windows: $client_connect_vpn_for_windows

4. Type in OpenVPN Connect: $client_ui
" | tee "/var/log/openvpn-guide.log"
