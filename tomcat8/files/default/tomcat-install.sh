#!/bin/bash
echo
      logfile=/var/log/tomcat-install.log
      #Start the logging
      exec >> $logfile 2>&1

      JDK_VERSION="1.8.0_65"
      TOMCAT_VERSION="8.0.28"

      # Lock release version
      sudo -n sed --in-place=bak 's/releasever=latest/#releasever=latest/' /etc/yum.conf
      sudo -n yum clean all -y -q
      sudo -n yum update -y -q
      # Install Java
      DIST_VERSION=$(echo $JDK_VERSION | sed -r 's/1\.([0-9])\.0_/\1u/')
      JDK_DIST="jdk-${DIST_VERSION}-linux-x64.rpm"
      aws s3 cp s3://bamInstall/${JDK_DIST} . --region us-east-1
      if [ $? -ne 0 ]; then
         echo Java rpm cannot be downloaded from s3://bamInstall/${JDK_DIST}
         exit 1
      fi
      sudo -n yum -q -y localinstall ${JDK_DIST}
      sudo -n alternatives --install /usr/bin/java java /usr/java/jdk${JDK_VERSION}/bin/java 2 \
          --slave /usr/bin/keytool keytool  /usr/java/jdk${JDK_VERSION}/bin/keytool \
          --slave /usr/bin/orbd orbd  /usr/java/jdk${JDK_VERSION}/bin/orbd \
          --slave /usr/bin/pack200 pack200  /usr/java/jdk${JDK_VERSION}/bin/pack200 \
          --slave /usr/bin/rmid rmid  /usr/java/jdk${JDK_VERSION}/bin/rmid \
          --slave /usr/bin/rmiregistry rmiregistry  /usr/java/jdk${JDK_VERSION}/bin/rmiregistry \
          --slave /usr/bin/servertool servertool  /usr/java/jdk${JDK_VERSION}/bin/servertool \
          --slave /usr/bin/tnameserv tnameserv  /usr/java/jdk${JDK_VERSION}/bin/tnameserv \
          --slave /usr/bin/unpack200 unpack200  /usr/java/jdk${JDK_VERSION}/bin/unpack200
      sudo -n alternatives --set jre /usr/java/jdk${JDK_VERSION}/jre
      sudo -n rm -f /usr/lib/jvm/jre
      sudo -n ln -s  /usr/java/jdk${JDK_VERSION}/jre /usr/lib/jvm/jre
      sudo -n alternatives --set java /usr/java/jdk${JDK_VERSION}/bin/java
      export JDK_HOME=/usr/java/jdk${JDK_VERSION}
      # Install Tomcat
      sudo -n yum install -y tomcat8 --enablerepo=epel -q
      aws s3 cp s3://bamInstall/apache-tomcat-${TOMCAT_VERSION}.tar.gz tomcat.tar.gz --region us-east-1
      if [ $? -ne 0 ]; then
         echo Tomcat installable cannot be downloaded from s3://bamInstall/apache-tomcat-${TOMCAT_VERSION}.tar.gz
         exit 1
      fi
      tar -xzf tomcat.tar.gz
      sudo -n rm -fr /usr/share/tomcat8/lib/*
      sudo -n cp -R -f apache-tomcat-${TOMCAT_VERSION}/lib/* /usr/share/tomcat8/lib
      sudo -n chkconfig tomcat8 on
      sudo -n sh -c 'echo "umask 002" >> /etc/sysconfig/tomcat8'
      sudo -n chmod a+rx /var/log/tomcat8
      # Install tomcat native connector
      sudo -n yum install apr-util.x86_64 -y -q
      sudo -n yum install apr-devel.x86_64 -y -q
      sudo -n yum install openssl-devel.x86_64 -y -q
      sudo -n yum install tomcat-native.x86_64 -y -q
      cd ${HOME}
      # Set system limits
cat <<EOF | sudo -n tee /etc/security/limits.d/91-tomcat.conf
tomcat - nproc 50000
tomcat - stack unlimited
tomcat - nofile 500000
tomcat - as unlimited
tomcat - memlock unlimited
root - memlock unlimited
root - nofile 100000
root - nproc 32768
root - as unlimited
EOF
# Disable upgrade on startup
cat <<EOF | sudo -n tee /etc/cloud/cloud.cfg.d/10_noupgrade.cfg
repo_upgrade: none
EOF
#Add custom log rotation for tomcat (default config is already under /etc/logrotate.d/tomcat7), OPS-78/SIQ-2716
cat <<EOF | sudo -n tee  /etc/logrotate.d/tomcat8
/var/log/tomcat8/catalina.out {
   copytruncate
   size 100M
   rotate 5
   compress
   missingok
   create 0644 tomcat tomcat
}
EOF
      sudo -n chown tomcat:tomcat /etc/tomcat8/tomcat8.conf
      sudo -n service tomcat8 restart
