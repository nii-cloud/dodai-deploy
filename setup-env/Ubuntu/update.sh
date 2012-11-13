#!/bin/bash

# confirm to update
echo -n "The contents of db will be reset. Do you really want to do updating? [Yn]"

read confirm
case $confirm in
  y|Y) ;;
  *) exit 1 ;;
esac

# remove manifests
rm -rf /etc/puppet/modules/*

RAILS_ENV=production rake db:drop
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake dodai:softwares:load_all proxy_server="$http_proxy" 
RAILS_ENV=production rake tmp:clear
RAILS_ENV=production rake log:clear

rake db:drop
rake db:migrate
rake dodai:softwares:load_all proxy_server="$http_proxy"
rake tmp:clear
rake log:clear
