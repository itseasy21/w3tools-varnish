#!/bin/bash

# This script installs VARNISH Cache along side Apache on cPanel servers. 
#This script installs VARNISH, changes the Apache port to 82, writes
# some config files, starts VARNISH, and terminates.

### Made by Shubham Mathur (itseasy21)

#-Colors :D
RED='\033[01;31m'
GREEN='\033[01;32m'
RESET='\033[0m'

#--Clearing Your Screen
clear

echo -e "$GREEN----------------------------------------$RESET"
echo -e "    $RED W3TooLS Varnish UnInstaller $RESET"
echo -e "              Version 0.2             "
echo -e "     http://www.w3tool.blogspot.in/  "
echo -e "$GREEN----------------------------------------$RESET"

#Backup Config
echo -e "$GREEN Backing Up Varnish Config to $RESET $RED /etc/varnish/default.vcl.bak $RESET"
cp /etc/varnish/default.vcl /etc/varnish/default.vcl.bak

#Remove Varnish
echo -e "$GREEN Removing $RESET $RED Varnish $RESET"
yum remove varnish -y

#Fix Apache Config to Listen on Port 80
echo -e "$GREEN Setting $RESET $RED Apache $RESET"
cd /var/cpanel
sed -i 's#apache_port=0.0.0.0:82#apache_port=0.0.0.0:80#g' ./cpanel.config
/usr/local/cpanel/whostmgr/bin/whostmgr2 -updatetweaksettings
/scripts/rebuildhttpdconf
service httpd restart


echo -e "$GREEN---------------------------------------------------$RESET"
echo -e "$GREEN      Varnish Cache Successfully Removed           $RESET"
echo -e ""
echo -e "If varnish failed to uninstall or you faced any bugs feel free to post them with install log at $GREEN http://bit.ly/w3tools-varnish-issues $RESET"
echo -e ""
echo -e "For more stay tuned at our blog : $GREEN http://www.w3tool.blogspot.in/ $RESET"
echo -e "$GREEN---------------------------------------------------$RESET"
