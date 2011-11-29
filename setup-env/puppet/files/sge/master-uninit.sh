#!/bin/bash

if type -P qconf
then
  #shutdown all execd daemons
  qconf -ke all

  #shutdown qmaster daemon
  qconf -km
fi
