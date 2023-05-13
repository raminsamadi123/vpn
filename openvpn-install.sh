#!/usr/bin/env bash

sudo apt-get update -y && sudo apt-get -y install ca-certificates wget net-tools gnupg
wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc

echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main" >/etc/apt/sources.list.d/openvpn-as-repo.list

if command -v "ufw"; then
	sudo ufw allow 443,80/tcp
	sudo ufw allow 943,1194/udp
fi

sudo apt-get update -y
sudo apt-get -y install openvpn-as | sudo tee "$HOME/openvpncredentials.txt"

admin_ui="$(grep "admin" "$HOME/openvpncredentials.txt" | awk '{ print $3 }')"
client_ui="$(grep "Client" "$HOME/openvpncredentials.txt" | awk '{ print $3 }')"

username="$(grep "account with" "$HOME/openvpncredentials.txt" | awk '{ print $6 }' | sed 's/"//g')"
password="$(grep "account with" "$HOME/openvpncredentials.txt" | awk '{ print $9 }' | sed 's/"//g')"

clear
echo -e "To access the OpenVPN:\n1. Type in Google Chrome: $admin_ui\n\n2. Login with\n	username: $username\n	password: $password\n\n3. Install OpenVPN Connect on Windows: https://openvpn.net/client-connect-vpn-for-windows/\n\n4. Type in OpenVPN Connect: $client_ui\n"

echo -e "To access the OpenVPN:\n1. Type in Google Chrome: $admin_ui\n\n2. Login with\n	username: $username\n	password: $password\n\n3. Install OpenVPN Connect on Windows: https://openvpn.net/client-connect-vpn-for-windows/\n\n4. Type in OpenVPN Connect: $client_ui\n" >"/tmp/openvpn-guide"
