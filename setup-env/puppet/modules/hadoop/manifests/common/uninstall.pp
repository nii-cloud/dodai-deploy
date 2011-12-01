class hadoop::common::uninstall {
    $hadoop_home = "/var/opt/hadoop"
    $version = "0.20.2"

    exec {
        "rm -rf /tmp/hadoop-*; rm -f /var/opt/init.sh; rm -rf $hadoop_home; rm -rf $hadoop_home-$version; rm -f $hadoop_home-$version.tar.gz":
            alias => "rm_hadoop_home"
    }
}
