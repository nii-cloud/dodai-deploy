#!/bin/bash

echo "create quantum db"
mysql -uroot -pnova -e "drop database if exists quantum;"

mysql -uroot -pnova -e "create database quantum;"
mysql -uroot -pnova -e " GRANT ALL ON quantum.* TO 'quantum'@'%' IDENTIFIED BY 'quantum';"
mysql -uroot -pnova -e "GRANT ALL ON quantum.* TO 'quantum'@localhost IDENTIFIED BY 'quantum';"

mysql -uroot -pnova -e "create database quantum_linux_bridge;"
mysql -uroot -pnova -e " GRANT ALL ON quantum_linux_bridge.* TO 'quantum'@'%' IDENTIFIED BY 'quantum';"
mysql -uroot -pnova -e "GRANT ALL ON quantum_linux_bridge.* TO 'quantum'@localhost IDENTIFIED BY 'quantum';"

