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

class sun_jre::install {

    file {
        "/tmp/sge":
            ensure => directory,
            mode => 644;
            
        "/tmp/sge/sun-jre-preseed.sh":
            alias => "sun-jre-preseed.sh",
            source => "puppet:///files/sge/sun-jre-preseed.sh",
    }
    
    exec { 
        "/tmp/sge/sun-jre-preseed.sh 2>&1":
            alias => "sun-jre-preseed.sh",
            require => File["sun-jre-preseed.sh"];
            
        "update-java-alternatives -s java-6-sun 2>&1; exit 0":
            alias => "alternatives-java",
            require => Package["sun-java6-jre"];
    }
    
    package { 
        ["sun-java6-jre"]:
            require => Exec["sun-jre-preseed.sh"],
            ensure => installed,
            notify => Exec["alternatives-java"];
    }
}

class sge_slave::install {
    include sun_jre::install
  
    file { 
        "/tmp/sge/sge-preseed.sh":
            alias => "sge-preseed.sh",
            source => "puppet:///files/sge/sge-preseed.sh",
            require => File["/tmp/sge"];
    }
    
    exec { 
        "/tmp/sge/sge-preseed.sh 2>&1":
            alias => "sge-preseed.sh",
            require => File["sge-preseed.sh"];
    }
    
    package {
      ["gridengine-client", "gridengine-exec"]:
            require => Package["sun-java6-jre"];
    }
}

class sge_master::install {
    include sun_jre::install
  
    file { 
        "/tmp/sge/sge-preseed.sh":
            alias => "sge-preseed.sh",
            source => "puppet:///files/sge/sge-preseed.sh";
            
        "/tmp/sge/sge-init.sh":
            source => "puppet:///files/sge/sge-init.sh",
            require => File["/tmp/sge"];
    }
    
    package {
        ["gridengine-client", "gridengine-common", "gridengine-master", gridengine-qmon]:
            require => Package["sun-java6-jre"],
            notify => Exec["sge-init"];
    }
    exec {             
        "/tmp/sge/sge-init.sh ${sge_slave_nodes} 2>&1":
            alias => "sge-init",
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

        "/tmp/sge/test_q.cnf":
            source => "puppet:///files/sge/test_q.cnf",
            alias => "q_conf";
    }

    exec {
        "/tmp/sge/test.sh $sge_slave_nodes 2>&1":
            require => File[test];
    }
}
