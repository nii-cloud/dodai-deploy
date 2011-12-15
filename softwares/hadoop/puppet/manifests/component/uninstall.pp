define hadoop::component::uninstall {
    $hadoop_home = "/opt/hadoop"

    include hadoop::common::uninstall

    exec {
        "echo Y | USER=root $hadoop_home/bin/hadoop-daemon.sh --config $hadoop_home/conf stop $title 2>&1; sudo sysv-rc-conf hadoop-$title off":
            notify => Exec[rm_hadoop_home]
    }
}
