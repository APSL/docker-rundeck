#!/bin/bash

if [ "$1" = 'rundeck' ]
then
    
    echo "starting rundeck service..."
    service rundeckd start

    touch /var/log/rundeck/rundeck.log
    chown rundeck:adm /var/log/rundeck/rundeck.log
    # Rundeck configuration
#     for FILE in `ls /root/rundeck-config`
#     do
#         envtpl -o /etc/rundeck/$FILE --allow-missing --keep-template /root/rundeck-config/$FILE
#     done
    for FILE in `ls /root/rundeck-config`
    do
      # If is not in the volume we copied the initial and linked to etc
      if [ ! -f /data/etc/$FILE ]
        cp /root/rundeck-config/$FILE /data/etc/$FILE
        rm /etc/rundeck/$FILE
        ln -s /data/etc/$FILE /etc/rundeck/$FILE
      endif 
    done
    tail -f /var/log/rundeck/rundeck.log

    # stop service and clean up here
    echo "stopping rundeck service..."
    service rundeckd stop
    echo "exited $0"
else
    exec "$@"
fi
 
