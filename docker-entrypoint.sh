#!/bin/bash

# Rundeck configuration
for FILE in `ls /root/rundeck-config`
do
    envtpl -o /etc/rundeck/$FILE --allow-missing --keep-template /root/rundeck-config/$FILE
done

if [ "$1" = 'rundeck' ]
then
    
    echo "starting rundeck service..."
    service rundeckd start

    touch /var/log/rundeck/rundeck.log
    chown rundeck:adm /var/log/rundeck/rundeck.log
    tail -f /var/log/rundeck/rundeck.log

    # stop service and clean up here
    echo "stopping rundeck service..."
    service rundeckd stop
    echo "exited $0"
else
    exec "$@"
fi
 
