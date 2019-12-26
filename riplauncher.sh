#!/bin/bash                                                                          
touch /etc/.dvdripconf                                                               
touch /var/log/ripscript.log                                                         
#do this individually                                                                
{                                                                                  
    date                                                                           
    SERVNUM=$(date +%s)                                                            
    echo "<<<<<<<<<<DRIVE IS: $1>>>>>>>>>>>>"                                      
    echo -e "ARG1=$1" > /etc/.dvdripconf                                           
    systemctl start dvdrip@$SERVNUM.service                                        
} &>> /var/log/rip.log                                                             
