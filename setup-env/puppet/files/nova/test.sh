#!/bin/bash

#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

HOME="/tmp/nova"

cd $HOME

if [ "`which nova-manage`" = ""  ]; then
    echo "Command nova-manage doesn't exist."
    exit 1
fi

nova-manage user admin anne
nova-manage project create IRT anne

rm nova.zip
nova-manage project zipfile IRT anne

rm -rf env
unzip -d env/ nova.zip
. env/novarc

euca-authorize -P icmp -t -1:-1 default
euca-authorize -P tcp -p 22 default

apt-get install cloud-utils -y

image_file="$1"
if [ ! -e "$HOME/$image_file" ]; then
  image_file="image_kvm.tgz"
fi
echo "$HOME/$image_file"

tar xzvf $image_file
euca-bundle-image -i *-vmlinuz -p kernel --kernel true
euca-upload-bundle -m /tmp/kernel.manifest.xml -b mybucket
kernel=`euca-register mybucket/kernel.manifest.xml | gawk '{print $2}'`

euca-bundle-image -i *-initrd -p ramdisk --ramdisk true
euca-upload-bundle -m /tmp/ramdisk.manifest.xml -b mybucket
ramdisk=`euca-register mybucket/ramdisk.manifest.xml | gawk '{print $2}'`

euca-bundle-image -i *img -p image --ramdisk $ramdisk --kernel $kernel
euca-upload-bundle -m /tmp/image.manifest.xml -b mybucket
image=`euca-register mybucket/image.manifest.xml | gawk '{print $2}'`

if [ $? != 0 ]; then
   echo $output
   echo "Failed to add image."
   exit 1
fi

sleep 60

echo "image: [$image]"

euca-add-keypair mykey > mykey.priv
chmod 400 mykey.priv

echo "euca-run-instances $image -k mykey -t m1.tiny" 
euca-run-instances $image -k mykey -t m1.tiny
if [ $? -ne 0 ]; then
    echo "Executing command euca-run-instances failed."
    exit 1
fi

# if the status doesn't become lauching after 12 * 10 seconds, running instance will be failed.
launching_time=12
instance_status=`euca-describe-instances | grep "INSTANCE" | gawk '{print $6}'`
if [ $instance_status = "(IRT," ]; then
    instance_status=`euca-describe-instances | grep "INSTANCE" | gawk '{print $4}'`
fi
echo "Instance status: $instance_status"
while [ "$instance_status" != "running" ]
do
    echo "Instance status: $instance_status"
    if [ "$instance_status" != "launching" ] && [ $launching_time -lt 0 ]; then
        echo "Running instance failed because the instance status wasn't \"launching\" after 120 seconds."
        exit 1
    fi

    launching_time=`expr $launching_time - 1`
    sleep 10

    instance_status=`euca-describe-instances | grep "INSTANCE" | gawk '{print $6}'`
    if [ "$instance_status" = "(IRT," ]; then
        instance_status=`euca-describe-instances | grep "INSTANCE" | gawk '{print $4}'`
    fi
    echo "Instance status: $instance_status"
done

echo "Test finished. It is OK."
