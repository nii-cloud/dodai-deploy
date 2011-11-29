#!/bin/bash

cd `dirname $0`
home_path=`pwd`

function uninstall {
  target=$1
  echo "-----------------Begin to uninstall $target-----------------------"
  uninstall_$target
  echo "-----------------Finished---------------------------------------"
  echo ""
}

function uninstall_ruby_rubygems {
  apt-get -y --purge remove ruby rubygems
}

function uninstall_activemq_server {
  activemq="apache-activemq-5.4.3"

  #stop activemq-server
  cd ~/$activemq
  bin/activemq stop

  cd $home_path

  rm -rf ~/$activemq
}

function uninstall_mcollective_client {
  dpkg -P mcollective-client
  dpkg -P mcollective-common
}

function uninstall_puppet_server {
  service puppetmaster stop

  apt-get -y --purge remove puppetmaster
}

function uninstall_deployment_app {
  cd ..

  script/stop-servers
}

function uninstall_mcollective_server {
  service mcollective stop
  dpkg -P mcollective 
}

function uninstall_puppet_client {
  apt-get -y --purge remove puppet
}

function uninstall_openstack_repository {
  rm -f /etc/apt/sources.list.d/openstack-release-2011_3-*

  apt-get update
}

function uninstall_sge_repository {
  sed -i -e "/lucid partner/d" /etc/apt/sources.list 

  apt-get update
}

function uninstall_memcached {
  service memcached stop
  apt-get -y --purge remove memcached
}


function uninstall_server {
  soft="$1"
  if [ "$soft" != "" ]; then
    uninstall $soft
    return
  fi

  for soft in ${server_softwares[@]} ; do
    uninstall $soft
  done 
}

function uninstall_node {
  apt-get update

  soft="$1"
  if [ "$soft" != "" ]; then
    uninstall $soft
    return
  fi

  for soft in ${node_softwares[@]} ; do
    uninstall $soft
  done
}

function print_usage {
  name=`basename $0`
  echo "Usage: $name TYPE

TYPE: server or node
"
}

server_softwares=(activemq_server mcollective_client puppet_server memcached deployment_app ruby_rubygems)
node_softwares=(mcollective_server puppet_client openstack_repository sge_repository ruby_rubygems)

type=$1
if [ "$type" = "server" ]; then
  uninstall_server
elif [ "$type" = "node" ]; then
  uninstall_node
else
  print_usage
fi
