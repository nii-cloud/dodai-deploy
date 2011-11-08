/*
 * Copyright 2011 National Institute of Informatics.
 *
 *
 *    Licensed under the Apache License, Version 2.0 (the "License"); you may
 *    not use this file except in compliance with the License. You may obtain
 *    a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 *    License for the specific language governing permissions and limitations
 *    under the License.
 */

$nova_templates_dir = "$proposal_id"
$nova_files_rel_dir = "files/nova"
$image_file_name = "image_kvm.tgz"

define nova_component() {
    include nova_common::install

    package {
        "$title":
            ensure => present,
            require => Package["python-nova"],
            notify => File["/etc/nova/nova.conf"]
    }
}

class nova_common::install {
    package {
        ["python-mysqldb", "python-nova", "python-eventlet", "python-novaclient"]:
            ensure => present;

        "nova-common":
            ensure => present,
            require => Package["python-novaclient"]
    }

    file {
        "/etc/nova/nova.conf":
            content => template("$nova_templates_dir/etc/nova/nova.conf.erb"),
            mode => 644,
            require => Package["nova-common"];

        "/tmp/nova":
            ensure => directory,
            mode => 644;

        "/tmp/nova/sudo-init.sh":
            source => "puppet:///files/nova/sudo-init.sh",
            alias => "sudo-init",
            require => File["/tmp/nova"]; 
    }

    exec {
        "/tmp/nova/sudo-init.sh 2>&1":
            refreshonly => true,
            subscribe => File["sudo-init"];
    }
}

class nova_common::uninstall {
    exec {
        "rm -rf /tmp/nova":
            alias => "remove-tmp-nova";

        "/tmp/nova/sudo-uninit.sh":
            refreshonly => true,
            notify => Exec["remove-tmp-nova"],
            subscribe => File["sudo-uninit"]
    }

    package {
        ["python-nova", "nova-common"]:
           ensure => purged 
    }

    file {
        "/tmp/nova/sudo-uninit.sh":
            source => "puppet:///files/nova/sudo-uninit.sh",
            alias => "sudo-uninit"
    }
}

class nova_common::test {
    file {
        "/tmp/nova":
            ensure => directory,
            mode => 644
    }
}

class bridge {
    package {
        "bridge-utils":
            ensure => present;
    }
}

class rabbitmq::install {
    service {
        "rabbitmq-server":
            ensure => stopped;
    }

    package {
        "rabbitmq-server":
            ensure => present,
            require => Service["rabbitmq-server"];
    }
}

class rabbitmq::uninstall {
    package {
        "rabbitmq-server":
            ensure => purged;
    }
}

class nova_api::install {
    nova_component { 
        ["nova-api", "python-libvirt", euca2ools, unzip, gawk]:
    }
}

class nova_api::uninstall {
    include nova_common::uninstall

    package {
        ["nova-api, python-libvirt", euca2ools]:
            ensure => purged
    }
}

class nova_api::test {
    include nova_common::test

    file {
        "/tmp/nova/test.sh":
            alias => "test.sh",
            source => "puppet:///$nova_files_rel_dir/test.sh",
            require => File["/tmp/nova"];
    }

    exec {
        "/tmp/nova/test.sh $image_file_name 2>&1":
            alias => "test.sh",
            require => File["test.sh", "$image_file_name"];
    }

    file {
        "/tmp/nova/$image_file_name":
            alias => "$image_file_name",
            source => "puppet:///$nova_files_rel_dir/$image_file_name",
            require => File["/tmp/nova"];
    }
}

class nova_objectstore::install {
    nova_component { 
        "nova-objectstore": 
    }
}

class nova_objectstore::uninstall {
    include nova_common::uninstall

    package {
        "nova-objectstore":
            ensure => purged
    }
}


class nova_volume::install {
    nova_component {
        "nova-volume":
    }

    file {
        "/etc/default/iscsitarget":
            source => "puppet:///$nova_files_rel_dir/iscsitarget",
            mode => 644,
            require => Package["nova-volume"]
    }

    service {
        "iscsitarget":
            ensure => running,
            require => File["/etc/default/iscsitarget"]
    }

}

class nova_volume::uninstall {
    include nova_common::uninstall

    package {
        "nova-volume":
            ensure => purged
    }
}


