#!/bin/bash

dns=`curl -s http://169.254.169.254/latest/meta-data/hostname`
dev="siq.sleepnumber.com"
prod="sleepiq.sleepnumber.com"
stackname=`uname -a | awk {'print $2'} | awk -F "-" {'print $1'}`
conf=/etc/httpd/conf/httpd.conf
echo "var:"$dns

if
        [[ "$dns" == *"$dev"* ]]
then
        sed -i 's/env/'$stackname'/g' $conf
        sed -i 's/url/'$dev'/g' $conf
        echo "Dev env setting config in httpd.conf"
else
        echo "Prod end setting config in httpd.conf"
fi
