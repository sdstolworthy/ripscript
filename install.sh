#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Create the needed directories
echo "Creating directories"
mkdir -p /usr/bin
mkdir -p /etc
mkdir -p /var/log
mkdir -p /etc/systemd/system
mkdir -p /etc/udev/rules.d/
mkdir -p /var/rips

echo "Installing files"
chmod a+x ./dvdrip@.service
/bin/cp -rf ./dvdrip@.service /etc/systemd/system

chmod a+x ./ripscript.sh
/bin/cp -rf ./ripscript.sh /usr/bin/ripscript

chmod a+x ./riplauncher.sh
/bin/cp -rf ./riplauncher.sh /usr/bin/riplauncher

echo "Adding rules to udev"
cat udev.rules > /etc/udev/rules.d/99-sr.rules

echo "Reloading udev rules"
udevadm control --reload-rules

echo "Reloading systemctl"
systemctl daemon-reload
