#!/bin/bash

if ! [ `which cloc` ]; then
  sudo apt-get install cloc -y
fi

cd `dirname $0`
cloc --read-lang-def=cloc.def --exclude-dir=public/javascripts/lib,public/stylesheets/lib,test/fixtures,vendor ../ $@
