w3tools-varnish
===============

####Varnish Cache Integration in cPanel

Varnish Cache is a web application accelerator also known as a caching HTTP reverse proxy. You install it in front of any server that speaks HTTP and configure it to cache the contents.

####Installation:

```bash
$> yum update -y
$> yum install wget -y
$> wget "https://raw.githubusercontent.com/itseasy21/w3tools-varnish/master/install.sh" -O /root/varnish-install.sh
$> cd /root
$> chmod +x varnish-install.sh
$> ./varnish-install.sh
``````

####Varnish Cache Settings

You can play around with Varnish setting to get best result based on your preferences
```bash
vim /etc/varnish/default.vcl
```
You can validate the setting before applying
```bash
varnishd -C -f /etc/varnish/default.vcl
```
To apply the setting, restart Varnish
````bash
service Varnish restart
```

Varnish Cache Proudly Presented by http://www.w3tool.blogspot.in/
