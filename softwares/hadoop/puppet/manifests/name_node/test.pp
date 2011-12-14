class hadoop::name_node::test {
    $hadoop_home = "/opt/hadoop"
    $version = "0.20.2"

    file {
        "$hadoop_home/test.sh":
            source => "puppet:///modules/hadoop/test.sh",
            alias => test
    }

    exec {
        "$hadoop_home/test.sh $version 2>&1":
            require => File[test]
    }
}
