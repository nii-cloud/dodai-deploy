class hadoop::common::uninstall {
    exec {
        "rm -rf /tmp/hadoop-*; rm -f /opt/init.sh; rm -rf $hadoop::home; rm -rf $hadoop::home-$hadoop::version; rm -f $hadoop::home-$hadoop::version.tar.gz; rm -rf /etc/init.d/hadoop-*;":
            alias => "rm_hadoop_home"
    }
}
