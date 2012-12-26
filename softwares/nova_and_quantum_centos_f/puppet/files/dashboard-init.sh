#!/bin/bash

echo "create db"
mysql -uroot -pnova -e "drop database if exists dash;"
mysql -uroot -pnova -e "create database dash;"
mysql -uroot -pnova -e " GRANT ALL ON dash.* TO 'dash'@'%' IDENTIFIED BY 'dash';"
mysql -uroot -pnova -e "GRANT ALL ON dash.* TO 'dash'@localhost IDENTIFIED BY 'dash';"

