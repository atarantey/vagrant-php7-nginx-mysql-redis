#!/usr/bin/env bash

# Set timezone
#ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

apt-get update
apt-get install -y curl git unzip

# Install postgres

apt-get install -y postgresql-10
echo "-------------------- creating postgres vagrant role with password vagrant"

sudo su postgres -c "psql -c \"create user \"al_web_user\" with password 'web_pass'\""
sudo su postgres -c "psql -c \"create database aestheticlink\""

sudo su postgres -c "psql -c \"grant all privileges on database aestheticlink to \"al_web_user\"\""
sudo su postgres -c "psql -c \"grant all privileges ON all tables in schema public TO \"al_web_user\"\""

echo "-----------enable external connection"
echo "host all all 192.168.66.1/24 md5" >> /etc/postgresql/10/main/pg_hba.conf

echo "-----------fixing listen_addresses on postgresql.conf"
sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /etc/postgresql/10/main/postgresql.conf
  
/etc/init.d/postgresql restart
# Install php 7.2
apt-get update
apt-get install -y git curl poppler-utils imagemagick php7.2 php7.2-fpm php7.2-bcmath php7.2-bz2 php7.2-cli php7.2-curl php7.2-intl php7.2-json php7.2-mbstring php7.2-opcache php7.2-soap php7.2-sqlite3 php7.2-xml php7.2-xsl php7.2-zip php7.2-pgsql php7.2-xdebug libapache2-mod-php7.2

mkdir -p /vagrant/www/html/tmp/profile

xdebug= `cat <<EOS
xdebug.remote_enable=on
xdebug.remote_log=/var/log/xdebug.log
xdebug.remote_handler=dbgp
xdebug.remote_port=9123
xdebug.collect_params=1
xdebug.remote_connect_back=Off
xdebug.remote_host=192.168.66.1
xdebug.default_enable=1
xdebug.profiler_enable_trigger=1
xdebug.profiler_output_dir=/var/www
xdebug.remote_autostart=1
xdebug.idekey=PHPSTORM
xdebug.show_local_vars=1                           
EOS`

echo $xdebug > /etc/php/7.2/mods-available/xdebug.ini

cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# Install nginx
systemctl disable apache2
systemctl stop apache2
apt-get install -y nginx
mv /home/vagrant/nginx.conf /etc/nginx/nginx.conf
mv /home/vagrant/remedly.conf /etc/nginx/sites-enabled/remedly.conf
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
systemctl enable nginx

# Install Redis
#apt-get -y install redis-server

 Install nodejs, npm, yarn
apt-get install -y nodejs npm
npm cache clean
npm install n -g
#n 8.9
apt-get purge -y nodejs npm
ln -sf /usr/local/bin/node /usr/bin/node
ln -sf /usr/local/bin/npm /usr/bin/npm
npm install -g yarn
