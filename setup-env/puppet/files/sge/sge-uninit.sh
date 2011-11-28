#!/bin/bash

CELL_NAME="default"

if type -P qconf
then
  #shutdown all execd daemons
  qconf -ke all

  #shutdown qmaster daemon
  qconf -km
fi

#remove cell configuration
rm -rf /var/lib/gridengine/$CELL_NAME/
