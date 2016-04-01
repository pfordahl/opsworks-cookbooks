#!/bin/bash
logfile=/var/log/apache-install.log
#Start the logging
#exec >> $logfile 2>&1

#Install Apache
yum -y httpd

#Set the service
chkconfig --add httpd

#Start the service
service httpd start
