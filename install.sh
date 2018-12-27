#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Create the needed directories
mkdir -p /usr/bin
mkdir -p /etc
mkdir -p /var/log
mkdir -p /etc/systemd/system
mkdir -p /etc/udev/rules.d/
mkdir -p /tmp/rips

chmod a+x ./dvdrip@.service
mv ./dvdrip@.service /etc/systemd/system

chmod a+x ./ripscript.sh
mv ./ripscript.sh /usr/bin/ripscript

chmod a+x ./riplauncher.sh
mv ./riplauncher.sh /usr/bin/riplauncher

cat udev.rules > /etc/udev/rules.d/99-sr.rules

udevadm control --reload-rules