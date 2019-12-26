#!/bin/bash

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
sleep 30;
grep -qF "$1" /etc/mtab;
RESULT=$1

if [ $RESULT == 1 ]; then
  {
    echo "DVD not loaded. Quitting..."
    exit 0;
  }
fi
{
    sleep 2
    date
    mount -a
    if [[ $1 == *"/dev/sr"* ]]; then
        IFS='
'
        for line in $(makemkvcon -r --cache=1 info disk:9999); do
                if [[ $line == *"$(echo $1)"* ]]; then
                        echo $line
                        DISNUM=`echo "$line" | cut -d ',' -f 1 | cut -d ':' -f 2`
                        echo $DISNUM
                fi
        done
    else
        echo "Error finding correct disk number. Found $DISNUM, but this number does not seem to exist"
    fi
    DVDNAME=$(uuidgen)
    WORKPATH="/mnt/network/ripped_videos/$DVDNAME"

    echo ">>>>>>>>>>>>>>>>>>>>>>>>Beginning script to rip: $DVDNAME"
    echo $USER
    
    echo "THIS IS YOUR DISC NUMBER: $DISNUM"
    mkdir -p $WORKPATH
    makemkvcon --minlength=3600 -r --decrypt --directio=true mkv disc:$DISNUM all $WORKPATH
    
    echo $DVDNAME
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>Copying Finished! Script Complete!"
    eject $1
} &>> "/var/log/rip.log"
