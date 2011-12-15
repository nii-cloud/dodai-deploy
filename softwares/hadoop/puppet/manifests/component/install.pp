define hadoop::component::install() {
    $hadoop_home = "/opt/hadoop"

    include hadoop::common::install

    if $title == "namenode" {
        exec {
            "echo Y | $hadoop_home/bin/hadoop namenode -format":
                require => File["core-site", "hdfs-site", "mapred-site", "hadoop-env"],
                notify => Service["hadoop-$title"];
        }
    }

    file {
        "/etc/init.d/hadoop-$title":
            content => template("hadoop/component.erb"),
            mode => 0644,
            alias => "hadoop-init";
    }

    service {
        "hadoop-$title":
            ensure => running,
            require => File["hadoop-init", "core-site", "hdfs-site", "mapred-site", "hadoop-env"];
    }

    package {
        sysv-rc-conf:
    }

    exec {
        "sysv-rc-conf hadoop-$title on":
            require => [File["hadoop-init"], Package[sysv-rc-conf]];
    }
}
