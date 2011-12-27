class hadoop::name_node::test {
    file {
        "$hadoop::home/test.sh":
            source => "puppet:///modules/hadoop/test.sh",
            alias => test
    }

    exec {
        "$hadoop::home/test.sh $hadoop::version 2>&1":
            require => File[test]
    }
}
