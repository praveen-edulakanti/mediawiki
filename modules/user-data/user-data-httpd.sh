#! /bin/bash
sudo dnf update
sudo dnf install httpd
sudo systemctl enable httpd
sudo service httpd restart
hostname | sudo tee /var/www/html/index.html