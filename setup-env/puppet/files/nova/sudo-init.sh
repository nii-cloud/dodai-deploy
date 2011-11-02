#!/bin/bash

grep nova /etc/sudoers
if [ $? = 0 ]; then
  exit 0 
fi

echo "nova  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
