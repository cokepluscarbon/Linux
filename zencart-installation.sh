#!/bin/sh
# https://hostadvice.com/how-to/how-to-install-and-configure-zen-cart-on-an-ubuntu-18-04-vps-or-dedicated-server/
echo -n "ZenCart installation, please enter your hostname:"
read hostname
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install tasksel
sudo apt-get install -y software-properties-common

cd ~
sudo wget https://github.com/cokepluscarbon/Linux/raw/master/images/zc-v1.5.7.zip
sudo unzip zc-v1.5.7.zip
sudo mv zen-cart-v1.5.7-06232020 /var/www/html/$hostname

cd ~
sudo wget https://raw.githubusercontent.com/cokepluscarbon/Web/master/opencart-nginx.conf
sudo sed -i "s/opencart/$hostname/g" opencart-nginx.conf
sudo mv opencart-nginx.conf /etc/nginx/sites-available/$hostname-nginx.conf
sudo ln -s /etc/nginx/sites-available/$hostname-nginx.conf /etc/nginx/sites-enabled/

cd /var/www/html/$hostname
sudo mv includes/dist-configure.php includes/configure.php
sudo mv admin/includes/dist-configure.php includes/configure.php

sudo chmod -R 777 /var/www/html/$hostname
sudo chmod 644 /var/www/html/$hostname/includes/configure.php
sudo chmod 644 /var/www/html/$hostname/admin/includes/configure.php

sudo systemctl restart nginx 
sudo systemctl restart php7.4-fpm
