#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__author_nick__="i686"
__copyright__="Aaron Castro"
__license__="MIT"

# Install LAMP on a Debian system

source colors.sh
source symbols.sh

# Check if being run as root
if [ "$(id -u)" != "0" ]; then
	printf "[$red$missing1$end] Do you remember you need to be root?\n"
	exit 1
fi

# Update system
printf "[$yellow"
printf "I$end] Updating the system...\n"
apt update
apt -y upgrade

# Ask DB password
printf "[$blue"
printf "?$end] Database root password [P@ssw0rd]:"
read -p " " DB_PASS
# If empty default to P@ssw0rd
if [ -z "$DB_PASS" ]; then
	DB_PASS="P@ssw0rd"
fi

# Install Apache
printf "[$yellow"
printf "I$end] Installing Apache web server...\n"
apt install -y apache2

# Configure and install MariaDB
printf "[$yellow"
printf "I$end] Configuring and installing MariaDB server...\n"
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_PASS"
apt install -y mariadb-server

# Install PHP
printf "[$yellow"
printf "I$end] Installing PHP...\n"
apt install -y php php-cgi php-pear php-mbstring php-gettext libapache2-mod-php php-common php-phpseclib php-mysql

# Configure Apache
printf "[$yellow"
printf "I$end] Configuring Apache web server...\n"
a2enmod rewrite

# Download and install latest PHPMyAdmin version
printf "[$yellow"
printf "I$end] Downloading and installing latest PHPMyAdmin...\n"
DATA="$(wget https://www.phpmyadmin.net/home_page/version.txt -q -O-)"
URL="$(echo $DATA | cut -d ' ' -f 3)"
VERSION="$(echo $DATA | cut -d ' ' -f 1)"
wget https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-english.tar.gz
tar xvf phpMyAdmin-${VERSION}-english.tar.gz
mv phpMyAdmin-*/ /usr/share/phpmyadmin

# Configure PHPMyAdmin
printf "[$yellow"
printf "I$end] Configuring PHPMyAdmin...\n"
mkdir -p /var/lib/phpmyadmin/tmp
chown -R www-data:www-data /var/lib/phpmyadmin
mkdir /etc/phpmyadmin
cp /usr/share/phpmyadmin/config.sample.inc.php  /usr/share/phpmyadmin/config.inc.php
K=$(openssl rand -base64 32 | sed 's,\/,\\/,g')
O="\$cfg\['blowfish_secret'\] = '';"
N="\$cfg\['blowfish_secret'\] = '$K';"
sed -i -e 's/'"$O"'/'"$N"'/g' /usr/share/phpmyadmin/config.inc.php
echo -e "\$cfg['TempDir'] = '/var/lib/phpmyadmin/tmp';" >> /usr/share/phpmyadmin/config.inc.php

# Ask PHPMyAdmin credentials
printf "[$blue"
printf "?$end] PHPMyAdmin username [pmauser]:"
read -p " " PMA_USER
printf "[$blue"
printf "?$end] PHPMyAdmin password [P@ssw0rd]:"
read -p " " PMA_PASS
# If empty default to pmauser and P@ssw0rd
if [ -z "$PMA_USER" ]; then
	PMA_USER="pmauser"
fi
if [ -z "$PMA_PASS" ]; then
	PMA_PASS="P@ssw0rd"
fi

#Enable PHPMyAdmin privileges
printf "[$yellow"
printf "I$end] Configuring MariaDB...\n"
mysql -u root -p$DB_PASS -e "CREATE USER '$PMA_USER'@'localhost' IDENTIFIED BY '$PMA_PASS';"
mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON *.* TO '$PMA_USER'@'localhost' WITH GRANT OPTION;"

# Create VHost for PHPMyAdmin
printf "[$yellow"
printf "I$end] Configuring PHPMyAdmin VHOST for Apache...\n"
echo "Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php

    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch \".+\.php$\">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
    <IfModule mod_php.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch \".+\.php$\">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>

</Directory>

<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authz_core.c>
        <IfModule mod_authn_file.c>
            AuthType Basic
            AuthName \"phpMyAdmin Setup\"
            AuthUserFile /etc/phpmyadmin/htpasswd.setup
        </IfModule>
        Require valid-user
    </IfModule>
</Directory>

<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>" >> /etc/apache2/conf-enabled/phpmyadmin.conf

# Restart Apache2
systemctl restart apache2


printf "[$green$check1$end1] LAMP installation complete...\n"
