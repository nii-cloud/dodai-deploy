#!/bin/bash

for i in `lvscan | grep 'cinder-volumes' | gawk '{print $2}'`; do lvremove --force ${i//\'/''}; done
