class hadoop_cdh4::job_tracker::install {
    hadoop_cdh4::component::install { "hadoop-0.20-mapreduce-jobtracker": }

    exec { "hadoop fs -mkdir $hadoop_tmp_dir/mapred/system; hadoop fs -chown mapred:hadoop $hadoop_tmp_dir/mapred/system":
        user => hdfs,
        alias => map_system,
        before => Service["hadoop-0.20-mapreduce-jobtracker"]
    }

    include hadoop_cdh4::mapred_common::install

    Package["hadoop-0.20-mapreduce-jobtracker"] -> File["$hadoop_tmp_dir/mapred/local"] -> Service["hadoop-0.20-mapreduce-jobtracker"]
}
