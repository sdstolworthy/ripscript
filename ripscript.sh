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
    DVDNAME=$(makemkvcon -r info)
    DVDNAME=`echo "$DVDNAME" | grep "DRV:$DISNUM\+"`
    DVDNAME=${DVDNAME:53}
    len=${#DVDNAME}-12
    DVDNAME=${DVDNAME:0:$len}
    
    
    echo "\ndrive is: $1\n\n"
    DVDNAME=$(isoinfo -i $1 -d | grep "Volume id:" | awk '{print $3}')
    
    if [[ ${DVDNAME^^} == DVD_VIDEO ]]; then
        DVDNAME+=$((`date +%s`*1000+`date +%-N`/1000000))
    fi
    WORKPATH="/var/rips"

    echo ">>>>>>>>>>>>>>>>>>>>>>>>Beginning script to rip: $DVDNAME"
    echo $USER
    
    echo "\nTHIS IS YOUR DISC NUMBER: $DISNUM\n\n"
    mkdir -p $WORKPATH
    rm $WORKPATH/*
    makemkvcon --minlength=3600 -r --decrypt --directio=true mkv disc:$DISNUM all $WORKPATH
    
    echo $DVDNAME
    eject
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>Copying Finished! Script Complete!"
} &>> "/var/log/rip.log"
