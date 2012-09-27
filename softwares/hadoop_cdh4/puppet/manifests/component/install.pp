define hadoop_cdh4::component::install() {
    include hadoop_cdh4::common::install

    service {
        "$title":
             ensure => running,
             require => [File["bigtop-detect-javahome", "core-site", "hdfs-site", "mapred-site", "default-hadoop-0.20", "tmp_dir"], Package["$title"]];
    }

    package {
        "$title":
            require => [Package["openjdk-6-jre"], Exec["add-cdh4-repository"]],
            before => File["bigtop-detect-javahome", "core-site", "hdfs-site", "mapred-site", "default-hadoop-0.20", "tmp_dir"]
    }
}
