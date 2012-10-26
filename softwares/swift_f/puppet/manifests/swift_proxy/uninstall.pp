class swift_f::swift_proxy::uninstall {
    package {
        [swift, swift-proxy, swauth]:
            ensure => purged,
            require => Exec["proxy-uninit"]
    }

    file {
       "/tmp/swift/proxy-uninit.sh":
           source => "puppet:///modules/swift_f/proxy-uninit.sh"
    }

    exec {
        "/tmp/swift/proxy-uninit.sh":
            alias => "proxy-uninit",
            require => File["/tmp/swift/proxy-uninit.sh"]
    }
}
