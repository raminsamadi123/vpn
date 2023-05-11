#!/usr/bin/env bash

ip_address="$(ip address | grep "inet" | grep "enp" | awk -F '/' '{print $1}' | awk '{print $2}')"
ufw="/usr/bin/ufw"

sudo apt-get update -y && sudo apt-get -y install ca-certificates wget net-tools gnupg
wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc

echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main" >/etc/apt/sources.list.d/openvpn-as-repo.list

if [ -f "$ufw" ]; then
	sudo ufw allow 443,80/tcp
	sudo ufw allow 943,1194/udp
fi

sudo apt-get update -y
sudo apt-get -y install openvpn-as | sudo tee "$HOME/openvpncredentials.txt"

username="$(grep "account with" "$HOME/openvpncredentials.txt" | awk '{ print $6 }' | sed 's/"//g')"
password="$(grep "account with" "$HOME/openvpncredentials.txt" | awk '{ print $9 }' | sed 's/"//g')"

clear
echo -e "To access the OpenVPN:\n1. Type in Google Chrome: https://$ip_address:943/admin\n2. Login with\nusername: $username\npassword: $password\n3. Install Openvpn Connect on Windows\n4. Type Client UI https://$ip_address:943/"
