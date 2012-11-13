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
  service activemq stop

  rm -rf /opt/$activemq
  rm -f /etc/init.d/activemq
}

function uninstall_mcollective_client {
  dpkg -P mcollective-client
  dpkg -P mcollective-common
}

function uninstall_puppet_server {
  service puppetmaster stop

  sleep 5
  apt-get -y --purge remove puppetmaster puppetmaster-common
  rm -rf /etc/puppet/*
  rm -rf /var/lib/puppet/*
}

function uninstall_deployment_app {
  ../../script/stop-servers
}

function uninstall_mcollective_server {
  service mcollective stop
  dpkg -P mcollective 
}

function uninstall_puppet_client {
  apt-get -y --purge remove puppet puppet-common
  rm -rf /etc/puppet/*
  rm -rf /var/lib/puppet/*
}

function uninstall_openstack_repository {
  rm -f /etc/apt/sources.list.d/openstack-release-2011_3-*

  apt-get update
}

function uninstall_sge_repository {
  rm -f /etc/apt/sources.list.d/ferramroberto-java*
  
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
  echo "Usage: $name [OPTIONS] TYPE

TYPE: 
  The type of deploy host. It is server or node.

OPTIONS
  -x: The http proxy, such as http://proxy.domain:8080.
"
}

server_softwares=(activemq_server mcollective_client puppet_server memcached deployment_app ruby_rubygems)
node_softwares=(mcollective_server puppet_client openstack_repository sge_repository ruby_rubygems)

while getopts "x:": opt
do
  case $opt in
    \?) OPT_ERROR=1; break;;
    x) proxy="$OPTARG";;
  esac
done

if [ $OPT_ERROR ]; then      # option error
  echo >&2
  print_usage
  exit 1
fi
shift $(( $OPTIND - 1 ))

if [ "$proxy" != "" ]; then
  export http_proxy="$proxy"
fi

type=$1
if [ "$type" = "server" ]; then
  uninstall_server "$2"
elif [ "$type" = "node" ]; then
  uninstall_node "$2"
else
  print_usage
fi
