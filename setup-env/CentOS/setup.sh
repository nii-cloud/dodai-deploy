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
  yum -y install ruby rubygems
}

function install_activemq_server {
  yum -y install java-1.6.0-openjdk wget

  activemq="apache-activemq-5.4.3"
  wget "http://www.us.apache.org/dist/activemq/apache-activemq/5.4.3/$activemq-bin.tar.gz"
  tar xzvf $activemq-bin.tar.gz > /dev/null
  rm $activemq-bin.tar.gz
  mv $activemq /opt/
  cp activemq/activemq.xml /opt/$activemq/conf/

  ln -sf /opt/$activemq/bin/activemq /etc/init.d/

  service activemq start
  chkconfig activemq on
}

function install_mcollective_client {
  yum install rubygem-stomp -y

  rpm -ivh http://downloads.puppetlabs.com/mcollective/mcollective-common-1.3.2-1.el6.noarch.rpm
  rpm -ivh http://downloads.puppetlabs.com/mcollective/mcollective-client-1.3.2-1.el6.noarch.rpm
  rm -f mcollective*.rpm

  cp mcollective/client.cfg /etc/mcollective/
  host=`hostname -f`
  sed -i -e "s/HOST/$host/g" /etc/mcollective/client.cfg
  sed -i -e "s/IDENTITY/$host/g" /etc/mcollective/client.cfg
}

function install_puppet_server {
  yum -y install puppet-server

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

  chkconfig puppetmaster on


  setenforce 0
  sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux
}

function install_deployment_app {
  cd ..

  gem_dir=`gem environment gemdir`

  gem install bundler

  yum -y install gcc make ruby-devel sqlite-devel 
  bundle install

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

  cd $home_path 
}

function install_mcollective_server {
  yum -y install rubygem-stomp

  rpm -ivh http://downloads.puppetlabs.com/mcollective/mcollective-common-1.3.2-1.el6.noarch.rpm
  rpm -ivh http://downloads.puppetlabs.com/mcollective/mcollective-1.3.2-1.el6.noarch.rpm
  rm -f mcollective*.rpm

  hostname=`hostname -f`

  cp mcollective/server.cfg /etc/mcollective/
  sed -i -e "s/HOST/$server/g" /etc/mcollective/server.cfg
  sed -i -e "s/IDENTITY/$hostname/g" /etc/mcollective/server.cfg

  #add puppet agent
  cp mcollective/agent/* /usr/libexec/mcollective/mcollective/agent/

  #add hostname fact
  echo "hostname: $hostname" >> /etc/mcollective/facts.yaml

  os=`facter operatingsystem`
  os_version=`facter operatingsystemrelease`
  echo "os: $os" >> /etc/mcollective/facts.yaml
  echo "os_version: $os_version" >> /etc/mcollective/facts.yaml

  service mcollective restart

  chkconfig mcollective on
}

function install_puppet_client {
  yum -y install puppet

  #rm ec2 facter
  rm -f /usr/lib/ruby/1.8/facter/ec2.rb
}

function install_openstack_repository {
  echo ""
}

function install_sge_repository {
  echo ""
}

function install_memcached {
  yum -y install memcached
  service memcached start
  chkconfig memcached on
}


function install_server {
  wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-5.noarch.rpm
  rpm -ivh epel*.rpm
  rm -f epel*.rpm

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
  wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-5.noarch.rpm
  rpm -ivh epel*.rpm
  rm -f epel*.rpm

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
