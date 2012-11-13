#!/bin/bash
shell_name=$1
shift

if [ "`which apt-get`" != "" ]; then
  apt-get install facter -y
elif [ "`which yum`" != ""  ]; then
  yum install facter -y
else
  echo "The application apt-get or yum doesn't exist. Please check your OS."
  exit 1
fi

os="`facter operatingsystem`"
if [ -d $os ]; then
  $os/$shell_name $@
else
  echo "The OS $os is not supported."
  exit 1 
fi
