class hadoop::common::install {
    $hadoop_home = "/opt/hadoop" 
    $version = "0.20.2"

    package { openjdk-6-jre: }

    file {
        "$hadoop_home-$version.tar.gz":
            source => "puppet:///modules/hadoop/hadoop-$version.tar.gz",
            mode => 644,
            alias => tarball,
            require => Package[openjdk-6-jre];

        "/opt/init.sh":
            source => "puppet:///modules/hadoop/init.sh",
            alias => init,
            require => File[tarball];

        "$hadoop_home/conf/core-site.xml":
            content => template("$proposal_id/conf/core-site.xml.erb"),
            mode => 644,
            alias => "core-site",
            require => Exec[init];

        "$hadoop_home/conf/hdfs-site.xml":
            content => template("$proposal_id/conf/hdfs-site.xml.erb"),
            mode => 644,
            alias => "hdfs-site",
            require => Exec[init];

        "$hadoop_home/conf/mapred-site.xml":
            content => template("$proposal_id/conf/mapred-site.xml.erb"),
            mode => 644,
            alias => "mapred-site",
            require => Exec[init];

        "$hadoop_home/conf/hadoop-env.sh":
            source => "puppet:///modules/hadoop/hadoop-env.sh",
            alias => "hadoop-env",
            require => Exec[init];
    }

    package {
        sysv-rc-conf:
    }

    exec {
        "/opt/init.sh 2>&1":
            alias => "init",
            cwd => "/opt",
            require => File[init]
    }
}
