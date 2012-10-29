class hadoop_cdh4::mapred_common::install {

    file {
        ["$hadoop_tmp_dir/mapred", "$hadoop_tmp_dir/mapred/local"]:
            ensure => directory,
            owner => mapred,
            group => hadoop,
            mode => 644,
            require => File[tmp_dir];
    }
}
