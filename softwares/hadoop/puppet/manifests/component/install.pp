define hadoop::component::install() {
    include hadoop::common::install

    if $title == "namenode" {
        exec {
            "echo Y | $hadoop::home/bin/hadoop namenode -format":
                require => File["core-site", "hdfs-site", "mapred-site", "hadoop-env"],
                notify => Service["hadoop-$title"];
        }
    }

    file {
        "/etc/init.d/hadoop-$title":
            content => template("hadoop/component.erb"),
            alias => "hadoop-init-$title";
    }

    service {
        "hadoop-$title":
            ensure => running,
            require => File["hadoop-init-$title", "core-site", "hdfs-site", "mapred-site", "hadoop-env"];
    }

    exec {
        "sysv-rc-conf hadoop-$title on":
            require => [File["hadoop-init-$title"], Package[sysv-rc-conf]];
    }
}
