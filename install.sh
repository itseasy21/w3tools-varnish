#!/bin/bash

# This script installs VARNISH Cache along side Apache on cPanel servers. The default setup
# is to have varnish serve static files (html, png, jpg, etc) and pass PHP requests
# over to Apache. This script installs VARNISH, changes the Apache port to 82, writes
# some config files, starts VARNISH, and terminates.

### Made by Shubham Mathur (itseasy21)

#-Colors :D
RED='\033[01;31m'
GREEN='\033[01;32m'
RESET='\033[0m'

#--Clearing Your Screen
clear

echo -e "$GREEN----------------------------------------$RESET"
echo -e " Starting the W3TooLS Varnish installer"
echo -e "            Version 0.2             "
echo -e "     http://www.w3tool.blogspot.in/  "
echo -e "$GREEN----------------------------------------$RESET"

#--Making Sure we have required libs
cd /root
yum install vim wget lynx sed rpm -y

#--CPanel check
echo -ne "Searchinng for cPanel .."
if [ -e  "/usr/local/cpanel/version" ]; then
	echo -e "[ $GREEN cPanel Found $RESET ]"
else
	echo -e "[ $RED cPanel Not Found $RESET ]"
	exit
fi

#--Libs Check
echo " "
echo -ne "Checking for Yum .."
if [ -e  "/etc/yum.conf" ]; then
	echo -e "[ $GREEN Found $RESET ]"
else
	echo -e "[ $RED Not Found $RESET ]"
	exit
fi

echo -ne "Checking for SED .."
if [ -e  "/bin/sed" ]; then
	echo -e "[ $GREEN Found $RESET ]"
else
	echo -e "[ $RED Not Found $RESET ]"
	exit
fi

#--Removing Previous Varnish Install
yum remove varnish -y


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
sed -i "s#host = \"127.0.0.1\"#host = \"$ip\"#g" ./default.vcl
sed -i 's#port = "80"#port = "82"#g' ./default.vcl

#-- Starting Varnish
chkconfig varnish on
service varnish start

echo -e "$GREEN----------------------------------------$RESET"
echo -e "$GREEN Varnish Cache Installation Complete  $RESET"
echo -e "If varnish failed to install or you faced any bugs feel free to post them with install log at http://bit.ly/w3tools-varnish-issues"
echo -e ""
echo -e "You can monitor varnish cache through this monitoring tool:$GREEN varnishstat $RESET"
echo -e ""
echo -e "Thanks for using our Varnish Installer for CPanel"
echo -e "For more stay tuned at our blog : http://www.w3tool.blogspot.in/"
echo -e "$GREEN----------------------------------------$RESET"

