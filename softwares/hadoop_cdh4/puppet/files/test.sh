#!/bin/bash

path=`dirname $0`
cd $path

mkdir inputs
echo "hoge hoge hoge fuga fuga" > inputs/file1
hadoop fs -mkdir inputs
hadoop fs -put inputs/file1 inputs
ret=$?
if [ $ret != 0 ]; then
  echo "Cannot copy folder."
  hadoop fs -rmr inputs
  rm -rf inputs
  exit $ret
fi

hadoop fs -ls
hadoop jar ../hadoop-examples.jar wordcount inputs outputs
ret=$?

#remove folders created
hadoop fs -rmr inputs
hadoop fs -rmr outputs
hadoop fs -ls

rm -rf inputs

exit $ret
