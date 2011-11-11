Welcome to the **Dodai project**

## Introduction
The Dodai is a software management tool. It supports OpenStack Diablo(Nova, Glance, Swift) and hadoop 0.20.2.

## Features
* Manage installation, uninstallation and testing of a software.
* Support OpenStack Diablo and hadoop 0.20.2
* Support target machines in different network segments.
* Provide web UI to facilitate user operations.
* Provide REST API to make it possible to integrate it with other tools.
* Support parallel installation of software components.

## Glossary
**Deployment server**
The server in which Dodai is installed.

**Node**
The machine that is the target of installation.

**Software**
Nova, Glance, Swift etc.

**Component**
Part of software, such as nova-compute or swift-proxy.

**Proposal**
The set of the kinds of configurations which describe how to install a software. The configurations include "Node config", "Config item", "Software config", "Component config".

**Node config**
A configuration that describes which component to be installed on a node.

**Config item**
A variable which can be used in the content of software config and component config.

**Software config**
A configuration that describes the content of a configuration file for all components.

**Component config**
A configuration that describes the content of a configuration file for only one component.

## Installation

The "$home" in the following sections is the path of the home directory of the dodai.

### OSes supported
The following OSes are supported.

* ubuntu 10.10
* ubuntu 11.04
* ubuntu 11.10

### Download dodai 
Execute the following commands on the deployment server and all the nodes.

    sudo apt-get install git -y
    git clone https://github.com/nii-cloud/dodai.git
    cd dodai; git checkout 1.0   #only used to get dodai 1.0

### Set up the deployment server
Execute the following commands on deployment server to install necessary softwares and modify their settings.

    sudo $home/setup-env/setup.sh server

### Set up nodes

Execute the following commands on all the nodes to install necessary softwares and modify their settings.

    sudo $home/setup-env/setup.sh node $server

The $server in the above command is the fqdn of the deployment server. You can confirm the fqdn with the following command.

    sudo hostname -f

### Set up storage device for Swift
It is necessary to set up a storage device before swift is installed. You should execute the commands ___for a physical device___ or ___for a loopback device___ on all nodes in which swift storage server is to be installed.

___For a physical device___

Use the following command when the device is a physical device.

    sudo $home/setup-env/setup-storage-for-swift.sh physical $storage_path $storage_dev

For example,

    sudo $home/setup-env/setup-storage-for-swift.sh physical /srv/node sdb1

___For a loopback device___

Use the following command when the device is a loopback device.

    sudo $home/setup-env/setup-storage-for-swift.sh loopback $storage_path $storage_dev $size

For example,

    sudo $home/setup-env/setup-storage-for-swift.sh loopback /srv/node sdb1 4

### Start servers
Execute the following command on the deployment server to start the web server and job server.

    sudo $home/script/start-servers production

BTW, You can stop the web server and job server with the following command.

    sudo $home/script/stop-servers

## Using web UI
You can find step-by-step guidance at http://$deployment_server:3000/rest_apis/index.html.

## Using REST APIs
An API simulator can be found at http://$deployment_server:3000/rest_apis/index.html. You can get the list of  REST APIs with it. Moreover, you can execute APIs by simply filling in parameters and clicking the "Execute" button.

## Notes

### Cannot use swift as the image store of glance

Swift cannot be used as the image store of glance because of the following bug. 
https://bugs.launchpad.net/glance/+bug/862664

### SSH login nova instance after test of nova
An instance will be started during the test of nova. After the test, you can login the instance by executing the following commands.

    sudo -i
    cd /tmp/nova
    . env/novarc
    euca-describe-instances
    ssh -i mykey.priv 10.0.0.3

### Nova depends on glance in default settings.

Because in /etc/nova/nova.conf the value of setting "image_service" is "nova.image.glance.GlanceImageService", glance should be installed before using nova.
