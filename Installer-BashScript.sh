#!/bin/bash

CYAN="\e[1;96m"
BLUE="\e[1;94m"
YELLOW="\e[33m"
LYELLOW="\e[93m"
ENDCOLOR="\e[0m"

echo -e "${BLUE}====================[ Web App Installer ]======================${ENDCOLOR}"
echo -e "${CYAN}    An easy-to-use installer for PHP based web application     ${ENDCOLOR}"
echo -e "${BLUE}---------------------------------------------------------------${ENDCOLOR}"
echo -e "${CYAN}          Arka Lilang Wiratma   (21/477428/PA/20661)           ${ENDCOLOR}"
echo -e "${CYAN}          Ihza Surya Pratama    (21/480981/PA/20923)           ${ENDCOLOR}"
echo -e "${CYAN}          Muhammad Nafis Aisy Z (21/477890/PA/20715)           ${ENDCOLOR}"
echo -e "${CYAN}          Septyan Jaya Saputra  (21/474285/PA/20479)           ${ENDCOLOR}"
echo -e "${BLUE}===============================================================${ENDCOLOR}"


echo -e "${CYAN}\n>>>>>>>>>>>>>>> DEPEDENCY PACKAGE INSTALLATION <<<<<<<<<<<<<<${ENDCOLOR}"
echo -e "${BLUE}_______________________________________________________________${ENDCOLOR}"
echo -e "${LYELLOW}\n> Updating to get latest package lists...${ENDCOLOR}${YELLOW}"
sudo apt-get update -y
echo -e "${LYELLOW}\n> Upgrading already installed packages to the latest version...${ENDCOLOR}${YELLOW}"
sudo apt-get upgrade -y
sudo apt-get install software-properties-*
echo -e "${LYELLOW}\n> Installing Apache2 package...${ENDCOLOR}${YELLOW}"
sudo apt-get purge apache2*
sudo apt-get install apache2 -y
sudo ufw allow in "Apache"
sudo ufw allow "Apache Full"
echo -e "${LYELLOW}\n> Installing MySQL package...${ENDCOLOR}${YELLOW}"
sudo systemctl stop mysql
sudo apt-get purge mysql*
sudo rm -r /etc/mysql /var/lib/mysql /var/log/mysql
sudo apt-get install mysql-server mysql-client mysql-common -y
echo -e "${LYELLOW}\n> Installing PHP package...${ENDCOLOR}${YELLOW}"
sudo apt-get purge php*
sudo apt-get install php8.1 php8.1-common libapache2-mod-php8.1 php8.1-mysql -y
sudo a2enmod php8.1

sudo systemctl restart apache2
sudo systemctl restart mysql

echo -e "${CYAN}\n>>>>>>>>>>>>> PREPARING DATABASE & SOURCE CODE <<<<<<<<<<<<<${ENDCOLOR}"
echo -e "${BLUE}_______________________________________________________________${ENDCOLOR}"
echo -e "${LYELLOW}\n> Creating new directory (/var/www/html)...${ENDCOLOR}${YELLOW}"
sudo rm -r -f /var/www/html
sudo mkdir /var/www/html
echo -e "${LYELLOW}\n> Copying web source code from repository (https://github.com/izasoerya/RekamMedis.git)...${ENDCOLOR}${YELLOW}"
git clone https://github.com/izasoerya/RekamMedis.git /var/www/html
echo -e "${LYELLOW}\n> Preparing mySQL...${ENDCOLOR}${YELLOW}"
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin';"
echo -e "${LYELLOW}\n> Creating new database (rekam_medis)... [default-password: admin]${ENDCOLOR}${YELLOW}"
sudo mysql -u root -p -e "DROP DATABASE rekam_medis;"
sudo mysql -u root -p -e "CREATE DATABASE rekam_medis;"
echo -e "${LYELLOW}\n> Importing database (rekam_medis)...${ENDCOLOR}${YELLOW}"
sudo mysql -u root -p rekam_medis < /var/www/html/rekam_medis.sql


echo -e "${CYAN}\n>>>>>>>>>>>>>>>>> STARTING WEB APP SERVICES <<<<<<<<<<<<<<<<<${ENDCOLOR}"
echo -e "${BLUE}_______________________________________________________________${ENDCOLOR}"
echo -e "${LYELLOW}\n> Starting apache2 services...${ENDCOLOR}${YELLOW}"
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl reload apache2
echo -e "${LYELLOW}\n> Starting mysql services...${ENDCOLOR}${YELLOW}"
sudo systemctl stop mysql.service
sudo systemctl start mysql.service
