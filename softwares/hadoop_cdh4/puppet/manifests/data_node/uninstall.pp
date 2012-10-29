class hadoop_cdh4::data_node::uninstall {
    hadoop_cdh4::component::uninstall { "hadoop-hdfs-datanode": }

    exec {
        "rm -rf $hadoop_tmp_dir/dfs/data":
    }
}
