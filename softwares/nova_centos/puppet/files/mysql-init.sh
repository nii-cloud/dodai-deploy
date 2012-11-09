#!/bin/bash

#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

#confirm if db nova exists.
pass="nova"
mysqladmin password ${pass}
mysql -uroot -pnova -e "CREATE DATABASE nova;"
mysql -uroot -pnova -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -pnova -e "DELETE FROM mysql.user WHERE user = '';"
mysql -uroot -pnova -e "UPDATE mysql.user SET password=PASSWORD('${pass}') WHERE user='root';"
mysql -uroot -pnova -e "FLUSH PRIVILEGES;"

#echo "create db"
#nova-manage db sync
#
#echo "create network"
#nova-manage network create private $1 1 255

echo "finished"
