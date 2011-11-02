#!/bin/bash

path=`dirname $0`
cd $path

version="$1"

mkdir inputs
echo "hoge hoge hoge fuga fuga" > inputs/file1
bin/hadoop dfsadmin -safemode leave
bin/hadoop fs -copyFromLocal inputs inputs
ret=$?
if [ $ret != 0 ]; then
  echo "Cannot copy folder."
  rm -rf inputs
  exit $ret
fi

bin/hadoop fs -ls
bin/hadoop jar hadoop-$version-examples.jar wordcount inputs outputs
ret=$?

#remove folders created
bin/hadoop fs -rmr inputs
bin/hadoop fs -rmr outputs
bin/hadoop fs -ls

rm -rf inputs

exit $ret
