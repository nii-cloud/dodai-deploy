#!/bin/bash

openstack-db --drop --service nova -r nova 
openstack-db --drop --service cinder -r nova

mysql -uroot -pnova -e "drop database if exists dash;"
mysql -uroot -pnova -e "DELETE FROM mysql.user WHERE user='dash';"

mysql -uroot -pnova -e "drop database if exists quantum;"
mysql -uroot -pnova -e "drop database if exists quantum_linux_bridge;"
mysql -uroot -pnova -e "DELETE FROM mysql.user WHERE user='quantum';"
