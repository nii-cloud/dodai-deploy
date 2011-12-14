define hadoop::component::uninstall {
    $hadoop_home = "/opt/hadoop"

    include hadoop::common::uninstall

    exec {
        "$hadoop_home/bin/hadoop-daemon.sh --config $hadoop_home/conf stop $title 2>&1":
            notify => Exec[rm_hadoop_home]
    }
}
