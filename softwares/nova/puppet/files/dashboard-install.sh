#!/bin/bash

home=`dirname $0`
cd $home

bzr branch lp:horizon/diablo -r 46 osdb
cd osdb
sh run_tests.sh
