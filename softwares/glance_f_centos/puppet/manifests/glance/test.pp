class glance_f_centos::glance::test {
    file {
        "/var/lib/glance/test.sh":
            alias => "test.sh",
            content => template("glance_f_centos/test.sh.erb")
    }

    exec {
        "/var/lib/glance/test.sh 2>&1":
            require => File["test.sh"],
    }
}
