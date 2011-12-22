#!/bin/bash

cd `dirname $0`
home_path=`pwd`

function install {
  target=$1
  echo "-----------------Begin to install $target-----------------------"
  install_$target
  echo "-----------------Finished---------------------------------------"
  echo ""
}

function install_ruby_rubygems {
  apt-get -y install ruby rubygems
}

function install_activemq_server {
  apt-get -y install openjdk-6-jre

  activemq="apache-activemq-5.4.3"
  wget "http://ftp.riken.jp/net/apache//activemq/apache-activemq/5.4.3/$activemq-bin.tar.gz"
  tar xzvf $activemq-bin.tar.gz > /dev/null
  rm $activemq-bin.tar.gz
  mv $activemq /opt/
  cp activemq/activemq.xml /opt/$activemq/conf/

  ln -sf /opt/$activemq/bin/activemq /etc/init.d/

  service activemq start
  sysv-rc-conf activemq on
}

function install_mcollective_client {
  wget "http://downloads.puppetlabs.com/mcollective/mcollective-common_1.3.1-19_all.deb"
  wget "http://downloads.puppetlabs.com/mcollective/mcollective-client_1.3.1-19_all.deb"
  dpkg -i mcollective*.deb
  rm -f mcollective*.deb

  gem install stomp -v 1.1.10 

  cp mcollective/client.cfg /etc/mcollective/
  host=`hostname -f`
  sed -i -e "s/HOST/$host/g" /etc/mcollective/client.cfg
  sed -i -e "s/IDENTITY/$host/g" /etc/mcollective/client.cfg
}

