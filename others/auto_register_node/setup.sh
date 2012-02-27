#!/bin/bash

home_dir=`dirname $0`
target_dir=$1
type=$2
host_name=`cat $target_dir/etc/hostname`

cd $home_dir

# copy agent to mcolective
cp node.rb $target_dir/usr/share/mcollective/plugins/mcollective/agent/

# modify settings
sed -i -e "s/HOST/$host_name/" $target_dir/etc/mcollective/server.cfg
sed -i -e "s/HOST/$host_name/" $target_dir/etc/mcollective/client.cfg
sed -i -e "s/HOST/$host_name/" $target_dir/etc/mcollective/facts.yaml

if [ $type = "server" ]; then
  # add to cron
  cp server_info_sender.rb $target_dir/usr/local/sbin/
  # echo "*/1 * * * *  root ruby /usr/local/sbin/server_info_sender.rb $network >> /var/log/server_info_sender.log 2>&1" > $target_dir/etc/cron.d/server_info_sender

  cp node_info_collector.rb $target_dir/usr/local/sbin/
  # echo "*/1 * * * *  root ruby /usr/local/sbin/node_info_collector.rb $network >> /var/log/node_info_collector.log 2>&1" > $target_dir/etc/cron.d/node_info_collector

  echo '/usr/local/src/dodai-deploy/script/start-servers production 80' >> $target_dir/etc/dodai/init.sh
fi

cp utils.rb $target_dir/usr/local/sbin/
cp server_info_listener.rb $target_dir/usr/local/sbin/
cp server_info_listener.conf $target_dir/etc/init/
