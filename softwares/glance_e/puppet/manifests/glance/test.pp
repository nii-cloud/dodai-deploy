class glance_e::glance::test {
    file {
        "/var/lib/glance/test.sh":
            alias => "test.sh",
            source => "puppet:///modules/glance_e/test.sh"
    }

    exec {
        "/var/lib/glance/test.sh $admin_tenant_name $admin_user $admin_password 2>&1":
            alias => "test.sh",
            require => File["test.sh"]
    }
}
