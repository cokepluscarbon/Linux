#!/bin/sh
# https://www.howtoforge.com/how-to-install-opencart-on-debian-10/
echo -n "Opencart installation, please enter your hostname:"
read hostname
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx mariadb-server php-common php-cli php-fpm php-opcache php-gd php-mysql php-curl php-intl php-xsl php-mbstring php-zip php-bcmath php-soap unzip git -y

sudo wet https://github.com/opencart/opencart/releases/download/3.0.3.6/opencart-3.0.3.6.zip
sudo unzip opencart-3.0.3.6.zip
sudo mv upload /var/www/html/$hostname

sudo cd /var/www/html/$hostname
sudo mv config-dist.php config.php
sudo mv admin/config-dist.php admin/config.php

sudo chown -R www-data:www-data /var/www/html/$hostname/
sudo chmod -R 775 /var/www/html/$hostname/

cd ~
sudo wget https://raw.githubusercontent.com/cokepluscarbon/Web/master/opencart-nginx.conf
sudo sed -i "s/opencart/$hostname/g" opencart-nginx.conf
sudo mv opencart-nginx.conf /etc/nginx/sites-available/$hostname-nginx.conf
sudo ln -s /etc/nginx/sites-available/$hostname.conf /etc/nginx/sites-enabled/

sudo systemctl restart nginx
sudo systemctl restart php7.4-fpm

sudo snap install --classic certbot
sudo certbot --nginx --redirect --agree-tos -m 123@gmail.com -n -d $hostname

sudo (crontab -l 2>/dev/null; echo "0 4 */30 * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew") | crontab -