class nova_compute::install {
    nova_component { 
        ["nova-compute", "vlan"]:
    }

    case $libvirt_type {
        kvm: {include kvm}
        xen: {include xen}
        uml: {include uml}
        lxc: {include lxc}
    }

    include bridge

    file {
        "/etc/nova/nova-compute.conf":
            content => template("$nova_templates_dir/etc/nova/nova-compute.conf.erb"),
            mode => 644,
            require => Package["nova-compute"];
    }
}

class nova_compute::uninstall {
    include nova_common::uninstall

    package {
        ["nova-compute", "libvirt-bin"]:
            ensure => purged
    }

    file {
        "/tmp/nova/nova-compute-uninit.sh":
            alias => "nova-compute-uninit.sh",
            source => "puppet:///$nova_files_rel_dir/nova-compute-uninit.sh"
    }

    exec {
        "/tmp/nova/nova-compute-uninit.sh 2>&1":
            alias => "nova-compute-uninit.sh",
            require => File["nova-compute-uninit.sh"],
            notify => Exec["remove-tmp-nova"];

        "rm -rf /etc/libvirt/*; exit 0":
            require => Package["libvirt-bin"]
    }
}


class kvm {
    package {
       "kvm":
            ensure => present
    }
}

class xen {
}

class uml {
    package {
       "user-mode-linux":
            ensure => present
    }
}

class lxc {
    package {
       "lxc":
            ensure => present
    }
}

class nova_scheduler::install {
    nova_component { 
        "nova-scheduler": 
    }
}

class nova_scheduler::uninstall {
    include nova_common::uninstall

    package {
        "nova-scheduler":
            ensure => purged
    }
}

class nova_network::install {
    nova_component { 
        "nova-network":
    }

    package {
        ["radvd", "dnsmasq", "iptables"]:
            ensure => present
    }

    service {
        dnsmasq:
            ensure => stopped,
            require => Package[dnsmasq]
    }

    include bridge

    exec {
        "stop nova-network; start nova-network":
            require => [Package["nova-network", iptables, radvd, "bridge-utils"], Service[dnsmasq]]
    }
}

class nova_network::uninstall {
    include nova_common::uninstall

    package {
        ["nova-network", dnsmasq]:
            ensure => purged
    }

    exec {
        "killall dnsmasq; exit 0":
            require => Package[dnsmasq]
    }
}

class mysql::install {
    include nova_common::install

    file { 
        "/tmp/nova/mysql-preseed.sh":
            alias => "mysql-preseed.sh",
            source => "puppet:///$nova_files_rel_dir/mysql-preseed.sh",
            require => File["/tmp/nova"];
        "/tmp/nova/mysql-init.sh":
            alias => "mysql-init.sh",
            source => "puppet:///$nova_files_rel_dir/mysql-init.sh",
            require => File["/tmp/nova"];
    }
    exec { 
        "/tmp/nova/mysql-preseed.sh 2>&1":
            alias => "mysql-preseed.sh",
            require => File["mysql-preseed.sh"];
        "/tmp/nova/mysql-init.sh $network_ip_range 2>&1":
            alias => "mysql-init.sh",
            require => [Package["mysql-server", "nova-common"], File["mysql-init.sh", "/etc/nova/nova.conf"], Service["mysql"]]
    }
    package { 
        "mysql-server":
            ensure => present,
            require => Exec["mysql-preseed.sh"],
            notify => [Service["mysql"], File["/etc/nova/nova.conf"]]
    }
    service {
        "mysql":
            ensure => running
    }
}

class mysql::uninstall {
    include nova_common::uninstall

    file {
        "/tmp/nova/mysql-uninit.sh":
            alias => "mysql-uninit.sh",
            source => "puppet:///$nova_files_rel_dir/mysql-uninit.sh"
    }

    exec {
        "/tmp/nova/mysql-uninit.sh 2>&1":
            alias => "mysql-uninit.sh",
            require => File["mysql-uninit.sh"],
            notify => Exec["remove-tmp-nova"];
    }

    service {
        "mysql":
            ensure => stopped,
            require => Exec["mysql-uninit.sh"]
    }

    package {
        "mysql-server":
            ensure => purged,
            require => Service["mysql"]
    }    
}
