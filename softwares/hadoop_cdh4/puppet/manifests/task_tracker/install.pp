class hadoop_cdh4::task_tracker::install {
    hadoop_cdh4::component::install { "hadoop-0.20-mapreduce-tasktracker": }

    include hadoop_cdh4::mapred_common::install

    Package["hadoop-0.20-mapreduce-tasktracker"] -> File["$hadoop_tmp_dir/mapred/local"] -> Service["hadoop-0.20-mapreduce-tasktracker"]
}
