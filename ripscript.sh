#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
{
    sleep 2
    date
    mount -a
    if [[ $1 == *"/dev/sr"* ]]; then
        DISNUM=$(echo $1 | grep -oP '\d')
    else
        echo "Error finding correct disk number. Found $DISNUM, but this number does not seem to exist"
    fi
    
    DVDNAME=$(makemkvcon -r info)
    DVDNAME=`echo "$DVDNAME" | grep "DRV:$DISNUM\+"`
    DVDNAME=${DVDNAME:53}
    len=${#DVDNAME}-12
    DVDNAME=${DVDNAME:0:$len}
    
    
    echo "drive is: $1"
    DVDNAME=$(isoinfo -i $1 -d | grep "Volume id:" | awk '{print $3}')
    
    if [[ ${DVDNAME^^} == DVD_VIDEO ]]; then
        DVDNAME+=$((`date +%s`*1000+`date +%-N`/1000000))
    fi
    WORKPATH="/tmp/rips"

    echo ">>>>>>>>>>>>>>>>>>>>>>>>Beginning script to rip: $DVDNAME"
    echo $USER
    
    echo "THIS IS YOUR DISC NUMBER: $DISNUM"
    mkdir -p $WORKPATH
    rm $WORKPATH/*
    makemkvcon --minlength=3600 -r --decrypt --directio=true mkv disc:$DISNUM all $WORKPATH
    
    echo $DVDNAME
    eject
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>Copying Finished! Script Complete!"
} &>> "/var/log/rip.log"
