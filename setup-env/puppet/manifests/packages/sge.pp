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

$sge_templates_dir = "${proposal_id}"
$sge_master_node = "${sge_master_fqdn}"

class sge_common::install {

    file {
        "/tmp/sge":
            ensure => directory,
            mode => 644;
            
        "/tmp/sge/sun-jre-preseed.conf":
            alias => "sun-jre-preseed",
            source => "puppet:///files/sge/sun-jre-preseed.conf";
    }
    
    exec { 
        "update-java-alternatives -s java-6-sun > /dev/null 2>&1; exit 0":
            alias => "alternatives-java",
            require => Package["sun-java6-jre"];
    }

    package { 
        "sun-java6-jre":
            responsefile => "/tmp/sge/sun-jre-preseed.conf",
            require => File["sun-jre-preseed"];
    }
}

class sge_slave::install {
    include sge_common::install

    file {
        "/tmp/sge/slave-preseed.conf":
            alias => "slave-preseed",
            content => template("sge/slave-preseed.conf.erb"),
            require => File["/tmp/sge"];
    }
 
    package {
        ["gridengine-client", "gridengine-exec"]:
            responsefile => "/tmp/sge/slave-preseed.conf",
            require => File["slave-preseed"];
    }
}

class sge_master::install {
    include sge_common::install
  
    file {
        "/tmp/sge/master-preseed.conf":
            alias => "master-preseed",
            content => template("sge/master-preseed.conf.erb"),
            require => File["/tmp/sge"];
 
        "/tmp/sge/master-init.sh":
            alias => "master-init",
            source => "puppet:///files/sge/master-init.sh",
            require => File["/tmp/sge"];
            
        "/tmp/sge/slave-servers":
            alias => "slave-servers",
            content => template("sge/slave-servers.erb");
    }
    
    package {
        ["gridengine-client", "gridengine-common", "gridengine-master", "gridengine-qmon"]:
            responsefile => "/tmp/sge/master-preseed.conf",
            require => [Exec["alternatives-java"], File["master-preseed"]]
    }

    exec {
        "/tmp/sge/master-init.sh 2>&1":
            alias => "master-init",
            require => [Package["gridengine-client", "gridengine-common", "gridengine-master", "gridengine-qmon"], File["slave-servers", "master-init"]];
    }
}

class sge_common::uninstall {

    package {
        ["gridengine-common", "gridengine-client", postfix, "bsd-mailx"]:
            ensure => purged,
            notify => Exec["rm-dir"];
    }
    
    exec {
        "rm -rf /tmp/sge 2>&1":
            alias => "rm-dir";
    }
}

class sge_master::uninstall {
    include sge_common::uninstall

    file {
        "/tmp/sge/master-uninit.sh":
            source => "puppet:///files/sge/master-uninit.sh",
            alias => "master-uninit";
    }

    exec {
        "/tmp/sge/master-uninit.sh 2>&1":
            alias => "master-uninit",
            notify => Package["gridengine-common", "gridengine-client", postfix, "bsd-mailx"],
            require => File["master-uninit"];
    }
}

class sge_slave::uninstall {
    include sge_common::uninstall
}

class sge_master::test {

    file {
        "/tmp/sge/test.sh":
            source => "puppet:///files/sge/test.sh",
            alias => "test";

        "/tmp/sge/test-example.sh":
            source => "puppet:///files/sge/test-example.sh",
            alias => "test-example";
            
        "/tmp/sge/test-queue.cnf":
            source => "puppet:///files/sge/test-queue.cnf",
            alias => "test-queue";
    }

    exec {
        "/tmp/sge/test.sh 2>&1":
            require => File[test, "test-example", "test-queue"];
    }
}
