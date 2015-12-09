#!/bin/bash
stackname=`uname -a | awk {'print $2'} | awk -F "-" {'print $1'}`
rm hzservers
counter=1
while true
do
host="$stackname-hz$counter"

ping -q -c 1 $host
ecode=`echo $?`
        if
                [ "$ecode" = 0 ]
        then
                echo $host >>hzservers
                ((counter++))
                #$counter=$(expr $counter + 1)
        else
                echo "no more servers"
                break
        fi
done
servers=`cat hzservers`

for i in $servers
do
echo "server:" $i
echo "running awk"
sed -i 's/localhost/'$stackname-mc1'/g' hazelcast.xml
sed -i '/<member-list>/a  \                      \<member>'$i'</member>' hazelcast.xml
echo "done running aws"
done
