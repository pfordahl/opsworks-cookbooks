#!bin/bash
logfile=/var/log/env-configure.log
#Start the logging
exec >> $logfile 2>&1

#Create the configure directory
mkdir -p /opt/bamHome/config/bam/

#Create Environment directory
mkdir -p /etc/environment
