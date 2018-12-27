#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
{
    sleep 2
    date
    mount -a
    # if [ $1 = '/dev/sr0' ]; then
    # 	DISNUM=1
    # elif [ $1 = '/dev/sr1' ]; then
    # 	DISNUM=0
    # else
    # 	echo "CONGRESS HAS NOT COME TO A DECISION; IMMINENT FAILURE"
    # 	exit
    # fi
    
    DISNUM=0
    
    DVDNAME=$(makemkvcon -r info)
    DVDNAME=$`echo "$DVDNAME" | grep "DRV:$DISNUM\+"`
    DVDNAME=${DVDNAME:53}
    len=${#DVDNAME}-12
    DVDNAME=${DVDNAME:0:$len}
    
    
    echo "drive is: $1"
    DVDNAME=$(isoinfo -i $1 -d | grep "Volume id:" | awk '{print $3}')
    
    if [[ ${DVDNAME^^} == DVD_VIDEO ]]; then
        DVDNAME+=$((`date +%s`*1000+`date +%-N`/1000000))
    fi
    #DVDNAME=$(sudo blkid -o value -s LABEL '$1')
    WORKPATH="/tmp/rips"
    
    echo ">>>>>>>>>>>>>>>>>>>>>>>>Beginning script to rip: $DVDNAME"
    echo $USER
    
    echo "THIS IS YOUR DISC NUMBER: $DISNUM"
    mkdir -p $WORKPATH
    rm $WORKPATH/*
    makemkvcon --minlength=3600 -r --decrypt --directio=true mkv disc:$DISNUM all $WORKPATH
    
    echo $DVDNAME
    eject
    echo "$DVDNAME is finished ripping" | mail -s "$DVDNAME is finished!" sdstolworthy@gmail.com
    curl http://textbelt.com/text -d number=6154978333 -d "message=$DVDNAME is finished ripping. Change me!"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>Copying $DVDNAME to /mnt/movie/$DVDNAME.mkv"
    mv $WORKPATH/* /media/server/$DVDNAME.mkv
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>Copying Finished! Script Complete!"
} &>> "/var/log/rip.log"
