#!/bin/bash

# Update the apt package index
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Start and enable Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# Install PHP and required extensions
sudo apt install -y php-fpm php-mysql

# Adjust PHP-FPM configuration to use Unix socket
sudo sed -i 's/^listen = .*/listen = \/run\/php\/php7.4-fpm.sock/' /etc/php/7.4/fpm/pool.d/www.conf
sudo systemctl restart php7.4-fpm

# Install MySQL Server
sudo apt install -y mysql-server

# Secure MySQL installation (interactive setup)
sudo mysql_secure_installation

# Adjust Nginx configuration to enable PHP processing
sudo sed -i 's/index index.html index.htm index.nginx-debian.html;/index index.php index.html index.htm;/' /etc/nginx/sites-available/default
sudo sed -i '/location ~ \.php$ {/,/}/ s/#//' /etc/nginx/sites-available/default
sudo sed -i '/location ~ \.php$ {/,/}/ s/fastcgi_pass unix:\/run\/php\/php7.4-fpm.sock;/fastcgi_pass unix:\/var\/run\/php\/php7.4-fpm.sock;/' /etc/nginx/sites-available/default
sudo systemctl restart nginx

# Verify installations
echo "Nginx version:"
nginx -v

echo "PHP version:"
php --version

echo "MySQL version:"
mysql --version
