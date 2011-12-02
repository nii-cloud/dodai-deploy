class sge::master::test {
    file {
        "/tmp/sge/test.sh":
            source => "puppet:///modules/sge/test.sh",
            alias => test;

        "/tmp/sge/test-example.sh":
            source => "puppet:///modules/sge/test-example.sh",
            alias => "test-example";

        "/tmp/sge/test-queue.conf":
            content => template("sge/test-queue.conf.erb"),
            alias => "test-queue";
    }

    exec {
        "/tmp/sge/test.sh 2>&1":
            require => File[test, "test-example", "test-queue"];
    }
}
