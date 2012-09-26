class hadoop_cdh4::common::install {
    package { 
        openjdk-6-jre:
            ensure => present;

        cdh4-repository:
            ensure => present,
            provider => dpkg,
            source => "/tmp/cdh4-repository_1.0_all.deb"
    }

    file {
        "/tmp/cdh4-repository_1.0_all.deb":
            source => "puppet:///modules/hadoop_cdh4/cdh4-repository_1.0_all.deb",
            alias => repository;

        "/etc/default/hadoop-0.20":
            source => "puppet:///modules/hadoop_cdh4/default-hadoop-0.20",
            mode => 644,
            alias => "default-hadoop-0.20";

        "/etc/hadoop/conf/core-site.xml":
            content => template("$proposal_id/conf/core-site.xml.erb"),
            mode => 644,
            alias => "core-site";

        "/etc/hadoop/conf/hdfs-site.xml":
            content => template("$proposal_id/conf/hdfs-site.xml.erb"),
            mode => 644,
            alias => "hdfs-site";

        "/etc/hadoop/conf/mapred-site.xml":
            content => template("$proposal_id/conf/mapred-site.xml.erb"),
            mode => 644,
            alias => "mapred-site";

        "/usr/lib/bigtop-utils/bigtop-detect-javahome":
            source => "puppet:///modules/hadoop_cdh4/bigtop-detect-javahome",
            alias => "bigtop-detect-javahome";

        "$hadoop_tmp_dir":
            ensure => directory,
            owner => hdfs,
            group => hdfs,
            mode => 644,
            alias => tmp_dir;

        ["$hadoop_tmp_dir/mapred", "$hadoop_tmp_dir/mapred/local"]:
            ensure => directory,
            owner => mapred,
            group => hadoop,
            mode => 644,
            require => File[tmp_dir];
    }
}
