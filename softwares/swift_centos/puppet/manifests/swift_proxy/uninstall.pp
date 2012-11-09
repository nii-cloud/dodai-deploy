class swift_centos::swift_proxy::uninstall {
    include swift_centos::common::uninstall

    package {
        [openstack-swift-proxy]:
            ensure => purged,
            require => Exec["proxy-uninit"]
    }

    file {
       "/tmp/swift/proxy-uninit.sh":
           source => "puppet:///modules/swift_centos/proxy-uninit.sh"
    }

    exec {
        "/tmp/swift/proxy-uninit.sh":
            alias => "proxy-uninit",
            require => File["/tmp/swift/proxy-uninit.sh"];

        "rm -rf /usr/lib/python2.6/site-packages/swauth*; rm -rf /usr/bin/swauth*":
    }
}
