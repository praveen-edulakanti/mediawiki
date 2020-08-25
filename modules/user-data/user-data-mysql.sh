#! /bin/bash
sudo dnf update -y
sudo dnf install mariadb-server -y
sudo systemctl enable mariadb.service
sudo service mysqld restart