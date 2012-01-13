#!/bin/bash

home=`dirname $0`
cd $home

tar xzvf osdb.tgz
cd osdb
sh run_tests.sh
