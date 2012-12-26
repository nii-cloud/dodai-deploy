class glance_centos_f::glance::test {
    file {
        "/var/lib/glance/test.sh":
            alias => "test.sh",
            content => template("glance_centos_f/test.sh.erb")
    }

    exec {
        "/var/lib/glance/test.sh 2>&1":
            require => File["test.sh"],
    }
}
