class hadoop_cdh4::name_node::install {
    hadoop_cdh4::component::install { "hadoop-hdfs-namenode": }

    exec {
        "echo Y | hdfs namenode -format":
            require => [Package["hadoop-hdfs-namenode"], File["core-site", "hdfs-site", "mapred-site", "bigtop-detect-javahome"]],
            notify => Service["hadoop-hdfs-namenode"],
            user => hdfs
    }
}
