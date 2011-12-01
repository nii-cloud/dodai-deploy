class glance::glance::test {
    file {
        "/tmp/glance":
            ensure => directory,
            mode => 644
    }

    file {
        "/tmp/glance/test.sh":
            alias => "test.sh",
            source => "puppet:///modules/glance/test.sh",
            require => File["/tmp/glance"]
    }

    exec {
        "/tmp/glance/test.sh 2>&1":
            alias => "test.sh",
            require => File["test.sh"],
    }
}
