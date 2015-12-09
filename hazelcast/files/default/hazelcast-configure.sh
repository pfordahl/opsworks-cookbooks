#!/bin/bash
logfile=/var/log/hazelcast-configure.log
#Start the logging
exec >> $logfile 2>&1

#Grab stack name - might use this later
#stackname=`uname -a | awk {'print $2'} | awk -F "-" {'print $1'}`

# Create the user for hazelcast to run under
useradd hazelcast

#Create hazelcast directory
mkdir /opt/hazelcast

#Download hazelcast
wget "http://download.hazelcast.com/download.jsp?version=hazelcast-3.5.3&p=113242738" -P /tmp/
mv /tmp/download* /opt/hazelcast/hazelcast.zip

unzip /opt/hazelcast/hazelcast* -d /opt/hazelcast
chown -R hazelcast:hazelcast /opt/hazelcast*
