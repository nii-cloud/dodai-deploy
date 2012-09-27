class hadoop_cdh4::common::install {
    package { 
        [openjdk-6-jre, bigtop-utils]:
            ensure => present;
    }

    file {
        "/tmp/cdh4-repository_1.0_all.deb":
            source => "puppet:///modules/hadoop_cdh4/cdh4-repository_1.0_all.deb",
            alias => repository;

        "/tmp/add-cdh4-repository.sh":
            source => "puppet:///modules/hadoop_cdh4/add-cdh4-repository.sh",
            alias => "add-cdh4-repository";

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
            require => Package["bigtop-utils"],
            alias => "bigtop-detect-javahome";

        "$hadoop_tmp_dir":
            ensure => directory,
            owner => hdfs,
            group => hdfs,
            mode => 644,
            alias => tmp_dir;
    }

    exec {
        "/tmp/add-cdh4-repository.sh":
            alias => "add-cdh4-repository",
            require => File["add-cdh4-repository", "repository"]
    }
}
