#!/bin/bash                                                                          
touch /etc/.dvdripconf                                                               
touch /var/log/ripscript.log                                                         
dd if=$1 of=/dev/null bs=1 count=1 2>/dev/null                                       
RESULT=$?                                                                            
                                                                                     
#do this individually                                                                
if [ $RESULT == 0 ]; then                                                            
  {                                                                                  
      date                                                                           
      SERVNUM=$(date +%s)                                                            
      echo "<<<<<<<<<<DRIVE IS: $1>>>>>>>>>>>>"                                      
      echo -e "ARG1=$1" > /etc/.dvdripconf                                           
      systemctl start dvdrip@$SERVNUM.service                                        
  } &>> /var/log/rip.log                                                             
else                                                                                 
        echo 'Drive empty'                                                           
        exit 0;
fi     
