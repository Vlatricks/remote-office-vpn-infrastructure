#!/bin/bash
if [ "$EUID" -ne 0 ]; then
	echo "Permision denied"
	exit 1
fi

apt update
apt install -y firewalld
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=1194/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload

apt install -y easy-rsa
mkdir ~/vpn-easy-rsa
chmod 700 ~/vpn-easy-rsa
cp -r /usr/share/easy-rsa/* ~/vpn-easy-rsa
cd ~/vpn-easy-rsa
./easyrsa init-pki
EASYRSA_BATCH=1 ./easyrsa gen-req vpn-server nopass
echo "Succsess! move file to CA with comand:"
echo "scp ~/vpn-easy-rsa/pki/reqs/vpn-server.req yc-user@IP_CA_VM:~/"
