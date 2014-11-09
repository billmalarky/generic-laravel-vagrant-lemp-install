#!/bin/sh

##############
############## IMPORTANT STEPS FOR RUNNING VAGRANT ON WINDOWS 7
############## Start up virtualbox in admin mode by right clicking on virtualbox and clicking "run as administrator" and then open up cygwin terminal as an administrator as well. Both programs must be run as admin for symlinking to work correctly on windows 7.
##############

SITE_DIR="/var/www/html/generic.local" # The path to the web application on the server (default: /var/www/html)
SITE_PUB_DIR="/var/www/html/generic.local/public" # The path to the application public web folder.
VAGRANT_DATA_DIR="/vagrant/vagrant"
DB_NAME="generic" #name of postgres DB.


# APPLICATIONS
echo "Adding essential development tools ..."

yum update -y
yum install -y postgresql-server.x86_64
postgresql-setup initdb
service postgresql start
chkconfig postgresql on
rm -f /var/lib/pgsql/data/postgresql.conf #use vagrant postgresql config
ln -s $VAGRANT_DATA_DIR/postgresql/postgresql.conf /var/lib/pgsql/data/postgresql.conf
rm -f /var/lib/pgsql/data/pg_hba.conf #use vagrant pg_hba config
ln -s $VAGRANT_DATA_DIR/postgresql/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf

#create postgresql DB user and database
#su postgres
#psql -f $VAGRANT_DATA_DIR/postgresql/generic-db-init.backup
#exit
runuser -l postgres -c 'psql -f /vagrant/vagrant/postgresql/generic-db-init.backup'

#Add generic user to linux system so laravel can connect via ident instead of trust
# This shouldn't be needed anymore since I updated pg_hba.conf to trust mode.
#USERNAME="generic"
#PASSWORD="generic"
#PASS=$(perl -e 'print crypt($ARGV[0], "password")' $PASSWORD)
#useradd -G vagrant -m -p $PASS $USERNAME

yum install -y nginx
yum install -y php-fpm
yum install -y php-dom
yum install -y php-mcrypt
yum install -y php-gd
yum install -y php-pdo
yum install -y php-pgsql
#yum install -y php-mysql 
#yum install -y php-soap
yum install -y git
yum install -y vim


# Setting up Xdebug
yum install -y php-devel
yum install -y php-pear
yum install -y gcc gcc-c++ autoconf automake
pecl install Xdebug

# Install xdebug.ini file.
ln -s $VAGRANT_DATA_DIR/php/xdebug.ini /etc/php.d/xdebug.ini


# Install configured php.ini
cp /etc/php.ini /etc/php.ini.orig
rm -f /etc/php.ini
ln -s $VAGRANT_DATA_DIR/php/php.ini /etc/php.ini

# Installing Composer - Run composer like "/usr/local/bin/composer update"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

#echo "Symlinking site ..."
#rm -rf /var/www/html #delete html folder so the symlink will recreate it correctly (folder recreated as link).
ln -s /vagrant $SITE_DIR
ln -s $VAGRANT_DATA_DIR/adminer-4.1.0.php $SITE_PUB_DIR/dbadmin.php #symlink Adminer

echo "Updating session folder permissions"
chown -R vagrant:vagrant /var/lib/php/session

echo "Giving you the power of SSH ..."
# Create ssh if not exist
mkdir -p /home/vagrant/.ssh
rm -f /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/id_rsa.pub
# Generate our ssh keys
ssh-keygen -t rsa -C "vagrant@vagrantup" -f /home/vagrant/.ssh/vagrant_rsa -P ''
echo ""
echo "====================VAGRANT PUBLIC SSH===================="
cat /home/vagrant/.ssh/vagrant_rsa.pub
echo "=========================================================="

echo "Configuring Laravel ..."
rm -f $SITE_DIR/app/config/app.php;
ln -s $VAGRANT_DATA_DIR/laravel/app.php $SITE_DIR/app/config/app.php # use laravel config from vagrant data dir.
rm -f $SITE_DIR/app/config/database.php;
ln -s $VAGRANT_DATA_DIR/laravel/database.php $SITE_DIR/app/config/database.php # use laravel config from vagrant data dir.
rm -f $SITE_DIR/app/config/session.php;
ln -s $VAGRANT_DATA_DIR/laravel/session.php $SITE_DIR/app/config/session.php # use laravel config from vagrant data dir.

#echo "Configuring nginx ..."
#rm -f /etc/nginx/nginx.conf
#ln -s $VAGRANT_DATA_DIR/nginx/nginx.conf /etc/nginx/nginx.conf

#rm -rf /etc/nginx/sites-enabled
#mkdir /etc/nginx/sites-enabled
#ln -s $VAGRANT_DATA_DIR/nginx/generic.local /etc/nginx/sites-enabled/generic.local

mv /etc/nginx /etc/nginx-orig
ln -s $VAGRANT_DATA_DIR/nginx/server-configs-nginx-master /etc/nginx
ln -s /etc/nginx/sites-available/generic.local /etc/nginx/sites-enabled/generic.local
mkdir -p /usr/share/nginx/logs # nginx requires this folder to place a "static.log" file in...

rm -f /etc/php-fpm.d/www.conf
ln -s $VAGRANT_DATA_DIR/php/www.conf /etc/php-fpm.d/www.conf

# Disabling the development firewall (commented bc iptables not installed by default on this box)
systemctl stop firewalld.service
################Figure out how to turn this off on system restart!!!!
#service iptables stop
#chkconfig iptables off
#chkconfig iptables --del

# Reload services
service nginx restart
service php-fpm restart
service postgresql restart

# Build DB structure via artisan migrations
php /var/www/html/generic.local/artisan migrate

echo "Server provisioning complete!"