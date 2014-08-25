#!/bin/bash

# This script installs VARNISH Cache along side Apache on cPanel servers. The default setup
# is to have varnish serve static files (html, png, jpg, etc) and pass PHP requests
# over to Apache. This script installs VARNISH, changes the Apache port to 82, writes
# some config files, starts VARNISH, and terminates.

### Made by Shubham Mathur (itseasy21)

echo '----------------------------------------'
echo " Starting the W3TooLS Varnish installer"
echo "--------------By itseasy21--------------"
echo '-----------------------------------------'

#--Adding Required FUnctions
cd /root
yum install vim wget lynx sed rpm -y

#--Change port Apache listens on to 82
cd /var/cpanel
sed -i 's#apache_port=0.0.0.0:80#apache_port=0.0.0.0:82#g' ./cpanel.config
/usr/local/cpanel/whostmgr/bin/whostmgr2 -updatetweaksettings
/scripts/rebuildhttpdconf
service httpd restart

#--Install Varnish 3
cd /root
rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm
yum install varnish -y

#-- Config Varnish
cd /etc/sysconfig/
sed -i 's#VARNISH_LISTEN_PORT=6081#VARNISH_LISTEN_PORT=80#g' ./varnish
cd /etc/varnish/
ip=$(( lynx --dump cpanel.net/showip.cgi ) 2>&1 | sed "s/ //g")
#sed -i 's#host = "127.0.0.1"#host = "$ip"#g' ./default.vcl
sed -i "s#host = \"127.0.0.1\"#host = \"$ip\"#g" ./default.vcl
sed -i 's#port = "80"#port = "82"#g' ./default.vcl

#-- Starting Varnish
chkconfig varnish on
service varnish start

