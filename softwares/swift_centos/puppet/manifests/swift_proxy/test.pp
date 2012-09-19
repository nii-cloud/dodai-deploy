class swift_centos::swift_proxy::test {
    file {
       "/tmp/swift/test.sh":
           source => "puppet:///modules/swift_centos/test.sh"
    }

    exec {
        "/tmp/swift/test.sh $super_admin_key 2>&1":
            require => File["/tmp/swift/test.sh"]
    }

}
