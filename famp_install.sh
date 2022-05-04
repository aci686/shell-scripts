#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Install LAMP on a FreeBSD system

source colors.sh

echo -e "[${yellow}I${end}] Upgrading the system..."
pkg update && pkg -y upgrade

echo -e "[${yellow}I${end}] Installing Apache2 webserver..."
pkg install -y apache24

echo -e "[${yellow}I${end}] Configuring Apache2 webserver..."
sysrc apache24_enable=yes
service apache24 start

echo -e "[${yellow}I${end}] Testing Apache2 so far..."
service apache24 status
if [ $? == 0 ] 
then
	echo -e "[${green}OK${end}] Apache2 running correctly..."
fi

echo -e "[${yellow}I${end}] Installing MySQL database server..."
pkg install -y mysql80-client mysql80-server

echo -e "[${yellow}I${end}] Configuring MySQL database server..."
sysrc mysql_enable=yes
service mysql-server start

echo -e "[${yellow}I${end}] Testing MySQL so far..."
service mysql-server status
if [ $? == 0 ]
then
	echo -e "[${green}OK${end}] MySQL running correctly..."
fi

echo -e "[${yellow}I${end}] Securing MySQL installation..."
mysql_secure_installation

echo -e "[${yellow}I${end}] Installing PHP..."
pkg install -y php74 php74-mysqli mod_php74

cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini

echo -e "[${yellow}I${end}] Configuring PHP..."
sysrc php_fpm_enable=yes
service php-fpm start

echo -e "[${yellow}I${end}] Testing PHP so far..."
service php-fpm status
if [ $? == 0 ]
then
	echo -e "[${green}OK${end}] PHP running correctly..."
fi

echo -e "[${yellow}I${end}] Reconfiguring Apache2..."
cat <<EOF >/usr/local/etc/apache24/modules.d/001_mod-php.conf
<IfModule dir_module>
	DirectoryIndex index.php index.html
	<FilesMatch "\.php$">
		SetHandler application/x-httpd-php
	</FilesMatch>
	<FilesMatch "\.phps$">
		SetHandler application/x-httpd-php-source
	</FilesMatch>
</IfModule>
EOF

cp /usr/local/etc/apache24/modules.d/0001_mod-php.conf /usr/local/etc/apache24/Includes/php.conf

service apache24 restart
echo -e "[${yellow}I${end}] Testing Apache2 so far..."
service apache24 status
if [ $? == 0 ]
then
	echo -e "[${green}OK${end}] Apache2 running correctly..."
fi


