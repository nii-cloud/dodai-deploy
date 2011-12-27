define hadoop::component::uninstall {
    include hadoop::common::uninstall

    exec {
        "echo Y | USER=root $hadoop::home/bin/hadoop-daemon.sh --config $hadoop::home/conf stop $title 2>&1; sudo sysv-rc-conf hadoop-$title off":
            notify => Exec[rm_hadoop_home]
    }
}