function install_puppet_server {
  apt-get -y install puppetmaster

  cp -r puppet/* /etc/puppet/

  for software in `ls ../softwares/`
  do
    mkdir -p /etc/puppet/modules/$software
    cp -r ../softwares/$software/puppet/* /etc/puppet/modules/$software/
  done

  if [ "$port" = "" ]; then
    port=3000
  fi
  sed -i -e "s/PORT/$port/g" /etc/puppet/external_nodes.rb

  #download kvm image
  target_file="/etc/puppet/modules/nova/files/image_kvm.tgz"
  if [ ! -e $target_file ]; then
    image="ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz"
    wget http://smoser.brickies.net/ubuntu/ttylinux-uec/$image
    mv $image $target_file 
  fi

  version="0.20.2"
  target_file="/etc/puppet/modules/hadoop/files/hadoop-$version.tar.gz"
  if [ ! -e $target_file ]; then
    wget http://ftp.jaist.ac.jp/pub/apache//hadoop/common/hadoop-$version/hadoop-$version.tar.gz
    mv hadoop-$version.tar.gz $target_file
  fi

  service puppetmaster stop
  sleep 5
  service puppetmaster start
}

function install_deployment_app {
  cd ..

  gem_dir=`gem environment gemdir`

  lsb_release -r | grep 10.04
  if [ $? = 0 ]; then
    gem install rubygems-update
    $gem_dir/bin/update_rubygems
    gem_dir=`gem environment gemdir`
  fi

  gem install bundle
  cp $gem_dir/bin/bundle /usr/bin/

  apt-get -y install ruby-dev libsqlite3-dev
  bundle install

  lsb_release -r | grep 11.10
  if [ $? = 0  ]; then
    echo "Change /var/lib/gems/1.8/specifications/json-1.6.1.gemspec date format for ubuntu 11.10"
    sed -i -e 's/ 00:00:00.000000000Z//g' /var/lib/gems/1.8/specifications/json-1.6.1.gemspec

    echo "Change /var/lib/gems/1.8/specifications/jquery-rails-1.0.19.gemspec date format for ubuntu 11.10"
    sed -i -e 's/ 00:00:00.000000000Z//g' /var/lib/gems/1.8/specifications/jquery-rails-1.0.19.gemspec
    bundle install
  fi

  cp $gem_dir/bin/rails /usr/bin/
  cp $gem_dir/bin/rake /usr/bin/

  RAILS_ENV=production rake db:drop
  RAILS_ENV=production rake db:migrate
  RAILS_ENV=production rake dodai:softwares:load_all 
  RAILS_ENV=production rake tmp:clear
  RAILS_ENV=production rake log:clear

  rake db:drop
  rake db:migrate
  rake dodai:softwares:load_all 
  rake tmp:clear
  rake log:clear

  # install puppet vim addon.
  apt-get install vim-puppet -y
  vim-addons install puppet -w 

  cd $home_path 
}

function install_mcollective_server {
  wget "http://downloads.puppetlabs.com/mcollective/mcollective-common_1.3.1-19_all.deb"
  wget "http://downloads.puppetlabs.com/mcollective/mcollective_1.3.1-19_all.deb"
  dpkg -i mcollective*.deb
  rm -f mcollective*.deb

  gem install stomp -v 1.1.10

  hostname=`hostname -f`

  cp mcollective/server.cfg /etc/mcollective/
  sed -i -e "s/HOST/$server/g" /etc/mcollective/server.cfg
  sed -i -e "s/IDENTITY/$hostname/g" /etc/mcollective/server.cfg

  #add puppet agent
  cp mcollective/agent/* /usr/share/mcollective/plugins/mcollective/agent/

  #add hostname fact
  echo "hostname: $hostname" >> /etc/mcollective/facts.yaml

  service mcollective restart

  sysv-rc-conf mcollective on
}

function install_puppet_client {
  apt-get -y install puppet

  #rm ec2 facter
  rm -f /usr/lib/ruby/1.8/facter/ec2.rb
}

function install_openstack_repository {
  lsb_release -r | grep 11.10
  if [ $? != 0  ]; then
    apt-get -y install python-software-properties
    add-apt-repository ppa:openstack-release/2011.3
    apt-get update 
  fi
}

function install_sge_repository {
  apt-get -y install python-software-properties
  add-apt-repository "deb http://archive.canonical.com/ lucid partner"

  apt-get update
}

function install_memcached {
  apt-get -y install memcached
}

function pre_install {
  apt-get update
  apt-get install sysv-rc-conf -y
}

function install_server {
  pre_install

  soft="$1"
  if [ "$soft" != "" ]; then
    install $soft
    return
  fi

  for soft in ${server_softwares[@]} ; do
    install $soft
  done 
}

function install_node {
  pre_install

  soft="$1"
  if [ "$soft" != "" ]; then
    install $soft
    return
  fi

  for soft in ${node_softwares[@]} ; do
    install $soft
  done
}

function print_usage {
  name=`basename $0`
  echo "Usage: $name [OPTIONS] TYPE [SOFTWARE]

TYPE:
  The type of deploy host. It is server or node.

OPTIONS:
  -s: The fqdn of deploy server. It should be specified if the TYPE is node.
  -p: The port number of the rails server on deploy server. It will be used only if the TYPE is server and SOFTWARE is puppet_server.

SOFTWARE:
  The name of the software which will be installed.

  For server, the following softwares can be specified.
    ${server_softwares[*]}
  For node, the following softwares can be specified.
    ${node_softwares[*]}

For examples,
  $name server
  $name server puppet_server
  $name -p 80 server
  $name -s ubuntu node
  $name -s ubuntu node mcollective_server
"
}

server_softwares=(ruby_rubygems activemq_server mcollective_client puppet_server memcached deployment_app)
node_softwares=(ruby_rubygems mcollective_server puppet_client openstack_repository sge_repository)

while getopts "s:p:": opt
do
  case $opt in
    \?) OPT_ERROR=1; break;;
    s) server="$OPTARG";;
    p) port="$OPTARG";;
  esac
done

if [ $OPT_ERROR ]; then      # option error
  echo >&2 
  print_usage
  exit 1
fi
shift $(( $OPTIND - 1 ))

type=$1
if [ "$type" = "server" ]; then
  install_server "$2"
elif [ "$type" = "node" ]; then
  if [ "$server" = ""  ]; then
    echo "Please specify the fqdn of deploy server."
    print_usage
    exit 1
  fi
  install_node "$2"
else
  echo "Please specify the TYPE. It should be server or node."
  print_usage
  exit 1
fi
