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
  yum -y remove ruby rubygems
}

function uninstall_activemq_server {
  activemq="apache-activemq-5.4.3"

  #stop activemq-server
  service activemq stop

  rm -rf /opt/$activemq
}

function uninstall_mcollective_client {
  rpm -e mcollective-client
  rpm -e mcollective-common
}

function uninstall_puppet_server {
  service puppetmaster stop

  yum -y remove puppetmaster
  rm -rf /etc/puppet/*
  rm -rf /var/lib/puppet/*
}

function uninstall_deployment_app {
  cd ..

  script/stop-servers
}

function uninstall_mcollective_server {
  service mcollective stop
  rpm -e mcollective 
}

function uninstall_puppet_client {
  yum -y remove puppet
  rm -rf /etc/puppet/*
  rm -rf /var/lib/puppet/*
}

function uninstall_openstack_repository {
  echo ""
}

function uninstall_sge_repository {
  echo ""
}

function uninstall_memcached {
  service memcached stop
  yum -y remove memcached
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
