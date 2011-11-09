Welcome to the **Dodai project**

## Introduction
The dodai is a software management tool. Now the tool supports openstack diablo(nova, glance, swift) and hadoop 0.20.2.

## Features
* Manage installation, uninstallation and testing of a software.
* Support openstack diablo and hadoop 0.20.2
* Support target machines in different network segments.
* Provide web UI to facilitate user operations.
* Provide rest API to make integration to other tools possible.
* Support parallel installation of components of a software.

## Glossary
**Deployment server**
The server where dodai is installed.

**Node**
The machine which will be the target to install on.

**Software**
Nova, glance, swift and etc.

**Component**
The part of software, such as nova-compute, swift-proxy.

**Proposal**
The definition of the software configurations.

**Node config**
The configuration which defines component will be installed on a node.

**Config item**
The variable which can be used in the content of software config and component config.

**Software config**
The configuration which defines content of a configuration file and will be applied to all the components of a software, such as nova.conf.

**Component config**
The configuration which defines content of a configuration file and will be applied to only a component, such as proxy-server.conf.

## Installation

The "$home" in the following sections is the path of the home directory of the dodai.

### OSes supported
The following OSes are supported.

* ubuntu 10.10
* ubuntu 11.04
* ubuntu 11.10

### Download dodai 
Execute the following commands on deployment server and all the nodes.

    sudo apt-get install git -y
    git clone https://github.com/nii-cloud/dodai.git
    cd dodai; git checkout 1.0   #only used to get dodai 1.0

### Set up deployment server
Execute the following commands on deployment server to install necessary softwares and modify settings of them.

    sudo $home/setup-env/setup.sh server

### Set up nodes

Execute the following commands on all the nodes to install necessary softwares and modify settings of them.

    sudo $home/setup-env/setup.sh node $server

The $server in the above command is the host name(fqdn) of the deployment server. You can confirm the host name(fqdn) with the following command.

    sudo hostname -f

### Set up storage device for swift
If swift will be installed, it is necessary to set up storage device before the installation. You should execute the commands ___for physical device___ or ___for loopback device___ on all the nodes where swift storage server will be installed.

___For physical device___

Use the following command when the device is a physical device.

    sudo $home/setup-env/setup-storage-for-swift.sh physical $storage_path $storage_dev

For example,

    sudo $home/setup-env/setup-storage-for-swift.sh physical /srv/node sdb1

___For loopback device___

Use the following command when the device is a loopback device.

    sudo $home/setup-env/setup-storage-for-swift.sh loopback $storage_path $storage_dev $size

For example,

    sudo $home/setup-env/setup-storage-for-swift.sh loopback /srv/node sdb1 4

### Start servers
Execute the following command on the deployment server to start the web server and job server.

    sudo $home/script/start-servers production

### Stop servers
Execute the following command on the deployment server to stop the web server and job server.

    sudo $home/script/stop-servers

## Using web UI
In the page http://$deployment_server:3000/, you can find guidance and do step by step.

## Using rest API
In the page http://$deployment_server:3000/rest_apis/index.html, you can find a rest api simulator. With it, you can know the definitions of APIs. Moreover, you can execute APIs by just filling parameters and clicking "Execute" button.

## Notes

### Cannot use swift as the store of glance

Due to the following bug, swift can't be used as the store of glance. 

https://bugs.launchpad.net/glance/+bug/862664

### SSH login nova instance after the testing of nova

During the testing of nova, an instance will be started. After the test, you can login the instance by executing the following commands.

    sudo -i
    cd /tmp/nova
    . env/novarc
    euca-describe-instances
    ssh -i mykey.priv 10.0.0.3

### Nova depends on glance in default settings.

Because in /etc/nova/nova.conf the value of setting "image_service" is "nova.image.glance.GlanceImageService", glance should be installed before using nova.
