class hadoop_cdh4::name_node::test {
    file {
        "/usr/lib/hadoop-0.20-mapreduce/test":
            ensure => directory,
            mode => 644,
            alias => test_dir,
            owner => hdfs;

        "/usr/lib/hadoop-0.20-mapreduce/test/test.sh":
            source => "puppet:///modules/hadoop_cdh4/test.sh",
            require => File[test_dir],
            alias => test
    }

    exec {
        "/usr/lib/hadoop-0.20-mapreduce/test/test.sh 2>&1":
            require => File[test],
            user => hdfs
    }
}
