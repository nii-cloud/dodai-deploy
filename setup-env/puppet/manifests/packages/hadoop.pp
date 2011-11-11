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

$hadoop_templates_dir = "${proposal_id}"
$version = "0.20.2"
$hadoop_home = "/var/opt/hadoop"

class hadoop_common::install {
    package { "openjdk-6-jre": }

    file {
        "$hadoop_home-$version.tar.gz":
            source => "puppet:///files/hadoop/hadoop-$version.tar.gz",
            mode => 644,
            alias => tarball,
            require => Package["openjdk-6-jre"];

        "/var/opt/init.sh":
            source => "puppet:///files/hadoop/init.sh",
            alias => "init",
            require => File[tarball];

        "$hadoop_home/conf/core-site.xml":
            content => template("$hadoop_templates_dir/conf/core-site.xml.erb"),
            mode => 644,
            alias => "core-site",
            require => Exec[init];

        "$hadoop_home/conf/hdfs-site.xml":
            content => template("$hadoop_templates_dir/conf/hdfs-site.xml.erb"),
            mode => 644,
            alias => "hdfs-site",
            require => Exec[init];

        "$hadoop_home/conf/mapred-site.xml":
            content => template("$hadoop_templates_dir/conf/mapred-site.xml.erb"),
            mode => 644,
            alias => "mapred-site",
            require => Exec[init];

        "$hadoop_home/conf/hadoop-env.sh":
            source => "puppet:///files/hadoop/hadoop-env.sh",
            alias => "hadoop-env",
            require => Exec[init];
    }


    exec {
        "/var/opt/init.sh 2>&1":
            alias => "init",
            cwd => "/var/opt",
            require => File[init]
    }
}

define hadoop_component_install() {
    include hadoop_common::install

    if $title == "namenode" {
        exec {
            "echo Y | $hadoop_home/bin/hadoop namenode -format; $hadoop_home/bin/hadoop-daemon.sh --config $hadoop_home/conf start $title 2>&1":
                require => File["core-site", "hdfs-site", "mapred-site", "hadoop-env"]
        }
    } else {
				exec {
						"$hadoop_home/bin/hadoop-daemon.sh --config $hadoop_home/conf start $title 2>&1":
								require => File["core-site", "hdfs-site", "mapred-site", "hadoop-env"],
				}
    }
}

class name_node::install {
    hadoop_component_install { namenode: }
}

class secondary_name_node::install {
    hadoop_component_install { secondarynamenode: }
}

class data_node::install {
    hadoop_component_install { datanode: }
}

class job_tracker::install {
    hadoop_component_install { jobtracker: }
}

class task_tracker::install {
    hadoop_component_install { tasktracker: }
}

class hadoop_common::uninstall {
    exec {
        "rm -rf /tmp/hadoop-*; rm -f /var/opt/init.sh; rm -rf $hadoop_home; rm -rf $hadoop_home-$version; rm -f $hadoop_home-$version.tar.gz":
            alias => "rm_hadoop_home"  
    }
}

define hadoop_component_uninstall {
    include hadoop_common::uninstall

    exec {
        "$hadoop_home/bin/hadoop-daemon.sh --config $hadoop_home/conf stop $title 2>&1":
            notify => Exec[rm_hadoop_home]
    }
}

class name_node::uninstall {
    hadoop_component_uninstall { namenode: }
}

class secondary_name_node::uninstall {
    hadoop_component_uninstall { secondarynamenode: }
}

class data_node::uninstall {
    hadoop_component_uninstall { datanode: }
}

class job_tracker::uninstall {
    hadoop_component_uninstall { jobtracker: }
}

class task_tracker::uninstall {
    hadoop_component_uninstall { tasktracker: }
}

class name_node::test {
    file {
        "$hadoop_home/test.sh":
            source => "puppet:///files/hadoop/test.sh",
            alias => "test"
    }

    exec {
        "$hadoop_home/test.sh $version 2>&1":
            require => File[test]
    }
}
