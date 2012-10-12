#!/bin/bash

if [ ! -e "/etc/puppet/modules/apt" ]; then
  git clone https://github.com/camptocamp/puppet-apt /etc/puppet/modules/apt
fi

