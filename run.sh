#!/usr/bin/env bash

if [ -d "./hosts" ]; then
	echo "--> Updating hosts"
	cd hosts
	git pull
	cd - > /dev/null
else
	echo "--> Cloning hosts"
	git clone https://github.com/StevenBlack/hosts.git hosts
fi

if [[ -z "$1" ]]; then
	hosts_file="hosts/hosts"
else
	hosts_file="$1"
fi

echo "--> Overriding /etc/hosts"
echo "--> Will prompt for sudo password"
read -p "--> Continue overriding /etc/hosts? [yn] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
	sudo cp $hosts_file /etc/hosts
	sudo chown root:wheel /etc/hosts

	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
else
	echo "--> Cancelled by user; quitting"
fi
