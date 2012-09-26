define hadoop_cdh4::component::install() {
    include hadoop_cdh4::common::install

    if $title == "hadoop-hdfs-namenode" {
        exec {
            "echo Y | hdfs namenode -format":
                require => [Package["$title"], File["core-site", "hdfs-site", "mapred-site", "bigtop-detect-javahome"]],
                notify => Service["$title"],
                user => hdfs
        }
    }

    if $title == "hadoop-0.20-mapreduce-jobtracker" {
        exec { "hadoop fs -mkdir $hadoop_tmp_dir/mapred/system; hadoop fs -chown mapred:hadoop $hadoop_tmp_dir/mapred/system":
            user => hdfs,
            alias => map_system
        }

        service {
            "$title":
                ensure => running,
                require => [File["bigtop-detect-javahome", "core-site", "hdfs-site", "mapred-site", "default-hadoop-0.20", "tmp_dir", "$hadoop_tmp_dir/mapred/local"], Exec[map_system], Package["$title"]];
        }

    } else {
        service {
            "$title":
                ensure => running,
                require => [File["bigtop-detect-javahome", "core-site", "hdfs-site", "mapred-site", "default-hadoop-0.20", "tmp_dir", "$hadoop_tmp_dir/mapred/local"], Package["$title"]];
        }
    }

    package {
        "$title":
            require => Package["openjdk-6-jre", "cdh4-repository"]
    }
}
