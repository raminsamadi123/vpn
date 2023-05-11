#!/usr/bin/env bash

sudo apt-get update -y && sudo apt-get -y install ca-certificates wget net-tools gnupg

wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc

echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main" >/etc/apt/sources.list.d/openvpn-as-repo.list

sudo apt-get update -y && sudo apt-get -y install openvpn-as

ip_address="$(ip address | grep "inet" | grep "enp" | awk -F '/' '{print $1}' | awk '{print $2}')"

echo -e "1. Open Google Chrome\n2. Type in Google Chrome Admin UI: https://$ip_address:943/admin\n3. Install Openvpn Connect on Windows\n4. Type Client UI https://$ip_address:943/"
