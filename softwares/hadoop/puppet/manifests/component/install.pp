define hadoop::component::install() {
    $hadoop_home = "/opt/hadoop"

    include hadoop::common::install

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
