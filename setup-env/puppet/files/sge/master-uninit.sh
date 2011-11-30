#!/bin/bash

if which qconf
then
  #shutdown all execd daemons
  qconf -ke all

  #shutdown qmaster daemon
  qconf -km
fi
