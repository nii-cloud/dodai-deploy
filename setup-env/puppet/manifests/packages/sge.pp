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
$sge_slave_nodes = "${sge_slave}"
$sge_home = "/var/lib/gridengine"

class sge_common::install {

    file {
        "/tmp/sge":
            ensure => directory,
            mode => 644;
            
        "/tmp/sge/sun-jre-preseed.sh":
            alias => "sun-jre-preseed.sh",
            source => "puppet:///files/sge/sun-jre-preseed.sh";

        "/tmp/sge/sge-preseed.sh":
            alias => "sge-preseed.sh",
            source => "puppet:///files/sge/sge-preseed.sh",
            require => File["/tmp/sge"];
    }
    
    exec { 
        "/tmp/sge/sun-jre-preseed.sh 2>&1":
            alias => "sun-jre-preseed.sh",
            require => File["sun-jre-preseed.sh"];
            
        "update-java-alternatives -s java-6-sun > /dev/null; exit 0":
            alias => "alternatives-java",
            require => Package["sun-java6-jre"];

        "/tmp/sge/sge-preseed.sh 2>&1":
            alias => "sge-preseed.sh",
            require => File["sge-preseed.sh"];
    }

    package { 
        "sun-java6-jre":
            require => Exec["sun-jre-preseed.sh"];
    }
}

class sge_slave::install {
    include sge_common::install
  
    package {
        ["gridengine-client", "gridengine-exec"]:
            require => Exec["alternatives-java", "sge-preseed.sh"];
    }
}

class sge_master::install {
    include sge_common::install
  
    file { 
        "/tmp/sge/sge-init.sh":
            alias => "sge-init",
            source => "puppet:///files/sge/sge-init.sh",
            require => File["/tmp/sge"];
            
        "/tmp/sge/sge-slave-servers":
            alias => "sge-slave-servers",
            content => template("/etc/puppet/templates/sge/sge-slave-servers.erb");
    }
    
    package {
        ["gridengine-client", "gridengine-common", "gridengine-master", gridengine-qmon]:
            require => Exec["alternatives-java", "sge-preseed.sh"]
    }

    exec {             
        "/tmp/sge/sge-init.sh 2>&1":
            alias => "sge-init",
            require => [Package["gridengine-client", "gridengine-common", "gridengine-master", gridengine-qmon], File["sge-slave-servers", "sge-init"]];
    }
}

class sge_common::uninstall {

    file {             
        "/tmp/sge/sge-uninit.sh":
            source => "puppet:///files/sge/sge-uninit.sh",
            alias => "sge-uninit.sh";
    }
    
    package {
        ["gridengine-common", "gridengine-client", "postfix", "bsd-mailx"]:
            ensure => purged,
            require => Exec["sge-uninit"],
            notify => Exec["rm-dir"];
    }
    
    exec {
        "/tmp/sge/sge-uninit.sh 2>&1":
            alias => "sge-uninit",
            require => File["sge-uninit.sh"];
            
        "rm -rf /tmp/sge 2>&1":
            alias => "rm-dir";
    }
}

class sge_master::uninstall {
    include sge_common::uninstall
}

class sge_slave::uninstall {
    include sge_common::uninstall
}

class sge_master::test {

    file {
        "/tmp/sge/test.sh":
            source => "puppet:///files/sge/test.sh",
            alias => "test";

        "/tmp/sge/example.sh":
            source => "puppet:///files/sge/example.sh",
            alias => "example";
            
        "/tmp/sge/test_q.cnf":
            source => "puppet:///files/sge/test_q.cnf",
            alias => "q_conf";
    }

    exec {
        "/tmp/sge/test.sh 2>&1":
            require => File[test, example, q_conf];
    }
}
